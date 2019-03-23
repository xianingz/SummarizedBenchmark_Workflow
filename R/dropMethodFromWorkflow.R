#' drop methods from workflow in BenchDesign object
#' 
#' @param bd BenchDesign object
#' @param step the name of the step that the method is from
#' @param method_label the name of the method that is to be dropped
#' 
#' @return new BenchDesign with methods built from workflow
#' 
#' @example 
#' bd <- dropMethodFromWorkflow(bd, step="First", method_label="pvalue"))
#' 
#' @export
dropMethodFromWorkflow <- function(bd, step, method_label) {
  UseMethod("dropMethodFromWorkflow")
}

#' @export
dropMethodFromWorkflow.BenchDesign <- function(bd, step, method_label) {
  ## verify that method definition already exists
  if(!(step %in% names(attributes(bd)$Workflow))) {
    stop("Specified step is not defined in BenchDesign")
  }else{
    if(!(method_label %in% names(attributes(bd)$Workflow[[step]]))) {
      stop("Specified method is not defined in specified Step")
    }
  }
  
  attributes(bd)$Workflow[[step]][[method_label]] <- NULL
  return(bd)
}