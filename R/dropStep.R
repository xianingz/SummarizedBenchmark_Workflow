dropStep <- function(bd, step) {
  UseMethod("dropStep")
}

#' @export
dropStep.BenchDesign <- function(bd, step) {
  ## verify that method definition already exists
  if(!(step %in% names(attributes(bd)$Workflow))) {
    stop("Specified step is not defined in BenchDesign")
  }
  
  attributes(bd)$Workflow[[step]] <- NULL
  return(bd)
}