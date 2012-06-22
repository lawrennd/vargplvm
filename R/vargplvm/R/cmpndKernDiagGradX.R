cmpndKernDiagGradX <-
function (kern, X) {
  X <- as.matrix(X)
  i <- 1

  if ( !is.na(kern$comp[[i]]$index) ) {
    gX <- matrix(0, dim(X)[1], dim(X)[2])
    gX[,kern$comp[[i]]$index] <-
      kernDiagGradX(kern$comp[[i]], X[,kern$comp[[i]]$index])
  } else {
    gX <- kernDiagGradX(kern$comp[[i]], X)
  }

  for ( i in seq(2, length=(length(kern$comp)-1)) ) {
    if ( !is.na(kern$comp[[i]]$index) ) {
      gX[,kern$comp[[i]]$index] <- gX[,kern$comp[[i]]$index] + 
        kernDiagGradX(kern$comp[[i]], X[,kern$comp[[i]]$index])
    } else {
      gX <- gX + kernDiagGradX(kern$comp[[i]], X)
    }
  }
 
  return (gX)
}
