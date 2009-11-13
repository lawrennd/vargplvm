function mm = vargplvmReduceModel(model, P)

% VARGPLVMREDUCEMODEL prunes out dimensions of the model.
% FORMAT
% DESC order the latent dimensions acorrding to the inputScales and
% reduces the model to have smaller number of latent dimensions.
% ARG model : the model to be reduced.
% ARG P : the number of dimensions to move to (setting to model.q will
% just reorder the dimensions in the model).
% RETURN model : the model with the reduced number of dimensions.
%
% COPYRIGHT : Michalis K. Titsias, 2009
%  
% MODIFICATIONS : Neil D. Lawrence, 2009
% 
% SEEALSO : vargplvmCreate  

% VARGPLVM


% create temporary model 
options = vargplvmOptions('dtcvar');
options.kern =[];
options.numActive = model.k;
if ~strcmp(model.kern.type,'cmpnd')
  options.kern = model.kern.type;
elseif strcmp(model.kern.type,'cmpnd')
  options.kern{1} = model.kern.comp{1}.type;
  for i = 2:length(model.kern.comp)
    options.kern{i} = model.kern.comp{i}.type;
  end
end

mm = vargplvmCreate(P, model.d, model.y, options);
N = size(model.vardist.means,1);

if ~strcmp(model.kern.type,'cmpnd')
  % 
  if strcmp(model.kern.type,'rbfard2') | strcmp(kern.type,'linard2')
    %
    [vals, order] = sort(-model.kern.inputScales); 
    mm.kern.inputScales =  model.kern.inputScales(order(1:P));
    %
  end
  %
else
  %
  for i = 1:length(model.kern.comp)
    %
    if strcmp(model.kern.comp{i}.type,'rbfard2') | strcmp(model.kern.comp{i}.type,'linard2')
      %  
      [vals, order] = sort(-model.kern.comp{i}.inputScales); 
      mm.kern.comp{i}.inputScales = model.kern.comp{i}.inputScales(order(1:P)); 
      % you order only wrt the first ARD kernel you find 
      break;  
      %
    end
    %
  end
  %
end

mm.vardist.means = model.vardist.means(:,order(1:P));
mm.vardist.covars = model.vardist.covars(:,order(1:P));

mm.X_u = model.X_u(:,order(1:P));
mm.X = model.vardist.means(:,order(1:P));
mm.inputSclsOrder = order; 

initParams = vargplvmExtractParam(mm);
mm.numParams = length(initParams);
% This forces kernel computation.
mm = vargplvmExpandParam(mm, initParams);
