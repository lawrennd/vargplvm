function f = vargplvmObjective(params, model)

% FGPLVMOBJECTIVE Wrapper function for GP-LVM objective.
% FORMAT
% DESC provides a wrapper function for the GP-LVM, it
% takes the negative of the log likelihood, feeding the parameters
% correctly to the model.
% ARG params : the parameters of the GP-LVM model.
% ARG model : the model structure in which the parameters are to be
% placed.
% RETURN f : the negative of the log likelihood of the model.
% 
% SEEALSO : vargplvmCreate, vargplvmLogLikelihood, vargplvmExpandParam
%
% COPYRIGHT : Neil D. Lawrence, 2005, 2006

% FGPLVM

model = vargplvmExpandParam(model, params);
f = - vargplvmLogLikelihood(model);
