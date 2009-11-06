function [gKern, gVarmeans, gVarcovars, gInd] = kernVardistPsi1Gradient(kern, vardist, Z, covGrad)

% KERNVARDISTPSI1GRADIENT description.  

% VARGPLVM


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
% This must be done similar to kernGradient at some point 
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

