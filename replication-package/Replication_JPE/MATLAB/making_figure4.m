% Counterfactual CR3
hold off
plot(year_vec,CR3_granular_top3(:,1)*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,CR3_granular_top3(:,2)*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,CR3_granular_top3(:,3)*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,CR3_granular_top3(:,4)*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,CR3_granular_top3(:,5)*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,agg_result.CR3_vec*100,'Linewidth',1)
legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All","Data",'Interpreter','latex','location','northwest')
xlim([year_vec(1) year_vec(end)])
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE4_A.pdf')
close(h)

% Counterfactual GDP
hold off
plot(year_vec,GDP_granular_top3(:,1)./GDP_result*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,GDP_granular_top3(:,2)./GDP_result*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,GDP_granular_top3(:,3)./GDP_result*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,GDP_granular_top3(:,4)./GDP_result*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,GDP_granular_top3(:,5)./GDP_result*100,'Linewidth',1,'Linestyle','-')
yline(100,'k--')
xlim([year_vec(1) year_vec(end)])
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE4_B.pdf')
close(h)
