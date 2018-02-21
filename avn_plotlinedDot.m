function avn_plotlinedDot(xValues,yValues,label)
labelName.set = 0;
y = yValues;
x = xValues;

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
    lbl.lineColor = label.lineColor;
else
    lbl.lineColor= 'r';
end

if any(strcmp('showStat',fieldnames(label)))
    lbl.showStat = label.showStat;
else
    lbl.showStat= true;
end

if any(strcmp('dotColor',fieldnames(label)))
    lbl.dotColor = label.dotColor;
else
    lbl.dotColor= 'b';
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


%% set x and y axis

maxX = max(x);
minX = min(x);
diffX = maxX - minX;

mnX = minX-0.1*diffX;
mxX = maxX+0.1*diffX;

maxY = max(y);
minY = min(y);
diffY = maxY - minY;
mnY = minY-0.1*diffY;
mxY = maxY+0.1*diffY;


if lbl.mn0
    mnX = 0;
    mnY = 0;
end

%% prepare line
[B,~,stats] =glmfit(x,y);

%% make figure
figure; hold on
plot(x,y,[lbl.dotColor,lbl.dotForm],'MarkerSize',lbl.dotSize)
plot(x,B(1)+B(2)*x,lbl.lineColor,'LineWidth',2);

sizeX = [mnX mxX];
sizeY = [mnY mxY];
xlim(sizeX);
ylim(sizeY);
ylabel(lbl.yValues,'fontsize',12,'fontname','Tahoma');
xlabel(lbl.xValues,'fontsize',12,'fontname','Tahoma');
title(lbl.titleText,'fontweight','bold','fontsize',14,'fontname','Tahoma')

if lbl.showStat
    ht = text((sizeX(1)+(sizeX(2)-sizeX(1))*0.15),(sizeY(2)-(sizeY(2)-sizeY(1))*0.15),...
        sprintf('p:%.2f',stats.p(2)),'Color','red','FontSize',10);
end