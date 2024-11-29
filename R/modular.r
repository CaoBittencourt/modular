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

#' @export
project.root <- function(start.path = ".", end.path = Sys.getenv("HOME"), root.name = "project.root", create.root = T, set.root = T, recursive = T) {
  # assert args
  stopifnot(
    "'start.path' and 'end.path' must be valid paths." = all(
      file.exists(start.path),
      file.exists(end.path)
    )
  )

  stopifnot(
    "'end.path' must be higher up in the file tree than 'start.path'." = all(
      dir.depth(start.path[[1]]) >= dir.depth(end.path[[1]])
    )
  )

  stopifnot(
    "'root.name' must be a character string indicating the name of the project root file." =
      is.character(root.name)
  )

  stopifnot(
    "'create.root' must be either TRUE or FALSE." = all(
      is.logical(create.root),
      !is.na(create.root)
    )
  )

  stopifnot(
    "'set.root' must be either TRUE or FALSE." = all(
      is.logical(set.root),
      !is.na(set.root)
    )
  )

  root.name <- root.name[[1]]
  start.path <- start.path[[1]]
  end.path <- end.path[[1]]
  create.root <- create.root[[1]]
  set.root <- set.root[[1]]

  # backup current working directory
  wd <- getwd()

  # look for a project root file
  list.files(
    path = start.path,
    pattern = root.name,
    full.names = T,
    recursive = recursive
  ) -> root.file

  # truncate search at system root directory
  end.path |>
    dir.depth() |>
    max(1) -> end.depth

  # if no project root file is found, look up the file tree
  while (all(!length(root.file), getwd() |> dir.depth() > end.depth)) {
    getwd() |>
      file.path("..") |>
      setwd()

    paste0(
      "Searching for '", root.name, "' in ",
      getwd()
    ) |>
      message()

    list.files(
      path = getwd(),
      pattern = root.name,
      full.names = T,
      recursive = recursive
    ) -> root.file
  }

  # or create one in the current working directory, if project root files don't exist
  if (all(!length(root.file), create.root)) {
    file.create(file.path(wd, root.name))
    file.path(wd, root.name) -> root.file
  }

  # nearest project root
  root.file[[
    root.file |>
      strsplit("/") |>
      sapply(length) |>
      which.max()
  ]] -> root.file

  # if set.root, set working directory to project root
  # else, reset working directory
  if (set.root) {
    root.file |>
      dirname() |>
      setwd()
  } else {
    setwd(wd)
  }

  # message and return the path to the project root
  "Project root:" |>
    paste(
      ifelse(
        dirname(root.file) == ".",
        getwd(),
        dirname(root.file)
      )
    ) |>
    message()

  return(root.file)
}
