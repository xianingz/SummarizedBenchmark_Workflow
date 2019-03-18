time_mem <- function(code) {
  start_gc <- gc(reset = TRUE)
  start_mem <- sum(start_gc[, "used"] * c(node_size(), 8))
  start_max <- sum(start_gc[, "max used"] * c(node_size(), 8))
  start_time <- Sys.time()
  
  expr <- substitute(code)
  eval(expr, parent.frame())
  rm(code, expr)
  
  
  end_time <- Sys.time()
  end_gc <- gc(reset = FALSE)
  end_mem <- sum(end_gc[, "used"] * c(node_size(), 8))
  end_max <- sum(end_gc[, "max used"] * c(node_size(), 8))
  
  mem_change <- round(as.numeric(end_mem - start_mem)/1000^2,2)
  mem_peak <- round(as.numeric(end_max - start_max)/1000^2,2)
  time_change <- round(as.numeric(difftime(end_time, start_time, units = "mins")),2)
  
  return(list(mem_change = mem_change, mem_peak = mem_peak, time_change = time_change))
}

node_size <- function() {
  bit <- 8L * .Machine$sizeof.pointer
  if (!(bit == 32L || bit == 64L)) {
    stop("Unknown architecture", call. = FALSE)
  }
  
  if (bit == 32L) 28L else 56L
}