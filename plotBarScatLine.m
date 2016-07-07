function lbl = plotBarScatLine(data,lbl,sets)
% function lbl = plotBarScatLine(data,lbl,sets) 
% Creates plot which include (groups of) bars, the induvidual data points
% which are scattered with a slight jitter (relative to bar-thickness)
% and can include lines between jitter-points if specified. 
% 
% You input your data in the following organisation:
% Within one 'group' of bars, conditions are put into colums whith on each 
% line the induvidual trials. Separate groups of bars are put into 
% different cells.
%
% (cell) (cell)
% group  group
% || ||  || || 
% c1 c2  c1 c2
%
% Further required and optional input
% required lbl input:
%  - lbl.setText.titleText
%  - lbl.setText.xLabels (name xType for each colum)
%  - lbl.setText.hYLabel
% optional lbl input:
%  - lbl.setText.yAxis (limit the yAxis, use standard [y,y] config)
%  - lbl.setText.legend (introduce legend, by specifying legendNames) 
%  - lbl.legendLocation (mark location by standard use, e.g. 'northeast')
%
% optinal sets input: 
%  - sets.lines (True/False(=default), lines between scatterpoints in colums)
%  - sets.colorScatter (format [0 0 0] , sets color of scatterpoints)
%  - sets.colorSpec (set your own colors using {[0 0 0;0 0 0],[0 0 0;0 0 0]} for each
%  colum a triplit on a new line, for each session a new cell. 
%
% Annelies van Nuland - 07/07/2016
%% basic setup
% Set baseline variables if not given
if ~any(strcmp('lines',fieldnames(sets)))
    sets.lines=false;
end

if ~any(strcmp('colorScatter',fieldnames(sets)))
    sets.colorScatter = [0.6,0.6,0.6];
end

% determine size dataset
nrSess = size(data,2);
nrCond = size(data{1},2);
nrSub = size(data{1},1);

% prepare some default colorscheme in the right format
if ~any(strcmp('colorSpec',fieldnames(sets)))
    colorOptions = colormap('lines');
    if nrSess>1
        for iSess = 1:nrSess
            sets.colorSpec{iSess} = repmat(colorOptions(iSess,:),nrCond,1);
        end
    else
        for iCond = 1:nrCond
            sets.colorSpec{1}(iCond,:) = colorOptions(iCond,:);
        end
    end
end

% calculate spacing (x-position bars, width of bars)
u = 1/(1+nrCond*4);
xPos = [];
x = -0.5;
for iCond = 1:nrCond
    if iCond ==1
        x = x+2.5*u;
    else
        x = x+4*u;
    end
    xPos(iCond) = x;
end
width = u*3;

% Nr the xlocations of the plot
xTickSpots = [];
for iSess = 1:nrSess
    xTickSpots = [xTickSpots,[xPos+repmat(iSess,1,nrCond)]];
end

% calculate mean and sem
for iSess = 1:nrSess
    meanData{iSess} = nanmean(data{iSess});
    semData{iSess} =nanstd(data{iSess},[],1)/sqrt(nrSub);
end

%% produce figure
figure('name',lbl.setText.titleText,'numbertitle','off'); hold on 
for iSess = 1:nrSess
    % create jitter
    sizeX = ones(nrSub,1);
    thisX = jitterRandX(sizeX,iSess,u/2);
    thisX = [thisX+xPos(1) thisX+xPos(2)];
    
    if sets.lines
        plot(thisX',...
            [data{iSess}'],'-','Color',sets.colorScatter)
    end
    
    for iCond = 1:nrCond
        currentColor = sets.colorSpec{iSess}(iCond,:);
        
        % draw bars 
        h1(iSess)=bar(iSess+xPos(iCond),meanData{iSess}(iCond),width,...
            'EdgeColor',currentColor,'FaceColor',currentColor);

        % draw datapoints
        plot(thisX(:,iCond),data{iSess}(:,iCond),'o', ...
            'MarkerEdgeColor',currentColor,...
            'MarkerFaceColor',sets.colorScatter)

        % draw errorbars
        errorbar(iSess+xPos(iCond),meanData{iSess}(iCond),semData{iSess}(iCond),'k.','LineWidth',2)
    end
end

% adjust graphics
set(gca,'XTick',xTickSpots)
set(gca,'XTickLabel',[lbl.setText.xLabels lbl.setText.xLabels])
lbl.Xtick = get(gca,'XTickLabel');
lbl.hYLabel = ylabel(lbl.setText.hYLabel);
lbl.hTitle = title(lbl.setText.titleText);

% limit xaxis in a pretty way
xlim([0.5 nrSess+0.5])
% limit yaxis to specifications (if any)
if any(strcmp('yAxis',fieldnames(lbl)))
    ylim(lbl.yAxis)
end

% set legend if specified
if any(strcmp('legend',fieldnames(lbl.setText)))
    if any(strcmp('legendLocation',fieldnames(lbl)))
        legend(h1,lbl.setText.legend,'location',lbl.legendLocation)
    else
        legend(h1,lbl.setText.legend)
    end
end

end

function randX = jitterRandX(X,meanX,width)
    randX = (rand(size(X))-0.5)*2*width+meanX;
end