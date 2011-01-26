function ll = vargplvmLogLikelihood(model)

% VARGPLVMLOGLIKELIHOOD Log-likelihood for a variational GP-LVM.
% FORMAT
% DESC returns the log likelihood for a given GP-LVM model.
% ARG model : the model for which the log likelihood is to be
% computed. The model contains the data for which the likelihood is
% being computed in the 'y' component of the structure.
% RETURN ll : the log likelihood of the data given the model.
%
% COPYRIGHT : Michalis K. Titsias, 2009, 2010
%
% COPYRIGHT : Neil D. Lawrence, 2009, 2010
%
% COPYRIGHT : Andreas Damianou, 2010

  
% VARGPLVM

% Likelihood term
if length(model.beta)==1
  ll = -0.5*(model.d*(-(model.N-model.k)*log(model.beta) ...
				  + model.logDetAt) ...
	      - (model.TrPP ...
	      - model.TrYY)*model.beta);
  %if strcmp(model.approx, 'dtcvar')
  ll = ll - 0.5*model.beta*model.d*model.Psi0 + 0.5*model.d*model.beta*model.TrC;
  %end
else
  error('Not implemented variable length beta yet.');
end

ll = ll-model.d*model.N/2*log(2*pi);

% KL divergence term 
varmeans = sum(sum(model.vardist.means.*model.vardist.means)); 
varcovs = sum(sum(model.vardist.covars - log(model.vardist.covars)));

KLdiv = -0.5*(varmeans + varcovs) + 0.5*model.q*model.N; 

% Obtain the final value of the bound by adding the likelihood
% and the KL term.
ll = ll + KLdiv; 
