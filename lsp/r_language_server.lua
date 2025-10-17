return {
  cmd = { "R", "-e", "languageserver::run()", "--slave" },
  filetypes = { "r", "rmd" },
  root_markers = { ".git", "DESCRIPTION" },
}
