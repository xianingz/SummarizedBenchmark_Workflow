initWorkflow <- function(bd, label=NULL, steps) {
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