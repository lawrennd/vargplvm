function [gKern, gVarmeans, gVarcovars] = kernVardistPsi0Gradient(kern, vardist, covGrad)

% KERNVARDISTPSI0GRADIENT description.  

% VARGPLVM


  
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

% variational variances are positive (This should rather go to
% vargplvmLogLikeGradients)
%gVarcovars = (gVarcovars(:).*vardist.covars(:))';


%-----------------------------------------------------
% This applies transformations 
% This must be done similar to kernGradient at some point 
function gK = paramTransformPsi0(kern, gK)
%
% 

if strcmp(kern.type,'rbfardjit') | strcmp(kern.type,'rbfard2') | strcmp(kern.type,'bias') | strcmp(kern.type,'white')
    gK(1) = gK(1)*kern.variance;
elseif strcmp(kern.type,'linard2')
    gK(1:end) = gK(1:end).*kern.inputScales;
end

