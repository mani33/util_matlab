function varargout = plot_bar_a_vs_b(adata,bdata,condStr,varargin)
args.axis_off = false;
args.face_alpha = 1;
args.bar_width = 0.8;
args.show_stat = false;
args.title = '';
args.boxplot = 0;
args.FontSize = 9;
args.paired = false;
args.show_legend = false;
args.xlim = [0 3];
args.ylim = [];
args.ylabel = '';
args.ylabel_col = 'k';
args.xlabel_col = 'k';
args.face_col1 = [0.8 0.8 0.8];
args.face_col2 = [1 0 0];
args.edge_col1 = [0,0,0];
args.edge_col2 = [0,0,0];
args.errorbar_col = 'k';
args.line_width = 1;
args.xcolor = 'k'; % x-spine
args.ycolor = 'k';
args.marker = 'O';
args.marker_size = 6;
args.marker_face_col = 'none';
args.marker_edge_col = 'k';
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
    x = bar(1,m(1),args.bar_width,'FaceAlpha',args.face_alpha,'linewidth',args.line_width);
    set(x,'facecolor',args.face_col1,'edgeColor',args.edge_col1)
    hold on
    
    y = bar(2,m(2),args.bar_width,'FaceAlpha',args.face_alpha,'LineWidth',args.line_width);    
    
    xlim(args.xlim)
    if ~isempty(args.ylim)
        ylim(args.ylim)
    end

    if args.paired
        X = repmat([1 2],length(adata),1);
        Y = [adata bdata];
        plot(X',Y','kO-','markerfacecolor','k')
    else
        plot(ones(1,lena)+za, sort(adata),args.marker,'color',args.marker_edge_col,'markerfacecolor',args.marker_face_col,'MarkerSize',args.marker_size)
        plot(2*ones(1,lenb)+zb, sort(bdata),args.marker,'color',args.marker_edge_col,'markerfacecolor',args.marker_face_col,'MarkerSize',args.marker_size)
    end
    % Draw error bar at end so it is overlaid on data points
    set(y,'facecolor',args.face_col2,'edgeColor',args.edge_col2)
    errorbar([1,2],m,se,'linestyle','none','color',args.errorbar_col,'linewidth',args.line_width)
end
hold on
if args.paired
    X = repmat([1 2],length(adata),1);
    Y = [adata bdata];
    plot(X',Y','kO-','markerfacecolor','k')
end
set(gca,'linewidth',args.line_width,'fontsize',args.FontSize)
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
set(gca,'XColor',args.xcolor,'YColor',args.ycolor)
ylabel(args.ylabel,'Color',args.ylabel_col)
set(gca,'xtick',[1 2],'xticklabel',condStr)
title(args.title,'FontWeight','normal','FontSize',args.FontSize)
if args.axis_off
    axis off
else
    axis on
end
if nargout
    varargout{1} = gca;
end