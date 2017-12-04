function yIx = plotPointwiseHist(inputData,lbl,par)
%function plotSmoothedHist(inputData,lbl,par)
% --cc Annelies van Nuland 19-11-2016

%% setup data

nSess= size(inputData,2);

%% enable default settings
if ~any(strcmp('fig',fieldnames(par)))
    par.fig = figure; hold on
end

if ~any(strcmp('nrBins',fieldnames(par)))
    par.nrBins = 20;
end

% prepare some default colorscheme in the right format
if ~any(strcmp('colorLine',fieldnames(par)))
    colorOptions = colormap('lines');
    for iSess = 1:nSess
        par.colorLine{iSess} = colorOptions(iSess,:);
    end
end

%% further setup



yIx = nan(size(inputData));

%% build plot
for iSess = 1:nSess
    highX = max(max(inputData(:,iSess)));
    lowX = min(min(inputData(:,iSess)));
    
    histIndex = linspace(lowX,highX,par.nrBins);
    
    plotData = inputData(:,iSess);
    % prepare smoothed line
    [N ind]=histc(plotData,histIndex); %Divide data into bins
    for iBin = 1:par.nrBins
        outP = plotData(ind==iBin);
        
%         outPSort = sort(outP);
        
        if any(strcmp('meanCenter',fieldnames(par)))
            if par.meanCenter
                yValues = (1:numel(outP))-numel(outP)/2;
            else
                yValues = 1:numel(outP);
            end
        else
            yValues = 1:numel(outP);
        end
        yIx(ind==iBin) = yValues;
        scatter(outP,yValues,[],par.colorLine{iSess});
    end
end



%% set labels
% setText = lbl.setText;
% if any(strcmp('legend',fieldnames(setText)))
%     lbl.hLegend = legend(storeH,lbl.setText.legend);
% end
% if any(strcmp('xLabel',fieldnames(setText)))
%     lbl.hXLabel = xlabel(lbl.setText.xLabel);
% end
% if any(strcmp('yLabel',fieldnames(setText)))
%     lbl.hXLabel = xlabel(lbl.setText.yLabel);
% end
% if any(strcmp('titleText',fieldnames(setText)))
%     lbl.hTitle = title(lbl.setText.titleText);
% end

end