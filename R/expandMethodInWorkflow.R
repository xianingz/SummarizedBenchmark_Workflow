#' expand methods in workflow
#' 
#' @param bd BenchDesign object
#' @param step the name of the step that should be excluded from building the methods
#' @param label the name of the method that should be excluded from building the methods
#' @param params use all steps and all methods in building workflow
#' 
#' @return new BenchDesign with methods built from workflow
#' 
#' @example 
#' bd <- expandMethodInWorkflow(bd)
#' 
#' @export
expandMethodInWorkflow <- function(bd, step, label, params, onlyone = NULL, .replace = FALSE, .overwrite = FALSE) {
  UseMethod("expandMethodInWorkflow")
}

expandMethodInWorkflow.BenchDesign <- function(bd, step, label, params, onlyone = NULL, .replace = FALSE, .overwrite = FALSE) {
  ## parse new inputs
  if (rlang::is_quosures(params)) {
    if (is.null(onlyone)) {
      stop("If onlyone = NULL, a named list of parameter lists must be supplied to ",
           "'params =' as a list of quosure lists created using rlang::quos.\n",
           "e.g. params = list(new_method1 = quos(..), new_method2 = quos(..))")
    }
    qd <- lapply(1:length(params), function(zi) {
      rlang::quos(!! onlyone := !! params[[zi]])
    })
    names(qd) <- names(params)
  } else if (is.list(params) & all(sapply(params, rlang::is_quosures))) {
    if (!is.null(onlyone)) {
      stop("If onlyone is non-NULL, a list of parameter values must be supplied to ",
           "'params =' as a list of quosures created using rlang::quos.\n",
           "e.g. params = quos(new_method1 = new_value1, new_method2 = new_value2)")
    }
    qd <- params
  } else {
    if (is.null(onlyone)) {
      stop("If 'onlyone = NULL', a named list of parameter lists must be supplied to ",
           "'params =' as a list of quosure lists created using rlang::quos.\n",
           "e.g. params = list(new_method1 = quos(..), new_method2 = quos(..))")
    } else {
      stop("If 'onlyone' is non-NULL, a list of parameter values must be supplied to ",
           "'params =' as a list of quosures created using rlang::quos.\n",
           "e.g. params = quos(new_method1 = new_value1, new_method2 = new_value2)")
    }
  }
  
  ## verify that parameter names are valid
  if (is.null(names(qd)) | any(nchar(names(qd)) == 0)) {
    stop("New parameter values must be named.")
  }
  if (any(names(qd) %in% names(attributes(bd)$Workflow[[step]]))) {
    stop("New method names should not overlap with names of current methods.")
  }
  if (any(duplicated(names(qd)))) {
    stop("New method names must be unique.")
  }
  
  ## verify that method definition already exists
  if(!(label %in% names(attributes(bd)$Workflow[[step]]))) {
    stop("Specified method is not defined in BenchDesign.")
  }
  bm <- attributes(bd)$Workflow[[step]][[label]]
  
  ## handle all using same named list format
  zl <- lapply(qd, .modmethod, m = bm, .overwrite = .overwrite)
  names(zl) <- names(qd)
  
  ## drop source method
  if (.replace) {
    bd <- dropMethodFromWorkflow(bd, step, label)
  }
  
  attributes(bd)$Workflow[[step]] <- c(attributes(bd)$Workflow[[step]], zl)
  bd
}