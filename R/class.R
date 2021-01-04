#' Alter
#' 
#' Alter datasets.
#' 
#' @examples 
#' Alter$new(cars)$
#'  source()$
#'  transform(
#'    type = "aggregate",
#'    fields = c("speed", "dist"),
#'    operations = c("mean", "sum"),
#'    as = c("meanDist", "sumDist")
#'  )
#' 
#' @export 
Alter <- R6::R6Class(
  "Alter",
  public = list(
#' @details Initialise
#' @param data A dataset to alter.
#' @param ... Options to pass to the `DataSet` method.
    initialize = function(data, ...){
      if(missing(data))
        stop("Missing `data`", call. = FALSE)

      private$name <- private$generateName()

      ctx$assign(
        sprintf("%sdata", private$name), 
        data
      )

      opts <- list(...)

      if(!length(opts)){
        ctx$eval(
          sprintf(
            "var %s = new DataSet().createView();",
            private$name
          )
        )
        return(invisible(self))
      }

      ctx$assign(
        sprintf("%sdataset", private$name), 
        opts
      )

      ctx$eval(
        sprintf(
          "var %s = new DataSet(%sdataset).createView();",
          private$name,
          private$name
        )
      )
    },
#' @details Source the data
#' @param ... Options to pass to the `source` method.
    source = function(...){
      opts <- list(...)

      if(!length(opts)){
        ctx$eval(
          sprintf(
            "%s = %s.source(%sdata);",
            private$name, 
            private$name,
            private$name
          )
        )
        return(invisible(self))
      }

      ctx$assign(
        sprintf("%src", private$name), 
        opts
      )
      ctx$eval(
        sprintf(
          "%s = %s.source(%sdata, %src);",
          private$name,
          private$name,
          private$name,
          private$name
        )
      )

      private$sourced <- TRUE

      invisible(self)
    },
#' @details Transform the data
#' @param ... Options to pass to the `transform` method.
    transform = function(...){
      
      if(!private$sourced)
        self$source()

      opts <- list(...)

      if(!length(opts))
        stop("Must pass options", call. = FALSE)

      ctx$assign(
        sprintf("%sopts", private$name), 
        opts
      )
      ctx$eval(
        sprintf(
          "var %s = %s.transform(%sopts);",
          private$name,
          private$name,
          private$name
        )
      )

      invisible(self)
    },
#' @details Get the rows of the altered data
#' @param clean Whether to remove the view created from 
#' the global context on exit.
    getRows = function(clean = TRUE){
      if(clean){
        on.exit(
          ctx$eval(
            sprintf("%s = null;", private$name)
          )
        )
      }

      ctx$get(sprintf("%s.rows", private$name))
    },
#' @details Get the view object
#' @param clean Whether to remove the view created from 
#' the global context on exit.
    getView = function(clean = TRUE){
      if(clean){
        on.exit(
          ctx$eval(
            sprintf("%s = null;", private$name)
          )
        )
      }

      ctx$get(sprintf("%s", private$name))
    },
#' @details Get from the view
#' @param what What to retrieve, e.g.: `rows` or `edges`.
#' @param clean Whether to remove the view created from 
#' the global context on exit.
#' @param ... Arguments to pass to the deserialiser.
    get = function(what, ..., clean = TRUE){
      if(missing(what))
        stop("Missing `what`", call. = FALSE)

      if(clean){
        on.exit(
          ctx$eval(
            sprintf("%s = null;", private$name)
          )
        )
      }

      ctx$get(sprintf("%s.%s", private$name, what), ...)
    },
#' @details Clean up
    finalize = function() {
      ctx$eval(
        sprintf(
          "%s = null;",
          private$name
        )
      )
    },
#' @details Print
    print = function(){
      cat("Alter dataset\n")
    }
  ),
  private = list(
    sourced = FALSE,
    dv = NULL,
    name = "dv",
    generateName = function(){
      paste0(sample(letters, 26), collapse = "")
    }
  )
)