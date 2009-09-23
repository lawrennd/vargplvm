function model = vargplvmParamInit(model,Y,X)
%
% Initialize the variational GPLVM from the data

model.kern.inputScales = 5./(((max(X)-min(X))).^2);
model.kern.variance = max(var(Y));
model.beta = 100/max(var(Y));
