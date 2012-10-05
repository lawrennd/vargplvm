
% Fix seeds
randn('seed', 1e5);
rand('seed', 1e5);

dataSetName = 'oil100';

%%%%% Options
N = 15;
Q = 3; 
K = 5;
dynUsed = 1;
learnInducing = 0;
%%%%%%%%%


% load data
[Y, lbls] = lvmLoadData(dataSetName);
Y = Y(1:N,:);



% Set up model
options = vargplvmOptions('dtcvar');
options.kern = {'rbfard2', 'bias', 'white'};
options.numActive = K; 

options.optimiser = 'scg2';
latentDim = Q;
d = size(Y, 2);

% demo using the variational inference method for the gplvm model
model = vargplvmCreate(latentDim, d, Y, options);
%
model.learnInducing = learnInducing;
model = vargplvmParamInit(model, model.m, model.X); 



model.learnBeta=1;



   if dynUsed
        timeStampsTraining = [1:model.N]';
        t=timeStampsTraining;
        optionsDyn.inverseWidth=100;
        fprintf(1,'# Adding dynamics to the model...\n');
        optionsDyn.type = 'vargpTime';
        optionsDyn.t=timeStampsTraining;
        %optionsDyn.inverseWidth=invWidthMultDyn; % Default: 100
        %optionsDyn.testReoptimise = testReoptimise;
        dynamicKern = {'rbf','white','bias'};        
        kern = kernCreate(t, dynamicKern); % Default: {'rbf','white','bias'}
        
        
        %-- Initialize each element of the compound kernel (optional but
        % recommended)
        % ATTENTION: For the gradients we assume that the base kernel (rbf,
        % matern etc) must be the FIRST one and if a second base kernel
        % (not white or bias) exist must be the LAST one!!!!!!!!!!!!!!
        vargplvmInitDynKernel;
        
        optionsDyn.learnVariance = 1; %% NEW
        optionsDyn.kern = kern;
        optionsDyn.vardistCovars = 1; %vardistCovarsMult; % 0.23 gives true vardist.covars around 0.5 (DEFAULT: 0.23) for the ocean dataset
        
        % Fill in with default values whatever is not already set
        optionsDyn = vargplvmOptionsDyn(optionsDyn);
        model = vargplvmAddDynamics(model, 'vargpTime', optionsDyn, optionsDyn.t, 0, 0,optionsDyn.seq);
        
        fprintf(1,'# Further calibration of the initial values...\n');
        model = vargplvmInitDynamics(model,optionsDyn);
   end
   
   

model = vargplvmOptimise(model, 1, 10, 'gradcheck', true);