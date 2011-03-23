function model = vargplvmInitDynamics(model,optionsDyn)
% VARGPLVMINITDYNAMICS Initialize the dynamics of a var-GPLVM model.
% FORMAT
% ARG optionsDyn : the VARGPLVM structure with the options used to
% create the vargplvm model..
% 
%
% COPYRIGHT : Michalis K. Titsias, 2011
% COPYRIGHT : Neil D. Lawrence, 2011
% COPYRIGHT : Andreas C. Damianou, 2011
% 
% SEEALSO : vargplvmOptionsDyn, vargplvmAddDynamics

% VARGPLVM



if ~isfield(model, 'dynamics') || isempty(model.dynamics)
    error(['model does not have field dynamics']);
end


%model.dynamics.kern.comp{1}.inverseWidth = 200./(((max(model.dynamics.t)-min(model.dynamics.t))).^2);
%params = vargplvmExtractParam(model);
%model = vargplvmExpandParam(model, params);

% Initialize barmu
if isfield(optionsDyn,'initX')
    initFunc = str2func([optionsDyn.initX 'Embed']);
else
    initFunc=str2func('ppcaEmbed');
end

% If the model is in "D greater than N" mode, then we want initializations
% to be performed with the original model.m
if isfield(model, 'DgtN') && model.DgtN
    X = initFunc(model.mOrig, model.q);
else
    X = initFunc(model.m, model.q);
end

vX = var(X);
for q=1:model.q
    Lkt = chol(model.dynamics.Kt + 0.01*vX(q)*eye(model.N))';
    % barmu = inv(Kt + s*I)*X, so that  mu = Kt*barmu =  Kt*inv(Kt +
    % s*I)*X, which is jsut the GP prediction, is temporally smoothed version
    % of the PCA latent variables X (for the data Y)
    model.dynamics.vardist.means(:,q) = Lkt'\(Lkt\X(:,q));
end
% smaller lengthscales for the base model
%model.kern.comp{1}.inputScales = 5./(((max(X)-min(X))).^2);
params = vargplvmExtractParam(model);
model = vargplvmExpandParam(model, params);

% inducing point need to initilize based on model.vardist.means
perm = randperm(model.k);
model.X_u = model.vardist.means(perm(1:model.k),:);
params = vargplvmExtractParam(model);
model = vargplvmExpandParam(model, params);






