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