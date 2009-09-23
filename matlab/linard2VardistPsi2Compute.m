function [Psi2 P] = linard2VardistPsi2Compute(linard2kern, vardist, Z)

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


%Psi1 = linard2KernCompute(linard2kern, vardist.means, Z);
%sqrtAS = sparse(diag(linard2kern.inputScales.*sqrt(sum(vardist.covars,1))));
%Zsc = Z*sqrtAS;
%P = Psi1'*Psi1;
%Psi2 = P + Zsc*Zsc';

ZA = Z*sparse(diag(linard2kern.inputScales));
Psi2 = ZA*(vardist.means'*vardist.means + diag(sum(vardist.covars,1)))*ZA';

P = [];




