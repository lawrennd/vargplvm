function g = vargplvmGradient(params, model)

% VARGPLVMGRADIENT Variational GP-LVM gradient wrapper.
% FORMAT
% DESC is a wrapper function for the gradient of the negative log
% likelihood of an variatioanl GP-LVM model with respect to the latent postions
% and parameters.
% ARG params : vector of parameters and latent postions where the
% gradient is to be evaluated.
% ARG model : the model structure into which the latent positions
% and the parameters will be placed.
% RETURN g : the gradient of the negative log likelihood with
% respect to the latent positions and the parameters at the given
% point.
% 
% SEEALSO : vargplvmLogLikeGradients, vargplvmExpandParam
%
% COPYRIGHT : Michalis K. Titsias, 2009 - 2011
%
% COPYRIGHT : Neil D. Lawrence, 2006, 2005, 2010-2011

% VARGPLVM

model = vargplvmExpandParam(model, params);
g = - vargplvmLogLikeGradients(model);

