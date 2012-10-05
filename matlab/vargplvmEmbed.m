% varargin = {options, initIters, iters, display}
function [X, sigma2, W, model] = vargplvmEmbed(Y, dims, varargin)

vargplvm_init;

initVardistIters = 15;
iters = 50;
display = 1;

options = vargplvmOptions('dtcvar');
options.kern = 'rbfardjit';
options.numActive = 50;
options.optimiser = 'scg2';
options.initSNR = 100;
    
if nargin > 2
    if ~isempty(varargin{1})
        options = varargin{1};
    end
    if length(varargin)>1 && ~isempty(varargin{2}), initVardistIters = varargin{2}; end
    if length(varargin)>2 && ~isempty(varargin{3}), iters = varargin{3}; end
    if length(varargin)>3 && ~isempty(varargin{4}), display = varargin{4}; end
end

globalOpt.initSNR = options.initSNR;

latentDim = dims;
d = size(Y, 2);

% demo using the variational inference method for the gplvm model
model = vargplvmCreate(latentDim, d, Y, options);
%
model = vargplvmParamInit(model, model.m, model.X); 
model = vargplvmModelInit(model, globalOpt);
modelInit = model;%%%% Delete
fprintf('#--- vargplvmEmbed from %d dims to %d dims (initSNR=%f)...\n',d,latentDim,vargplvmShowSNR(model, false));

% Optimise the model.
fprintf('  # vargplvmEmbed: Optimising var. distr. for %d iters...\n',initVardistIters);
if initVardistIters > 0
    model.initVardist = 1; model.learnSigmaf = false;
    model = vargplvmOptimise(model, display, initVardistIters);
end
model.initVardist = false; model.learnSigmaf = true;
if iters > 0
    fprintf('\n  # vargplvmEmbed: Optimising for %d iters...\n',iters);
    model = vargplvmOptimise(model, display, iters);
end
X = model.vardist.means;
sigma2 = model.vardist.covars;
W = vargplvmScales('get', model);

SNRfinal = vargplvmShowSNR(model, false);
fprintf('#--- Finished embedding. SNR: %f \n',SNRfinal);
fprintf('#--- Scales: %s\n\n', num2str(W));
if SNRfinal < 10
    warning(['During vargplvmEmbed SNR was too low (' num2str(SNRfinal) ')!'])
end
