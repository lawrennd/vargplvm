% demCmu35 with animation. The predictions Ypred are recomputed based on
% the saved barmu, lambda, modelUpdated because they weren't saved
% properly. (TODO: save these recomputations!)

randn('seed', 1e5);
rand('seed', 1e5);


dataSetName = 'cmu35gplvm';
if ~exist('experimentNo') experimentNo = 33; end

% load data
[Y, lbls, Ytest, lblstest] = lvmLoadData(dataSetName);
dataSetName = 'cmu35gplvm';

capName = dataSetName;
capName(1) = upper(capName(1));
fileName=['dem' capName 'Vargplvm' num2str(experimentNo)];

% load data
[Y, lbls, Ytest, lblstest] = lvmLoadData(dataSetName);
origBias = mean(Y);
origScale = 1./sqrt(var(Y));

legInd = [8:14];
bodyInd = [21:50];

startInd = 63;
dt=0.05;
timeStampsTest = ([0:size(Ytest,1)-1].*dt)';

load(fileName)
model.dynamics.t_star = timeStampsTest;

%load(['demCmu35Vargplvm' num2str(experimentNo) 'PredLegs.mat']); missingInd = legInd;
load(['demCmu35Vargplvm' num2str(experimentNo) 'PredBody.mat']) ;missingInd = bodyInd;

YtestOrig = Ytest;
YtestGplvm = Ytest;
YtestGplvm(startInd:end, missingInd) = NaN;
indexMissingData = startInd:size(YtestGplvm);
[x, varx, modelUpdated] = vargplvmDynamicsUpdateModelTestVar(model, barmu, lambda, YtestGplvm);
Testmeans = x(indexMissingData, :);
Testcovars = varx(indexMissingData, :);
[mu, sigma] = vargplvmPosteriorMeanVar(modelUpdated, Testmeans, Testcovars);
Ypred = mu;




%%
origYtest = Ytest;
err = origYtest(startInd:end, missingInd) - Ypred(:, missingInd);
err = err*180/pi;
angleErrorGplvm = sqrt(mean(mean((err.*err))))
load cmu35TaylorScaleBias
err = err.*repmat(scale(1, missingInd+9), size(origYtest, 1)-startInd+1, 1);
taylorErrorGplvm = sum(sum(err.*err))/length(missingInd)


%%
% NN
temp = ones(1, size(Ytest, 2));
temp(missingInd) = 0;
presentInd = find(temp);
YtrainNn = Y(:, presentInd);
YtestNn = origYtest(startInd:end, presentInd);
dists = dist2(YtrainNn, YtestNn);
[void, bestIndNn] = min(dists);

%%

if ~exist('displayPlots')
    displayPlots = 1;
end

if displayPlots
    colordef white
    plotRange = missingInd;
    for plotNo = plotRange
        figNo = plotNo - min(plotRange) + 1;
        figure(figNo)
        clf
        lin = plot(1:size(origYtest, 1), origYtest(:, plotNo), '-')
        hold on
        lin = [lin; plot(1:size(origYtest, 1), [origYtest(1:startInd-1, plotNo); Y(bestIndNn, plotNo)], ':')];
        lin = [lin; plot(1:size(origYtest, 1), [origYtest(1:startInd-1, plotNo); Ypred(:, plotNo)], '--')];
        ax = gca;
        xlabel('Frame')
        ylabel('Normalized joint angle')
        set(ax, 'fontname', 'arial');
        set(ax, 'fontsize', 20);
        set(lin, 'lineWidth', 2);
        pos = get(gcf, 'paperposition')
        origpos = pos;
        pos(3) = pos(3)/2;
        pos(4) = pos(4)/2;
        set(gcf, 'paperposition', pos);
        fontsize = get(gca, 'fontsize');
        set(gca, 'fontsize', fontsize/2);
        lineWidth = get(gca, 'lineWidth');
        set(gca, 'lineWidth', lineWidth*2);
        set(gcf, 'paperposition', origpos);
    end
end


%%

