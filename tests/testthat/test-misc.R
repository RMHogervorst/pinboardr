test_that("parse_1d_list works", {
  data <- list("dog" = 1, "pupper" = 2, "crowd" = 4)
  expected2 <- expected <- data.frame(
    tag = c("dog", "pupper", "crowd"),
    count = c(1, 2, 4)
  )
  names(expected2) <- c("tags", "number")
  expect_equal(parse_1d_list_to_df(data), expected)
  expect_equal(parse_1d_list_to_df(data, "tags", "number"), expected2)
})


test_that("pb_add_tag_column works", {
  expected <- source <- data.frame(a = 1:4, tags = c("inspiration dog", "dog", "cat", "inspiration"))
  expected$inspiration <- c(TRUE, FALSE, FALSE, TRUE)
  expect_equal(pb_add_tag_column(source, "inspiration"), expected)
})
