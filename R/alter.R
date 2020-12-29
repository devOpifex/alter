#' Alter
#' 
#' Alter a dataset using [DataSet](https://github.com/antvis/data-set).
#' 
#' @param data A data.frame to alter.
#' @param ... Altering options.
#' @param source A `list` of options to pass to the `source`
#' method.
#' @param dataset A `list` of options to pass to the `DataSet`
#' instantiation.
#' @param .rows Wheter to return the whole altered object or just the rows.
#' @param .return Method to return, `"rows"`.
#' 
#' @examples
#' alter(
#'  cars, 
#'  type = "aggregate", 
#'  fields = c("speed", "dist"), 
#'  operations = c("mean", "mean"), 
#'  as = c("x", "y")
#' ) 
#' 
#' @name functional
#' 
#' @export
alter <- function(data, ..., dataset = NULL, source = NULL, .rows = TRUE, .return = NULL){
  if(missing(data))
    stop("Missing `data`", call. = FALSE)
  
  ctx$assign("data", data)

  if(!is.null(dataset)){
    ctx$assign("dataset", dataset)
    ctx$eval("var dv = new DataSet(dataset).createView();")
  } else {
    ctx$eval("var dv = new DataSet().createView();")
  }

  if(!is.null(source)){
    ctx$assign("src", source)
    ctx$eval("dv = dv.source(data, src);")
  } else {
    ctx$eval("dv = dv.source(data);")
  }

  opts <- list(...)
  if(length(opts)){
    ctx$assign("opts", opts)
    ctx$eval("var dv = dv.transform(opts);")
  }

  if(!is.null(.return))
    return(ctx$get(paste0("dv.", .return)))
  
  if(.rows)
    transformed <- ctx$get("dv.rows")
  else
    transformed <- ctx$get("dv")
  
  return(transformed)
}