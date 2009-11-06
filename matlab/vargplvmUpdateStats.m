function model = vargplvmUpdateStats(model, X_u)
%

% VARGPLVMUPDATESTATS Update stats of VARGPLVM model.

% VARGPLVM
  
jitter = 1e-6;


model.K_uu = kernCompute(model.kern, X_u);

% Always add jitter (so that the inducing variables are "jitter" function variables)
% and the above value represents the minimum jitter value
if (~isfield(model.kern, 'whiteVariance')) | model.kern.whiteVariance < jitter
   % There is no white noise term so add some jitter.
   model.K_uu = model.K_uu ...
        + sparseDiag(repmat(jitter, size(model.K_uu, 1), 1));
end

model.Psi0 = kernVardistPsi0Compute(model.kern, model.vardist);
model.Psi1 = kernVardistPsi1Compute(model.kern, model.vardist, X_u);
[model.Psi2, AS] = kernVardistPsi2Compute(model.kern, model.vardist, X_u);

% compute the kernel. But be careful when is linear 
% compute using the matrix inversion lemma 
% if ~strcmp(model.kern.type,'cmpnd')
%   %   
%   if strcmp(model.kern.type,'linard2')
%       % use matrix inversion lemma for the linear kernel 
%       % X_u*X_u' + jit = ( I - X_u*( jit*I + X_u'*X_u)*X_u')/jit;
%       Xu2 = X_u'*X_u; 
%       XXu = Xu2 + sparseDiag(jitter./(model.kern.inputScales'));
%       
%       A = sparse(diag(model.kern.inputScales)); 
%       
%       AMS = A*MS*A + (1/model.beta)*A; 
%     
%       [AMSinv, sqrtAMS] = pdinv(AMS); 
%       AMSX_u = (jitter/model.beta)*AMSinv + Xu2;
%       L_amsx = jitChol(AMSX_u); 
%       invL_amsx = L_amsx\eye(size(L_amsx, 1));
%    
%       XinvL = X_u*invL_amsx; 
%       model.Ainv = (eye(size(X_u,1)) - XinvL*XinvL')*(model.beta/jitter); 
%       
%       model.logdetA = (size(X_u,1)-model.q)*log(jitter/model.beta) + ... 
%                            2*sum(log(diag(sqrtAMS))) + 2*sum(log(diag(L_amsx)));
%       
%       
%       
%       X_u'*X_u + sparseDiag(jitter./(model.kern.inputScales'));
%       
%       L_uu = jitChol(XXu);
%       invL_uu = L_uu\eye(size(L_uu, 1));
%       XinvL_uu = X_u*invL_uu;
%       % without the jit that is divided 
%       model.invK_uu = (eye(size(X_u,1)) - XinvL_uu*XinvL_uu')/jitter; 
%       model.logDetK_uu = (size(X_u,1)-model.q)*log(jitter) + ... 
%                            sum(log(model.kern.inputScales)) + 2*sum(log(diag(L_uu))); 
%   else
%       [model.invK_uu, model.sqrtK_uu] = pdinv(model.K_uu);
%       model.logDetK_uu = logdet(model.K_uu, model.sqrtK_uu);
%   end  
%   %  
% else % the kernel is cmpnd
%   %
% 
%   %
% end

[model.invK_uu, model.sqrtK_uu] = pdinv(model.K_uu);
model.logDetK_uu = logdet(model.K_uu, model.sqrtK_uu);
 
model.A = (1/model.beta)*model.K_uu + model.Psi2;
%%This can become unstable when K_uf2 is low rank.
[model.Ainv, model.sqrtA] = pdinv(model.A);
model.logdetA = logdet(model.A, model.sqrtA);
 
 
 
% model.K_uu
% model.invK_uu
% model1.invK_uu
% model.Ainv
% model1.Ainv
% sum(sum(abs(model1.invK_uu - model.invK_uu)))
% sum(sum(abs(model1.Ainv - model.Ainv)))
% [model.logDetK_uu-model1.logDetK_uu]
% [model.logdetA-model1.logdetA]
% [model.logdetA model1.logdetA]
% pause






%if ~isfield(model, 'isSpherical') | model.isSpherical
 % compute inner products
for i = 1:model.d
    E = model.Psi1'*model.m(:, i);    
    %model.innerProducts(1, i) = model.beta*(model.m(:, i)'*model.m(:, i) - E'*model.Ainv*E);

    model.sqrtAinv = model.sqrtA\eye(size(model.sqrtA, 1));
    E = E'*model.sqrtAinv;
    model.innerProducts(1, i) = model.beta*(model.m(:, i)'*model.m(:, i) - E*E');
end
%sum(sum(abs(model.innerProducts - Products)))
%pause

%if strcmp(model.approx, 'dtcvar')
%model.diagD = -model.beta*trace(model.invK_uu*model.Psi2);
model.diagD = -model.beta*sum(model.invK_uu.*model.Psi2,2);



%[gradient, delta]
%pause

%invL = model.sqrtK_uu\eye(size(model.sqrtK_uu, 1));
%diagD = -model.beta*sum(invL*model.Psi2,2);
%end

%model.K_uu
%model.kern.comp{1}.inputScales
%model.kern.comp{2}
%model.kern.whiteVariance
%cond(model.K_uu) 
%cond(model.Psi2)
%model.beta
%AS
%model.Psi0 + sum(model.diagD)/model.beta
%model.kern.whiteVariance
%mean(diag(model.K_uu))
%model.beta
%g = - vargplvmLogLikeGradients(model);
%g(end-10:end-1)
%pause
