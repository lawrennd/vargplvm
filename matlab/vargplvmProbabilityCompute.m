function logProb = vargplvmProbabilityCompute(model, y, indexPresent)

% VARGPLVMPROBABILITYCOMPUTE description
  
% VARGPLVM
  
% Takes an input a trained vargplvm and a test data point (with possibly missing values)
% Computes the probability density in the test data point 



% compute the variational lower without the new data point 
Fold = vargplvmLogLikelihood(model);

% initialize the latent point using the nearest neighbour 
% from the training data
dst = dist2(y(indexPresent), model.y(:,indexPresent));
[mind, mini] = min(dst);
% create the variational distribtion for the test latent point
vardistx = vardistCreate(model.vardist.means(mini,:), model.q, 'gaussian');

% optimize over the latent point 
iters = 100;
display = 0;
model.vardistx = vardistx;
vardistx = vargplvmOptimisePoint(model, vardistx, y(indexPresent), indexPresent, display, iters);

% compute the variational lower with the new data point included
Fnew = vargplvmPointLogLikelihood(model, vardistx, y(indexPresent), indexPresent);

% compute the probability 
logProb = Fnew - Fold;
 
