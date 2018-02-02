# new internal helper functions for freeze 5 refactoring -----------------------

#' add column_name_unparsed column to tibble prior to parsing (for debugging, 
#' mostly)
#' @importFrom magrittr "%>%"
#' @noRd
.preserve_raw <- function(selected_columns, to_parse) {
  selected_columns <- selected_columns %>%
    # first copy unparsed columns to colum_name_unparsed
    dplyr::bind_cols(dplyr::select_at(
      .,
      .vars = to_parse,
      .funs = dplyr::funs(paste0(., "_unparsed"))
    ))
  return(selected_columns)
}

#' remove spurious {*} strings from fields:
#' .{n} -> .
#' .{n}; -> .;
#' .{n}. -> .,. (or .{n}. -> . ?)
#' 
#' @importFrom magrittr "%>%"
#' @noRd
.parse_clean <- function(selected_columns, to_clean){
  if (length(to_clean) == 0){
    return(selected_columns)
  }

  # if no {*}, no parsing needed.
  if (!any(
    selected_columns %>%
    dplyr::select(to_clean) %>%
    stringr::str_detect("\\{[^\\}]+\\}"))){
    return(selected_columns)
  }

  selected_columns <-
    selected_columns %>%
    #.{n} -> .
    dplyr::mutate_at(.vars = to_clean,
                     .funs = dplyr::funs(
                       stringr::str_replace_all(., "\\{[^\\}]+\\}$", "")
                       )
                     ) %>%
    # .{n}; -> .;
    dplyr::mutate_at(.vars = to_clean,
                     .funs = dplyr::funs(
                       stringr::str_replace_all(., "\\{[^\\}]+\\};", ";")
                       )
                     ) %>%
    # .{n}. -> .,. (or should it be .{n}. -> . ? or .{n}. -> .;. ?)
    dplyr::mutate_at(.vars = to_clean,
                     .funs = dplyr::funs(
                       stringr::str_replace_all(.,
                        "\\.\\{[^\\}]+\\}(?!;)", ".,")
                       )
                     )
  return(selected_columns)
}

#' pick maximum value from compound entry in column
#' @importFrom magrittr "%>%"
#' @noRd

.parse_max_columns <- function(selected_columns, max_columns) {
  if (length(max_columns) == 0){
    return(selected_columns)
  }

  # if no ; or {*}, only single values, so no parsing needed
  if (!any(
    selected_columns %>%
    dplyr::select(max_columns) %>%
    stringr::str_detect("\\{[^\\}]+\\}|;"))){
    return(selected_columns)
  }

  # if ; or {*}, replace with a space, split on whitespace, and return max
  # value
  selected_columns <-
    suppressWarnings(
      selected_columns %>%
        # replace ; or {*} with a space
        dplyr::mutate_at(
          .vars = max_columns,
          .funs = dplyr::funs(
            stringr::str_replace_all(., "(?:\\{.*?\\})|;", " "))
        ) %>%
        # trim white space padding to be safe
        dplyr::mutate_at(
          .vars = max_columns,
          .funs = dplyr::funs(stringr::str_trim(., side = "both"))
        ) %>%
        # also trim multiple spaces to be safe
        dplyr::mutate_at(
          .vars = max_columns,
          .funs = dplyr::funs(stringr::str_replace(., "\\s{2,}", " ")) #nolint
        ) %>%
        # split the string at the space
        dplyr::mutate_at(
          .vars = max_columns,
          .funs = dplyr::funs(stringr::str_split(., "\\s+"))
        ) %>%
        # make values numeric
        dplyr::mutate_at(
          .vars = max_columns,
          .funs = dplyr::funs(purrr::map(., as.numeric))
        ) %>%
        # get the max values
        dplyr::mutate_at(
          .vars = max_columns,
          .funs = dplyr::funs(purrr::map_dbl(., max, na.rm = TRUE))
        ) %>%
        # change to character
        dplyr::mutate_at(
          .vars = max_columns,
          .funs = dplyr::funs(as.character)
        ) %>%
        # change "-Inf" to "."
        dplyr::mutate_at(
          .vars = max_columns,
          .funs = dplyr::funs(ifelse((. == "-Inf"), ".", .)) #nolint
        )
    )
  return(selected_columns)
}

