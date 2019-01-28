function lbl = avn_linedDotPlot(xValues,yValues,label)
% function lbl = linedDotPlot(xValues,yValues,label)
% This function draws a labeled scatter plot with a standard glmfit line 
% and stats
% 
% Possible input xValues,yValues:
%  
% - xValues,yValues can be both vectors, in which case the figure will
% consist of one dataset, with one line.
%
% - Or xValues,yValues can be both matrixes of the same size, in that case
% the figure will consist of twe datasets, which are drawn in overlap.
% 
% - Or either xValues or yValues can be a vector while the other is a matrix.
% In this case the figure will be drawn in overlap just as in the previous
% case, but the x or y value that is a vector, will be used in all
% instances of the parameter size of the other matrix.
% 
% 
% You can set mutiple labels: 
% 
% label.xLabel:     Will set the label on the x axis
% label.yLabel:     Will set the label on the y axis
% label.titleText:  will set the text of the title (if left unspecified, 
%                   title will consist of xlabel by ylabel. 
% label.showStat:   "True" will insert the p value result of a linar model,
%                   "False" will leave this out, standard is set to "True"
% label.lineColor:  You can set an overruling line color e.g. 'm','b','c'
% label.dotColor:   You can set an overruling dot color e.g. 'm','b','c'
% label.dotShape:   You can overrule the standard dot shape 
%                   which is a filled circle ( '.' , size 20 ) to an open
%                   circle ( 'o' , size 10 )
% label.mno:        if "True" you manually set the minimum value of the x
%                   and y axis to 0.
% label.xaxis:      Use to overide standard x axis, specify as [min,max]
% label.yaxis:      Use to overide standard y axis, specify as [min,max]
%
% By Annelies van Nuland March 2018

%%
% determine size of input values
dimX = size(xValues);
dimY = size(yValues);
nrOfX = min(dimX);
nrOfY = min(dimY);
maxNrXY = max(nrOfX,nrOfY);

% adjust axis according to maximum/minum values of x and y
maxX = max(max(xValues));
minX = min(min(xValues));
diffX = maxX - minX;

mnX = minX-0.1*diffX;
mxX = maxX+0.1*diffX;

maxY = max(max(yValues));
minY = min(min(yValues));
diffY = maxY - minY;
mnY = minY-0.1*diffY;
mxY = maxY+0.1*diffY;

label.random = 1;

%% process all possible label input
if any(strcmp('yValues',fieldnames(label)))
    lbl.yValues= label.yValues;
else
    lbl.yValues= '';
end

if any(strcmp('xValues',fieldnames(label)))
    lbl.xValues= label.xValues;
else
    lbl.xValues= '';
end

if any(strcmp('titleText',fieldnames(label)))
    lbl.titleText = label.titleText;
else
    lbl.titleText= sprintf('%s x %s',lbl.yValues,lbl.xValues);
end

if any(strcmp('lineColor',fieldnames(label)))
    if iscell(label.dotColor)
    lbl.lineColor = label.lineColor;
    else
        lbl.lineColor = {label.lineColor};
    end
else
    if maxNrXY==1
        lbl.lineColor= {'r'};
    else
        lbl.lineColor= {'b','k','m','r'};
    end
end

if any(strcmp('dotColor',fieldnames(label)))
    if iscell(label.dotColor)
    lbl.dotColor = label.dotColor;
    else
        lbl.dotColor = {label.dotColor};
    end
else
    if maxNrXY==1
        lbl.dotColor= {'b'};
    else
        lbl.dotColor= {'b','k','m','r'};
    end
end

if any(strcmp('showStat',fieldnames(label)))
    lbl.showStat = label.showStat;
else
    lbl.showStat= true;
end


if any(strcmp('dotShape',fieldnames(label)))
    label.dotShape= label.dotShape;
else
    label.dotShape= 'filled';
end

if strcmp(label.dotShape,'filled')
    lbl.dotForm = '.';
    lbl.dotSize = 20;
else
    lbl.dotForm = 'o';
    lbl.dotSize = 10;
end

if any(strcmp('mn0',fieldnames(label)))
    lbl.mn0 = label.mn0;
else
    lbl.mn0 = false;
end



%% produce figure
if ~any(strcmp('figHdl',fieldnames(label)))
    figure; hold on
else
    
end

for iLine = 1:maxNrXY
    
    % select the right inputline
    if nrOfX==nrOfY
        iLineX = iLine;
        iLineY = iLine;
    elseif nrOfX==1||nrOfY==1 
        % if one maxtrix (but not the other) has only one parameter 
        % matrix (min size ==1), use the same parameter for all paramater
        % of the other matrix.
        if nrOfX==1
            iLineX = 1; 
            iLineY = iLine;
        end
        if nrOfY==1
            iLineY = 1; 
            iLineX = iLine;
        end;
    else
        error('Matrixes do not have an equal number of variables, input matrixes need to have equal variables, or one needs to be a vector')
    end
    
    % make sure the orrientation of the input is always in the right way
    if dimX(2)==nrOfX
        x = xValues(:,iLineX);
    elseif dimX(1)==nrOfX
        x = xValues(iLineX,:)';
    end
    
    if dimY(2)==nrOfY
        y = yValues(:,iLineY);
    elseif dimY(1)==nrOfX
        y = yValues(iLineY,:)';
    end
    

    
    % overrule axis minimun values, and set to 0 (if variable mn0 is set)
    if lbl.mn0
        mnX = 0;
        mnY = 0;
    end
    
    % overrule axis minimun values, and set to specicif number 
    % (if variable yaxis or xaxis is set)
    if any(strcmp('yaxis',fieldnames(label)))
        mnY = label.yaxis(1);
        mxY = label.yaxis(2);
    end
    
    if any(strcmp('xaxis',fieldnames(label)))
        mnX = label.xaxis(1);
        mxX = label.xaxis(2);
    end
    
    %% prepare line
    [B,~,stats] =glmfit(x,y);
    
    % Make lines dotted if the linear model calculation is not significant
    % (does not work momentarily, even though this written as documented)
    % if stats.p(2)>0.05
    %     lineshape = '--';
    % else
    %     lineshape = '-';
    % end
    
    lineshape = '-';  % temporary overruled as always a solid line
    curLineColor = lbl.lineColor{iLine};
    curDotColor = lbl.dotColor{iLine};
    lineStyle = [lineshape curLineColor];
    
    %% make figure
    
    % set axis
    sizeX = [mnX mxX];
    sizeY = [mnY mxY];
    xlim(sizeX);
    ylim(sizeY);
    
    % plot dots and line
    plot(x,y,[curDotColor,lbl.dotForm],'MarkerSize',lbl.dotSize)
    plot(x,B(1)+B(2)*x,lineStyle,'LineWidth',2);
    
    % set labelnames and title
    ylabel(lbl.yValues,'fontsize',12,'fontname','Tahoma');
    xlabel(lbl.xValues,'fontsize',12,'fontname','Tahoma');
    title(lbl.titleText,'fontweight','bold','fontsize',14,'fontname','Tahoma')
    
    % set statistics (if showstats is set to true)
    if lbl.showStat
        
        text((sizeX(1)+(sizeX(2)-sizeX(1))*0.15),(sizeY(2)-(sizeY(2)-sizeY(1))*0.15*iLine),...
            sprintf('p:%.3f',stats.p(2)),'Color',lbl.lineColor{iLine},'FontSize',10);
    end
    
end
end


