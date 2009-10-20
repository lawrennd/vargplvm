function vardist = vardistCreate(X, Q, type)
%
% creates the structure of the variational distirbution over the latent
% values in the GP-LVM 
%
% The variational distribution is assumed to be factorized over the 
% the latent variables. Each factor each a Gaussain N(x_n|mu_n,S_n) 
% with a diagonal covariance matrix  
%
% The structure of the vardist is similar to the structure of a kernel


vardist.type = 'vardist';
vardist.vartype = type; 

vardist.numData = size(X,1); 
vardist.latentDimension = Q; 
vardist.nParams = 2*vardist.numData*vardist.latentDimension;
%  number of training points
N = size(X,1);

vardist.transforms(1).index = [(N*Q+1):vardist.nParams];
vardist.transforms(1).type = optimiDefaultConstraint('positive');

% initialize the parameters
vardist.means  = X;
vardist.covars = 0.1*ones(N,Q) + 0.01*randn(N,Q);
vardist.covars(vardist.covars<0.1) = 0.1;
%vardist.means = randn(N,Q);
%pmeans = randn(Q,N);
%pcovars = randn(Q,N);
%params = [pmeans(:)' pcovars(:)']; 
%vardist = vardistExpandParam(vardist, params);