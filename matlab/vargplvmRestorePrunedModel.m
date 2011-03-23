function model = vargplvmRestorePrunedModel(model, Ytr)
% VARGPLVMCREATE Restore a pruned var-GPLVM model.
% FORMAT
% DESC restores a vargplvm model which has been pruned and it brings it in
% the same state that it was before pruning.
% ARG model: the model to be restored
% ARG Ytr: the training data
% RETURN model : the variational GP-LVM model after being restored
%
% COPYRIGHT: Andreas Damianou, Michalis Titsias, Neil Lawrence, 2011
%
% SEEALSO : vargplvmReduceModel, vargplvmPruneModel

% VARGPLVM


model.y = Ytr;
model.m= gpComputeM(model);

if model.DgtN
    model.mOrig = model.m;
    YYT = model.m * model.m'; % NxN
    % Replace data with the cholesky of Y*Y'.Same effect, since Y only appears as Y*Y'.
     %%% model.m = chol(YYT, 'lower');  %%% Put a switch here!!!!
    [U S V]=svd(YYT);
    model.m=U*sqrt(abs(S));
    model.TrYY = sum(diag(YYT)); % scalar
else
    model.TrYY = sum(sum(model.m .* model.m));
end
    
params = vargplvmExtractParam(model);
model = vargplvmExpandParam(model, params);


model = orderfields(model);

