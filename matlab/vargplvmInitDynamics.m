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

if isfield(optionsDyn, 'vardistCovars')
    if length(optionsDyn.vardistCovars) ==1
        model.dynamics.vardist.covars = 0.1*ones(model.N,model.q) + 0.001*randn(model.N,model.q);
        model.dynamics.vardist.covars(model.dynamics.vardist.covars<0.05) = 0.05;
        model.dynamics.vardist.covars = optionsDyn.vardistCovars * ones(size(model.dynamics.vardist.covars));
    elseif size(optionsDyn.vardistCovars) == size(model.dynamics.vardist.covars)
        model.dynamics.vardist.covars = optionsDyn.vardistCovars;
    end
end

% smaller lengthscales for the base model
%model.kern.comp{1}.inputScales = 5./(((max(X)-min(X))).^2);
params = vargplvmExtractParam(model);
model = vargplvmExpandParam(model, params);


if isfield(optionsDyn,'X_u')
    model.X_u = optionsDyn.X_u;
else
    % inducing point need to initilize based on model.vardist.means
    if model.k <= model.N % model.N = size(mode.vardist.means,1)
        perm = randperm(model.k);
        model.X_u = model.vardist.means(perm(1:model.k),:);
    else
        samplingInd=0; %% TEMP
        if samplingInd
            % !!! We could also try to sample all inducing points (more uniform
            % solution)
            % This only works if k<= 2*N
            model.X_u=zeros(model.k, model.q);
            ind = randperm(model.N);
            %ind = ind(1:model.N);
            model.X_u(1:model.N,:) = model.X(ind, :);
            
            % The remaining k-N points are sampled from the (k-N) first
            % distributions of the variational distribution (this could be done
            % randomly as well).
            dif=model.k-model.N;
            model.X_u(model.N+1:model.N+dif,:)=model.vardist.means(1:dif,:) + rand(size(model.vardist.means(1:dif,:))).*sqrt(model.vardist.covars(1:dif,:));  % Sampling from a Gaussian.
        else
            % !!! The following is not a good idea because identical initial
            % ind.points are difficult to optimise... better add some
            % additional noise.
            model.X_u=zeros(model.k, model.q);
            for i=1:model.k
                %ind=randi([1 size(model.vardist.means,1)]);
                % Some versions do not have randi... do it with rendperm
                % instead:
                ind=randperm(size(model.vardist.means,1));
                ind=ind(1);
                model.X_u(i,:) = model.vardist.means(ind,:);
            end
        end
    end   
end

params = vargplvmExtractParam(model);
model = vargplvmExpandParam(model, params);






