function model = vargplvmCreate(q, d, Y, options)

% VARGPLVMCREATE Create a GPLVM model with inducing variables.
% FORMAT
% DESC creates a GP-LVM model with the possibility of using
% inducing variables to speed up computation.
% ARG q : dimensionality of latent space.
% ARG d : dimensionality of data space.
% ARG Y : the data to be modelled in design matrix format (as many
% rows as there are data points).
% ARG options : options structure as returned from
% FGPLVMOPTIONS. This structure determines the type of
% approximations to be used (if any).
% RETURN model : the GP-LVM model.
%
% COPYRIGHT : Michalis K. Titsias and Neil D. Lawrence, 2009
%
% SEEALSO : vargplvmOptions

% VARGPLVM

if size(Y, 2) ~= d
  error(['Input matrix Y does not have dimension ' num2str(d)]);
end

model.type = 'vargplvm';
model.approx = options.approx;
  
model.learnScales = options.learnScales;
%model.scaleTransform = optimiDefaultConstraint('positive');

model.optimiseBeta = options.optimiseBeta;
model.betaTransform =  optimiDefaultConstraint('positive');  

model.q = q;
model.d = size(Y, 2);
model.N = size(Y, 1);

model.optimiser = options.optimiser;
model.bias = mean(Y);
model.scale = ones(1, model.d);

if(isfield(options,'scale2var1'))
  if(options.scale2var1)
    model.scale = std(Y);
    model.scale(find(model.scale==0)) = 1;
    if(model.learnScales)
      warning('Both learn scales and scale2var1 set for GP');
    end
    if(isfield(options, 'scaleVal'))
      warning('Both scale2var1 and scaleVal set for GP');
    end
  end
end
if(isfield(options, 'scaleVal'))
  model.scale = repmat(options.scaleVal, 1, model.d);
end

model.y = Y;
model.m = gpComputeM(model);
%if options.computeS 
%  model.S = model.m*model.m';
%  if ~strcmp(model.approx, 'ftc')
%    error('If compute S is set, approximation type must be ''ftc''')
%  end
%end


if isstr(options.initX)
  initFunc = str2func([options.initX 'Embed']);
  X = initFunc(model.m, q);
else
  if size(options.initX, 1) == size(Y, 1) ...
        & size(options.initX, 2) == q
    X = options.initX;
  else
    error('options.initX not in recognisable form.');
  end
end

model.X = X;


%model.isMissingData = options.isMissingData;
%if model.isMissingData
%  for i = 1:model.d
%    model.indexPresent{i} = find(~isnan(y(:, i)));
% end
%end
%model.isSpherical = options.isSpherical;


if isstruct(options.kern) 
  model.kern = options.kern;
else
  model.kern = kernCreate(model.X, options.kern);
end

%if isfield(options, 'noise')
%  if isstruct(options.noise)
%    model.noise = options.noise;
%  else
%    model.noise = noiseCreate(options.noise, y);
%  end
%
%  % Set up noise model gradient storage.
%  model.nu = zeros(size(y));
%  model.g = zeros(size(y));
%  model.gamma = zeros(size(y));
%  
%  % Initate noise model
%  model.noise = noiseCreate(noiseType, y); 
%  
%  % Set up storage for the expectations
%  model.expectations.f = model.y;
%  model.expectations.ff = ones(size(model.y));
%  model.expectations.fBar =ones(size(model.y));
%  model.expectations.fBarfBar = ones(numData, ...
%                                     numData, ...
%                                     size(model.y, 2));
%end


switch options.approx
 case {'dtcvar'}
  % Sub-sample inducing variables.
  model.k = options.numActive;
  model.fixInducing = options.fixInducing;
  if options.fixInducing
    if length(options.fixIndices)~=options.numActive
      error(['Length of indices for fixed inducing variables must ' ...
             'match number of inducing variables']);
    end
    model.X_u = model.X(options.fixIndices, :);
    model.inducingIndices = options.fixIndices;
  else
    ind = randperm(model.N);
    ind = ind(1:model.k);
    model.X_u = model.X(ind, :);
  end
  model.beta = options.beta;
end
%if model.k>model.N
%  error('Number of active points cannot be greater than number of data.')
%end
%if strcmp(model.approx, 'pitc')
%  numBlocks = ceil(model.N/model.k);
%  numPerBlock = ceil(model.N/numBlocks);
%  startVal = 1;
%  endVal = model.k;
%  model.blockEnd = zeros(1, numBlocks);
%  for i = 1:numBlocks
%    model.blockEnd(i) = endVal;
%    endVal = numPerBlock + endVal;
%    if endVal>model.N
%      endVal = model.N;
%    end
%  end  
%end


if isstruct(options.prior)
  model.prior = options.prior;
else
  if ~isempty(options.prior)
    model.prior = priorCreate(options.prior);
  end
end

model.vardist = vardistCreate(X, q, 'gaussian');

if isfield(options, 'tieParam') & ~isempty(options.tieParam)
%
  if strcmp(options.tieParam,'free')
      % paramsList =  
  else
      startVal = model.vardist.latentDimension*model.vardist.numData + 1;
      endVal = model.vardist.latentDimension*model.vardist.numData; 
      for q=1:model.vardist.latentDimension
          endVal = endVal + model.vardist.numData;
          index = startVal:endVal;
          paramsList{q} = index; 
          startVal = endVal + 1; 
      end
      model.vardist = modelTieParam(model.vardist, paramsList); 
  end
%
end
%  if isstruct(options.back)

%if isstruct(options.inducingPrior)
%  model.inducingPrior = options.inducingPrior;
%else
%  if ~isempty(options.inducingPrior)
%    model.inducingPrior = priorCreate(options.inducingPrior);
%  end
%end

%if isfield(options, 'back') & ~isempty(options.back)
%  if isstruct(options.back)
%    model.back = options.back;
%  else
%    if ~isempty(options.back)
%      model.back = modelCreate(options.back, model.d, model.q, options.backOptions);
%    end
%  end
%  if options.optimiseInitBack
%    % Match back model to initialisation.
%    model.back = mappingOptimise(model.back, model.y, model.X);
%  end
%  % Now update latent positions with the back constraints output.
%  model.X = modelOut(model.back, model.y);
%else
%  model.back = [];
%end

model.constraints = {};

model.dynamics = [];

initParams = vargplvmExtractParam(model);
model.numParams = length(initParams);
% This forces kernel computation.
model = vargplvmExpandParam(model, initParams);

