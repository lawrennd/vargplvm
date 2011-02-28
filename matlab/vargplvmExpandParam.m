function model = vargplvmExpandParam(model, params)

% VARGPLVMEXPANDPARAM Expand a parameter vector into a GP-LVM model.
% FORMAT
% DESC takes an VARGPLVM structure and a vector of parameters, and
% fills the structure with the given parameters. Also performs any
% necessary precomputation for likelihood and gradient
% computations, so can be computationally intensive to call.
% ARG model : the VARGPLVM structure to put the parameters in.
% ARG params : parameter vector containing the parameters to put in
% the VARGPLVM structure.
% 
%
% COPYRIGHT : Michalis K. Titsias, 2009

% COPYRIGHT : Neil D. Lawrence, 2009
% 
% SEEALSO : vargplvmCreate, vargplvmExtractParam, modelExpandParam

% VARGPLVM

%if isfield(model, 'back') & ~isempty(model.back)
%  endVal = model.back.numParams;
%  model.back = modelExpandParam(model.back, params(startVal:endVal));
%  model.X = modelOut(model.back, model.y);
%else

%%% Parameters must be passed as a vector in the following order (left to right) 
% - parameter{size} -
% vardistParams{model.vardist.nParams} % mu, S
%       OR
% [dynamicsVardistParams{dynamics.vardist.nParams} dynamics.kernParams{dynamics.kern.nParams}] % mu_bar, lambda
% inducingInputs{model.q*model.k}
% kernelParams{model.kern.nParams}
% beta{prod(size(model.beta))}


startVal = 1;
if isfield(model, 'dynamics') & ~isempty(model.dynamics)
    % variational parameters (reparametrized) AND dyn.kernel's parameters
    endVal = model.dynamics.nParams;
    model.dynamics = modelExpandParam(model.dynamics, params(startVal:endVal));
    
    %%%% DEBUG_
    %fprintf(1,'In expandParam, params=%d %d %d\n', model.dynamics.kern.comp{1}.inverseWidth, model.dynamics.kern.comp{1}.variance,model.dynamics.kern.comp{2}.variance );
    %%% _DEBUG
    
    %model.dynamics.X = model.vardist.means;
else
    % variational parameters (means and covariances), original ones
    endVal = model.vardist.nParams;
    model.vardist = modelExpandParam(model.vardist, params(startVal:endVal)); 
end



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

% 
% %%%
% % NEW_
% % Give parameters to dynamics if they are there.
% if isfield(model, 'dynamics') & ~isempty(model.dynamics)
%   startVal = endVal + 1;
%   endVal = length(params);
% 
%   % Fill the dynamics model with current latent values.
%   % model.dynamics = modelSetLatentValues(model.dynamics, model.X); %???
% 
%   % Update the dynamics model with parameters (thereby forcing recompute).
%    model.dynamics = modelExpandParam(model.dynamics, params(startVal:endVal));
%    model.nParams = model.nParams + model.dynamics.nParams;
% end
% %%%
% % _NEW

% Update statistics
model = vargplvmUpdateStats(model, model.X_u);
