function g = vargplvmPointGradient(x, model, y, indexPresent)

% VARGPLVMPOINTGRADIENT Wrapper function for gradient of a single point.
% FORMAT
% DESC is a wrapper function for the gradient of the log likelihood
% with respect to a point in the latent space. The GP-LVM
% model is one that is assumed to have already been trained.
% ARG x : the position in the latent space that is being optimised.
% ARG model : the trained GP-LVM model that is being optimised.
% ARG y : the position in data space for which the latent point is
% being optimised.
% RETURN g : the gradient of the log likelihood with respect to the
% latent position.
%
% SEEALSO : vargplvmPointLogLikeGradient, vargplvmOptimisePoint
%
% COPYRIGHT Michalis K. Titsias and Neil D. Lawrence, 2009

% VARGPLVM

vardistx = model.vardistx;
vardistx = vardistExpandParam(vardistx,x);
g = - vargplvmPointLogLikeGradient(model, vardistx, y, indexPresent);
