# internal helper functions ----------------------------------------------------

#' hack to pass devtools::check()
#' see: https://stackoverflow.com/questions/9439256/
#' @noRd
utils::globalVariables(c(".", ":=", "VEP_ensembl_Codon_Change_or_Distance",
                         "aaref", "match_mask", "new_p", "p_clean", "p_list",
                         "p_max", "p_min", "r_clean", "r_corresponding",
                         "r_list", "v_clean", "v_corresponding", "v_list",
                         "wacky_no_column", "aaalt", "Eigen-PC-raw_unparsed",
                         "Eigen-phred", "Eigen-phred_unparsed", "Eigen-raw",
                         "Eigen-raw_rankscore", "Eigen-raw_rankscore_unparsed",
                         "Eigen-raw_unparsed", "GMS_paired-end",
                         "GMS_paired-end_unparsed", "GMS_single-end",
                         "GMS_single-end_unparsed", "H1-hESC_fitCons_rankscore",
                         "H1-hESC_fitCons_rankscore_unparsed",
                         "H1-hESC_fitCons_score",
                         "H1-hESC_fitCons_score_unparsed", "MAP20(+-149bp)",
                         "MAP20(+-149bp)_unparsed", "MAP35(+-149bp)",
                         "MAP35(+-149bp)_unparsed",
                         "fathmm-MKL_coding_rankscore",
                         "fathmm-MKL_coding_rankscore_unparsed",
                         "fathmm-MKL_coding_score",
                         "fathmm-MKL_coding_score_unparsed",
                         "fathmm-MKL_non-coding_rankscore",
                         "fathmm-MKL_non-coding_rankscore_unparsed",
                         "fathmm-MKL_non-coding_score",
                         "fathmm-MKL_non-coding_score_unparsed",
                         "#chr", "1000G_strict_masked",
                         "1000G_strict_masked_unparsed",
                         "1000Gp3_AC", "1000Gp3_AF", "1000Gp3_AFR_AC",
                         "1000Gp3_AFR_AF", "1000Gp3_AMR_AC", "1000Gp3_AMR_AF",
                         "1000Gp3_EAS_AC", "1000Gp3_EAS_AF", "1000Gp3_EUR_AC",
                         "1000Gp3_EUR_AF", "1000Gp3_SAS_AC", "1000Gp3_SAS_AF",
                         "CADDphred", "CADDraw", "Eigen-PC-raw",
                         "Eigen-PC-raw_rankscore",
                         "Eigen-PC-raw_rankscore_unparsed",
                         "data", "data_copy", ".data", "dbnsfp", "field",
                         "indel", "parseGroup", "pivotChar", "pivotGroup",
                         "SNV", "sourceGroup", "transformation"))

#' Check if the current chunk includes a header row describing the fields
#' @noRd
.get_first_line <- function(source_file){
  readfile_con <- gzfile(source_file, "r")
  first_line <- suppressWarnings(readLines(readfile_con, n = 1))
  close(readfile_con)
  return(first_line)
}

#' Check if the current chunk includes a header row describing the fields
#' @noRd
.has_header <- function(raw_chunk){
  any(stringr::str_detect(raw_chunk, "^#?chr\\tpos\\tref\\talt")) #nolint
}

#' Get header row from raw chunk
#' @noRd
.get_header <- function(raw_chunk){
  raw_chunk[stringr::str_detect(raw_chunk, "^#?chr\\tpos\\tref\\talt")]
}

#' Check whether the source_file is WGSA indel annotation
#' @noRd
.is_indel <- function(header){
  any(stringr::str_detect(header, "indel_focal_length"))
}

#' use read_tsv to read fields from raw chunk of TSV from readLines()
#' @noRd
.get_fields_from_chunk <- function(raw_chunk) {
  readr::read_tsv(paste0(raw_chunk, collapse = "\n"),
           col_types = readr::cols(.default = readr::col_character()))
}

