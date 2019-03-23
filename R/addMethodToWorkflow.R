#' initiate workfow with steps in BenchDesign object
#' 
#' @param bd BenchDesign object
#' @param step the name of the step that the method is added to
#' @param method_label the name of the method
#' @param func function of the method
#' @param params parameter of the function
#' @param post Optional post-processing function
#' @param meta Optional meta-information
#' 
#' @return new BenchDesign object with the method added
#' 
#' @example 
#' b <- addMethodToWorkflow(bd, steps="First",method_label=""))
#' 
#' @export
addMethodToWorkflow <- function(bd, step, method_label, func, params = rlang::quos(), post=NULL, meta = NULL) {
  UseMethod("addMethodToWorkflow")
}

addMethodToWorkflow.BenchDesign <- function(bd, step, method_label, func, params = rlang::quos(), post=NULL, meta = NULL){
  if (!rlang::is_quosures(params)) {
    stop("Please supply 'func' parameters to 'params =' as ",
         "a list of quosures using rlang::quos.\n",
         "e.g. params = quos(param1 = x, param2 = y)")
  }
  ## capture input
  qf <- rlang::enquo(func)
  
  ## add to bench
  attributes(bd)$Workflow[[step]][[method_label]] <- BDMethod(x = qf, params = params, post = post, meta = meta)
  bd
}