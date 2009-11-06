function mm = vargplvmReduceModel(model, P)

% VARGPLVMREDUCEMODEL description.

% VARGPLVM
  
%
% Order the latent dimensions accroding to the values of the inputScales
% reduce the model to a smaller model having only P latent dimensions 
% 




% create temporary model 
options = vargplvmOptions('dtcvar');
options.kern =[];
options.numActive = model.k;
if ~strcmp(model.kern.type,'cmpnd')
    options.kern = model.kern.type;
end
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
         order
         order(1:2) = order([2,1]);
         order
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