#' expand the selected annotation fields by separating list columns to rows:
#' e.g. a field like value1|value2 becomes two rows, and other columns are
#' duplicated
#' @importFrom magrittr "%>%"
#' @noRd
.expand_chunk <- function(selected_columns,
                          freeze,
                          indel_flag = FALSE,
                          dbnsfp_flag = FALSE) {
  # set variables by freeze-----------------------------------------------------
  if (freeze == 4) {
    if (dbnsfp_flag == TRUE) {
      to_split <- .get_list("fr_4_dbnsfp_to_split")
    }
    if (indel_flag == TRUE) {
      to_split_VEP <- .get_list("fr_4_indel_to_split")
    } else {
      to_split_VEP <- .get_list("fr_4_snv_to_split_VEP")
    }
    #    to_split_TFBS <- .get_list("fr_4_snv_to_split_TFBS") #nolint
    to_split_GTEx_V6 <- .get_list("fr_4_snv_to_split_GTEx_V6")


    # pivot most fields by | for dbnsfp chunk-----------------------------------
    if (dbnsfp_flag == TRUE) {
      expanded <- selected_columns %>%
        tidyr::separate_rows(dplyr::one_of(to_split), sep = "\\|") %>%
        tidyr::separate_rows(dplyr::one_of(c("Ensembl_geneid")), sep = ";") %>%
        dplyr::distinct()
    } else {
      # pivot the VEP_* fields by | for snp and indel chunks--------------------
      expanded <- selected_columns %>%
        tidyr::separate_rows(dplyr::one_of(to_split_VEP), sep = "\\|")

      # pivot the ENCODE_TFBS_* fields by ;-------------------------------------
      # expanded <- expanded %>% #nolint
      #   separate_rows(one_of(to_split_TFBS), sep = ";") #nolint

      # pivot the Ensembl_Regulatory_Build_Overviews field by ;-----------------
      expanded <- expanded %>%
        tidyr::separate_rows(
          dplyr::one_of("Ensembl_Regulatory_Build_Overviews"), sep = ";")

      # pivot the Ensembl_Regulatory_Build_TFBS field by ;----------------------
      expanded <- expanded %>%
        tidyr::separate_rows(
          dplyr::one_of("Ensembl_Regulatory_Build_TFBS"), sep = ";")

      # pivot the GTEx_V6 fields by |-------------------------------------------
      expanded <- expanded %>%
        tidyr::separate_rows(dplyr::one_of(to_split_GTEx_V6), sep = "\\|")
    }
  }
  # remove duplicate rows
  expanded <- dplyr::distinct(expanded)
}

#' split the VEP_ensembl_Codon_Change_or_Distance field -
#' if number, put in VEP_ensembl_Distance field
#' if string, put in VEP_ensembl_Codon_Change field
#' #' @importFrom magrittr "%>%"
#' @noRd
.split_VEP_codon <- function(expanded) {
  expanded <- expanded %>%
    tidyr::extract(
      col = VEP_ensembl_Codon_Change_or_Distance, #nolint
      into = c("VEP_ensembl_Distance", "VEP_ensembl_Codon_Change"),
      regex = "(\\d*)(\\D*)"
    ) %>%
    dplyr::mutate_at(dplyr::vars(dplyr::one_of(
      c("VEP_ensembl_Distance",
        "VEP_ensembl_Codon_Change")
    )),
    dplyr::funs(stringr::str_replace(
      ., pattern = "^$", replacement = "."
    ))) # fill blanks with "."

  return(expanded)
}

