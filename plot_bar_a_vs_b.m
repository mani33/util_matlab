function varargout = plot_bar_a_vs_b(adata,bdata,condStr,varargin)
args.col_a = 'k';
args.col_b = 'k';
args.ylabel = '';
args.show_stat = false;
args.title = '';
args.boxplot = 0;
args.FontSize = 11;
args.paired = false;
args.show_legend = false;
args.xlim = [0 3];
args.ylim = [];
args.face_col1 = [0.8 0.8 0.8];
args.face_col2 = [1 0 0];
args.jitter = 0.015;
args = parse_var_args(args,varargin{:});
adata = adata(:);
bdata = bdata(:);
lena = length(adata);
lenb = length(bdata);
m = [mean(adata,'omitnan') mean(bdata,'omitnan')];
se = [std(adata,'omitnan') std(bdata,'omitnan')]./[sqrt(lena) sqrt(lenb)];

% Offsetting along horizontal dimension to avoid overlap of points
za = ones(1,lena)*args.jitter;
za(1:2:end) = -1*args.jitter;
zb = ones(1,lenb)*args.jitter;
zb(1:2:end) = -1*args.jitter;

if args.boxplot
    boxplot([adata bdata],'labels',condStr,'notch','off')
else
    x = bar(1,m(1),args.col_a);
    set(x,'facecolor',args.face_col1,'linewidth',1)
    hold on
    
    y = bar(2,m(2),args.col_b);
    set(y,'facecolor',args.face_col2,'linewidth',1);
    errorbar([1,2],m,se,'linestyle','none','color','k')
    
    xlim(args.xlim)
    if ~isempty(args.ylim)
        ylim(args.ylim)
    end

    if args.paired
        X = repmat([1 2],length(adata),1);
        Y = [adata bdata];
        plot(X',Y','kO-','markerfacecolor','k')
    else
        plot(ones(1,lena)+za, sort(adata),'O','color','k','markerfacecolor','none')
        plot(2*ones(1,lenb)+zb, sort(bdata),'O','color','k','markerfacecolor','none')
    end
end
hold on
if args.paired
    X = repmat([1 2],length(adata),1);
    Y = [adata bdata];
    plot(X',Y','kO-','markerfacecolor','k')
end
set(gca,'linewidth',1,'fontsize',13)
box off
if args.show_legend
    leg = legend([x,y],condStr);
    set(leg,'box','off')
end
if args.show_stat
    if args.paired
        [~,p] = ttest(adata,bdata);
    else
        [~,p] = ttest2(adata,bdata);
    end
    yl = max([adata(:)' bdata(:)']);
    text(0.25,0.95*yl,sprintf('n = %0.0f,%0.0f;  p = %0.2f',lena,lenb,p))
end
ylabel(args.ylabel)
set(gca,'xtick',[1 2],'xticklabel',condStr,'FontSize',args.FontSize)
title(args.title,'FontWeight','normal','FontSize',args.FontSize)

if nargout
    varargout{1} = gca;
end