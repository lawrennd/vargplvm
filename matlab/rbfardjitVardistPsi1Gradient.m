function [gKern, gVarmeans, gVarcovars, gInd] = rbfardjitVardistPsi1Gradient(rbfard2Kern, vardist, Z, covGrad)

% RBFARDJITVARDISTPSI1GRADIENT description.
  
% VARGPLVM
  
 [gKern, gVarmeans, gVarcovars, gInd] = rbfard2VardistPsi1Gradient(rbfard2Kern, vardist, Z, covGrad);