#' parse columns from tibble for which we want to select maximum value
#' @importFrom magrittr "%>%"
#' @noRd
.parse_indel_max_columns <- function(selected_columns, max_columns) {
  selected_columns <-
    suppressWarnings(
      selected_columns %>%
        # first copy unparsed columns to colum_name_unparsed
        dplyr::bind_cols(
          dplyr::select_at(.,
                           .vars = dplyr::vars(max_columns),
                           .funs = dplyr::funs(paste0(., "_unparsed")))) %>%
        # next replace ; or {*} with a space
        dplyr::mutate_at(
          .vars = dplyr::vars(max_columns),
          .funs = dplyr::funs(
            stringr::str_replace_all(., "(?:\\{.*?\\})|;", " ")
            )
        ) %>%
        # trim final space to be safe
        dplyr::mutate_at(
          .vars = dplyr::vars(max_columns),
          .funs = dplyr::funs(stringr::str_replace(., "\\s+$", ""))
        ) %>%
        # split the string at the space
        dplyr::mutate_at(
          .vars = dplyr::vars(max_columns),
          .funs = dplyr::funs(stringr::str_split(., "\\s+"))
        ) %>%
        # make values numeric
        dplyr::mutate_at(
          .vars = dplyr::vars(max_columns),
          .funs = dplyr::funs(purrr::map(., as.numeric))
        ) %>%
        # get the max values
        dplyr::mutate_at(
          .vars = dplyr::vars(max_columns),
          .funs = dplyr::funs(purrr::map_dbl(., max, na.rm = TRUE))
        ) %>%
        # change to character
        dplyr::mutate_at(
          .vars = dplyr::vars(max_columns),
          .funs = dplyr::funs(as.character)
        ) %>%
        # change "-Inf" to "."
        dplyr::mutate_at(
          .vars = dplyr::vars(max_columns),
          .funs = dplyr::funs(ifelse( (. == "-Inf"), ".", .))
        )
    )
  return(selected_columns)
}

#' parse columns from tibble for which we want to parse to N if there is an N
#' present, then Y if Y present, else .
#' @importFrom magrittr "%>%"
#' @noRd
.parse_indel_no_columns <- function(selected_columns, no_columns) {
  selected_columns <-
    suppressWarnings(
      selected_columns %>%
        # first copy unparsed columns to colum_name_unparsed
        dplyr::bind_cols(dplyr::select_at(
          .,
          .vars = dplyr::vars(no_columns),
          .funs = dplyr::funs(paste0(., "_unparsed"))
        )) %>%
        # then parse:  N if N present, else Y if Y present, else .
        dplyr::mutate_at(.vars = dplyr::vars(no_columns),
                  .funs = dplyr::funs(ifelse(
                    stringr::str_detect(., "N"),
                    "N",
                    ifelse(stringr::str_detect(., "Y"),
                           "Y", ".")
                  )))
    )
  return(selected_columns)
}

#' parse columns from tibble for which we want to parse to Y if there is an Y
#' present, then N if N present, else .
#' @importFrom magrittr "%>%"
#' @noRd
.parse_indel_yes_columns <- function(selected_columns, yes_columns){
  selected_columns <-
    suppressWarnings(
      selected_columns %>%
        # first copy unparsed columns to colum_name_unparsed
        dplyr::bind_cols(dplyr::select_at(
          .,
          .vars = dplyr::vars(yes_columns),
          .funs = dplyr::funs(paste0(., "_unparsed"))
        )) %>%
        # then parse:  Y if Y present, else N if N present, else .
        dplyr::mutate_at(.vars = dplyr::vars(yes_columns),
                  .funs = dplyr::funs(ifelse(
                    stringr::str_detect(., "Y"),
                    "Y",
                    ifelse(stringr::str_detect(., "N"),
                           "N", ".")
                  )))
    )
  return(selected_columns)
}

