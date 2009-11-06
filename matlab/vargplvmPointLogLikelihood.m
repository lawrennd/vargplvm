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
E = model.Psi1'*model.m(:,indexMissing);
EET = E*E';

ll1 =  -0.5*(dmis*(-(model.N-model.k)*log(model.beta) ...
      - model.logDetK_uu +model.logdetA) ...
      - (sum(sum(model.Ainv.*EET)) ...
      -sum(sum(model.m(:,indexMissing).*model.m(:,indexMissing))))*model.beta);
    
ll1 = ll1 - 0.5*model.beta*dmis*model.Psi0 - 0.5*dmis*sum(model.diagD);
  

ll1 = ll1 - dmis*model.N/2*log(2*pi);
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
model.A = (1/model.beta)*model.K_uu + model.Psi2;
[model.Ainv, model.sqrtA] = pdinv(model.A);
model.logdetA = logdet(model.A, model.sqrtA);
model.diagD = -model.beta*sum(model.invK_uu.*model.Psi2,2);

% normalize y exactly as model.m is normalized 
my = y - model.bias(indexPresent);
my = my./model.scale(indexPresent);

% change the data (by including the new point and taking only the present indices)
model.m = model.m(:,indexPresent);
model.m = [my; model.m]; 

E = model.Psi1'*model.m;
EET = E*E';

ll2 = -0.5*(model.d*(-(model.N-model.k)*log(model.beta) ...
     - model.logDetK_uu +model.logdetA) ...
     - (sum(sum(model.Ainv.*EET))...
     -sum(sum(model.m.*model.m)) )*model.beta);
   
ll2 = ll2 - 0.5*model.beta*model.d*model.Psi0 - 0.5*model.d*sum(model.diagD);

ll2 = ll2 - model.d*model.N/2*log(2*pi);

% KL divergence term 
model.vardist.means = [vardistx.means; model.vardist.means];
model.vardist.covars = [vardistx.covars; model.vardist.covars];
varmeans = sum(sum(model.vardist.means.*model.vardist.means)); 
varcovs = sum(sum(model.vardist.covars - log(model.vardist.covars)));

KLdiv = -0.5*(varmeans + varcovs) + 0.5*model.q*model.N; 

ll = ll1 + ll2 + KLdiv; 
%

