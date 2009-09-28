function vardist = vardistExpandParam(vardist, params)

% VARDISTEXPANDPARAM helper function for variational dist expand params.
% FORMAT
% DESC is a helper function for vargplvmExpandParam.
% ARG vardist : the variational distribution structure to update.
% ARG params : the parameters to distribute in that structure.
% RETURN vardist : the updated variational distribution structure.
%
% SEEALSO : vargplvmExpandParam, vargplvmCreate
%
% COPYRIGHT : Michalis K. Titsias, 2009

% VARGPLVM
  
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
  vardist.covars = reshape(covs, vardist.numData, ...
                           vardist.latentDimension);
end