#' parse column pairs from tibble for which we want to get logical mask from
#' first column and apply to second column
#' @importFrom magrittr "%>%"
#' @importFrom rlang ":="
#' @noRd
.parse_indel_column_pairs <- function(selected_columns, pair_columns) {
  column_pairs <-
    for (pair in pair_columns) {
      current_pair <- rlang::syms(pair)

      score_name <- pair[[1]]
      rankscore_name <- pair[[2]]
      unparsed_score_name <- paste0(score_name, "_unparsed")
      unparsed_rankscore_name <- paste0(rankscore_name, "_unparsed")

      selected_columns <-
        suppressWarnings(
          selected_columns %>%
            dplyr::mutate(
              p_clean = stringr::str_replace_all(rlang::UQ(current_pair[[1]]),
                                        "(?:\\{.*?\\})|;", " "),
              p_clean = stringr::str_replace(p_clean, "\\s+$", ""),
              p_list = stringr::str_split(p_clean, "\\s+"),
              p_list = purrr::map(p_list, as.numeric),
              p_max = purrr::map_dbl(p_list, max, na.rm = TRUE),
              p_max = as.character(p_max),
              p_max = ifelse( (p_max == "-Inf"), ".", p_max),
              match_mask = purrr::map2(p_list, p_max, stringr::str_detect),
              match_mask = replace(match_mask, is.na(match_mask), TRUE),
              match_mask = purrr::map(match_mask,
                               function(x)
                                 x &
                                 !duplicated(x)),
              # thanks Adrienne!
              r_clean = stringr::str_replace_all(rlang::UQ(current_pair[[2]]),
                                        "(?:\\{.*?\\})|;", " "),
              r_clean = stringr::str_replace(r_clean, "\\s+$", ""),
              r_list =  stringr::str_split(r_clean, "\\s+"),
              r_corresponding = purrr::map2_chr(match_mask, r_list,
                                         function(logical, string)
                                           subset(string, logical))
            ) %>%
            dplyr::select(-p_clean,
                   -p_list,
                   -match_mask,
                   -r_clean,
                   -r_list) %>%
            dplyr::rename(
              rlang::UQ(unparsed_score_name) := rlang::UQ(current_pair[[1]]),
              rlang::UQ(current_pair[[1]]) := p_max,
              rlang::UQ(unparsed_rankscore_name) :=
                rlang::UQ(current_pair[[2]]),
              rlang::UQ(current_pair[[2]]) := r_corresponding
            )
        )
    }
  return(selected_columns)
}


#' parse column triples from tibble for which we want to get logical mask from
#' first column and apply to second and third columns. Assumes 2nd column is
#' rankscore.
#' @importFrom magrittr "%>%"
#' @importFrom rlang ":="
#' @noRd
.parse_indel_column_triples <- function(selected_columns, triple_columns) {
  for (triple in triple_columns) {
    current_triple <- rlang::syms(triple)

    score_name <- triple[[1]]
    rankscore_name <- triple[[2]]
    value_name <- triple[[3]]
    unparsed_score_name <- paste0(score_name, "_unparsed")
    unparsed_rankscore_name <- paste0(rankscore_name, "_unparsed")
    unparsed_value_name <- paste0(value_name, "_unparsed")

    selected_columns <-
      suppressWarnings(
        selected_columns %>%
          dplyr::mutate(
            p_clean = stringr::str_replace_all(rlang::UQ(current_triple[[1]]),
                                      "(?:\\{.*?\\})|;", " "),
            p_clean = stringr::str_replace(p_clean, "\\s+$", ""),
            p_list = stringr::str_split(p_clean, "\\s+"),
            p_list = purrr::map(p_list, as.numeric),
            p_max = purrr::map_dbl(p_list, max, na.rm = TRUE),
            p_max = as.character(p_max),
            p_max = ifelse( (p_max == "-Inf"), ".", p_max),
            match_mask = purrr::map2(p_list, p_max, stringr::str_detect),
            match_mask = replace(match_mask, is.na(match_mask), TRUE),
            match_mask = purrr::map(match_mask,
                             function(x)
                               x & !duplicated(x)), # thanks Adrienne!
            r_clean = stringr::str_replace_all(
              rlang::UQ(current_triple[[2]]),
              "(?:\\{.*?\\})|;", " "),
            r_clean = stringr::str_replace(r_clean, "\\s+$", ""),
            r_list =  stringr::str_split(r_clean, "\\s+"),
            r_corresponding = purrr::map2_chr(match_mask, r_list,
                                       function(logical, string)
                                         subset(string, logical)),
            v_clean = stringr::str_replace_all(
              rlang::UQ(current_triple[[3]]),
              "(?:\\{.*?\\})|;", " "),
            v_clean = stringr::str_replace(v_clean, "\\s+$", ""),
            v_list =  stringr::str_split(v_clean, "\\s+"),
            v_corresponding = purrr::map2_chr(match_mask, v_list,
                                       function(logical, string)
                                         subset(string, logical))
          ) %>%
          dplyr::select(-p_clean,
                 -p_list,
                 -r_clean,
                 -r_list,
                 -match_mask,
                 -v_clean,
                 -v_list
          ) %>%
          dplyr::rename(
            rlang::UQ(unparsed_score_name) := rlang::UQ(current_triple[[1]]),
            rlang::UQ(current_triple[[1]]) := p_max,
            rlang::UQ(unparsed_rankscore_name) :=
              rlang::UQ(current_triple[[2]]),
            rlang::UQ(current_triple[[2]]) := r_corresponding,
            rlang::UQ(unparsed_value_name) := rlang::UQ(current_triple[[3]]),
            rlang::UQ(current_triple[[3]]) := v_corresponding
          )
      )
  }
  return(selected_columns)
}

