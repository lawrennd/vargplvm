function g = vargplvmLogLikeGradients(model)

% VARGPLVMLOGLIKEGRADIENTS Compute the gradients for the FGPLVM.
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
% COPYRIGHT : Michalis K. Titsias, 2009
%  
% COPYRIGHT : Mauricio Alvarez, 2009
%
% COPYRIGHT : Neil D. Lawrence, 2009
%
% SEEALSO : vargplvmLogLikelihood, vargplvmCreate, modelLogLikeGradients

% VARGPLVM


  [gK_uu, gPsi0, gPsi1, gPsi2, g_Lambda, gBeta] = vargpCovGrads(model);
  
  [gKern1, gVarmeans1, gVarcovs1, gInd1] = kernVardistPsi1Gradient(model.kern, model.vardist, model.X_u, gPsi1');
  [gKern2, gVarmeans2, gVarcovs2, gInd2] = kernVardistPsi2Gradient(model.kern, model.vardist, model.X_u, gPsi2);
  [gKern0, gVarmeans0, gVarcovs0] = kernVardistPsi0Gradient(model.kern, model.vardist, gPsi0);
  gKern3 = kernGradient(model.kern, model.X_u, gK_uu);
  
  % KL divergence terms  
  gVarmeansKL = - model.vardist.means(:)';
  % !!! the covars are optimized in the log space 
  %gVarcovsKL = 0.5./model.vardist.covars(:)' - 0.5;
  %gVarcovsKL = gVarcovsKL.*model.vardist.covars(:)';
  gVarcovsKL = 0.5 - 0.5*model.vardist.covars(:)';
  
  
  gVarmeans = gVarmeans0 + gVarmeans1 + gVarmeans2 + gVarmeansKL;
  gVarcovs = gVarcovs0 + gVarcovs1 + gVarcovs2 + gVarcovsKL; 
  gKern = gKern0 + gKern1 + gKern2 + gKern3;
  
  %%% Compute Gradients of Kernel Parameters %%%
  
  
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
  
  gInd = gInd1 + gInd2 + gX_u(:)';
  
  g = [gVarmeans gVarcovs gInd gKern gBeta];
end  
  
% delete afterwards
%g = [gVarmeans2 gVarcovs2 (gX_u(:)'+ gInd2) (gKern3+gKern2) 0*gBeta];



%~
function [gK_uu, gPsi0, gPsi1, gPsi2, g_Lambda, gBeta] = vargpCovGrads(model)
%
%

%if ~isfield(model, 'isSpherical') | model.isSpherical
  E = model.Psi1'*model.m;
  EET = E*E';
  AinvEET = model.Ainv*EET;
  AinvEETAinv = AinvEET*model.Ainv;
  gK_uu = 0.5*(model.d*(model.invK_uu-(1/model.beta)*model.Ainv) ...
               - AinvEETAinv);
  
  K_uuInvPsi2K_uuInv = model.invK_uu*model.Psi2*model.invK_uu;
  gK_uu = gK_uu - 0.5*model.d*model.beta*K_uuInvPsi2K_uuInv;
  
  gPsi1 = model.beta*(model.Ainv*E*model.m');
  %gK_uf = gK_uf + model.d*model.beta*K_uuInvK_uf;
  
  
  gPsi2 = - 0.5*(model.d*model.Ainv + model.beta*AinvEETAinv) ...
          + 0.5*model.d*model.beta*model.invK_uu;
  
  gBeta = 0.5*(model.d*((model.N-model.k)/model.beta ...
                        +sum(sum(model.Ainv.*model.K_uu))/(model.beta*model.beta))...
               +sum(sum(AinvEETAinv.*model.K_uu))/model.beta ...
               +(trace(AinvEET)-sum(sum(model.m.*model.m))));
  
  gBeta = gBeta -0.5*model.d*model.Psi0 - 0.5*model.d*sum(model.diagD)/model.beta;
  
  fhandle = str2func([model.betaTransform 'Transform']);
  gBeta = gBeta*fhandle(model.beta, 'gradfact');
  
  gPsi0 = -0.5*model.beta*model.d;
  
  g_Lambda = repmat(-0.5*model.beta*model.d, 1, model.N);
  
  % delete afterwards
  %gK_uu = model.invK_uu + model.Ainv/model.beta;
  %gPsi2 = model.Ainv;
end