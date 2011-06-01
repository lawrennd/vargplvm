function [muqOrig SqOrig] = modelPriorKernGrad(dynModel)

fhandle = str2func([dynModel.type 'PriorKernGrad']);
[muqOrig SqOrig] = fhandle(dynModel);

% if isfield(model, 'paramGroups')
%  g = g*model.paramGroups;
% end
