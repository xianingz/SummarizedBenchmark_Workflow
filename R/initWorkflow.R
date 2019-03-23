#' initiate workfow with steps in BenchDesign object
#' 
#' @param bd BenchDesign object
#' @param steps a vector with the name of the steps for the workfle
#' 
#' @return new BenchDesign object with workflow
#' 
#' @example 
#' b <- initWorkflow(bd, steps=c("First","Second","Third))
#' 
#' @import SummarizedBenchmark
#' @export
initWorkflow <- function(bd, steps) {
  UseMethod("initWorkflow")
}

initWorkflow.BenchDesign <- function(bd, steps){
  workflow = SimpleList()
  for(i in c(1:length(steps))){
    workflow[[i]] <- new("BDMethodList",list())
  }
  names(workflow) <- steps
  attributes(bd)$Workflow <- new("BDWorkflow", workflow)
  return(bd)
}

setAs("list", "BDWorkflow", function(from) {
  new("BDWorkflow", as(from, "SimpleList"))
})