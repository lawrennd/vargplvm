function gVarcovsLik = vargplvmLogLikeGradientsTEMP(model)





% Likelihood terms (coefficients)
[gK_uu, gPsi0, gPsi1, gPsi2, g_Lambda, gBeta] = vargpCovGrads(model);


% Get (in three steps because the formula has three terms) the gradients of
% the likelihood part w.r.t the data kernel parameters, variational means
% and covariances (original ones). From the field model.vardist, only
% vardist.means and vardist.covars and vardist.lantentDimension are used.
[gKern1, gVarmeans1, gVarcovs1, gInd1] = kernVardistPsi1Gradient(model.kern, model.vardist, model.X_u, gPsi1');
[gKern2, gVarmeans2, gVarcovs2, gInd2] = kernVardistPsi2Gradient(model.kern, model.vardist, model.X_u, gPsi2);
[gKern0, gVarmeans0, gVarcovs0] = kernVardistPsi0Gradient(model.kern, model.vardist, gPsi0);

   
 
gVarcovsLik = gVarcovs0 + gVarcovs1 + gVarcovs2;
gVarcovsLik = gVarcovsLik(:);




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
