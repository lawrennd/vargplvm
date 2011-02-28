function model = addDefaultVargpTimeDynamics(model, timeStamps)
   
fprintf(1,'# Adding dynamics to the model...\n');
%optionsDyn = vargplvmOptions('ftc'); %%% TODO

%optionsDyn.prior = 'gaussian';
optionsDyn.initX = 'ppca'; %probably not needed

% Create time vector for each dimension (later change that if t is given)
if exist('timeStamps')
    t = timeStamps;
else
    fprintf(1, '# Time vector unknown; creating random, equally spaced time vector\n');
    t = linspace(0, 2*pi, size(model.X, 1)+1)';  
    t = t(1:end-1, 1);
end

%%% Create Kernel -this should go to the vargplvmOptions
kern = kernCreate(t, {'rbf','white'});    

kern.comp{2}.variance = 1e-3; % 1e-1
kern.comp{1}.inverseWidth = 5./(((max(t)-min(t))).^2);
%kern.comp{1}.inverseWidth = 1;
kern.comp{1}.variance = 1;
optionsDyn.kern = kern;
%optionsDyn.means = model.vardist.means;
%optionsDyn.covars = model.vardist.covars;

model = vargplvmAddDynamics(model, 'vargpTime', optionsDyn, t, 0, 0);