#' pick minimmum value from compound entry in column
#' @importFrom magrittr "%>%"
#' @noRd

.parse_min_columns <- function(selected_columns, min_columns) {
  if (length(min_columns) == 0){
    return(selected_columns)
  }

  # if no ; or {*}, only single values, so no parsing needed
  if (!any(
    selected_columns %>%
    dplyr::select(min_columns) %>%
    stringr::str_detect("\\{[^\\}]+\\}|;"))){
    return(selected_columns)
  }

  # if ; or {*}, replace with a space, split on whitespace, and return min
  # value
  selected_columns <-
    suppressWarnings(
      selected_columns %>%
        # replace ; or {*} with a space
        dplyr::mutate_at(
          .vars = min_columns,
          .funs = dplyr::funs(
            stringr::str_replace_all(., "(?:\\{.*?\\})|;", " "))
        ) %>%
        # trim white space padding to be safe
        dplyr::mutate_at(
          .vars = min_columns,
          .funs = dplyr::funs(stringr::str_trim(., side = "both"))
        ) %>%
        # also trim multiple spaces to be safe
        dplyr::mutate_at(
          .vars = min_columns,
          .funs = dplyr::funs(stringr::str_replace(., "\\s{2,}", " ")) #nolint
        ) %>%
        # split the string at the space
        dplyr::mutate_at(
          .vars = min_columns,
          .funs = dplyr::funs(stringr::str_split(., "\\s+"))
        ) %>%
        # make values numeric
        dplyr::mutate_at(
          .vars = min_columns,
          .funs = dplyr::funs(purrr::map(., as.numeric))
        ) %>%
        # get the min values
        dplyr::mutate_at(
          .vars = min_columns,
          .funs = dplyr::funs(purrr::map_dbl(., min, na.rm = TRUE))
        ) %>%
        # change to character
        dplyr::mutate_at(
          .vars = min_columns,
          .funs = dplyr::funs(as.character)
        ) %>%
        # change "Inf" to "."
        dplyr::mutate_at(
          .vars = min_columns,
          .funs = dplyr::funs(ifelse((. == "Inf"), ".", .)) #nolint
        )
    )
  return(selected_columns)
}

# TODO: is there a way to short-circuit parsing on trivial case?
#' @importFrom magrittr "%>%"
#' @noRd
.parse_yes_columns <- function(selected_columns, yes_columns){
  if (length(yes_columns) == 0){
    return(selected_columns)
  }
  selected_columns <-
    suppressWarnings(
      selected_columns %>%
        # parse:  Y if Y present, else N if N present, else .
        dplyr::mutate_at(.vars = yes_columns,
                         .funs = dplyr::funs(ifelse(
                           stringr::str_detect(., "Y"),
                           "Y",
                           ifelse(stringr::str_detect(., "N"),
                                  "N", ".")
                         )))
    )
  return(selected_columns)
}

# TODO: is there a way to short-circuit parsing on trivial case?
#' @importFrom magrittr "%>%"
#' @noRd
.parse_no_columns <- function(selected_columns, no_columns){
  if (length(no_columns) == 0){
    return(selected_columns)
  }
  selected_columns <-
    suppressWarnings(
      selected_columns %>%
        # parse:  N if N present, else Y if Y present, else .
        dplyr::mutate_at(.vars = no_columns,
                         .funs = dplyr::funs(ifelse(
                           stringr::str_detect(., "N"),
                           "N",
                           ifelse(stringr::str_detect(., "Y"),
                                  "Y", ".")
                         )))
    )
  return(selected_columns)
}

