#' @export
project.options <- function(project.name = "project", relative.paths = list(), ...) {
  # assert args

  # if project options are already set, load project options
  project.name |>
    paste0(".rda") ->
  proj.options

  if (file.exists(proj.options)) {
    message("Loading project options.")
    load(proj.options)
    options(proj.options)
    return()
  }

  # else, set project options
  # get or set project root
  project.root |>
    do.call(args = list(...)) |>
    dirname() ->
  root.dir

  # backup working directory
  getwd() -> wd

  # set dir for relative paths
  setwd(root.dir)

  # set options
  message("Setting project options.")
  project.name |>
    paste0(".root") ->
  proj.root

  getwd() |>
    setNames(proj.root) |>
    c(
      relative.paths |>
        lapply(function(x) {
          file.path(getwd(), x)
        })
    ) |>
    options() ->
  proj.options

  # save options in the project root
  message("Saving project options.")
  save(proj.options, file = paste0(project.name, ".rda"))

  # reset working directory
  setwd(wd)
}
