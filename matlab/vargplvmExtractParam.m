function [params, names] = vargplvmExtractParam(model)

% VARGPLVMEXTRACTPARAM Extract a parameter vector from a VARGPLVM model.
% FORMAT
% DESC extracts a parameter vector from a given VARGPLVM structure.
% ARG model : the model from which parameters are to be extracted.
% RETURN params : the parameter vector extracted from the model.
%
% DESC does the same as above, but also returns parameter names.
% ARG model : the model structure containing the information about
% the model.
% RETURN params : a vector of parameters from the model.
% RETURN names : cell array of parameter names.
%
% COPYRIGHT : Michalis K. Titsias, 2009
%
% COPYRIGHT : Neil D. Lawrence, 2009
%
% SEEALSO : vargplvmCreate, vargplvmExpandParam, modelExtractParam

% VARGPLVM

if nargout > 1
  returnNames = true;
else
  returnNames = false;
end 

% Kernel parameters  
if returnNames
  [kernParams, kernParamNames] = kernExtractParam(model.kern); 
  for i = 1:length(kernParamNames)
    kernParamNames{i} = ['Kernel, ' kernParamNames{i}];
  end
  names = {kernParamNames{:}};
else
  kernParams = kernExtractParam(model.kern);
end
params = kernParams;


% beta in the likelihood 
if model.optimiseBeta
   fhandle = str2func([model.betaTransform 'Transform']);
   betaParam = fhandle(model.beta, 'xtoa');
   params = [params betaParam(:)'];
   if returnNames
     for i = 1:length(betaParam)
       betaParamNames{i} = ['Beta ' num2str(i)];
     end
     names = {names{:}, betaParamNames{:}};
   end
end

% Inducing inputs 
if ~model.fixInducing
    params =  [model.X_u(:)' params];
    if returnNames 
      for i = 1:size(model.X_u, 1)
      for j = 1:size(model.X_u, 2)
          X_uNames{i, j} = ['X_u(' num2str(i) ', ' num2str(j) ')'];
      end
      end
      names = {X_uNames{:}, names{:}};
    end
end

% Variational parameters 
if returnNames
  [varParams, varNames] = vardistExtractParam(model.vardist);
  params = [varParams params];
  names = {varNames{:}, names{:}}; 
else
  varParams = vardistExtractParam(model.vardist);
  params = [varParams params];
end

