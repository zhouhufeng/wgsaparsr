#' Parse the WGSA output file to tidy and select columns of interest
#'
#' \href{https://sites.google.com/site/jpopgen/wgsa}{WGSA} generates distinct
#' annotation output files for annotating indel or SNVs. These output files
#' contain thousands of fields, including fields with lists of entries.
#' parse_to_file() reads a WGSA output file in chunks, parses the chunks, writes
#' to two output files - one for the snv or indel annotation, and another for
#' the dbnsfp annotation. These tab-separated output files can then be imported
#' to a database for aggregation, or used for obtaining variant annotation.
#'
#' @param source_file Path to the WGSA output file to parse (indel or SNV
#'   annotation)
#' @param config Path to config file or a dataframe that passes
#'   validate_config()
#' @param destination Path to the desired indel or snv output file
#' @param dbnsfp_destination Path to the desired dbnsfp output file
#' @param freeze Which TOPMed freeze is being used (default 5)
#' @param chunk_size Number of lines to parse each iteration (default 10,000)
#' @param verbose more output to screen (default TRUE)
#'
#' @examples
#' \dontrun{
#'
#' parse_to_file(source_file = "WGSA_chr_1.gz",
#'  destination = "parsed_chr_1_snv.tsv",
#'  dbnsfp_destination = "parsed_chr_1_dbnsfp.tsv",
#'  chunk_size = 1000)
#' }
#'
#' @export

