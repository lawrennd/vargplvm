function [gKern, gVarmeans, gVarcovars, gInd] = linard2VardistPsi2Gradient(linard2Kern, vardist, Z, covGrad)
% GGWHITEXGAUSSIANWHITEKERNGRADIENT Compute gradient between the GG white
%                                   and GAUSSIAN white kernels.
% FORMAT
% DESC computes the
%	gradient of an objective function with respect to cross kernel terms
%	between GG white and GAUSSIAN white kernels for the multiple output kernel.
% RETURN g1 : gradient of objective function with respect to kernel
%	   parameters of GG white kernel.
% RETURN g2 : gradient of objective function with respect to kernel
%	   parameters of GAUSSIAN white kernel.
% ARG ggwhitekern : the kernel structure associated with the GG white kernel.
% ARG gaussianwhiteKern :  the kernel structure associated with the GAUSSIAN white kernel.
% ARG x : inputs for which kernel is to be computed.
%
% FORMAT
% DESC  computes
%	the gradient of an objective function with respect to cross kernel
%	terms between GG white and GAUSSIAN white kernels for the multiple output kernel.
% RETURN g1 : gradient of objective function with respect to kernel
%	   parameters of GG white kernel.
% RETURN g2 : gradient of objective function with respect to kernel
%	   parameters of GAUSSIAN white kernel.
% ARG ggwhiteKern : the kernel structure associated with the GG white kernel.
% ARG gaussianwhiteKern : the kernel structure associated with the GAUSSIAN white kernel.
% ARG x1 : row inputs for which kernel is to be computed.
% ARG x2 : column inputs for which kernel is to be computed.
%
% SEEALSO : multiKernParamInit, multiKernCompute, ggwhiteKernParamInit,
% gaussianwhiteKernParamInit
%
% COPYRIGHT : Michalis K. Titsias, 2009
%

% inverse variances
A = linard2Kern.inputScales;

Psi1 = linard2VardistPsi1Compute(linard2Kern, vardist, Z);

sumS = sum(vardist.covars,1);

Amat = sparse(diag(A));  
K = Amat*(vardist.means'*vardist.means + diag(sum(vardist.covars,1)))*Amat;

for q=1:vardist.latentDimension
   sc = sum(vardist.means(:,q)*ones(1,size(Z,1)).*Psi1,1); 
   
   ZZ = Z(:,q)*Z(:,q)';
      
   gKern(q)  = sum(sum( (Z(:,q)*sc + (sumS(q)*A(q))*ZZ).*covGrad )); 
   
   gVarmeans(:,q) =  A(q)*sum(Psi1*((ones(size(Z,1),1)*Z(:,q)').*covGrad),2);
   
   gVarcovars(q) = sum(sum((ZZ.*covGrad)));   
end

gKern = 2*gKern(:)';

gVarmeans = 2*gVarmeans(:)'; % zeros(1,prod(size(vardist.means))); 
gVarcovars = (A.^2).*gVarcovars;
gVarcovars = ones(size(Psi1,1),1)*gVarcovars;

gVarcovars = gVarcovars(:)'; % zeros(1,prod(size(vardist.means)));
gInd = covGrad*Z*K;
gInd = 2*gInd(:)';


