function g = vargplvmPointLogLikeGradient(model, vardistx, y, indexPresent)

% VARGPLVMPOINTLOGLIKEGRADIENT Log-likelihood gradient for of a point of the GP-LVM.
% FORMAT
% DESC returns the gradient of the log likelihood with respect to
% the latent position, where the log likelihood is conditioned on
% the training set. 
% ARG model : the model for which the gradient computation is being
% done.
% ARG x : the latent position where the gradient is being computed.
% ARG y : the position in data space for which the computation is
% being done.
% RETURN g : the gradient of the log likelihood, conditioned on the
% training data, with respect to the latent position.
%
% SEEALSO : vargplvmPointLogLikelihood, vargplvmOptimisePoint, vagplvmSequenceLogLikeGradient
%
% COPYRIGHT : Michalis K. Titsias  and Neil D. Lawrence, 2009

% VARGPLVM


% normalize y exactly as model.m is normalized 
my = y - model.bias(indexPresent);
my = my./model.scale(indexPresent);

[gPsi0, gPsi1, gPsi2] = vargpCovGrads(model, vardistx, my, indexPresent);

[gKern1, gVarmeans1, gVarcovs1] = kernVardistPsi1Gradient(model.kern, vardistx, model.X_u, gPsi1');
[gKern2, gVarmeans2, gVarcovs2] = kernVardistPsi2Gradient(model.kern, vardistx, model.X_u, gPsi2);
[gKern0, gVarmeans0, gVarcovs0] = kernVardistPsi0Gradient(model.kern, vardistx, gPsi0);

% KL divergence terms  
gVarmeansKL = - vardistx.means(:)';
% !!! the covars are optimized in the log space 
gVarcovsKL = 0.5 - 0.5*vardistx.covars(:)';

gVarmeans = gVarmeans0 + gVarmeans1 + gVarmeans2 + gVarmeansKL;
gVarcovs = gVarcovs0 + gVarcovs1 + gVarcovs2 + gVarcovsKL; 

g = [gVarmeans gVarcovs];

%-
function [gPsi0, gPsi1, gPsi2] = vargpCovGrads(model, vardistx, my, indexPresent)
%
%

d = prod(size(indexPresent));

% change the data (by including the new point and taking only the present indices)
model.m = model.m(:,indexPresent);
model.m = [my; model.m]; 

pointPsi1 = kernVardistPsi1Compute(model.kern, vardistx, model.X_u);
pointPsi2 = kernVardistPsi2Compute(model.kern, vardistx, model.X_u);

model.Psi1 = [pointPsi1; model.Psi1]; 

model.A = (1/model.beta)*model.K_uu + model.Psi2 + pointPsi2;
[model.Ainv, model.sqrtA] = pdinv(model.A);

E = model.Psi1'*model.m;
EET = E*E';
AinvEET = model.Ainv*EET;
AinvEETAinv = AinvEET*model.Ainv;

gPsi1 = model.beta*(model.Ainv*E*my');

gPsi2 = - 0.5*(d*model.Ainv + model.beta*AinvEETAinv) ...
    + 0.5*d*model.beta*model.invK_uu;

gPsi0 = -0.5*model.beta*d;
