function ll = vargplvmPointLogLikelihood(model, vardistx, y, indexPresent)

% VARGPLVMPOINTLOGLIKELIHOOD Log-likelihood of a point for the GP-LVM.
% FORMAT
% DESC returns the log likelihood of a latent point and an observed
% data point for the posterior prediction of the GP-LVM model.
% ARG model : the model for which the point prediction will be
% made.
% ARG vardistx : the variational distribution over latent point for which the posterior distribution
% will be evaluated. It contains the mean and tha diagonal covarriance 
% ARG y : the observed data point for which the posterior is evaluated
% ARG indexPresent: indicates which indices from the observed vector are present
%         (e.g. when when all indices are present, then y will d-dimensional     
%          and indexPresent = 1:D)          
%
% SEEALSO : vargplvmCreate, vargplvmOptimisePoint, vargplvmPointObjective
%
% COPYRIGHT : Michalis K. Titsias and Neil D. Lawrence, 2009

% VARGPLVM


% !!!!!! this function can become faster with precomputations stored in the
% structure model !!!!! 


% compute firstly the lower bound that corresponds to the missing indices
% in y 
%  --- this bit of the lower bound does not depend on the vardistx    


indexMissing = setdiff(1:model.d, indexPresent);


ll1 = 0;
if ~isempty(indexMissing)
dmis = prod(size(indexMissing));

% Precompute again the parts that contain Y
TrYY = sum(sum(model.m(:,indexMissing) .* model.m(:,indexMissing)));
P = model.P1 * (model.Psi1' * model.m(:,indexMissing));
TrPP = sum(sum(P .* P));

ll1 = -0.5*(dmis*(-(model.N-model.k)*log(model.beta) ...
				  + model.logDetAt) ...
	      - (TrPP ...
	      - TrYY)*model.beta);
  %if strcmp(model.approx, 'dtcvar')
ll1 = ll1 - 0.5*model.beta*dmis*model.Psi0 + 0.5*dmis*model.beta*model.TrC;
ll1 = ll1-dmis*model.N/2*log(2*pi);
end


%---
% compute the part of lower bound that corresponds to the present indices
% in y 
%  --- this bit of the lower bound depends on the vardistx     

% evaluate the statistics psi0, psi1, psi2 for the new latent point 
pointPsi0 = kernVardistPsi0Compute(model.kern, vardistx);
pointPsi1 = kernVardistPsi1Compute(model.kern, vardistx, model.X_u);
pointPsi2 = kernVardistPsi2Compute(model.kern, vardistx, model.X_u);


model.N = model.N + 1; % we have one more data point 
model.d = prod(size(indexPresent));
model.Psi1 = [pointPsi1; model.Psi1]; 
model.Psi2 = model.Psi2 + pointPsi2;
model.Psi0 = model.Psi0 + pointPsi0;


% normalize y exactly as model.m is normalized 
my = y - model.bias(indexPresent);
my = my./model.scale(indexPresent);

% change the data (by including the new point and taking only the present indices)
model.m = model.m(:,indexPresent);
model.m = [my; model.m]; 

model.TrYY = sum(sum(model.m .* model.m));


model.Lm = jitChol(model.K_uu)';      % M x M: L_m (lower triangular)   ---- O(m^3)
model.invLm = model.Lm\eye(model.k);  % M x M: L_m^{-1}                 ---- O(m^3)
model.invLmT = model.invLm'; % L_m^{-T}
model.C = model.invLm * model.Psi2 * model.invLmT;
model.TrC = sum(diag(model.C)); % Tr(C)
model.At = (1/model.beta) * eye(size(model.C,1)) + model.C; % At = beta^{-1} I + C
model.Lat = jitChol(model.At)';
model.invLat = model.Lat\eye(size(model.Lat,1));  
model.invLatT = model.invLat';
model.logDetAt = 2*(sum(log(diag(model.Lat)))); % log |At|
model.P1 = model.invLat * model.invLm; % M x M
model.P = model.P1 * (model.Psi1' * model.m);
model.TrPP = sum(sum(model.P .* model.P));


ll2 = -0.5*(model.d*(-(model.N-model.k)*log(model.beta) ...
				  + model.logDetAt) ...
	      - (model.TrPP ...
	      - model.TrYY)*model.beta);
ll2 = ll2 - 0.5*model.beta*model.d*model.Psi0 + 0.5*model.d*model.beta*model.TrC;


ll2 = ll2-model.d*model.N/2*log(2*pi);

% KL divergence term 
model.vardist.means = [vardistx.means; model.vardist.means];
model.vardist.covars = [vardistx.covars; model.vardist.covars];
varmeans = sum(sum(model.vardist.means.*model.vardist.means)); 
varcovs = sum(sum(model.vardist.covars - log(model.vardist.covars)));

KLdiv = -0.5*(varmeans + varcovs) + 0.5*model.q*model.N; 

ll = ll1 + ll2 + KLdiv; 
%

