function prettyPlotHelp(lbl)
% function prettyPlotHelp(lbl)
% In this function you can automatically update your matlab plot to use a
% certain font for x- and y-labels, titles etc. and use a certain FontSize.
% 
% You input the handles of your axis using the following labels:
%
% required input:
% lbl.resultFolder (folder in which you want your plot saved)
% lbl.setText.titleText -or- lbl.titleText
% (title text, it will use this to save your file)
%
% optional input:
% lbl.hYLabel   (y-label handle) --> a good scientist always labels axis!
% lbl.hXLabel   (x-label handle) 
% lbl.Xtick     (label x-tick points)
% lbl.hTitle    (title handle)
% lbl.hText     (any text added by 'text(..)')
% lbl.hLegend   (legend handle)
%
% current fonts used are Century Gothic (titles,axes), and Helvetica
%
% Annelies van Nuland - 07/07/2016

mainFont ='Century Gothic';
secondaryFont = 'Helvetica';

if any(strcmp('setText',fieldnames(lbl)))
    lbl.titleText = lbl.setText.titleText;
end

set( gca                       , ...
    'FontName'   , secondaryFont);

% title 
if any(strcmp('hTitle',fieldnames(lbl)))
set([lbl.hTitle], ...
    'FontName'   , mainFont);
set( lbl.hTitle                    , ...
    'FontSize'   , 12          , ...
    'FontWeight' , 'bold'      );
end
% y axis label
if any(strcmp('hYLabel',fieldnames(lbl)))
set([lbl.hYLabel], ...
    'FontName'   , mainFont);
set([ lbl.hYLabel]  , ...
    'FontSize'   , 10          );
end
% x axis label
if any(strcmp('hXLabel',fieldnames(lbl)))
    set(lbl.hXLabel, ...
        'FontName'   , mainFont);
    set(lbl.hXLabel  , ...
        'FontSize'   , 10          );
end
% xtick label
if any(strcmp('Xtick',fieldnames(lbl)))
    set(gca,'XTickLabel',lbl.Xtick,'FontName',mainFont,'fontsize',9)
end

% legend
if any(strcmp('hLegend',fieldnames(lbl)))
    set([lbl.hLegend, gca]             , ...
        'FontSize'   , 9           );
end

% text input 
if any(strcmp('hText',fieldnames(lbl)))
    if size(lbl.hText,2)==1
        set(lbl.hText, ...
            'FontName'   , mainFont);
        set(lbl.hText  , ...
            'FontSize'   , 9          );
    else
        for iSteptext = 1:size(lbl.hText,2)
            set(lbl.hText(iSteptext), ...
                'FontName'   , mainFont);
            set(lbl.hText(iSteptext)  , ...
                'FontSize'   , 9          );
        end
    end
end
% update plot appearance
set(gcf, 'PaperPositionMode', 'auto');
% print image
print('-dpng',fullfile(lbl.resultFolder,'images',sprintf('img_%s.png',lbl.titleText)))
end