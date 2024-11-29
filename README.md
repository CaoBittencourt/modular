# `modular`: Modules in R With Objective Project Roots and File Tree Lookup

`modular` helps to write modular code in R. It is meant to be used with packages such as `box` or regular `source` commands by providing an absolute path to a project's root which is objetive and consistent across files and working directories.

Therefore, if one calls the `project.root` function from any file whatsover, `modular` will either find a local project root or create one. Unless specified, it will then set the working directory to the project root. Thus, all paths can be objectively referenced from it.

To install `modular`, run
```
devtools::install_github('CaoBittencourt/modular')
```

To set an objective project root, run
```
project.root()
```
at the top of your R scripts.

With this, files can be objectively referenced as such:
```
project.root()
box::use(exa = modules / example)
```
or
```
project.root()
source('./modules/example.r')
```