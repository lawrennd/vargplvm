function model = vargplvmUpdateStats(model, X_u)
%

jitter = 1e-6;

model.K_uu = kernCompute(model.kern, X_u);
  
if ~isfield(model.kern, 'whiteVariance') | model.kern.whiteVariance == 0
   % There is no white noise term so add some jitter.
   model.K_uu = model.K_uu ...
        + sparseDiag(repmat(jitter, size(model.K_uu, 1), 1));
end

model.Psi0 = kernVardistPsi0Compute(model.kern, model.vardist);
model.Psi1 = kernVardistPsi1Compute(model.kern, model.vardist, X_u);
model.Psi2 = kernVardistPsi2Compute(model.kern, model.vardist, X_u);
[model.invK_uu, model.sqrtK_uu] = pdinv(model.K_uu);
model.logDetK_uu = logdet(model.K_uu, model.sqrtK_uu);


model.A = (1/model.beta)*model.K_uu + model.Psi2;
% This can become unstable when K_uf2 is low rank.
[model.Ainv, U] = pdinv(model.A);
model.logdetA = logdet(model.A, U);

%if ~isfield(model, 'isSpherical') | model.isSpherical
 % compute inner products
for i = 1:model.d
    E = model.Psi1'*model.m(:, i);    
    model.innerProducts(1, i) = model.beta*(model.m(:, i)'*model.m(:, i) - E'*model.Ainv*E);
end
%if strcmp(model.approx, 'dtcvar')
%model.diagD = -model.beta*trace(model.invK_uu*model.Psi2);
model.diagD = -model.beta*sum(model.invK_uu.*model.Psi2,2);
%end