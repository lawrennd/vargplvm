function model = vargplvmParamInit(model, Y, X)

% VARGPLVMPARAMINIT Initialize the variational GPLVM from the data.
% FORMAT
% DESC initializes the variational GP-LVM from the data.
% ARG model : the model to initialize.
% ARG Y : the data set.
% ARG X : the latent variable positions.
%
% COPYRIGHT : Michalis K. Titsias, 2009
%
% SEEALSO : vargplvmCreate

% VARGPLVM

  model.kern.inputScales = 5./(((max(X)-min(X))).^2);
  model.kern.variance = max(var(Y));
  model.beta = 100/max(var(Y));
end