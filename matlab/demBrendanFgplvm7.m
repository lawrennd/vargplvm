% DEMBRENDANFGPLVM7 Reconstruction of partial observed test data in Brendan faces using sparse GP-LVM (with dtcvar) and 5 latent dimensions

% FGPLVM

% Fix seeds
randn('seed', 1e6);
rand('seed', 1e6);

dataSetName = 'brendan';
experimentNo = 7;
printDiagram = 1;


% load data
[Y, lbls] = lvmLoadData(dataSetName);

load ../../vargplvm/matlab/demBrendanVargplvm3.mat
% training and test sets
Ntr = 1000; 
Ytr = Y(perm(1:Ntr),:);      %lblsTr = lbls(perm(1:Ntr),:);
Yts = Y(perm(Ntr+1:end),:);  %lblsTs = lbls(perm(Ntr+1:end),:);

% Set up model
options = fgplvmOptions('dtcvar');
options.kern = {'rbfard2', 'white'};
options.numActive = 50; 
options.scale2var1 = 1; % scale data to have variance 

options.optimiser = 'scg';
latentDim = 5;
d = size(Ytr, 2);


model = fgplvmCreate(latentDim, d, Ytr, options);

iters = 1000;
display = 1;

model = fgplvmOptimise(model, display, iters);

iters = 100;
display = 0;

% 50% missing outputs from the each test point
numIndPresent = round(0.5*model.d);
allInds = 1:model.d; 
% patrial reconstruction of test points
for i=1:size(Yts,1)
    %
    % randomly choose which outputs are present
    indexPresent = indexP(i,:);
    
    % initialize the latent point using the nearest neighbour 
    % from he training data
    dst = dist2(Yts(i,indexPresent), Ytr(:,indexPresent));
    [mind, mini] = min(dst);
    
    x = model.X(mini,:);
    % optimize over the latent point
    YY = Yts(i,:);
    indexMissing = setdiff(allInds,indexP(i,:));
    YY(indexMissing) = NaN;
    % normalize YY exactly as model.m is normalized 
    MYY = YY;
    MYY(indexPresent) = YY(indexPresent) - model.bias(indexPresent);
    MYY(indexPresent) = MYY(indexPresent)./model.scale(indexPresent);
    x = fgplvmOptimisePoint(model, x, MYY, display, iters);
   
    % reconstruct the missing outputs  
    [mu, sigma] = fgplvmPosteriorMeanVar(model, x);
    Fmu(i,:) = mu; 
    Fsigma(i,:) = sigma; 
    %
end

% compute the MSE per image
allInds = 1:model.d; 
for i=1:size(Yts,1)
    %
    indexMissing = setdiff(allInds,indexP(i,:));
    Ferror(i)  = mean( abs(Yts(i,indexMissing) - Fmu(i,indexMissing) ) );     
    %
end

%
capName = dataSetName;;
capName(1) = upper(capName(1));
modelType = model.type;
modelType(1) = upper(modelType(1));
save(['dem' capName modelType num2str(experimentNo) '.mat'], 'model', 'Ferror', 'perm', 'indexP', 'Fmu', 'Fsigma');
