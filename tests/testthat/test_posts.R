
test_that("suggest_to_df works as expected", {
  typical_api_response <- list(list(popular = list()), list(recommended = c(
    "culture",
    "religion", "taiwan", "chinese", "humor"
  )))
  expected <- data.frame(tag = c(
    "culture",
    "religion", "taiwan", "chinese", "humor"
  ), popular = FALSE, recommended = TRUE)
  expect_equal(suggest_to_df(typical_api_response), expected)
})

test_that("remove empty vars excluded correctly", {
  vec <- c("url=https://www.example.com", "title=an example", "extended=")
  expected <- c("url=https://www.example.com", "title=an example")
  expect_equal(remove_empty_vars(vec), expected)
})

# concat_args


test_that("tags_parser works as expected", {
  tags <- c("dog", "cat ", "bird,")
  expected <- "dog+cat+bird"
  expect_warning(result <- tags_parser(tags))
  expect_equal(result, expected)
  expect_equal(tags_parser(), "")
})

test_that("pinboard_dataframe_to_logical_names works", {
  pinboard_api_output <- data.frame(
    href = "https://nope.com",
    description = "wait this is a title",
    extended = "this is actually a description",
    meta = "ASDFADF8723",
    hash = "ASDFA422723",
    time = "2020-05-11T04:53:53Z",
    shared = "yes",
    toread = "yes",
    tags = "inspiration anothertag"
  )
  expected <- data.frame(
    href = "https://nope.com",
    title = "wait this is a title",
    description = "this is actually a description",
    meta = "ASDFADF8723",
    hash = "ASDFA422723",
    time = "2020-05-11T04:53:53Z",
    public = "yes",
    toread = "yes",
    tags = "inspiration anothertag"
  )
  expect_equal(pinboard_dataframe_to_logical_names(pinboard_api_output), expected)
})


test_that("rename_column works", {
  df <- data.frame(falafal = c("one"), house = "dog")
  expected <- data.frame(falafal = c("one"), pet = "dog")
  expect_equal(rename_column(df, "house", "pet"), expected)
})
