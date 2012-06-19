testcpp <- function(M, N, Q, A, vardist, asPlus1, aDasPlus1, ZmZm, covGrad, gVarmeans,
                    gVarcovars, partInd2, partA2, Amq)
{
  for (n in 1:N)
  {  
#     cat("n is ")
#     print (n)
#     cat("\n")
    #   source('~/Desktop/Software/Rcode/Rcode/repmat.R')
    mu_n <- vardist$means[n,]  
    s2_n <- vardist$covars[n,]  
    AS_n <- asPlus1[n,]   
    
    MunZmZm <- array(repmat(mu_n, M, 1), dim = c(M, length(mu_n), M))  -ZmZm 
    #     %MunZmZm = repmat(mu_n, [M 1 M]) - ZmZm;
    #     MunZmZm <- bsxfun(@minus,mu_n,ZmZm) 
    MunZmZmA <- MunZmZm/array(repmat(AS_n, M, 1), dim = c(M, length(AS_n), M)) 
    #     %MunZmZmA = MunZmZm./repmat(AS_n,[M 1 M]);
    #     MunZmZmA <-  bsxfun(@rdivide, MunZmZm, AS_n) 
    
    
    temp2 <- (MunZmZm^2)*array(repmat(aDasPlus1[n,], M, 1), dim = c(M, length(aDasPlus1[n,]), M))  
    k2Kern_n <- array(0, dim = c(dim(temp2)[1], 1, dim(temp2)[3]))
    for (q1 in 1: dim(temp2)[3])
    {
      k2Kern_n[,,q1] <- rowSums(temp2[,,q1]) 
    }
    #     %k2Kern_n = sum((MunZmZm.^2).*repmat(aDasPlus1(n,:),[M 1 M]),2);   
    #     k2Kern_n <- sum(  bsxfun(@times, MunZmZm.^2,aDasPlus1(n,:)),2) 
    
    k2Kern_n <- exp(-k2Kern_n)/prod(sqrt(AS_n)) 
    
    #     % derivatives wrt to variational means
    #     k2ncovG <- repmat(k2Kern_n*covGrad,[1 Q 1])  
    prod3 <- k2Kern_n*covGrad
    k2ncovG<- array(0, dim = dim(ZmZm))
    for (q in 1:dim(prod3)[3])
    {
      k2ncovG[,,q] <- matrix(prod3[,,q], length(prod3[,,q]), Q) 
    }
    #     %tmp2 <- tmp + reshape(diag(diag(squeeze(tmp))),[M 1 M]) 
    #     %diagCorr <- diag(diag(squeeze(tmp)))  
    tmp <- MunZmZmA*k2ncovG 
    tmp <- apply(tmp,1:2, sum) 
    gVarmeans[n,] <- -2*A*(colSums(tmp)) 
    
    #     % derivatives wrt inducing inputs 
    #     %diagCorr <- diagCorr*(repmat(mu_n,[M 1]) - Z).*repmat(aDasPlus1(n,:),[M 1]) 
    #     %partInd2 <- partInd2 + Amq.*(sum(tmp,3) + diagCorr) 
    partInd2 <- partInd2 + Amq*tmp 
    
    
    #     % Derivative wrt input scales  
    MunZmZmA <- MunZmZmA*MunZmZm  
    partA2 <- partA2 + colSums(apply(((MunZmZmA + array(repmat(s2_n, M, 1), dim = c(M, length(s2_n), M)))*
      k2ncovG)/array(repmat(AS_n, M, 1), dim = c(M, length(AS_n), M)),1:2, sum))
    #     %partA2 <- partA2 + sum(sum(((MunZmZmA + repmat(s2_n,[M 1 M])).*k2ncovG)./repmat(AS_n,[M 1 M]),1),3) 
    #     tmppartA2 <- bsxfun(@plus, MunZmZmA,s2_n).*k2ncovG 
    #     partA2 <- partA2 + sum(sum( bsxfun(@rdivide, tmppartA2, AS_n), 1),3) 
    
    #     % derivatives wrt variational diagonal covariances 
    MunZmZmA <- MunZmZmA*array(repmat(A, M, 1), dim = c(M, length(A), M))
    #     %MunZmZmA <- MunZmZmA.*repmat(A,[M 1 M]) 
    #     MunZmZmA <- bsxfun(@times, MunZmZmA, A) 
    gVarcovars[n,] <- colSums(apply(array(repmat(aDasPlus1[n,], M, 1), dim = c(M, length(aDasPlus1[n,]), M))*
      (2*MunZmZmA - 1)*k2ncovG,1:2, sum))
  }
  return (list(partInd2 =  partInd2, partA2 = partA2, gVarcovars = gVarcovars, gVarmeans =gVarmeans ))
}
