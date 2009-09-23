function [gKern, gVarmeans, gVarcovars] = linard2VardistPsi0Gradient(linard2Kern, vardist, covGrad)
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
% SEEALSO :
% COPYRIGHT : Michalis K. Titsias
%

A = linard2Kern.inputScales;
gKern = covGrad*sum((vardist.means.*vardist.means) + vardist.covars,1); 
 
gVarmeans = 2*(vardist.means*sparse(diag(A))); 
%gVarmeans1 = 2*(repmat(A,size(vardist.means,1),1).*vardist.means); 

gVarcovars = ones(size(vardist.means,1),1)*A; 

gVarmeans = covGrad*gVarmeans(:)'; 
gVarcovars = covGrad*gVarcovars(:)';


