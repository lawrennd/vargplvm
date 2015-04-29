disp('press any key to tidy up.')
pause
clear all
close all

cd ../../vargplvm/matlab/
lvmResultsDynamic('vargplvm', 'brendan', 5, 'image', [20 28], 1, 0, ...
                  1);
pause 
close all
clear all
importTool('vargplvm')
cd ../../svargplvm/matlab/
demYaleDemonstration
pause
cd ../../hsvargplvm/matlab/
demDigitsDemonstration
cd ../../vargplvm/matlab/