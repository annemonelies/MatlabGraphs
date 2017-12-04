function avn_plotCorrelate(data,labelNames,titleName)
% function myCorrplot(data,labelNames,titleName)
% input 
% data = matrix, has columns with different vectors of interest
% labelName = the name of each different column.
% -----------------------------------------------------------------
% Annelies van Nuland : 17-10-2016

 figure; hold on
 % collect data size, and correct for improper data organisation.
 nrVar = min(size(data));
 if size(data,1)==nrVar
     data = data';
 end

 % build plot
 iWide = 1;
 iHigh = 1;
 for iStep = 1:nrVar*nrVar
     subplot(nrVar,nrVar,iStep)
     if iWide==iHigh
         hist(data(:,iWide))
     else
         % datapoints
        hp = plot(data(:,iWide),data(:,iHigh),'o');
        set(hp,'MarkerSize',2)
        sizeY = get(gca,'ylim');
        sizeX = get(gca,'xlim');
        axis([sizeX,sizeY]);
        % line 
        hl = lsline;
        set(hl,'color','m')
        % nr
        [R,P] = corrcoef(data(:,iWide),data(:,iHigh));

        ht = text((sizeX(1)+(sizeX(2)-sizeX(1))*0.15),(sizeY(2)-(sizeY(2)-sizeY(1))*0.15),...
            sprintf('R:%.2f,p:%.2f',R(2),P(2)),'Color','red','FontSize',10);
        set(ht, 'Clipping', 'on');
     end
     % set labels on the left side
     if iWide ==1
         ylabel(labelNames{iHigh});
     end
     % set labels on the bottom
     if iHigh == 4;
         xlabel(labelNames{iWide});
     end
     % update new datalocation
     iWide = iWide +1;
     if iWide>4
         iWide = 1;
         iHigh = iHigh+1;
     end
 end
 % finally add top-label
mtit(titleName,'fontsize',14); % function is added below!
end



function	par=mtit(varargin)
% created:
%	us	24-Feb-2003		/ R13
% modified:
%	us	24-Feb-2003		/ CSSM
%	us	06-Apr-2003		/ TMW
%	us	13-Nov-2009 17:38:17

		defunit='normalized';
	if	nargout
		par=[];
	end

% check input
	if	nargin < 1
		help(mfilename);
		return;
	end
	if	isempty(get(0,'currentfigure'))
		disp('MTIT> no figure');
		return;
	end

		vl=true(size(varargin));
	if	ischar(varargin{1})
		vl(1)=false;
		figh=gcf;
		txt=varargin{1};
	elseif	any(ishandle(varargin{1}(:)))		&&...
		ischar(varargin{2})
		vl(1:2)=false;
		figh=varargin{1};
		txt=varargin{2};
	else
		error('MTIT> invalid input');
	end
		vin=varargin(vl);
		[off,vout]=get_off(vin{:});

% find surrounding box
		ah=findall(figh,'type','axes');
	if	isempty(ah)
		disp('MTIT> no axis');
		return;
	end
		oah=ah(1);

		ou=get(ah,'units');
		set(ah,'units',defunit);
		ap=get(ah,'position');
	if	iscell(ap)
		ap=cell2mat(get(ah,'position'));
	end
		ap=[	min(ap(:,1)),max(ap(:,1)+ap(:,3)),...
			min(ap(:,2)),max(ap(:,2)+ap(:,4))];
		ap=[	ap(1),ap(3),...
			ap(2)-ap(1),ap(4)-ap(3)];

% create axis...
		xh=axes('position',ap);
% ...and title
		th=title(txt,vout{:});
		tp=get(th,'position');
		set(th,'position',tp+off);
		set(xh,'visible','off','hittest','on');
		set(th,'visible','on');

% reset original units
		ix=find(~strcmpi(ou,defunit));
	if	~isempty(ix)
	for	i=ix(:).'
		set(ah(i),'units',ou{i});
	end
	end

% ...and axis' order
		uistack(xh,'bottom');
		axes(oah);				%ok

	if	nargout
		par.pos=ap;
		par.oh=oah;
		par.ah=xh;
		par.th=th;
	end
end
%-------------------------------------------------------------------------------
function	[off,vout]=get_off(varargin)

% search for pairs <.off>/<value>

		off=zeros(1,3);
		io=0;
	for	mode={'xoff','yoff','zoff'};
		ix=strcmpi(varargin,mode);
	if	any(ix)
		io=io+1;
		yx=find(ix);
		ix(yx+1)=1;
		off(1,io)=varargin{yx(end)+1};
		varargin=varargin(xor(ix,1));
	end
	end
		vout=varargin;
end