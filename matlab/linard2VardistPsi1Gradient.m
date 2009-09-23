function [gKern, gVarmeans, gVarcovars, gInd] = linard2VardistPsi1Gradient(linard2Kern, vardist, Z, covGrad)
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

A = linard2Kern.inputScales;
%
for q=1:vardist.latentDimension
   gKern(q) = sum(sum((vardist.means(:,q)*(Z(:,q)')).*covGrad));
   
   gVarmeans(:,q) = A(q)*sum((ones(vardist.numData,1)*Z(:,q)').*covGrad,2);
   gInd(:,q) = A(q)*sum((vardist.means(:,q)*ones(1,size(Z,1))).*covGrad,1)';
   
   %gVarmeans2(:,q) = A(q)*sum(repmat(Z(:,q)',vardist.numData,1).*covGrad,2);
   %gInd2(:,q) = A(q)*sum(repmat(vardist.means(:,q),1,size(Z,1)).*covGrad,1)';
end
%

gKern = gKern(:)';  
% gVarmeans is N x Q matrix (N:number of data, Q:latent dimension)
% this will unfold this matrix column-wise 
gVarmeans = gVarmeans(:)'; 

% gInd is M x Q matrix (M:number of inducing variables, Q:latent dimension)
% this will unfold this matrix column-wise 
gInd = gInd(:)'; 

gVarcovars = zeros(1,prod(size(vardist.covars))); 
