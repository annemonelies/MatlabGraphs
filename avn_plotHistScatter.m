function avn_plotHistScatter(inputData,lbl,par)
%function plotSmoothedHist(inputData,lbl,par)
% --cc Annelies van Nuland 19-11-2016

%% setup data
highX = max(max(inputData));
lowX = min(min(inputData));
nSess= size(inputData,2);
storeH = nan(1,nSess);

%% enable default settings
if ~any(strcmp('fig',fieldnames(par)))
    figure; hold on
end

if ~any(strcmp('nrBins',fieldnames(par)))
    par.nrBins = 20;
end

if ~any(strcmp('smoothing',fieldnames(par)))
    par.smoothing = 3;
end

% prepare some default colorscheme in the right format
if ~any(strcmp('colorLine',fieldnames(par)))
    colorOptions = colormap('lines');
    for iSess = 1:nSess
        par.colorLine{iSess} = colorOptions(iSess,:);
    end
end

%% further setup
histIndex = linspace(lowX,highX,par.nrBins);

%% build plot
for iSess = 1:nSess
    plotData = inputData(:,iSess);
    
    % prepare smoothed line
    N=histc(plotData,histIndex); %Divide data into bins
    N2=conv(N,ones(1,par.smoothing),'same')/par.smoothing; %Smooth the bar heights, averaging over x bins
    % plot line
    if any(strcmp('switchXY',fieldnames(par)))
        if par.switchXY
            H=line(N2,histIndex); %Plot the smoothed line
        else
            H=line(histIndex,N2); %Plot the smoothed line
        end
    else
        H=line(histIndex,N2); %Plot the smoothed line
    end
     if any(strcmp('xlim',fieldnames(par)))
        xlim(par.xlim)
     end
     if any(strcmp('ylim',fieldnames(par)))
        ylim(par.ylim)
     end
    set(H,'color',par.colorLine{iSess},'linewidth',2)
    storeH(iSess)=H;
end

%% set labels
setText = lbl.setText;
if any(strcmp('legend',fieldnames(setText)))
    lbl.hLegend = legend(storeH,lbl.setText.legend);
end
if any(strcmp('xLabel',fieldnames(setText)))
    lbl.hXLabel = xlabel(lbl.setText.xLabel);
end
if any(strcmp('yLabel',fieldnames(setText)))
    lbl.hXLabel = xlabel(lbl.setText.yLabel);
end
if any(strcmp('titleText',fieldnames(setText)))
    lbl.hTitle = title(lbl.setText.titleText);
end

end