skel = acclaimReadSkel('35.asf');
[tmpchan, skel] = acclaimLoadChannels('35_01.amc', skel);
channels1 = demCmu35VargplvmLoadChannels(Ytest,skel);
channels2 = demCmu35VargplvmLoadChannels(Ypred,skel);
channels3 = demCmu35VargplvmLoadChannels(Y(bestIndNn, :),skel);
%skelPlayData(skel, channels, 1/25);

%{
 for i=1:3
    %left indices
    xyzInd = [2];
    xyzDiffInd = [1 3];
    rotInd = [4 6];
    rotDiffInd = [5];
    generalInd = [7:38 41:47 49:50 53:59 61:62];
    startInd = 1;
    endInd = length(generalInd);
    channels(:, generalInd) = 180*Ytest(:, startInd:endInd)/pi;
    startInd = endInd + 1;
    endInd = endInd + length(xyzDiffInd);
    channels(:, xyzDiffInd) = cumsum(Ytest(:, startInd:endInd), 1);
    startInd = endInd + 1;
    endInd = endInd + length(xyzInd);
    channels(:, xyzInd) = Ytest(:, startInd:endInd);
    startInd = endInd + 1;
    endInd = endInd + length(xyzDiffInd);
    channels(:, xyzDiffInd) = cumsum(Ytest(:, startInd:endInd), 1);
    startInd = endInd + 1;
    endInd = endInd + length(rotInd);
    channels(:, rotInd) = asin(Ytest(:, startInd:endInd))*180/pi;
    channels(:, rotInd(end)) = channels(:, rotInd(end))+270;
    startInd = endInd + 1;
    endInd = endInd + length(rotDiffInd);
    channels(:, rotDiffInd) = 0;%cumsum(asin(Ytest(:, startInd:endInd)), 1))*180/pi;
    % skelPlayData(skel, channels, 1/25);

    if i==1
        Ytest = Ypred;
        channels1 = channels;
        clear channels
    elseif i==2
        Ytest = Y(bestIndNn, :);
        channels2 = channels;
        clear channels
    end
end
%channels3 = channels;
%}

startInd = 63;
skelPlayData2(skel, 1/15, channels1(startInd:end,:), channels2, channels3,{'Ytest','YpredGPLVM','YpredNN'});

%%
% Sampling:
if ~exist('doSampling')
    doSampling = 0;
end





if doSampling
 %   timeStampsTestOrig = timeStampsTest;
 %   timeStampsTest = (timeStampsTest(end):dt:(timeStampsTest(end)+100*dt))';
    model.dynamics.t_star = timeStampsTest;
    seqTest = 1; % WALK
    %seqTest = 17; % RUN
    
    if seqTest ~= 1
        datFrom = model.dynamics.seq(seqTest-1)+1;
    else
        datFrom = 1;
    end
    datEnd=model.dynamics.seq(seqTest);
    
    model.dynamics.t_star = model.dynamics.t_star(1:(datEnd+1-datFrom));%%%
    %     clear model
    %     load demCmu35VargplvmOne
    %     %load demCmu35VargplvmOneRun
    %     ySamp, xSamp] = vargpTimeDynamicsSample(model,1);
    %     channels4 = demCmu35VargplvmLoadChannels(ySamp,skel);
    %     skelPlayData(skel, channels4, 1/25);
    
    
    [ySamp, xSamp] = vargpTimeDynamicsSampleSeq(model,1,seqTest);
    channels4 = demCmu35VargplvmLoadChannels(ySamp,skel);
    skelPlayData(skel, channels4, 1/10);
    
    %     [Testmeans2 Testcovars2] = vargplvmPredictSeq(model.dynamics, timeStampsTest,1);
    %     Varmu2 = vargplvmPosteriorMeanVar(model, Testmeans2, Testcovars2);
    %     channels5 = demCmu35VargplvmLoadChannels(Varmu2,skel);
    %     skelPlayData(skel, channels5, 1/25);
    
end
%%
%lvmVisualise(model, [], 'skelVisualise', 'skelModify', channels, skel);
%lvmVisualise(model, [], 'TEMPskelVisualise', 'skelModify', channels1,
%skel);