function Psi0 = kernVardistPsi0Compute(kern, vardist)

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


if ~strcmp(kern.type,'cmpnd')
  %  
  fhandle = str2func([kern.type 'VardistPsi0Compute']);
  Psi0 = fhandle(kern, vardist);
  %
else  % the kernel is cmpnd
  % 
  fhandle = str2func([kern.comp{1}.type 'VardistPsi0Compute']);
  Psi0 = fhandle(kern.comp{1}, vardist);
  %
  for i = 2:length(kern.comp)
      %
      fhandle = str2func([kern.comp{i}.type 'VardistPsi0Compute']);
      Psi0 = Psi0 + fhandle(kern.comp{i}, vardist);
      %
  end
  %
end

