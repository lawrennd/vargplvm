function mm = vargplvmPruneModel(model)
% VARGPLVMCREATE Prune a var-GPLVM model.
% FORMAT
% DESC prunes a VAR-GPLVM model by removing some fields which can later be
% reconstructed based on what is being kept. Used when storing a model.
% ARG model: the model to be pruned
% RETURN mm : the variational GP-LVM model after being pruned
%
% COPYRIGHT: Andreas Damianou, Michalis Titsias, Neil Lawrence, 2011
%
% SEEALSO : vargplvmReduceModel, vargplvmRestorePrunedModel

% VARGPLVM


fieldsToKeep = ...
    {'type','approx','learnScales', 'optimiseBeta','betaTransform','q','d','N','optimiser',...
    'bias','scale','X','DgtN', 'kern','k','fixInducing','inducingIndices','X_u','beta','prior','vardist','numParams', ...
    'nParams','K_uu','learnBeta', 'dynamics', 'iters', 'date', 'fixedBetaIters'}';

mm=[];
for i=1:length(fieldsToKeep)
    if isfield(model, fieldsToKeep{i})
        f = getfield(model,fieldsToKeep{i});
        mm=setfield(mm,fieldsToKeep{i},f);
    else
        fprintf(['??? Field ' fieldsToKeep{i} ' was missing from model! This field was skipped...\n']);
    end
end

