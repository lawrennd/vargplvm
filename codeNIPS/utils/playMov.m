function playMov(h, w, options, Y1, Y2,sz)

if ~nargin
    fprintf(1,'# Usage: \nplayMov(h,w,[p <p_diff>],Y1,<Y2>,<figSizeFactor>)\n');
    return
end
if ~isfield(options,'imFormat')
    imFormat = 'jpg';
end

scrsz = get(0,'ScreenSize');
fntSz=18;
try
    if ~isstruct(options)
        p = options;
    else
        p = options.p;
        if isfield(options, 'indices')
            indices = options.indices;
        end
        if isfield(options, 'saveMovie') && options.saveMovie
            saveMovie=1;
            aviobj = avifile(options.movieName, 'fps', options.fps);
            if isfield(options,'quality')
                aviobj.Quality = options.quality;
            end
            if isfield(options,'compression') && ~isempty(options.compression) % e.g. 'Cinepak'
                aviobj.Compression = options.compression;
            end
        end
        if isfield(options, 'sz')
             scrsz(3) = scrsz(3)/options.sz;
             scrsz(4) = scrsz(4)/options.sz;
             fntSz = fntSz/options.sz;
        end
         if isfield(options, 'sz1') && isfield(options, 'sz2')
             scrsz(3) = options.sz1;
             scrsz(4) = options.sz2;
        end
    end
    if exist('sz') && sz
        scrsz(3) = scrsz(3)/sz;
        scrsz(4) = scrsz(4)/sz;
    end
    
    

    figure('Position',[scrsz(3)/4.86 scrsz(4)/6.666 scrsz(3)/1.6457 scrsz(4)/1.4682])

    % if sz is zero pause to allow user to fixz manually the size
    if exist('sz') && ~sz
        pause
    end

    % Oversampling
    if nargin > 4 && (length(p)==2)
        % if p is 2-D then the first element says how much to pause for the
        % second matrix and the second elem how many frames of the second to play in
        % between from the first matrix
        k=1;
        try
            for i=1:size(Y2,1)
                subplot(1,2,1);
                fr=reshape(Y2(i,:),h,w);
                imagesc(fr);
                colormap('gray');
                title(['frame' num2str(i)])
                text(scrsz(4)/6.666,0,['frame' num2str(i)],'HorizontalAlignment','center','VerticalAlignment','top','BackgroundColor',[.7 .9 .7], 'FontSize',fntSz);
                for j=1:p(2)
                    subplot(1,2,2);
                    fr=reshape(Y1(k,:),h,w);
                    k = k+1;
                    imagesc(fr);
                    colormap('gray');
                    pause(p(1))
                end
                if isfield(options, 'saveMovie') && options.saveMovie
                    frame = getframe ( gca );
                    aviobj = addframe ( aviobj, frame );
                end
             if isfield(options, 'saveImages')
                 frame = getframe ( gca );
                   imwrite (frame.cdata,[options.saveImages num2str(i) '.' imFormat]); 
                end
            end
        catch e
            e.message
        end
    elseif nargin >4 && (length(p) < 2) % Two movies
        for i=1:size(Y1,1)
            subplot(1,2,1);
            fr=reshape(Y1(i,:),h,w);
            imagesc(fr);
            colormap('gray');
            subplot(1,2,2);
            fr=reshape(Y2(i,:),h,w);
            imagesc(fr);
            colormap('gray');
            title(['frame' num2str(i)])
           % text(scrsz(4)/6.666,0,['frame' num2str(i)],'HorizontalAlignment','center','VerticalAlignment','top','BackgroundColor',[.7 .9 .7], 'FontSize',fntSz);
            if isempty(p)
                pause
            else
                pause(p);
            end
            if isfield(options, 'saveMovie') && options.saveMovie
                frame = getframe ( gca );
                aviobj = addframe ( aviobj, frame );
            end
             if isfield(options, 'saveImages')
                 frame = getframe ( gca );
                   imwrite (frame.cdata,[options.saveImages num2str(i) '.' imFormat]); 
                end
        end
    elseif nargin <=4 % One movie
        for i=1:size(Y1,1)
            fr=reshape(Y1(i,:),h,w);
            imagesc(fr);
            colormap('gray');
            if exist('indices')
                if indices(i)
                    title(['Frame: ' num2str(i) ' (Training)'], 'Color','b','FontSize',fntSz)
                    text(scrsz(4)/6.666,0,['frame' num2str(i) ' (Training)'],'VerticalAlignment','top','BackgroundColor',[.7 .9 .7], 'FontSize',fntSz);
                else
                    title(['Frame: ' num2str(i) ' (Generated)'], 'Color','r','FontSize',fntSz)
                    text(scrsz(4)/6.666,0,['frame' num2str(i) ' (Generated)'],'VerticalAlignment','top','BackgroundColor',[1 0 0], 'FontSize',fntSz);
                end
            else
                title(['frame' num2str(i)])
               % text(scrsz(4)/6.666,0,['frame' num2str(i)],'HorizontalAlignment','center','VerticalAlignment','top','BackgroundColor',[.7 .9 .7], 'FontSize',fntSz);
            end
            if isempty(p)
              
                pause
            else
                pause(p);
            end
            if isfield(options, 'saveMovie') && options.saveMovie
                frame = getframe ( gca );
                aviobj = addframe ( aviobj, frame );
            end
            if isfield(options, 'saveImages')
                frame = getframe ( gca );
                   imwrite (frame.cdata,[options.saveImages num2str(i) '.' imFormat]);
             end
        end
    else
        fprintf(1,'playMov(h,w,p,Y1,Y2)\n')
    end

catch e
    e.stack
    if isfield(options, 'saveMovie') && options.saveMovie
        aviobj = close (aviobj);
    end
   error(e.stack)
end

if isfield(options, 'saveMovie') && options.saveMovie
    aviobj = close ( aviobj );
end