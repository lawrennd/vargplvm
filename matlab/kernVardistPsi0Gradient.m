function [gKern, gVarmeans, gVarcovars] = kernVardistPsi0Gradient(kern, vardist, covGrad)
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

if ~strcmp(kern.type,'cmpnd')
   % 
   fhandle = str2func([kern.type 'VardistPsi0Gradient']);
   [gKern, gVarmeans, gVarcovars] = fhandle(kern, vardist, covGrad);    
   
   % Transformations
   gKern = paramTransformPsi0(kern, gKern); 
   %
else % the kernel is cmpnd
   %
   fhandle = str2func([kern.comp{1}.type 'VardistPsi0Gradient']);
   [gKern, gVarmeans, gVarcovars] = fhandle(kern.comp{1}, vardist, covGrad);
   % Transformations
   gKern = paramTransformPsi0(kern.comp{1}, gKern); 
   %
   for i = 2:length(kern.comp)
       %
       fhandle = str2func([kern.comp{i}.type 'VardistPsi0Gradient']);
       [gKerni, gVarmeansi, gVarcovarsi] = fhandle(kern.comp{i}, vardist, covGrad);
       
       % Transformations
       gKerni = paramTransformPsi0(kern.comp{i}, gKerni); 
   
       gVarmeans = gVarmeans + gVarmeansi; 
       gVarcovars = gVarcovars + gVarcovarsi;
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
function gK = paramTransformPsi0(kern, gK)
%
% 

if strcmp(kern.type,'rbfard2') | strcmp(kern.type,'bias')
    gK(1) = gK(1)*kern.variance;
elseif strcmp(kern.type,'linard2')
    gK(1:end) = gK(1:end).*kern.inputScales;
end

