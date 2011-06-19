function model = vargplvmParamInit(model,Y,X)

% VARGPLVMPARAMINIT Initialize the variational GPLVM from the data
% COPYRIGHT: Michalis Titsias 2009-2011
% VARGPLVM
  
  
% if input dimension is equal to the latent dimension, 
% then  initialize the variational mean to the normalzed training data
%if model.d == model.q 
%    X = Y; 
%    model.vardist.means = X;  
%    % inducing points 
%    ind = randperm(model.N);
%    ind = ind(1:model.k);
%    model.X_u = X(ind, :);
%end

if ~strcmp(model.kern.type,'cmpnd')
   % 
   if strcmp(model.kern.type,'rbfard2')  | strcmp(model.kern.type,'rbfardjit') 
      % 
       model.kern.inputScales = 5./(((max(X)-min(X))).^2);
       %model.kern.variance = max(var(Y)); % !!! better use mean(var(Y)) here...
       model.kern.variance = mean(var(Y)); % NEW!!!
      %
   elseif strcmp(model.kern.type,'linard2')
      %
      model.kern.inputScales = 5./(((max(X)-min(X))).^2);
      %   
   end
   %
else
   %
   for i = 1:length(model.kern.comp)
      %
      if strcmp(model.kern.comp{i}.type,'rbfard2') | strcmp(model.kern.type,'rbfardjit') 
      % 
         model.kern.comp{i}.inputScales = 5./(((max(X)-min(X))).^2);
         %model.kern.comp{i}.variance = max(var(Y));
         model.kern.comp{i}.variance = var(model.m(:));
      %
      elseif strcmp(model.kern.comp{i}.type,'linard2')
      %
       model.kern.comp{i}.inputScales = 0.01*max(var(Y))*ones(1,size(X,2));% %5./(((max(X)-min(X))).^2);
      %   
      end
      %
   end
   %
end

% initialize inducing inputs by kmeans 
%kmeansops = foptions;
%kmeansops(14) = 10;
%kmeansops(5) = 1;
%kmeansops(1) = 0;
%ch = randperm(model.N);
%centres = model.vardist.means(ch(1:model.k),:);
%model.X_u = kmeans(centres, model.vardist.means, kmeansops);

model.beta = 1000;%/max(var(Y));


initParams = vargplvmExtractParam(model);
model.numParams = length(initParams);
% This forces kernel computation.
model = vargplvmExpandParam(model, initParams);

