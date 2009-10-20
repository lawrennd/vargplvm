function Psi0 = linard2VardistPsi0Compute(linard2kern, vardist)

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
% COPYRIGHT : Michalis K. Titsias, 2009
%

A = linard2kern.inputScales;
Psi0 = sum(A.*sum((vardist.means.*vardist.means) + vardist.covars,1));

%Psi0covs = sum(A.*sum(vardist.covars,1)); 

%psi00 = kernCompute(linard2kern,vardist.means);
%ok = 0;
%for n=1:size(vardist.means,1)
%    ok = ok + trace(diag(A)*(vardist.means(n,:)'*vardist.means(n,:))) + trace(diag(A)*diag(vardist.covars(n,:))); 
%end
%ok
%pause
%Psi0 = Psi0means + Psi0covs;



