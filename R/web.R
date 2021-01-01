#' Dependency
#' 
#' Import dataset dependency to use in browser.
#' 
#' @examples 
#' library(shiny)
#' 
#' ui <- fluidPage(
#'  dataset_dependency()
#' )
#' 
#' server <- function(input, output){}
#' 
#' if(interactive())
#'  shinyApp(ui, server)
#' 
#' @importFrom htmltools htmlDependency
#' 
#' @export 
dataset_dependency <- function(){
  htmlDependency(
    name = "datasets",
    version = "0.11.7",
    src = "asset",
    script = c(file = "dataset.min.js"),
    package = "alter"
  )
}
