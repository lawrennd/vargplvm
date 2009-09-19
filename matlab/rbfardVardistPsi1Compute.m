function [K, Knovar, argExp] = rbfardVardistPsi1Compute(rbfardKern, vardist, Z)

% RBFARD2XGAUSSIANVARIATIONALDISTKERNCOMPUTE Compute a cross kernel after convolution of the rbfard2 (rbfard with the traditional 
%   parametrizatiion) and a variational Gaussian distribution (a separate Gaussina for each row of X)
% FORMAT
% DESC computes cross kernel
%	terms between GG white and GAUSSIAN white kernels for the multiple output kernel.
% RETURN k :  block of values from kernel matrix.
% ARG ggKern : the kernel structure associated with the GG kernel.
% ARG gaussianKern : the kernel structure associated with the GAUSSIAN kernel.
% ARG x :  inputs for which kernel is to be computed.
%
% FORMAT
% DESC computes cross
%	kernel terms between GG white and GAUSSIAN white kernels for the multiple output
%	kernel.
% RETURN K : block of values from kernel matrix.
% ARG ggwhiteKern :  the kernel structure associated with the GG kernel.
% ARG gaussianwhiteKern the kernel structure associated with the GAUSSIAN kernel.
% ARG x : row inputs for which kernel is to be computed.
% ARG x2 : column inputs for which kernel is to be computed.
%
% SEEALSO : multiKernParamInit, multiKernCompute, ggwhiteKernParamInit,
%           gaussianwhiteKernParamInit
%
%
% COPYRIGHT : Michalis K. Titsias and Neil D. Lawrence, 2009
%

% KERN

% variational means
N  = size(vardist.means,1);
%  inducing variables 
M = size(Z,1); 

A = rbfardKern.inverseWidth;
         
argExp = zeros(N,M); 
normfactor = ones(N,1);
for q=1:vardist.latentDimension
%
    S_q = vardist.covars(:,q);  
    normfactor = normfactor.*(A(q)*S_q + 1);
    Mu_q = vardist.means(:,q); 
    Z_q = Z(:,q)'; 
    distan = (repmat(Mu_q,[1 M]) - repmat(Z_q,[N 1])).^2;
    size(distan)
    size(repmat(A(q)/(A(q)*S_q + 1), [1 M]))
    argExp = argExp + repmat(A(q)/(A(q)*S_q + 1), [1 M]).*distan;
%
end
Knovar = repmat(normfactor,[1 M]).*exp(-0.5*argExp); 
K = rbfardKern.variance.*Knovar; 


