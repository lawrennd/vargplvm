kernGradient <-
function (kern, x, ...) {
  funcName <- paste(kern$type, "KernGradient", sep="")
  func <- get(funcName, mode="function")

  g <- func(kern, x, ...)

  factors <- kernFactors(kern, "gradfact")
  g[factors$index] <- g[factors$index]*factors$val

  return (g)
}
