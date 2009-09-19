function vardist = vardistExpandParam(vardist, params)
%
% places params back to the variational distrbution structure 
%
% 

if ~isempty(vardist.transforms)
  for i = 1:length(vardist.transforms)
    index = vardist.transforms(i).index;
    fhandle = str2func([vardist.transforms(i).type 'Transform']);
    params(index) = fhandle(params(index), 'atox');
  end
end

means = params(1:(vardist.numData*vardist.latentDimension));
st = vardist.numData*vardist.latentDimension + 1;
covs = params(st:end);

vardist.means = reshape(means, vardist.numData, vardist.latentDimension);
vardist.covars = reshape(covs, vardist.numData, vardist.latentDimension);