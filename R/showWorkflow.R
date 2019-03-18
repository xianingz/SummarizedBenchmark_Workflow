.show.BDWorkflow <- function(object) {
  cat(stringr::str_pad("BenchDesign Workflow (BDWorkflow) ", 60, "right", "-"), "\n")
  cat("list of", length(object), ifelse(length(object) == 1L, "step", "steps"), "\n")
  if(length(object) < 1){
    cat("  none\n")
  }else{
    i=0
    for(n in names(object)) {
      i = i + 1
      cat("  Step",i,": ", n, ", ",length(object[[i]]), " methods\n", sep = "")
      if(length(object[[i]]) < 1)
        cat("    none")
      else
        cat("    ")
      for(ni in names(object[[i]])) {
        cat(ni, "; ", sep = "")
      }
      cat("\n")
      
    }
  }
}

#' @param object BDWorkflow object to show
#' 
#' @importFrom stringr str_pad str_trunc
#' @import rlang
#' @rdname BDWorkflow-class
setMethod("show", signature(object = "BDWorkflow"), .show.BDWorkflow)