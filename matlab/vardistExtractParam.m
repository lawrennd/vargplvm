function [params, names] = vardistExtractParam(vardist)
%
%
%  Extracts the parameters of the variational distribution used for the
%  latent variables of the GP-LVM 


%means = vardist.means'; 
%covs = vardist.covars';

% the variational means and diagonal covariances obtained COLUMN-WISE 
params = [vardist.means(:)' vardist.covars(:)'];

% names
if nargout > 1  
    for i=1:size(vardist.means,1)
    for j=1:size(vardist.means,2)
        varmeanNames{i,j} = ['varmean(' num2str(i) ', ' num2str(j) ')'];
    end
    end
    for i=1:size(vardist.means,1)
    for j=1:size(vardist.means,2)
        varcovNames{i,j} = ['varcov(' num2str(i) ', ' num2str(j) ')'];
    end
    end
    names = {varmeanNames{:}, varcovNames{:}}; 
end

% Check if parameters are being optimised in a transformed space.
if ~isempty(vardist.transforms)
  for i = 1:length(vardist.transforms)
    index = vardist.transforms(i).index;
    fhandle = str2func([vardist.transforms(i).type 'Transform']);
    params(index) = fhandle(params(index), 'xtoa');
  end
end