#' change any old names to new style names in fr_4 indel file
#' @importFrom magrittr "%>%"
#' @noRd
.fix_names <- function(indel_tibble) {
  indel_tibble <- indel_tibble %>%
    dplyr::rename(
      chr = `#chr`,
      MAP20_149bp = `MAP20(+-149bp)`,
      MAP35_149bp = `MAP35(+-149bp)`,
      GMS_single_end = `GMS_single-end`,
      GMS_paired_end = `GMS_paired-end`,
      H1_hESC_fitCons_score = `H1-hESC_fitCons_score`, #nolint
      H1_hESC_fitCons_rankscore = `H1-hESC_fitCons_rankscore`, #nolint
      KGP_strict_masked = `1000G_strict_masked`,
      KGP3_AC = `1000Gp3_AC`,
      KGP3_AF = `1000Gp3_AF`,
      KGP3_AFR_AC = `1000Gp3_AFR_AC`,
      KGP3_AFR_AF = `1000Gp3_AFR_AF`,
      KGP3_EUR_AC = `1000Gp3_EUR_AC`,
      KGP3_EUR_AF = `1000Gp3_EUR_AF`,
      KGP3_AMR_AC = `1000Gp3_AMR_AC`,
      KGP3_AMR_AF = `1000Gp3_AMR_AF`,
      KGP3_SAS_AC = `1000Gp3_SAS_AC`,
      KGP3_SAS_AF = `1000Gp3_SAS_AF`,
      KGP3_EAS_AC = `1000Gp3_EAS_AC`,
      KGP3_EAS_AF = `1000Gp3_EAS_AF`,
      fathmm_MKL_non_coding_score = `fathmm-MKL_non-coding_score`,
      fathmm_MKL_non_coding_rankscore = `fathmm-MKL_non-coding_rankscore`, #nolint
      fathmm_MKL_coding_score = `fathmm-MKL_coding_score`,
      fathmm_MKL_coding_rankscore = `fathmm-MKL_coding_rankscore`,
      Eigen_raw = `Eigen-raw`,
      Eigen_phred = `Eigen-phred`,
      Eigen_raw_rankscore = `Eigen-raw_rankscore`,
      Eigen_PC_raw = `Eigen-PC-raw`,
      Eigen_PC_raw_rankscore = `Eigen-PC-raw_rankscore`,
      CADD_raw = `CADDraw`,
      CADD_phred = `CADDphred`,
      MAP20_149bp_unparsed = `MAP20(+-149bp)_unparsed`,
      MAP35_149bp_unparsed = `MAP35(+-149bp)_unparsed`,
      GMS_single_end_unparsed = `GMS_single-end_unparsed`,
      GMS_paired_end_unparsed = `GMS_paired-end_unparsed`,
      H1_hESC_fitCons_score_unparsed = `H1-hESC_fitCons_score_unparsed`, #nolint
      H1_hESC_fitCons_rankscore_unparsed = `H1-hESC_fitCons_rankscore_unparsed`, #nolint
      KGP_strict_masked_unparsed = `1000G_strict_masked_unparsed`,
      fathmm_MKL_non_coding_score_unparsed = `fathmm-MKL_non-coding_score_unparsed`, #nolint
      fathmm_MKL_non_coding_rankscore_unparsed = `fathmm-MKL_non-coding_rankscore_unparsed`, #nolint
      fathmm_MKL_coding_score_unparsed = `fathmm-MKL_coding_score_unparsed`, #nolint
      fathmm_MKL_coding_rankscore_unparsed = `fathmm-MKL_coding_rankscore_unparsed`, #nolint
      Eigen_raw_unparsed = `Eigen-raw_unparsed`,
      Eigen_phred_unparsed = `Eigen-phred_unparsed`,
      Eigen_raw_rankscore_unparsed = `Eigen-raw_rankscore_unparsed`,
      Eigen_PC_raw_unparsed = `Eigen-PC-raw_unparsed`,
      Eigen_PC_raw_rankscore_unparsed = `Eigen-PC-raw_rankscore_unparsed` #nolint
    )
}

