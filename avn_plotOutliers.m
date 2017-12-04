function [outliersRemoved,outlier,lbl] = avn_plotOutliers(inputData,lbl)
%function [outliersRemoved,lbl] = plotOutliers(inputData,lbl)
% Creates plot that visualises (and removes) the outliers of a given vector
% according to the presumption that an outliers is SD>3.
%
% Further optional input
%  - lbl.setText.titleText
%  - lbl.setText.hYLabel
%  - lbl.outlierLim
% Annelies van Nuland - 30/10/2016

%% update data to plot format
if ~any(strcmp('preOutlier',fieldnames(lbl)))
    preOutlier = [];
else
    preOutlier = [lbl.preOutlier, inputData(lbl.preOutlier)];
    inputData(lbl.preOutlier)=NaN;
    
end

if ~any(strcmp('outlierLim',fieldnames(lbl)))
    lbl.outlierLim = 3;
end

inputData(inputData==0)=NaN;
zInputData = zscore(inputData,2);
% zInputData(isnan(zInputData))=0;
highPoint = find(zInputData>lbl.outlierLim|zInputData<-lbl.outlierLim);
x= 1:numel(zInputData);

%% plotting
if any(strcmp('plotOutliers',fieldnames(lbl)))
    plotOutliers = lbl.plotOutliers;
else
    plotOutliers = true;
end

if plotOutliers
    
    % plot main points
    if ~any(strcmp('figHndle',fieldnames(lbl)))
        figure; hold on;
    end
    hold on;
    
    % plot multiple groups
    if any(strcmp('group',fieldnames(lbl)))
        colorOptions = colormap('lines');
        groups = unique(lbl.group);
        
        ix=1;
        for a = 1:numel(groups)
            iGroup = groups(a);
            
            y = zInputData(lbl.group==iGroup);
            x = ix:ix+numel(y)-1;
            groupColor = colorOptions(iGroup,:);
            plot(x,y,'-s',...
                'Color',groupColor,...
                'LineWidth',1.5,...
                'MarkerSize',5,...
                'MarkerFaceColor',groupColor)
            ix = x(end)+1;
        end
    else
        % plot one group
        plot(x,zInputData,'-s',...
            'Color',[0.4 0.2 0.8],...
            'LineWidth',1.5,...
            'MarkerSize',5,...
            'MarkerFaceColor',[0.4 0.2 0.8])
    end
    
    % plot outliers
    plot(highPoint,zInputData(highPoint),'s',...
        'Color',[0.8 0.0 0.0],...
        'LineWidth',1.5,...
        'MarkerSize',5,...
        'MarkerFaceColor',[0.8 0.0 0.0])
end
% outplut outlier points
outlier(1:(numel(highPoint)+size(preOutlier,1)),1:2)= [preOutlier;highPoint,inputData(highPoint)];

if plotOutliers
    % plot visualization lines
    h1 = hline(0); set(h1,'Color',[0.0 0.6 0.6],'LineWidth',1.5)
    h2 = hline(-lbl.outlierLim,'r'); set(h2,'Color',[0.8 0.0 0.0],'LineWidth',1.5)
    h3 = hline(lbl.outlierLim,'r'); set(h3,'Color',[0.8 0.0 0.0],'LineWidth',1.5)
    ylim([-4 4]);
end

% set Axis and titles
if any(strcmp('setText',fieldnames(lbl)))
    % title
    if any(strcmp('titleText',fieldnames(lbl.setText)));
        lbl.hTitle = title(lbl.setText.titleText);   end
    % y-Axis
    if ~any(strcmp('hYLabel',fieldnames(lbl.setText)));
        lbl.setText.hYLabel = 'zScore';
    end
    lbl.hYLabel = ylabel(lbl.setText.hYLabel);
end

%% output outlier removed data
outliersRemoved=inputData;
outliersRemoved(highPoint)=NaN;

end
