function [K, outKern, sumKern, Kgvar] = rbfardVardistPsi2Compute(rbfardKern, vardist, Z)

% RBFARD2XGAUSSIANVARIATIONALDISTKERNCOMPUTE Compute a cross kernel after convolution of the rbfard2 (rbfard with the traditional 
%   parametrizatiion) and a variational Gaussian distribution (a separate Gaussina for each row of X)
% FORMAT
% DESC computes cross kernel
%	terms between GG white and GAUSSIAN white kernels for the multiple output kernel.
% RETURN k :  block of values from kernel matrix.
% ARG ggKern : the kernel structure associated with the GG kernel.
% ARG gaussianKern : the kernel structure associated with the GAUSSIAN kernel.
% ARG x :  inputs for which kernel is to be computed.
%
% FORMAT
% DESC computes cross
%	kernel terms between GG white and GAUSSIAN white kernels for the multiple output
%	kernel.
% RETURN K : block of values from kernel matrix.
% ARG ggwhiteKern :  the kernel structure associated with the GG kernel.
% ARG gaussianwhiteKern the kernel structure associated with the GAUSSIAN kernel.
% ARG x : row inputs for which kernel is to be computed.
% ARG x2 : column inputs for which kernel is to be computed.
%
% SEEALSO : multiKernParamInit, multiKernCompute, ggwhiteKernParamInit,
%           gaussianwhiteKernParamInit
%
%
% COPYRIGHT : Michalis K. Titsias and Neil D. Lawrence, 2009
%


% variational means
N  = size(vardist.means,1);
%  inducing variables 
M = size(Z,1); 

A = rbfardKern.inputScales;
    
% first way
sumKern = zeros(M,M); 
for n=1:N
    %    
    AS_n = (1 + 2*A.*vardist.covars(n,:)).^0.5;  
    
    normfactor =  1./prod(AS_n);
    
    Z_n = (repmat(vardist.means(n,:),[M 1]) - Z)*0.5; 
    Z_n = Z_n.*repmat(sqrt(A)./AS_n,[M 1]);
    distZ = dist2(Z_n,-Z_n); 
    
    sumKern = sumKern + normfactor*exp(-distZ);  
    %
end
    
ZZ = Z.*(repmat(sqrt(A),[M 1]));
distZZ = dist2(ZZ,ZZ);
outKern = exp(-0.25*distZZ);

Kgvar = rbfardKern.variance*(outKern.*sumKern); 
K = rbfardKern.variance*Kgvar;

% second way
%sumKern2 = zeros(M,M); 
%for n=1:N
%    norm = [];
%    sumK = zeros(M,M); 
%    for q=1:size(Z,2)
%       norm(q) = sqrt(1 + 2*A(q).*vardist.covars(n,q));
%       
%       ZZ_q = 0.5*(repmat(Z(:,q),[1 M]) + repmat(Z(:,q)',[M 1]));
%       sumK = sumK + (A(q)/(1 + 2*A(q)*vardist.covars(n,q)))*((vardist.means(n,q) - ZZ_q).^2);
%    end
%    sumKern2 = sumKern2 + exp(-sumK)/prod(norm); 
%end
%(1/prod(norm))
%
%outKern2 = zeros(M,M); 
%for q=1:size(Z,2)
%    outKern2 = outKern2 + A(q)*dist2(Z(:,q),Z(:,q)); 
%end
%outKern2 = exp(-0.25*outKern2); 
%sum(sum(abs(sumKern - sumKern2)))
%sum(sum(abs(outKern - outKern2)))
%Kgvar = rbfardKern.variance*(outKern2.*sumKern2); 
%K = rbfardKern.variance*Kgvar;