#' select columns to set order and write_tsv
#' @importFrom magrittr "%>%"
#' @noRd
.write_to_file <- function(parsed_lines,
                           destination,
                           processed_fields,
                           header_flag) {
  if (header_flag) {
    parsed_lines %>%
      dplyr::select(dplyr::one_of(processed_fields)) %>% # ensure column order
      readr::write_tsv(path = destination, append = FALSE)
  } else {
    parsed_lines %>%
      dplyr::select(dplyr::one_of(processed_fields)) %>%
      readr::write_tsv(path = destination, append = TRUE)
  }
}

#' parse db_nsfp_low_pairs - select low value from pair[[1]] and corresponding
#' value from pair[[2]]
#' @importFrom magrittr "%>%"
#' @importFrom rlang ":="
#' @noRd
.parse_dbnsfp_low <- function(filtered_selected_columns, low_pairs) {
  for (pair in low_pairs) {
    current_pair <- rlang::syms(pair)
    score_name <- pair[[1]]
    pred_name <- pair[[2]]
    unparsed_score_name <- paste0(score_name, "_unparsed")
    unparsed_pred_name <- paste0(pred_name, "_unparsed")

    filtered_selected_columns <-
      suppressWarnings(
        filtered_selected_columns %>%
          dplyr::mutate(
            p_list = stringr::str_split(rlang::UQ(current_pair[[1]]), ";"),
            p_list = purrr::map(p_list, as.numeric),
            p_min = purrr::map_dbl(p_list, min, na.rm = TRUE),
            p_min = as.character(p_min),
            p_min = ifelse( (p_min == "Inf"), ".", p_min),
            match_mask = purrr::map2(p_list, p_min, stringr::str_detect),
            # replace NA with false
            match_mask = purrr::map(match_mask,
                             function(x)
                               replace(x, is.na(x), FALSE)),
            # if all FALSE, change all to TRUE, then keep only first
            match_mask = purrr::map(match_mask,
                             function(x)
                               if (all(x == FALSE))
                                 ! x
                             else
                               x),
            # if match_mask has more than one TRUE, keep only first TRUE
            # -- thanks Adrienne!
            match_mask = purrr::map(match_mask,
                             function(x)
                               x & !duplicated(x)),
            r_list =  stringr::str_split(rlang::UQ(current_pair[[2]]), ";"),
            r_corresponding = purrr::map2_chr(match_mask, r_list,
                                       function(logical, string)
                                         subset(string, logical))
          ) %>%
          dplyr::select(-p_list,
                 -match_mask,
                 -r_list) %>%
          dplyr::rename(
            rlang::UQ(unparsed_score_name) := rlang::UQ(current_pair[[1]]),
            rlang::UQ(current_pair[[1]]) := p_min,
            rlang::UQ(unparsed_pred_name) := rlang::UQ(current_pair[[2]]),
            rlang::UQ(current_pair[[2]]) := r_corresponding
          )
      )
  }
  return(filtered_selected_columns)
}

