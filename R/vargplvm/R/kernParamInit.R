kernParamInit <-
function (kern, matlabway = FALSE) {
  
  funcName <- paste(kern$type, "KernParamInit", sep="")
  kern$transforms <- list()

  func <- get(funcName, mode="function")
  kern <- func(kern, matlabway = matlabway)  

  return (kern)
}
