linard2VardistPsi1Compute <- function (linard2kern, vardist, Z)
{
  # % LINARD2VARDISTPSI1COMPUTE description.
  
  # % VARGPLVM
  #cat("linard2VardistPsi1Compute ")
  #print(linard2kern$type)
  #print(dim(vardist$means))
  #print(dim(Z))
  K <- kernCompute(linard2kern,vardist$means, x2 = Z);
  P <- NULL
  return (list(K = K, P = P))
}