# TODO: is there a way to short-circuit parsing on trivial case?
#' @importFrom magrittr "%>%"
#' @noRd
.parse_a_columns <- function(selected_columns, a_columns){
  if (length(a_columns) == 0){
    return(selected_columns)
  }
  selected_columns <-
    suppressWarnings(
      selected_columns %>%
        # parse: A if A present, then D, P, N, else .
        mutate_at(.vars = a_columns,
                  .funs = dplyr::funs(
                    ifelse(stringr::str_detect(., "A"), "A",
                           ifelse(stringr::str_detect(., "D"), "D",
                                  ifelse(stringr::str_detect(., "P"), "P",
                                         ifelse(stringr::str_detect(., "N"),
                                                "N", ".")
                                  )
                           )
                    )
                  )
        )
    )
  return(selected_columns)
}

# helper for .parseDistinct() - returns |-separated unique values from
# character vector
#' @importFrom magrittr "%>%"
#' @noRd
.collapse_unique <- function(x) {
  unique(x) %>%
    stringr::str_c(collapse = "|")
}

# helper for .parseDistinct()
# NOTE: .;abc;def becomes ;abc;def instead of .;abc;def problem?
# I think no, because .parse_distinct() fixes that case

#' @importFrom magrittr "%>%"
#' @noRd
.unique_values <- function(a_string) {
  a_string %>%
    # replace {n} with ;
    stringr::str_replace_all("\\{.*?\\}", ";") %>%
    # trim any padding spaces to be safe
    stringr::str_trim(side = "both") %>%
    # replace ".;" at the end of the line with "."
    stringr::str_replace_all("\\.;$", ".") %>%
    # remove ".;" within the string
    stringr::str_replace_all("\\.;", "") %>%
    # remove ";;"
    stringr::str_replace_all(";;", ";") %>%
    # remove ";" if it's the beginning or end of the string
    stringr::str_replace_all("^;|;$", "") %>%
    # split the string at the semicolon (makes list of character vectors)
    stringr::str_split(";") %>%
    # collapse_unique returns |-separated unique values from character vector
    purrr::map_chr(.collapse_unique)
}

# distinct_example:
# Before
# chr pos Ensembl_Regulatory_Build_TFBS
# 1  100  .{1}Tr4;Egr1;Egr1{4}
# 1  200  .{4}Egr1{3}Gabp{5}Gabp;Egr1{1}Gabp;Gabp{7}Gabp;Gabp;Egr1{4}
#
# After
# chr pos Ensembl_Regulatory_Build_TFBS
# 1  100  Tr4
# 1  100  Egr1
# 1  200  Egr1
# 1  200  Gabp

#' @importFrom magrittr "%>%"
#' @noRd
.parse_distinct <- function(selected_columns, distinct_columns){
  # trivial case
  if (length(distinct_columns) == 0){
    return(selected_columns)
  }

  # if no {*} or ;, no parsing needed.
  if (!any(
    selected_columns %>%
    dplyr::select(distinct_columns) %>%
    stringr::str_detect("(?:\\{.*?\\})|;"))
  ){
    return(selected_columns)
  }

  # now parse column using new functions
  selected_columns <-
    selected_columns %>%
    purrr::map_at(distinct_columns, .unique_values) %>%
    dplyr::as_tibble()

  return(selected_columns)
  # NOTE: selected_columns still needs to be pivoted on the distinct field(s)
  # after this function call
}

#' @noRd
.last <- function() {
  message("You're a rock star!")
}

#' Get path to load wgsaparsr example
#' 
#' \code{wgsaparsr} comes bundled with sample files in its \code{inst/extdata}
#' diretory. This function makes them easier to access. Based on
#' \code{readr::readr_example()}
#' 
#' @param path Name of file
#'
#' @examples
#' wgsaparsr_example(path = "fr_5_config.tsv")
#' 
#' @export
wgsaparsr_example <- function(path) {
  system.file("extdata", path, package = "wgsaparsr", mustWork = TRUE)
}