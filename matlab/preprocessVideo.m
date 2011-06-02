
function [Y, height, width] = preprocessVideo(videoFile, width, height, form, options)
% PREPROCESSVIDEO
% VARGPLVM


%baseDir = 'datasets/';
%baseDir=[];
%videoFile='miss-america_qcif.yuv';
%width=176;
%height=144;

% options.dirName='missa/'; options.from=0; options.to=149;
% width=360;
% height=288;
% Y=preprocessVideo('missa',width,height,'ras',options);

if strcmp(form,'yuv')
    if ~exist('options')
        options = '420';
    end
    mov=yuv2mov([baseDir videoFile],width,height,options);

    Y = zeros(size(mov,2), width*height);
    for i=1:size(mov,2)
        mov(i).cdata = rgb2gray(mov(i).cdata);
        %imagesc(mov(i).cdata); colormap('gray');
        Y(i,:) = mov(i).cdata(:)';
    end
elseif strcmp(form,'ras')
    Y=[];
    dirName=options.dirName;
    from = options.from;
    to=options.to;
    %digitNo=length(num2str(to));
    digitNo=3;
    for i=from:to
        zerosAdd=digitNo-length(num2str(i));
        z=[];
        for j=1:zerosAdd
            z=['0' z];
        end
        im=imread([baseDir dirName videoFile sprintf([z '%d' '.ras'],i)],'RAS');
        Y(i+1,:)=im(:)';
    end
elseif strcmp(form,'avi') || strcmp(form, 'mov')
    if strcmp(form, 'avi')
        mov=aviread([baseDir videoFile]);
    else
        mov=videoFile;
        clear videoFile
    end
    width=size(mov(1).cdata,1);
    height=size(mov(1).cdata,2);
%{
%     %%% Constants
%     rate=2;
%     horFrom=20;
%     horTo=650;
%     vertFrom=1;
%     vertTo=900;
%
%     Y=zeros(round(size(mov,2)/rate), length(horFrom:horTo)*length(vertFrom:vertTo));
%     for i=1:size(mov,2)
%         fr=mov(i).cdata;
%     end
    %}

    Y = zeros(size(mov,2), width*height);
    for i=1:size(mov,2)
        mov(i).cdata = rgb2gray(mov(i).cdata);
        %imagesc(mov(i).cdata); colormap('gray');
        Y(i,:) = mov(i).cdata(:)';
    end
    if isfield(options, 'cropVideo')
        fprintf(1,'# Cropping video...');
        newHeight=options.cropVector(3)+1;
        newWidth=options.cropVector(4)+1;
        Ynew = zeros(size(Y,1), newWidth*newHeight);
        for i=1:size(Y,1)
            fr=reshape(Y(i,:),width,height);
            fr=imcrop(fr,options.cropVector);
            Ynew(i,:) = reshape(fr,1,newWidth*newHeight);
        end
        Y = Ynew; width=newWidth; height=newHeight;
    end  
end

% See the animation ensuring that the images are created correctly
if 0
    for i=1:size(Y,1)
        fr=reshape(Y(i,:),width,height);
        imagesc(fr); colormap('gray');
        pause(0.03)
        hold on
    end
end

