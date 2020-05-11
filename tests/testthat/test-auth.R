old <- list()
old$PB_USERNAME <- Sys.getenv(x = "PB_USERNAME")
old$PB_TOKEN <- Sys.getenv(x = "PB_TOKEN")

setup({
  Sys.setenv(PB_USERNAME = "USERNAME")
  Sys.setenv(PB_TOKEN = "TOKEN")
})

teardown({
  Sys.setenv(PB_USERNAME = old$PB_USERNAME)
  Sys.setenv(PB_TOKEN = old$PB_TOKEN)
})

test_that("correctly find env var", {
  expect_equal(if_null_search_env_var(arg = NULL, varname = "PB_USERNAME"), "USERNAME")
  expect_equal(if_null_search_env_var(arg = NULL, varname = "PB_TOKEN"), "TOKEN")
  expect_equal(if_null_search_env_var(arg = "given", varname = "PB_USERNAME"), "given")
})
test_that("test auth", {
  expected <- "USERNAME:TOKEN"
  expect_equal(pb_auth(username = NULL, token = NULL), expected)
  expect_equal(pb_auth(), expected)
})

test_that("build_url follows pinboard conventions", {
  expected <- "https://api.pinboard.in/v1/tags/get?auth_token=USERNAME:TOKEN&format=json"
  expect_equal(build_url("tags/get"), expected)
})

test_that("build args works", {
  expect_equal(
    build_args(), ""
  )
  expect_equal(
    build_args("tag=svg"), "&tag=svg"
  )
  expect_equal(
    build_args(c("tags=svg", "results=200")),
    "&tags=svg&results=200"
  )
})
