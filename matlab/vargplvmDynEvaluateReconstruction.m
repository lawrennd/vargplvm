% This function is depricated, not used in the demos.
function modelRec=vargplvmDynEvaluateReconstruction(model,Varmu,Varsigma,Testmeans,Testcovars,Yts,YtsOriginal,modelTEMP)

% Function which evaluates the reconstruction. 


%----- Sq. error
% Find the square error
errsum = sum((Varmu - YtsOriginal).^2);
% Devide by the total number of test points to find a mean
error = errsum / size(Varmu,1);

% Find the mean sq. error for each datapoint, to see how it increases as
% we give points further to the future. This time sum accros dimensions
errSq = sum((Varmu - YtsOriginal).^2 ,2);
errPt = errSq ./ size(Varmu,2);

fprintf(1,'*** Mean error: %d\n', mean(error));

figure;plot(errPt);
xlabel('time test datapoints','fontsize',18);
ylabel('Mean error','fontsize',18);

%----- Latent dims 1
N = size(model.X,1);
Nstar = size(Yts,1);
figure
fprintf(1,'# The two larger latent dims. plotted against each other. Red are the predicted points.\n');
plot(model.X(:,1), model.X(:,2),'--rs', 'Color','b')
hold on
plot(Testmeans(:,1),Testmeans(:,2),'--rs', 'Color','r')
title('The two larger latent dims. plotted against each other. Red are the predicted points.');
hold off
figure

%----- Reconstructing the data
fprintf(1,'# Reconstructing the data and showing error bars with dashed lines...\n');
for i=1:model.q
    plot(YtsOriginal(:,1), 'Color', 'r'); hold on; 
    plot(Varmu(:,1));
    plot(Varmu(:,i) - 2*sqrt(Varsigma(:,i)),'b:'); plot(Varmu(:,i) + 2*sqrt(Varsigma(:,i)),'b:'); 
    legend('Original data','Reconstructed data','Error bars');
    pause(0.2);
    hold off
end

%------ Latent dims 2
%See how the latent space looks like after adding the predicted latent
%points
modelRec = model;
N = size(model.X,1);
Nstar = size(model.dynamics.t_star,1);
newX = zeros( N+Nstar, model.q );
newX(1:N,:) = model.X(:,:);
newX(N+1:N+Nstar, :) = Testmeans(:,:);
modelRec.X = newX;
%modelTEMP = vargplvmCreate(model.q, model.d, Yall, options);
modelRec.m = modelTEMP.m;
modelRec.y = modelTEMP.y;
modelRec.N = modelTEMP.N;
modelRec.vardist.means = [modelRec.vardist.means; Testmeans];
modelRec.vardist.covars = [modelRec.vardist.covars; Testcovars];



