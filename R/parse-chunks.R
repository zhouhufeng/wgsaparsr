#' Parse a chunk tibble from a SNV annotation file
#' @importFrom magrittr "%>%"
#' @noRd
.parse_chunk_snv <- function(all_fields, freeze) {
  # set variables by freeze-----------------------------------------------------
  if (freeze == 4){
    WGSA_version <- "WGSA065"
    desired_columns <- .get_list("fr_4_snv_desired")
  }

  # pick desired columns--------------------------------------------------------
  selected_columns <- all_fields %>%
    dplyr::select(dplyr::one_of(desired_columns)) %>% # select fields
    dplyr::mutate(wgsa_version = WGSA_version) # add wgsa version

  # pivot columns---------------------------------------------------------------
  expanded <- .expand_chunk(selected_columns, freeze)

  # split the VEP_ensembl_Codon_Change_or_Distance field------------------------
  expanded <- .split_VEP_codon(expanded)

  # remove redundant rows
  expanded <- dplyr::distinct(expanded)
}

#' Parse a chunk tibble from an indel annotation file -- PIVOT FIRST?
#' @importFrom magrittr "%>%"
#' @noRd
.parse_chunk_indel <- function(all_fields, freeze) {
  # set variables by freeze-----------------------------------------------------
  if (freeze == 4){
    desired_columns <- .get_list("fr_4_indel_desired")
    WGSA_version <- "WGSA065"

    max_columns <- .get_list("fr_4_indel_max_columns")
    no_columns <- .get_list("fr_4_indel_no_columns")
    yes_columns <- .get_list("fr_4_indel_yes_columns")
    pair_columns <- .get_list("fr_4_indel_pair_columns")
    triple_columns <- .get_list("fr_4_indel_triple_columns")
  }

  # pick desired columns--------------------------------------------------------
  selected_columns <- all_fields %>%
    dplyr::select(dplyr::one_of(desired_columns)) %>% # select fields
    dplyr::mutate(wgsa_version = WGSA_version) # add wgsa version

  # pivot columns---------------------------------------------------------------
  expanded <- .expand_chunk(selected_columns, freeze, indel_flag = TRUE)

  # split the VEP_ensembl_Codon_Change_or_Distance field------------------------
  expanded <- .split_VEP_codon(expanded)

  # parse get max columns #SLOW-------------------------------------------------
  expanded <- .parse_indel_max_columns(expanded, max_columns)

  # parse default No columns----------------------------------------------------
  expanded <- .parse_indel_no_columns(expanded, no_columns)

  # parse default Yes columns---------------------------------------------------
  expanded <- .parse_indel_yes_columns(expanded, yes_columns)

  # parse pair-columns----------------------------------------------------------
  expanded <- .parse_indel_column_pairs(expanded, pair_columns)

  # parse triple-columns--------------------------------------------------------
  expanded <- .parse_indel_column_triples(expanded, triple_columns)

  # change column names from old-version WGSA fields----------------------------
  if (freeze == 4){
    expanded <- .fix_names(expanded)
  }

  # remove redundant rows
  expanded <- dplyr::distinct(expanded)
}

#' Parse a chunk tibble from a SNV annotation file for dbNSFP annotation
#' @importFrom magrittr "%>%"
#' @noRd
.parse_chunk_dbnsfp <- function(all_fields, freeze) {
  # set variables by freeze-----------------------------------------------------
  if (freeze == 4){
    desired_columns <- .get_list("fr_4_dbnsfp_desired")
    low_pairs <- .get_list("fr_4_dbnsfp_low_pairs")
    high_pairs <- .get_list("fr_4_dbnsfp_high_pairs")
    mutation_pairs <- .get_list("fr_4_dbnsfp_mutation_pairs")
  }

  # pick desired columns and rows-----------------------------------------------
  filtered_selected_columns <- all_fields %>%
    dplyr::select(dplyr::one_of(desired_columns)) %>% # select fields
    dplyr::filter(aaref != ".") %>% # select rows with dbNSFP annotation
    dplyr::distinct() # trim redundant rows before expanding

    # IF NO ROWS, RETURN EMPTY TIBBLE
  if (nrow(filtered_selected_columns) == 0) {
    return(filtered_selected_columns)
  }

  # pivot columns---------------------------------------------------------------
  expanded <- .expand_chunk(filtered_selected_columns,
                            freeze,
                            dbnsfp_flag = TRUE)

  # parse db_nsfp_low_pairs-----------------------------------------------------
  expanded <- .parse_dbnsfp_low(expanded, low_pairs)

  # parse db_nsfp_high_pairs----------------------------------------------------
  expanded <- .parse_dbnsfp_high(expanded, high_pairs)

  # parse db_nsfp_mutation_pairs------------------------------------------------
  expanded <- .parse_dbnsfp_mutation(expanded, mutation_pairs)

  # add aachange column---------------------------------------------------------
  expanded <- expanded %>%
    dplyr::mutate(aachange = paste0(aaref, "/", aaalt))

  expanded <- dplyr::distinct(expanded)
}
