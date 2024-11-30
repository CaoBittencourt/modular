# directory depth helper function
dir.depth <- function(path) {
  ifelse(
    path[[1]] == ".",
    getwd(),
    path[[1]]
  ) -> path

  strsplit(path, "/")[[1]] |>
    setdiff("") |>
    length() -> forward

  strsplit(path, "..")[[1]] |>
    setdiff("") |>
    length() -> back

  return(forward - back)
}