#' parse db_nsfp_high_pairs - select high value from pair[[1]] and corresponding
#' value from pair[[2]]
#' @importFrom magrittr "%>%"
#' @importFrom rlang ":="
#' @noRd
.parse_dbnsfp_high <- function(filtered_selected_columns, high_pairs) {
  for (pair in high_pairs) {
    current_pair <- rlang::syms(pair)
    score_name <- pair[[1]]
    pred_name <- pair[[2]]
    unparsed_score_name <- paste0(score_name, "_unparsed")
    unparsed_pred_name <- paste0(pred_name, "_unparsed")

    filtered_selected_columns <-
      suppressWarnings(
        filtered_selected_columns %>%
          dplyr::mutate(
            p_list = stringr::str_split(rlang::UQ(current_pair[[1]]), ";"),
            p_list = purrr::map(p_list, as.numeric),
            p_max = purrr::map_dbl(p_list, max, na.rm = TRUE),
            p_max = as.character(p_max),
            p_max = ifelse( (p_max == "-Inf"), ".", p_max),
            match_mask = purrr::map2(p_list, p_max, stringr::str_detect),
            # replace NA with false
            match_mask = purrr::map(match_mask,
                             function(x)
                               replace(x, is.na(x), FALSE)),
            # if all FALSE, change all to TRUE, then keep only first
            match_mask = purrr::map(match_mask,
                             function(x)
                               if (all(x == FALSE))
                                 ! x
                             else
                               x),
            # if match_mask has more than one TRUE, keep only first TRUE
            # -- thanks Adrienne!
            match_mask = purrr::map(match_mask,
                             function(x)
                               x & !duplicated(x)),
            r_list =  stringr::str_split(rlang::UQ(current_pair[[2]]), ";"),
            r_corresponding = purrr::map2_chr(match_mask, r_list,
                                       function(logical, string)
                                         subset(string, logical))
          ) %>%
          dplyr::select(-p_list,
                 -match_mask,
                 -r_list) %>%
          dplyr::rename(
            rlang::UQ(unparsed_score_name) := rlang::UQ(current_pair[[1]]),
            rlang::UQ(current_pair[[1]]) := p_max,
            rlang::UQ(unparsed_pred_name) := rlang::UQ(current_pair[[2]]),
            rlang::UQ(current_pair[[2]]) := r_corresponding
          )
      )
  }
  return(filtered_selected_columns)
}

#' parse db_nsfp_mutation_pairs - select character from pair[[2]] and
#' corresponding value from pair[[1]]
#' @importFrom magrittr "%>%"
#' @importFrom rlang ":="
#' @noRd
#'
.parse_dbnsfp_mutation <- function(filtered_selected_columns,
                                   mutation_pairs) {
  for (pair in mutation_pairs) {
    current_pair <- rlang::syms(pair)
    score_name <- pair[[2]]
    pred_name <- pair[[1]]
    unparsed_score_name <- paste0(score_name, "_unparsed")
    unparsed_pred_name <- paste0(pred_name, "_unparsed")

    filtered_selected_columns <-
      suppressWarnings(
        filtered_selected_columns %>%
          dplyr::mutate(
            # If A present keep A,
            # else if D present keep D,
            # else if P present keep P,
            # else if N present keep N,
            # else .
            new_p = ifelse(
              stringr::str_detect(rlang::UQ(current_pair[[1]]), "A"),
              "A",
              ifelse(
                stringr::str_detect(rlang::UQ(current_pair[[1]]), "D"),
                "D",
                ifelse(
                  stringr::str_detect(rlang::UQ(current_pair[[1]]), "P"),
                  "P",
                  ifelse(
                    stringr::str_detect(rlang::UQ(current_pair[[1]]),
                                        "N"),
                    "N",
                    "."
                    )
                )
              )
            ),
            p_list = stringr::str_split(rlang::UQ(current_pair[[1]]), ";"),
            match_mask = purrr::map2(p_list, new_p, stringr::str_detect),
            # if match_mask has more than one TRUE, keep only first TRUE
            # -- thanks Adrienne!
            match_mask = purrr::map(match_mask,
                             function(x)
                               x & !duplicated(x)),
            r_list =  stringr::str_split(rlang::UQ(current_pair[[2]]), ";"),
            r_corresponding = purrr::map2_chr(match_mask, r_list,
                                       function(logical, string)
                                         subset(string, logical))
          ) %>%
          dplyr::select(-p_list,
                 -match_mask,
                 -r_list) %>%
          dplyr::rename(
            rlang::UQ(unparsed_score_name) := rlang::UQ(current_pair[[2]]),
            rlang::UQ(current_pair[[2]]) := r_corresponding,
            rlang::UQ(unparsed_pred_name) := rlang::UQ(current_pair[[1]]),
            rlang::UQ(current_pair[[1]]) := new_p
          )
      )
  }
  return(filtered_selected_columns)
}
