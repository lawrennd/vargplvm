rbfard2KernGradXpoint <-
function (kern, x, X2)
{
# % RBFARD2KERNGRADXPOINT Gradient with respect to one point of x.

scales <- Matrix(sqrt(diag(kern$inputScales)), sparse = TRUE) 
gX <- matrix(0, dim(X2)[1], dim(X2)[2]) 
n2 <- dist2(X2%*%scales, x%*%scales) 
rbfPart <- kern$variance*exp(-n2*0.5) 
for (i in 1:dim(x)[2])
{
  gX[, i] <- as.vector(kern$inputScales[i]*(t(t(X2[, i])) - x[i])*rbfPart) 
}
return (gX)
}
