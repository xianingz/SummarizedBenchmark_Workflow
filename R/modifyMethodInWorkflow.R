modifyMethodInWorkflow <- function(bd, step, method_label, params, .overwrite = FALSE) {
  UseMethod("modifyMethodInWorkflow")
}

#' @export
modifyMethodInWorkflow.BenchDesign <- function(bd, step, method_label, params, .overwrite = FALSE) {
  ## verify that method definition already exists
  if(!(step %in% names(attributes(bd)$Workflow))) {
    stop("Specified step is not defined in BenchDesign")
  }else{
    if(!(method_label %in% names(attributes(bd)$Workflow[[step]]))) {
      stop("Specified method is not defined in specified Step")
    }
  }
  
  if (!rlang::is_quosures(params)) {
    stop("Please supply 'func' parameters to 'params =' as ",
         "a list of quosures using rlang::quos.\n",
         "e.g. params = quos(param1 = x, param2 = y)")
  }
  
  ## modify and add to bench
  bm <- attributes(bd)$Workflow[[step]][[method_label]]
  attributes(bd)$Workflow[[step]][[method_label]] <- .modmethod(bm, params, .overwrite)
  
  return(bd)
}

.modmethod <- function(m, q, .overwrite) {
  ## parse out post, meta
  if ("bd.post" %in% names(q)) {
    new_post <- rlang::eval_tidy(q$bd.post)
  } else {
    new_post <- m@post
  }
  if ("bd.meta" %in% names(q)) {
    new_meta <- rlang::eval_tidy(q$bd.meta)
  } else {
    new_meta <- m@meta
  }
  
  ## process named parameters to be used for func
  q <- q[! names(q) %in% c("bd.post", "bd.meta")]
  if (.overwrite) {
    new_params <- q
  } else {
    new_params <- replace(m@params, names(q), q)
  }
  
  ## easiest way to create modified BDMethod w/ m@f, m@fc
  bd <- BDMethod(x = m@f, post = new_post, meta = new_meta,
                 params = new_params)
  bd@fc <- m@fc
  bd
}