ctx <- NULL

.onLoad <- function(libname, pkgname){
  ctx <<- V8::new_context()
  ctx$eval("var window = [];")
  ctx$source(system.file("datasets.js", package = "alter"))
}
