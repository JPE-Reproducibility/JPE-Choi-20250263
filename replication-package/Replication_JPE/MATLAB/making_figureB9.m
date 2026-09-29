% Figure B9
hold off
plot(year_vec,CR3_result,'Linewidth',1)
hold on
plot(year_vec,CR3_mkt_str{2},'Linewidth',1)
plot(year_vec,CR3_mkt_str{3},'Linewidth',1)
plot(year_vec,CR3_mkt_str{4},'Linewidth',1)
legend("Baseline","Oligopoly","Oligopsony","Monopolistic Competition",'Interpreter','latex','location','northwest')
xlim([year_vec(1) year_vec(end)])

h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGUREB9.pdf')
close(h)
