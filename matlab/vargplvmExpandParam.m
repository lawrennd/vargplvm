function model = vargplvmExpandParam(model, params)

% VARGPLVMEXPANDPARAM Expand a parameter vector into a VARGPLVM model.
% FORMAT
% DESC takes an VARGPLVM structure and a vector of parameters, and
% fills the structure with the given parameters. Also performs any
% necessary precomputation for likelihood and gradient
% computations, so can be computationally intensive to call.
% ARG model : the VARGPLVM structure to put the parameters in.
% ARG params : parameter vector containing the parameters to put in
% the VARGPLVM structure.
% 
% COPYRIGHT : Michalis K. Titsias, 2009
%
% COPYRIGHT : Neil D. Lawrence, 2009
% 
% SEEALSO : vargplvmCreate, vargplvmExtractParam, modelExpandParam

% VARGPLVM

%if isfield(model, 'back') & ~isempty(model.back)
%  endVal = model.back.numParams;
%  model.back = modelExpandParam(model.back, params(startVal:endVal));
%  model.X = modelOut(model.back, model.y);
%else

% variational parameters (means and covariances)
startVal = 1;
endVal = model.vardist.nParams;
%model.vardist = vardistExpandParam(model.vardist, params(startVal:endVal)); 
model.vardist = modelExpandParam(model.vardist, params(startVal:endVal)); 

% inducing inputs 
startVal = endVal+1;
if model.fixInducing 
    % X_u values are taken from X values.
    model.X_u = model.X(model.inducingIndices, :);
else
    % Parameters include inducing variables.
    endVal = endVal + model.q*model.k;
    model.X_u = reshape(params(startVal:endVal),model.k,model.q);
end

% kernel hyperparameters 
startVal = endVal+1; 
endVal = endVal + model.kern.nParams;
model.kern = kernExpandParam(model.kern, params(startVal:endVal));

% likelihood beta parameters
if model.optimiseBeta
  startVal = endVal + 1;
  endVal = endVal + prod(size(model.beta));
  fhandle = str2func([model.betaTransform 'Transform']);
  model.beta = fhandle(params(startVal:endVal), 'atox');
end

model.nParams = endVal;

% Update statistics
model = vargplvmUpdateStats(model, model.X_u);
