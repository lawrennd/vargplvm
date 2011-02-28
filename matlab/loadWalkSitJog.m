function [Y timeStamps] = loadWalkSitJog

Y = load('walkSitJog2.txt');
timeStamps = Y(:,1);
Y = Y(:,2:size(Y,2));