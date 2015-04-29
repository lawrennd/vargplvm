cd ../../hgplvm/matlab/
hgplvmToolboxes
disp('load demWalkRun1.mat')
disp(['hgplvmHierarchicalVisualise(model, visualiseNodes, depVisData'])
r = input('Type ''R'' to run or ''S'' to skip: ', 's');
switch r
 case {'r', 'R'}
  close all
  clear all
  % Load model
  load demWalkRun1
  % Display results
  hgplvmHierarchicalVisualise(model, visualiseNodes, depVisData);

 otherwise
end


disp('press any key to tidy up.')
pause
clear all
close all

cd ../../vargplvm/matlab/
lvmResultsDynamic('vargplvm', 'brendan', 5, 'image', [20 28], 1, 0, ...
                  1);
disp('press any key to tidy up.')
pause 
close all
clear all
importTool('vargplvm')
cd ../../svargplvm/matlab/
demYaleDemonstration
pause
disp('press any key to tidy up.')
pause 
close all
clear all
cd ../../hsvargplvm/matlab/
closeLatest('mltools')
importTool('mltools')
importTool('gplvm')
demDigitsDemonstration
cd ../../vargplvm/matlab/