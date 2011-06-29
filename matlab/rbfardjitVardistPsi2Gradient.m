function [gKern, gVarmeans, gVarcovars, gInd] = rbfardjitVardistPsi2Gradient(rbfardKern, vardist, Z, covGrad)

% RBFARDJITVARDISTPSI2GRADIENT description.
  
% VARGPLVM
  
[gKern, gVarmeans, gVarcovars, gInd] = rbfard2VardistPsi2Gradient(rbfardKern, vardist, Z, covGrad);
