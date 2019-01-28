function [lbl, h1] = avn_plotBarScatter(inData,lbl)
% function lbl = plotBarScatLine(data,lbl,lbl)
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
%  - lbl.yAxis (limit the yAxis, use standard [y,y] config)
%  - lbl.setText.legend (introduce legend, by specifying legendNames)
%  - lbl.legendLocation (mark location by standard use, e.g. 'northeast')
%
% optinal lbl input:
%  - lbl.lines (True/False(=default), lines between scatterpoints in colums)
%  - lbl.colorScatter (format [0 0 0] , lbl color of scatterpoints)
%  - lbl.colorSpec (set your own colors using {[0 0 0;0 0 0],[0 0 0;0 0 0]} for each
%  colum a triplit on a new line, for each session a new cell.
% % Note: Remove spm from path because of conflict with nanvar and nanmean
% Annelies van Nuland - 07/07/2016

%% basic setup
% Set baseline variables if not given
lbl.random = 1;
lbl.setText.random = 1;

if ~any(strcmp('titleText',fieldnames(lbl.setText)))
    lbl.setText.titleText = 'title';
end

if ~any(strcmp('lines',fieldnames(lbl)))
    lbl.lines=false;
end

if ~any(strcmp('colorScatter',fieldnames(lbl)))
    lbl.colorScatter = [0.6,0.6,0.6];
end

if ~iscell(inData)
    data{1} = inData;
else
    data = inData;
end

% determine size dataset
nrSess = size(data,2);
for iSess = 1:nrSess
    nrCondperSess(iSess) = size(data{iSess},2);
end
nrSub = size(data{1},1);

% prepare some default colorscheme in the right format
if ~any(strcmp('colorSpec',fieldnames(lbl)))
    colorOptions = colormap('lines');
    if nrSess>1
        for iSess = 1:nrSess
            nrCond = nrCondperSess(iSess);
            lbl.colorSpec{iSess} = repmat(colorOptions(iSess,:),nrCond,1);
        end
    else
        nrCond = nrCondperSess(1);
        for iCond = 1:nrCond
            lbl.colorSpec{1}(iCond,:) = colorOptions(iCond,:);
        end
    end
end


for iSess = 1:nrSess
    % calculate spacing (x-position bars, width of bars)
    nrCond = nrCondperSess(iSess);
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
    allXpos{iSess} = xPos;
    allU(iSess) = u;
end
uMin = min(allU);
width = uMin*3;


% Nr the xlocations of the plot
xTickSpots = [];
for iSess = 1:nrSess
    thisCond = size(data{iSess},2);
    xPos = allXpos{iSess};
    xTickSpots = [xTickSpots,[xPos(1:thisCond)+repmat(iSess,1,thisCond)]];
end

% calculate mean and sem
if nrSub>1
    for iSess = 1:nrSess
        meanData{iSess} = nanmean(data{iSess});
        snrCond = size(data{iSess},2);
        for iCond = 1:snrCond
            notNan = data{iSess}(~isnan(data{iSess}(:,iCond)),iCond);
            semData{iSess}(:,iCond) =std(notNan)./sqrt(numel(notNan));
        end
    end
else
    meanData{iSess} = data{iSess};
    if any(strcmp('manualSEM',fieldnames(lbl)))
        semData{iSess} = lbl.manualSEM{iSess};
    end
end

if ~any(strcmp('xLabels',fieldnames(lbl.setText)))
    lbl.setText.xLabels = [1:nrCond];
end

if ~any(strcmp('hYLabel',fieldnames(lbl.setText)))
    lbl.setText.hYLabel = '';
end

if ~any(strcmp('hXLabel',fieldnames(lbl.setText)))
    lbl.setText.hXLabel = '';
end

%% produce figure
if ~any(strcmp('handle',fieldnames(lbl)))
    figure('name',lbl.setText.titleText,'numbertitle','off'); hold on
end

xlim([0.5 nrSess+0.5])
for iSess = 1:nrSess
    nrSub = size(data{iSess},1);
    thisCond = size(data{iSess},2);
    xPos = allXpos{iSess};
    % create jitter
    sizeX = ones(nrSub,1);
    baseX = jitterRandX(sizeX,iSess,u/2);
    thisX = zeros(nrSub,thisCond);
    for iCond =1:thisCond
        thisX(:,iCond)=baseX+xPos(iCond);
    end
    
    if lbl.lines&&thisCond>1
        plot(thisX',...
            [data{iSess}'],'-','Color',lbl.colorScatter)
    end
    
    for iCond = 1:thisCond
        nrSub = size(data{iSess},1);
        currentColor = lbl.colorSpec{iSess}(iCond,:);
        
        % draw bars
        
        h1(iSess,iCond)=bar(iSess+xPos(iCond),meanData{iSess}(iCond),width,...
            'EdgeColor',currentColor,'FaceColor',currentColor);
        
        
        if nrSub>1
            % draw datapoints
            plot(thisX(:,iCond),data{iSess}(:,iCond),'o', ...
                'MarkerEdgeColor',currentColor,...
                'MarkerFaceColor',lbl.colorScatter)
            
            
        end
    end
end

for iSess = 1:nrSess
    xPos = allXpos{iSess};
    thisCond = size(data{iSess},2);
    
    for iCond =1:thisCond
        % draw errorbars
        errorbar(iSess+xPos(iCond),meanData{iSess}(iCond),semData{iSess}(iCond),'k.','LineWidth',2)
        
        
        if any(strcmp('manualSEM',fieldnames(lbl)))
            % draw errorbars
            errorbar(iSess+xPos(iCond),meanData{iSess}(iCond),semData{iSess}(iCond),'k.','LineWidth',2)
        end
        
    end
end

% adjust graphics
set(gca,'XTick',xTickSpots)
set(gca,'XTickLabel',[lbl.setText.xLabels lbl.setText.xLabels])
lbl.Xtick = get(gca,'XTickLabel');
lbl.hYLabel = ylabel(lbl.setText.hYLabel);
lbl.hXLabel = xlabel(lbl.setText.hXLabel);
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
        legend(h1(:,1),lbl.setText.legend)
    end
end

end

function randX = jitterRandX(X,meanX,width)
randX = (rand(size(X))-0.5)*2*width+meanX;
end