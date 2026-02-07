library(rix)
rix(r_ver = "4.5.1",
    r_pkgs = c(
    "magrittr",
    "commonmark",
    "xml2",
    "tibble",
    "purrr",
    "bslib", 
    "shiny",
    "shinythemes",
    "stringr",
    "httr",
    "clipr",
    "fs",
    "devtools"
),
    system_pkgs = c("curl"),
    ide = "none",
    project_path = ".",
    overwrite = TRUE)
