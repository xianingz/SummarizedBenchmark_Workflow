buildMethodFromWorkflow <- function(bd, steps.exclude=NULL, methods.exclude=NULL,all=TRUE){
  UseMethod("buildMethodFromWorkflow")
}

buildMethodFromWorkflow.BenchDesign <- function(bd, methods=NULL, label=NULL,all=TRUE){
  ##Removing existing methods
  if(all){
    for(n in names(bd@methods)){
      BDMethodList(bd)[[n]] <- NULL
    }
  }
  
  vecs <- c()
  steps <- names(attributes(bd)$Workflow)
  num.steps <- length(steps)
  
  if(!is.null(methods)){
    if(length(methods)!= num.steps){
      stop("The length of methods is not correct. The length should equal to the number of steps defined")
    }
    for(i in c(1:num.steps)){
      if(methods[i] != "NULL"){
        if(!methods[i] %in% names(attributes(bd)$Workflow[[i]]))
          o1 <- "The method specified in step"
          o2 <- i
          o3 <- steps[i]
          o4 <- "doesn't exist. Please check the name or add it into the Workflow"
          stop(paste0(c(o1,o2,o3,o4), collapse = "_"))
      }
    }
    ##Name
    if(is.null(label)){
      label = paste0(methods, collapse = "_")
    }
    ##Construct function
    wfl <- function(...){
      #params.list <- list(...)
      tgb <- c()
      for(j in c(1:num.steps)){
        if(j ==1){
          #bd@data@data[["TBG"]] <- 
          f <- attributes(bd)$Workflow[[steps[[j]]]][[methods[j]]]@f
          #params <- params.list[[j]]
          params <- attributes(bd)$Workflow[[steps[[j]]]][[methods[j]]]@params
          expr <- rlang::quo((f)(!!! params))
          tgb <- eval_tidy(expr)
          #show(tgb)
          #cat("finish")
        }else if(j != num.steps){
          #bd@data@data[["TBG"]] <- 
          f <- attributes(bd)$Workflow[[steps[[j]]]][[methods[j]]]@f
          #params <- params.list[[j]]
          params <- attributes(bd)$Workflow[[steps[[j]]]][[methods[j]]]@params
          expr <- rlang::quo((f)(tgb,!!!params))
          tgb <- eval_tidy(expr)
          #show(tgb)
          #cat("finish")
        }else{
          f <- attributes(bd)$Workflow[[steps[[j]]]][[methods[j]]]@f
          #params <- params.list[[j]]
          params <- attributes(bd)$Workflow[[steps[[j]]]][[methods[j]]]@params
          expr <- rlang::quo((f)(tgb,!!!params))
          res <- eval_tidy(expr)
          #show(res)
          return(res)
        }
      }
    }
    bd <- addMethod(bd, label = label, func = wfl, params = rlang::quos())
    return(bd)
  }
  
  ##Add methods from workflow
  for(i in c(1:num.steps)){
    vecs <- c(vecs, length(attributes(bd)$Workflow[[i]]))
  }
  vecs <- mapply(seq,1,vecs)
  iterall <- do.call(expand.grid, vecs)
  for(i in c(1:dim(iterall)[1])){
    names <- c()
    params.list <- list()
    for(j in (1:num.steps)){
      names <- c(names, names(attributes(bd)$Workflow[[steps[[j]]]])[iterall[i,j]])
      params.list[[j]] <- attributes(bd)$Workflow[[steps[[j]]]][[iterall[i,j]]]@params
    }
    label = paste(names, collapse = "_")
    
    wfl <- function(...){
      #params.list <- list(...)
      tgb <- c()
      for(j in c(1:num.steps)){
        if(j ==1){
          #bd@data@data[["TBG"]] <- 
          f <- attributes(bd)$Workflow[[steps[[j]]]][[iterall[i,j]]]@f
          #params <- params.list[[j]]
          params <- attributes(bd)$Workflow[[steps[[j]]]][[iterall[i,j]]]@params
          expr <- rlang::quo((f)(!!! params))
          tgb <- eval_tidy(expr)
          #show(tgb)
          #cat("finish")
        }else if(j != num.steps){
          #bd@data@data[["TBG"]] <- 
          f <- attributes(bd)$Workflow[[steps[[j]]]][[iterall[i,j]]]@f
          #params <- params.list[[j]]
          params <- attributes(bd)$Workflow[[steps[[j]]]][[iterall[i,j]]]@params
          expr <- rlang::quo((f)(tgb,!!!params))
          tgb <- eval_tidy(expr)
          #show(tgb)
          #cat("finish")
        }else{
          f <- attributes(bd)$Workflow[[steps[[j]]]][[iterall[i,j]]]@f
          #params <- params.list[[j]]
          params <- attributes(bd)$Workflow[[steps[[j]]]][[iterall[i,j]]]@params
          expr <- rlang::quo((f)(tgb,!!!params))
          res <- eval_tidy(expr)
          #show(res)
          return(res)
        }
      }
    }
    bd <- addMethod(bd, label = label, func = wfl, params = rlang::quos())
  }
  return(bd)
}