setClass("BDWorkflow", contains =  "SimpleList")

setValidity("BDWorkflow",
            function(object){
              if (!all(unlist(lapply(object, is, "BDMethodList"))))
                stop("All steps must be named BDMethodList objects.")
              if (length(object) >0 && is.null(names(object)))
                stop("All steps must be named BDMethodList objects, steps were unamed.")
              if (length(object) >0 && any(!nzchar(names(object))))
                stop("All steps must be named BDMethodList objects, some steps were unnamed.")
              if (length(object) >0 && any(duplicated(names(object))))
                stop("Some step names were duplicated.")
              TRUE
            })