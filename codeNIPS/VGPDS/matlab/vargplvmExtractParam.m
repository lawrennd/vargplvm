function [params, names] = vargplvmExtractParam(model)

% VARGPLVMEXTRACTPARAM Extract a parameter vector from a variational GP-LVM model.
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
% COPYRIGHT : Michalis K. Titsias and Neil D. Lawrence, 2009-2011
%
% Modifications: Andreas C. Damianou, 2010-2011 
%
% SEEALSO : vargplvmCreate, vargplvmExpandParam, modelExtractParam

% VARGPLVM

%%% Parameters must be returned as a vector in the following order (left to right) 
% - parameter{size} -
% vardistParams{model.vardist.nParams} % mu, S
%       OR
% [dynamicsVardistParams{dynamics.vardist.nParams} dynamics.kernParams{dynamics.kern.nParams}] % mu_bar, lambda
% inducingInputs{model.q*model.k}
% kernelParams{model.kern.nParams}
% beta{prod(size(model.beta))}


if nargout > 1
  returnNames = true;
else
  returnNames = false;
end 

if isfield(model, 'dynamics') & ~isempty(model.dynamics)
    % [VariationalParameters(reparam)   dynKernelParameters]
    if returnNames
        [dynParams, dynParamNames] = modelExtractParam(model.dynamics);
        names = dynParamNames;
    else
        dynParams = modelExtractParam(model.dynamics);
    end
    params = dynParams;
else
    % Variational parameters 
    if returnNames
        %[varParams, varNames] = vardistExtractParam(model.vardist);
        [varParams, varNames] = modelExtractParam(model.vardist);
        names = varNames{:}; 
    else
        %varParams = vardistExtractParam(model.vardist);
        varParams = modelExtractParam(model.vardist);
    end
    params = varParams;
end


% Inducing inputs 
if ~model.fixInducing
    params =  [params model.X_u(:)'];
    if returnNames 
      for i = 1:size(model.X_u, 1)
      for j = 1:size(model.X_u, 2)
          X_uNames{i, j} = ['X_u(' num2str(i) ', ' num2str(j) ')'];
      end
      end
      names = {names{:}, X_uNames{:}};
    end
end


% Kernel parameters  
if returnNames
  [kernParams, kernParamNames] = kernExtractParam(model.kern); 
  for i = 1:length(kernParamNames)
    kernParamNames{i} = ['Kernel, ' kernParamNames{i}];
  end
  names = {names{:}, kernParamNames{:}};
else
  kernParams = kernExtractParam(model.kern);
end
params = [params kernParams];


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

