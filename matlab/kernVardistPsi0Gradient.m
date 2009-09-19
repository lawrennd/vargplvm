function gk0 = kernVardistPsi0Gradient(kern, vardist)
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
% COPYRIGHT : Mauricio A. Alvarez and Neil D. Lawrence, 2008
%
% MODIFICATIONS : Mauricio A. Alvarez, 2009.


fhandle = str2func([kern.type 'VardistPsi0Gradient']);
gk0 = fhandle(kern, vardist);

% Transformations 
% /~Michalis this must be done similar to kernGradient at some point 
if strcmp(kern.type,'rbfard2')
  gk0 = gk0*kern.variance;
elseif strcmp(kerntype,'linard2')
   %covars = vardist.covars'; 
   %gVarcovars = (gVarcovars(:).*covars(:))'; 
end


