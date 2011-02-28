function g = vargplvmLogLikeGradients(model)

% VARGPLVMLOGLIKEGRADIENTS Compute the gradients for the variational GPLVM.
% FORMAT
% DESC returns the gradients of the log likelihood with respect to the
% parameters of the GP-LVM model and with respect to the latent
% positions of the GP-LVM model. 
% ARG model : the FGPLVM structure containing the parameters and
% the latent positions.
% RETURN g : the gradients of the latent positions (or the back 
% constraint's parameters) and the parameters of the GP-LVM model.
%
% FORMAT
% DESC returns the gradients of the log likelihood with respect to the
% parameters of the GP-LVM model and with respect to the latent
% positions of the GP-LVM model in seperate matrices. 
% ARG model : the FGPLVM structure containing the parameters and
% the latent positions.
% RETURN gX : the gradients of the latent positions (or the back
% constraint's parameters).
% RETURN gParam : gradients of the parameters of the GP-LVM model.
%
% COPYRIGHT : Michalis K. Titsias, 2009, 2010
%
% COPYRIGHT :  Mauricio Alvarez, 2009, 2010
%
% COPYRIGHT :  Neil D. Lawrence, 2009, 2010
%
% COPYRIGHT : Andreas Damianou, 2010

% SEEALSO : vargplvmLogLikelihood, vargplvmCreate, modelLogLikeGradients

% VARGPLVM


% KL divergence terms  

%%%%% WITH THIS VERSION Sq's are (must be) computed twice!!
%%%%% See also vargpTimeDynamicsVarPriorGradients which is not used because
%%%%% it is not compatible with the old implementation

% The gradient of the kernel of the dynamics (e.g. temporal prior)
gDynKern = [];

% % Check if Dynamics kernel is being used.
% if isfield(model, 'dynamics') && ~isempty(model.dynamics)
%     % The model only holds the free variational parameters (reparametrization).
%     % Get the original ones by performing the appropriate mapping.
%     [muqOrig SqOrig] = modelPriorKernGrad(model.dynamics);
%     % In case the model doesn't have dynamics, model.vardist holds the
%     % variational distribution with its parameters. If it does contain
%     % dynamics, it contains the variational distribution but the true means
%     % and covariances are not stored; instead, the free ones are used
%     % and they are stored in the model.dynamics.vardist field. With the
%     % following command the true parameters are calculated and stored
%     % temporarily into the model.
%     model.vardist.means = muqOrig;
%     model.vardist.covars = SqOrig;
% else

if ~isfield(model, 'dynamics') || isempty(model.dynamics)
    gVarmeansKL = - model.vardist.means(:)';
    % !!! the covars are optimized in the log space 
    gVarcovsKL = 0.5 - 0.5*model.vardist.covars(:)';
end


% Likelihood terms (coefficients)
[gK_uu, gPsi0, gPsi1, gPsi2, g_Lambda, gBeta] = vargpCovGrads(model);


% Get (in three steps because the formula has three terms) the gradients of
% the likelihood part w.r.t the data kernel parameters, variational means
% and covariances (original ones). From the field model.vardist, only
% vardist.means and vardist.covars and vardist.lantentDimension are used.
[gKern1, gVarmeans1, gVarcovs1, gInd1] = kernVardistPsi1Gradient(model.kern, model.vardist, model.X_u, gPsi1');
[gKern2, gVarmeans2, gVarcovs2, gInd2] = kernVardistPsi2Gradient(model.kern, model.vardist, model.X_u, gPsi2);
[gKern0, gVarmeans0, gVarcovs0] = kernVardistPsi0Gradient(model.kern, model.vardist, gPsi0);
gKern3 = kernGradient(model.kern, model.X_u, gK_uu);

% At this point, gKern gVarmeansLik and gVarcovsLik have the derivatives for the
% likelihood part. Sum all of them to obtain the final result.
gKern = gKern0 + gKern1 + gKern2 + gKern3;
gVarmeansLik = gVarmeans0 + gVarmeans1 + gVarmeans2;


if isfield(model, 'dynamics') && ~isempty(model.dynamics)
    % Calculate the derivatives for the reparametrized variational and Kt parameters.
    % The formulae for these include in a mixed way the derivatives of the KL
    % term w.r.t these., so gVarmeansKL and gVarcovsKL are not needed now. Also
    % the derivatives w.r.t kernel parameters also require the derivatives of
    % the likelihood term w.r.t the var. parameters, so this call must be put
    % in this part.
    
    % For the dynamical GPLVM further the original covs. must be fed,
    % before amending with the partial derivative due to exponing to enforce
    % positiveness.
    gVarcovsLik = gVarcovs0 + gVarcovs1 + gVarcovs2;
    [gVarmeans gVarcovs gDynKern] = modelPriorReparamGrads(model.dynamics, gVarmeansLik, gVarcovsLik);
    % Variational variances are positive: Now that the final covariances
    % are obtained we amend with the partial derivatives due to the
    % exponential transformation to ensure positiveness.
    gVarcovs = (gVarcovs(:).*model.dynamics.vardist.covars(:))';
else
    % For the non-dynamical GPLVM these cov. derivatives are the final, so
    % it is time to amend with the partial derivative due to exponing them
    % to force posigiveness.
    gVarcovs0 = (gVarcovs0(:).*model.vardist.covars(:))';
    gVarcovs1 = (gVarcovs1(:).*model.vardist.covars(:))';
    gVarcovs2 = (gVarcovs2(:).*model.vardist.covars(:))';
    
    gVarcovsLik = gVarcovs0 + gVarcovs1 + gVarcovs2;
    gVarmeans = gVarmeansLik + gVarmeansKL;
    %gVarcovsLik = (gVarcovsLik(:).*model.vardist.covars(:))';
    gVarcovs = gVarcovsLik + gVarcovsKL;
end



gVar = [gVarmeans gVarcovs];

% gVarmeans = gVarmeans0 + gVarmeans1 + gVarmeans2 + gVarmeansKL;
% gVarcovs = gVarcovs0 + gVarcovs1 + gVarcovs2 + gVarcovsKL; 



if isfield(model.vardist,'paramGroups')
    gVar = gVar*model.vardist.paramGroups;
end


    
  
%%% Compute Gradients with respect to X_u %%%
gKX = kernGradX(model.kern, model.X_u, model.X_u);

% The 2 accounts for the fact that covGrad is symmetric
gKX = gKX*2;
dgKX = kernDiagGradX(model.kern, model.X_u);
for i = 1:model.k
  gKX(i, :, i) = dgKX(i, :);
end

% Allocate space for gX_u
gX_u = zeros(model.k, model.q);
% Compute portion associated with gK_u
for i = 1:model.k
  for j = 1:model.q
    gX_u(i, j) = gKX(:, j, i)'*gK_uu(:, i);
  end
end

% This should work much faster 
%gX_u2 = kernKuuXuGradient(model.kern, model.X_u, gK_uu);

%sum(abs(gX_u2(:)-gX_u(:)))
%pause

gInd = gInd1 + gInd2 + gX_u(:)';
  

%g = [gVar         gInd gKern gBeta];
g = [gVar gDynKern gInd gKern gBeta];


%%%%%% DEBUG_
%fprintf(1,'In logLikeGradients kernParams are %s\n', num2str(gKern));
%%%%%% _DEBUG

% delete afterwards
%g = [gVarmeans2 gVarcovs2 (gX_u(:)'+ gInd2) (gKern3+gKern2) 0*gBeta];


function [gK_uu, gPsi0, gPsi1, gPsi2, g_Lambda, gBeta] = vargpCovGrads(model)

gPsi1 = model.beta * model.m * model.B';
    gPsi1 = gPsi1'; % because it is passed to "kernVardistPsi1Gradient" as gPsi1'...

gPsi2 = (model.beta/2) * model.T1;

gPsi0 = -0.5 * model.beta * model.d;

gK_uu = 0.5 * (model.T1 - (model.beta * model.d) * model.invLmT * model.C * model.invLm);

sigm = 1/model.beta; % beta^-1

PLm = model.invLatT*model.P;
gBeta = 0.5*(model.d*(model.TrC + (model.N-model.k)*sigm -model.Psi0) ...
	- model.TrYY + model.TrPP ...
	+ (1/(model.beta^2)) * model.d * sum(sum(model.invLat.*model.invLat)) + sigm*sum(sum(PLm.*PLm)));

%gBeta = 0.5*(model.d*(model.TrC + (model.N-model.k)*sigm -model.Psi0) ...
%	- model.TrYY + model.TrPP ...
%	+ sigm * sum(sum(model.K_uu .* model.Tb))); 

fhandle = str2func([model.betaTransform 'Transform']);
gBeta = gBeta*fhandle(model.beta, 'gradfact');

g_Lambda = repmat(-0.5*model.beta*model.d, 1, model.N);
