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

model.C = model.invLm * (model.Psi2 + pointPsi2) * model.invLmT;
model.TrC = sum(diag(model.C)); % Tr(C)
model.At = (1/model.beta) * eye(size(model.C,1)) + model.C;
model.Lat = jitChol(model.At)';
model.invLat = model.Lat\eye(size(model.Lat,1));  
model.invLatT = model.invLat';
model.logDetAt = 2*(sum(log(diag(model.Lat)))); % log |At|
model.P1 = model.invLat * model.invLm; % M x M
model.P = model.P1 * (model.Psi1' * model.m);
model.TrPP = sum(sum(model.P .* model.P));
model.B = model.P1' * model.P;
P1TP1 = (model.P1' * model.P1);
model.Tb = (1/model.beta) * d * P1TP1;
	model.Tb = model.Tb + (model.B * model.B');
model.T1 = d * model.invK_uu - model.Tb;

gPsi2 = (model.beta/2) * model.T1;

gPsi0 = -0.5 * model.beta * d;

gPsi1 = model.beta*(P1TP1*model.Psi1'*model.m*my');