parse_to_file <- function(source_file,
                          config,
                          destination,
                          dbnsfp_destination = NA,
                          freeze = 5,
                          chunk_size = 10000,
                          verbose = TRUE) {
  if (file.exists(destination)) {
    stop("destination outfile already exists.")
  }
  if (!is.na(dbnsfp_destination) && file.exists(dbnsfp_destination)) {
    stop("dbnsfp_destination outfile already exists.")
  }
  if (freeze == 4) {
    # freeze 4 legacy code------------------------------------------------------

    indel_parsed_fields <- .get_list("fr_4_indel_post_processing")
    snv_parsed_fields <- .get_list("fr_4_snv_post_processing")
    dbnsfp_parsed_fields <- .get_list("fr_4_dbnsfp_post_processing")

    # get header and check if indel file----------------------------------------
    first_line <- .get_first_line(source_file)

    if (!.has_header(first_line)) {
      stop("source_file doesn't have header line")
    }

    raw_header <- first_line
    indel_flag <- .is_indel(first_line)

    # main loop - read file by chunk, process chunk, write chunk----------------
    readfile_con <- gzfile(source_file, "r")
    index <- 0L
    while (TRUE) {
      # read chunk
      raw_chunk <- suppressWarnings(readLines(readfile_con, n = chunk_size))

      # readLines() returns a zero length result at EOF (which SHOULD end loop)
      if (length(raw_chunk) == 0) {
        break
      }

      # if header line in this chunk, read raw chunk to all_fields tibble
      header_flag <- .has_header(raw_chunk)

      if (header_flag) {
        all_fields <- .get_fields_from_chunk(raw_chunk)
      } else {
        modified_chunk <- c(raw_header, raw_chunk) # add the raw header
        all_fields <- .get_fields_from_chunk(modified_chunk)
      }

      # end current iteration if all_fields has 0 observations
      # (to avoid dplyr error arising from empty tibble)
      if (nrow(all_fields) == 0) {
        index <- index + 1L
        next
      }

      # parse the all_fields tibble for snv or indel annotation
      if (indel_flag == TRUE) {
        # parse chunk of indel annotation
        parsed_lines <- .parse_chunk_indel(all_fields, freeze)
        parsed_fields <- indel_parsed_fields
      } else {
        # parse chunk of snv annotation
        parsed_lines <- .parse_chunk_snv(all_fields, freeze)
        parsed_fields <- snv_parsed_fields

        # parse dbnsfp fields from snv chunk
        dbnsfp_parsed_lines <- .parse_chunk_dbnsfp(all_fields, freeze)

        # if present, write dbnsfp data to tsv file
        if (nrow(dbnsfp_parsed_lines) > 0) {
          .write_to_file(
            dbnsfp_parsed_lines,
            dbnsfp_destination,
            dbnsfp_parsed_fields,
            header_flag
          )
        }
      }

      # write processed chunk to tsv file
      .write_to_file(parsed_lines,
                     destination,
                     parsed_fields,
                     header_flag)

      # ready for the next chunk!
      index <- index + 1L

      # update progress if desired
      if (verbose) {
        msg <- paste0(
          "Chunks completed: ",
          index,
          "\n Sourcefile lines processed <= ",
          chunk_size * index,
          "\n Records in current import: ",
          dim(parsed_lines)[1]
        )
        message(msg)
      }
    }
    close(readfile_con)
  } else {
    # freeze 5------------------------------------------------------------------
    # check config-------------------
    if ("data.frame" %in% class(config)) {
      validate_config(config)
    } else {
      config <- load_config(config)
    }

    # get header and check if indel file----------------------------------------
    first_line <- .get_first_line(source_file)

    if (!.fr5_has_header(first_line)) {
      stop("source_file doesn't have header line")
    }

    raw_header <- first_line
    indel_flag <- .is_indel(first_line)

    # main loop - read file by chunk, process chunk, write chunk----------------
    readfile_con <- gzfile(source_file, "r")
    index <- 0L
    while (TRUE) {
      # read chunk
      raw_chunk <- suppressWarnings(readLines(readfile_con, n = chunk_size))

      # readLines() returns a zero length result at EOF (which SHOULD end loop)
      if (length(raw_chunk) == 0) {
        break
      }

      # if header line in this chunk, read raw chunk to all_fields tibble
      header_flag <- .fr5_has_header(raw_chunk)

      if (header_flag) {
        all_fields <- .get_fields_from_chunk(raw_chunk)
      } else {
        modified_chunk <- c(raw_header, raw_chunk) # add the raw header
        all_fields <- .get_fields_from_chunk(modified_chunk)
      }

      # end current iteration if all_fields has 0 observations
      # (to avoid dplyr error arising from empty tibble)
      if (nrow(all_fields) == 0) {
        index <- index + 1L
        next
      }

      # don't need to get dbnsfp fields from indel chunk
      if (indel_flag == TRUE) {
        type <- "indel"
      } else {
        type <- "SNV"
      }

      # parse chunk of indel or SNV annotation
      parsed_lines <- .parse_then_pivot(all_fields, config, type)

      # get list of desired fields from config to ensure outfile column order
      parsed_fields <-
        unlist(.get_list_from_config(config, "desired", type))

      # freeze 5 has some different field names between indel and SNV. Fix that.
      if ("MAP35_149bp" %in% names(parsed_lines)) {
        parsed_lines <- dplyr::rename(parsed_lines, MAP35_149 = "MAP35_149bp")
        parsed_fields <-
          stringr::str_replace(parsed_fields, "MAP35_149bp", "MAP35_149")
      }
      if ("VEP_refseq_ProteinID(ENSP)" %in% names(parsed_lines)) {
        parsed_lines <- dplyr::rename(parsed_lines,
                      VEP_refseq_ProteinID = "VEP_refseq_ProteinID(ENSP)")
        parsed_fields <-
          stringr::str_replace(parsed_fields, "VEP_refseq_ProteinID(ENSP)",
                      "VEP_refseq_ProteinID")
      }

      if (type == "SNV") {
        # parse dbnsfp fields from snv chunk
        dbnsfp_parsed_lines <- .pivot_then_parse(all_fields, config, "dbnsfp")
        dbnsfp_parsed_fields <-
          unlist(.get_list_from_config(config, "desired", "dbnsfp"))

        # if present, write dbnsfp data to tsv file
        if (nrow(dbnsfp_parsed_lines) > 0) {
          .write_to_file(
            dbnsfp_parsed_lines,
            dbnsfp_destination,
            dbnsfp_parsed_fields,
            header_flag)
        }
      }

      # write processed indel or snv chunk to tsv file
      .write_to_file(parsed_lines,
                     destination,
                     parsed_fields,
                     header_flag)

      # update progress if desired
      if (verbose) {
        msg <- paste0(
          "Finished chunk ", index,
          "\n Sourcefile lines processed <= ",
          chunk_size * (index + 1),
          "\n Records in current import: ",
          dim(parsed_lines)[1]
        )
        message(msg)
      }

      # ready for the next chunk!
      index <- index + 1L

    }
    close(readfile_con)
  }
  .last()
}
