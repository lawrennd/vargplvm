
%{
delete testDynamics24Feb.txt;

diary 'testDynamics24Feb.txt'
   
fprintf(1,'# Usage: runDemoDynamics(demoName, expNo, latentDim, indPoints, dataToKeep, itNo, dynUsed, moreOptions )\n');

%%% DemRobotWireless %%%%
runDemoDynamics('demRobotWirelessVargplvmDyn1', 501, 10, 25, -1, 1200, 1, []);
runDemoDynamics('demRobotWirelessVargplvmDyn1', 601, 10, 25, -1, 1200, 0, []);
runDemoDynamics('demRobotWirelessVargplvmDyn1', 502, 10, 50, -1, 600, 1, []);
runDemoDynamics('demRobotWirelessVargplvmDyn1', 602, 10, 50, -1, 600, 0, []);

runDemoDynamics('demStickVargplvmDyn1', 511, 10, 30, -1, 1800, 1, []);
runDemoDynamics('demStickVargplvmDyn1', 611, 10, 30, -1, 1800, 0, []);
runDemoDynamics('demStickVargplvmDyn1', 512, 10, 50, -1, 1500, 1, []);
runDemoDynamics('demStickVargplvmDyn1', 612, 10, 50, -1, 1500, 0, []);

runDemoDynamics('demBrendanVargplvmDyn1', 521, 10, 40, -1, 50, 1, []);
runDemoDynamics('demBrendanVargplvmDyn1', 621, 10, 40, -1, 50, 0, []);
runDemoDynamics('demBrendanVargplvmDyn1', 522, 30, 50, 1400, 50, 1, []);
runDemoDynamics('demBrendanVargplvmDyn1', 622, 30, 50, 1400, 50, 0, []);
% runDemoDynamics('demBrendanVargplvmDyn1', 523, 30, 80, 1000, 80, 1, []);
% runDemoDynamics('demBrendanVargplvmDyn1', 623, 30, 80, 1000, 80, 0, []);
% runDemoDynamics('demBrendanVargplvmDyn1', 523, 30, 80, 200, 300, 1, []);
% runDemoDynamics('demBrendanVargplvmDyn1', 623, 30, 80, 200, 300, 0, []);
% runDemoDynamics('demBrendanVargplvmDyn1', 524, 40, 100, -1, 5, 1, []);
% runDemoDynamics('demBrendanVargplvmDyn1', 624, 40, 100, -1, 5, 0, []);

diary off
%}

delete testDynamics25Feb.txt;

diary 'testDynamics25Feb.txt'
   
fprintf(1,'# Usage: runDemoDynamics(demoName, expNo, latentDim, indPoints, dataToKeep, itNo, dynUsed, moreOptions )\n');


runDemoDynamics('demBrendanVargplvmDyn1', 523, 30, 50, 400, 50, 1, []);
runDemoDynamics('demBrendanVargplvmDyn1', 623, 30, 50, 400, 50, 0, []);

runDemoDynamics('demWalkSitJogVargplvmDyn1', 531,10,30,400,80,1,[]);
runDemoDynamics('demWalkSitJogVargplvmDyn1', 631,10,30,400,80,0,[]);
runDemoDynamics('demWalkSitJogVargplvmDyn1', 532,10,50,600,15,1,[]);
runDemoDynamics('demWalkSitJogVargplvmDyn1', 632,10,50,600,15,0,[]);

diary off