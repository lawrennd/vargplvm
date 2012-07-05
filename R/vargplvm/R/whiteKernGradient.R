whiteKernGradient <-
  function (kern, x, matlabway = TRUE, x2, covGrad) {

    if (missing(covGrad)) {
      covGrad <- x2
      g <- sum(diag(as.matrix(covGrad)))
    } else {
      g <- 0
    }  
    
    return (g)
  }
