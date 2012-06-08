test <-
function (N =10)
{
  # % variational means
  #N <- 100 
  # %  inducing variables 
  M <- 50  
  Q <- 10
  
  # % inverse variances
  A <- rep(1.2, Q) 

  ZmZm  <- array(0.2, dim = c(M,Q,M)) 
asPlus1 <- matrix(1.5, N, Q)
  aDasPlus1 <- asPlus1 +0.4
  
  #covGrad <- (rbfardKern$variance^2)*(covGrad*r2vp2c$outKern) 
  covGrad <- array(0.1, dim = c(M, 1, M)) 
   
means <- matrix(0.7, N, Q)
covars <- matrix(0.8,N, Q)
stim <- system.time( { 
  out <-.Call("vargplvm", M, N, Q, A, 
              means, covars, asPlus1, aDasPlus1,
              ZmZm, covGrad)
  })[3]
  cat("rbfard2VardistPsi2GradientOrig systime is ")
  print(stim)
partInd2 <-out$partInd2
partA2 <-out$partA2
gVarmeans <-out$gVarmeans
gVarcovars <-out$gVarcovars
  return (out)
}
