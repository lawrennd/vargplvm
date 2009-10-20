function [gKern, gVarmeans, gVarcovars, gInd] = kernVardistPsi1Gradient(kern, vardist, Z, covGrad)
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


if ~strcmp(kern.type,'cmpnd')
   % 
   fhandle = str2func([kern.type 'VardistPsi1Gradient']);
   [gKern, gVarmeans, gVarcovars, gInd] = fhandle(kern, vardist, Z, covGrad);    
   
   % Transformations
   gKern = paramTransformPsi1(kern, gKern); 
   %
else % the kernel is cmpnd
   %
   fhandle = str2func([kern.comp{1}.type 'VardistPsi1Gradient']);
   [gKern, gVarmeans, gVarcovars, gInd] = fhandle(kern.comp{1}, vardist, Z, covGrad);
   % Transformations
   gKern = paramTransformPsi1(kern.comp{1}, gKern); 
   %
   for i = 2:length(kern.comp)
       %
       fhandle = str2func([kern.comp{i}.type 'VardistPsi1Gradient']);
       [gKerni, gVarmeansi, gVarcovarsi, gIndi] = fhandle(kern.comp{i}, vardist, Z, covGrad);
       
       % Transformations
       gKerni = paramTransformPsi1(kern.comp{i}, gKerni); 
   
       gVarmeans = gVarmeans + gVarmeansi; 
       gVarcovars = gVarcovars + gVarcovarsi;
       gInd = gInd + gIndi;
       gKern = [gKern gKerni]; 
       %
   end
   % 
end

% variational variances are positive  
gVarcovars = (gVarcovars(:).*vardist.covars(:))'; 



%-----------------------------------------------------
% This applies transformations 
% /~This must be done similar to kernGradient at some point 
function gKern = paramTransformPsi1(kern, gKern)
%
% 
if strcmp(kern.type,'rbfard2')
   gKern(1) = gKern(1)*kern.variance;
   gKern(2:end) = gKern(2:end).*kern.inputScales; 
elseif strcmp(kern.type,'linard2')
   gKern(1:end) = gKern(1:end).*kern.inputScales;
elseif strcmp(kern.type,'bias')
   gKern = gKern*kern.variance;   
else
   % do nothing
end

