context("test_.has_header - unit tests")

test_that(
  ".has_header returns TRUE for a header line", {
    test_string <- paste("#chr", "pos", "ref", "alt", sep = "\t")
    expect_true(.has_header(test_string))
  }
)


test_that(
  ".has_header returns TRUE for a header line", {
    test_string <- paste("chr", "pos", "ref", "alt", sep = "\t")
    expect_true(.has_header(test_string))
  }
)

test_that(
  ".has_header returns FALSE for a non-header line", {
    test_string <- "Not a header."
    expect_false(.has_header(test_string))
  }
)
