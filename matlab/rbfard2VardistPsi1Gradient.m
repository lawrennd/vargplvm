function [gKern, gVarmeans, gVarcovars, gInd] = rbfard2VardistPsi1Gradient(rbfard2Kern, vardist, Z, covGrad)
% GGWHITEXGAUSSIANWHITEKERNGRADIENT Compute gradient between the GG white
%                                   and GAUSSIAN white kernels.
% FORMAT
% DESC computes the
%	gradient of an objective function with respect to cross kernel terms
%	between GG white and GAUSSIAN white kernels for the multiple output kernel.
% RETURN g1 : gradient of objective function with respect to kernel
%	   parameters of GG white kernel.
% RETURN g2 : gradient of objective function with respect to kernel
%	   parameters of GAUSSIAN white kernel.
% ARG ggwhitekern : the kernel structure associated with the GG white kernel.
% ARG gaussianwhiteKern :  the kernel structure associated with the GAUSSIAN white kernel.
% ARG x : inputs for which kernel is to be computed.
%
% FORMAT
% DESC  computes
%	the gradient of an objective function with respect to cross kernel
%	terms between GG white and GAUSSIAN white kernels for the multiple output kernel.
% RETURN g1 : gradient of objective function with respect to kernel
%	   parameters of GG white kernel.
% RETURN g2 : gradient of objective function with respect to kernel
%	   parameters of GAUSSIAN white kernel.
% ARG ggwhiteKern : the kernel structure associated with the GG white kernel.
% ARG gaussianwhiteKern : the kernel structure associated with the GAUSSIAN white kernel.
% ARG x1 : row inputs for which kernel is to be computed.
% ARG x2 : column inputs for which kernel is to be computed.
%
% SEEALSO : multiKernParamInit, multiKernCompute, ggwhiteKernParamInit,
% gaussianwhiteKernParamInit
%
% COPYRIGHT : Mauricio A. Alvarez and Neil D. Lawrence, 2008
%
% MODIFICATIONS : Mauricio A. Alvarez, 2009.


% KERN
% variational means
N = size(vardist.means,1);
%  inducing variables 
M = size(Z,1); 


% evaluate the kernel matrix 
[K_fu Knovar] = rbfard2VardistPsi1Compute(rbfard2Kern, vardist, Z);

% inverse variances
A = rbfard2Kern.inputScales;

% gradient wrt variance of the kernel 
gKernvar = sum(sum(Knovar.*covGrad));  

% compute the gradient wrt lengthscales, variational means and variational variances  
for q=1:vardist.latentDimension
%
    S_q = vardist.covars(:,q);  
    Mu_q = vardist.means(:,q); 
    Z_q = Z(:,q)'; 
    
    % B3_q term (without A(q); see report)
    B_q = repmat(1./(A(q)*S_q + 1), [1 M]).*(repmat(Mu_q,[1 M]) - repmat(Z_q,[N 1]));
 
    % derivatives wrt variational means and inducing inputs 
    tmp = A(q)*((K_fu.*B_q).*covGrad);
    
    % variational means: you sum out the columns (see report)
    gVarmeans(:,q) = -sum(tmp,2); 
    
    % inducing inputs: you sum out the rows 
    gInd(:,q) = sum(tmp,1)'; 
    
    % 
    %B_q = repmat(1./(A(q)*S_q + 1), [1 M]).*dist2(Mu_q, repmat(Z_q);
    B_q = (B_q.*(repmat(Mu_q,[1 M]) - repmat(Z_q,[N 1])));
    
    % B1_q term (see report)
    B1_q = -(0.5./repmat((A(q)*S_q + 1), [1 M])).*(repmat(S_q, [1 M]) + B_q);
    
    % gradients wrt kernel hyperparameters (lengthscales) 
    gKernlengcs(q) = sum(sum((K_fu.*B1_q).*covGrad)); 
    
    % B2_q term (see report)  
    %B1_q = ((0.5*A(q))./repmat((A(q)*S_q + 1), [1 M])).*(B_q - 1); 
  
    B1_q = ((0.5*A(q))./repmat((A(q)*S_q + 1), [1 M])).*(A(q)*B_q - 1); 
    
    % gradient wrt variational covars (diagonal covariance matrices) 
    gVarcovars(:,q) = sum((K_fu.*B1_q).*covGrad,2);
  
    %
end
     
gKern = [gKernvar gKernlengcs];

% gVarmeans is N x Q matrix (N:number of data, Q:latent dimension)
% this will unfold this matrix row-wise 
gVarmeans = gVarmeans'; 
gVarmeans = gVarmeans(:)'; 

% gVarcovars is N x Q matrix (N:number of data, Q:latent dimension)
% this will unfold this matrix row-wise 
gVarcovars = gVarcovars'; 
gVarcovars = gVarcovars(:)';

% gInd is M x Q matrix (M:number of inducing variables, Q:latent dimension)
% this will unfold this matrix row-wise 
gInd = gInd'; 
gInd = gInd(:)'; 



