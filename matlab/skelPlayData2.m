function skelPlayData2(skelStruct, frameLength, channels1, channels2, channels3, lbls)

% SKELPLAYDATA Play skel motion capture data.
%
%	Description:
%
%	SKELPLAYDATA(SKEL, CHANNELS, FRAMELENGTH) plays channels from a
%	motion capture skeleton and channels.
%	 Arguments:
%	  SKEL - the skeleton for the motion.
%	  CHANNELS - the channels for the motion.
%	  FRAMELENGTH - the framelength for the motion.
%
%
%	See also
%	BVHPLAYDATA, ACCLAIMPLAYDATA


%	Copyright (c) 2006 Neil D. Lawrence
% 	skelPlayData.m CVS version 1.2
% 	skelPlayData.m SVN version 42
% 	last update 2008-08-12T20:23:47.000000Z

if nargin < 3
    frameLength = 1/120;
end
clf



scrsz = get(0,'ScreenSize');

%     scrsz(3) = scrsz(3)/sz;
%     scrsz(4) = scrsz(4)/sz;


figure('Position',[scrsz(3)/4.86 scrsz(4)/6.666 scrsz(3)/1.6457 scrsz(4)/1.4682])





subplot(1,3,1);
gca1 = gca;
handle1 = skelVisualise(channels1(1, :), skelStruct);
if exist('lbls')
    title(lbls{1})
end
subplot(1,3,2);
gca2 = gca;
handle2 = skelVisualise(channels2(1, :), skelStruct);
if exist('lbls')
    title(lbls{2})
end

if exist('channels3') && ~isempty(channels3)
    subplot(1,3,3);
    gca3 = gca;
    handle3 = skelVisualise(channels3(1, :), skelStruct);
    if exist('lbls')
        title(lbls{3})
    end
end

% Get the limits of the motion.
xlim = get(gca, 'xlim');
minY1 = xlim(1);
maxY1 = xlim(2);
ylim = get(gca, 'ylim');
minY3 = ylim(1);
maxY3 = ylim(2);
zlim = get(gca, 'zlim');
minY2 = zlim(1);
maxY2 = zlim(2);
for i = 1:size(channels1, 1)
    Y = skel2xyz(skelStruct, channels1(i, :));
    minY1 = min([Y(:, 1); minY1]);
    minY2 = min([Y(:, 2); minY2]);
    minY3 = min([Y(:, 3); minY3]);
    maxY1 = max([Y(:, 1); maxY1]);
    maxY2 = max([Y(:, 2); maxY2]);
    maxY3 = max([Y(:, 3); maxY3]);
end
xlim = [minY1 maxY1];
ylim = [minY3 maxY3];
zlim = [minY2 maxY2];
set(gca1, 'xlim', xlim, ...
    'ylim', ylim, ...
    'zlim', zlim);

set(gca2, 'xlim', xlim, ...
    'ylim', ylim, ...
    'zlim', zlim);

set(gca3, 'xlim', xlim, ...
    'ylim', ylim, ...
    'zlim', zlim);


% Play the motion
for j = 1:size(channels1, 1)
    pause(frameLength)
    subplot(1,3,1)
    skelModify(handle1, channels1(j, :), skelStruct);
    subplot(1,3,2)
    skelModify(handle2, channels2(j, :), skelStruct);
    if exist('channels3') && ~isempty(channels3)
        subplot(1,3,3)
        skelModify(handle3, channels3(j, :), skelStruct);
    end
end
