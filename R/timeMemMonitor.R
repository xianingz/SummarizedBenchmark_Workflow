time_mem <- function(code) {
  start_gc <- gc(reset = TRUE)
  start_mem <- show_bytes(sum(start_gc[, "used"] * c(node_size(), 8)))
  start_max <- show_bytes(sum(start_gc[, "max used"] * c(node_size(), 8)))
  start_time <- Sys.time()
  
  expr <- substitute(code)
  eval(expr, parent.frame())
  rm(code, expr)
  
  
  end_time <- Sys.time()
  end_gc <- gc(reset = FALSE)
  end_mem <- show_bytes(sum(end_gc[, "used"] * c(node_size(), 8)))
  end_max <- show_bytes(sum(end_gc[, "max used"] * c(node_size(), 8)))
  
  mem_change <- show_bytes(end_mem - start_mem)
  mem_peak <- show_bytes(end_max - start_max)
  time_change <- as.numeric(difftime(end_time, start_time, units = "mins"))
  
  return(list(mem_change = mem_change, mem_peak = mem_peak, time_change = time_change))
}

node_size <- function() {
  bit <- 8L * .Machine$sizeof.pointer
  if (!(bit == 32L || bit == 64L)) {
    stop("Unknown architecture", call. = FALSE)
  }
  
  if (bit == 32L) 28L else 56L
}

#' @export
print.bytes <- function(x, digits = 3, ...) {
  ##To MB
  x <- x / (1000 ^ 2)
  unit <- "MB"
  formatted <- format(signif(x, digits = digits), big.mark = ",",
                      scientific = FALSE)
  
  cat(formatted, "\n", sep = "")
}
