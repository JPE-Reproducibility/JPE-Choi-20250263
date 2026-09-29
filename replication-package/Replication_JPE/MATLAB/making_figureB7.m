% Figure B7
hold off
plot(year_vec,agg_result.mu_y_dom_agg,'Linewidth',3)
hold on
plot(year_vec,agg_result.mu_y_agg,'Linewidth',3)
xlim([year_vec(1) year_vec(end)])
legend("Domestic Markup","Aggregate Markup",'location','northwest')
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax = gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h,figure+'FIGUREB7_A.pdf')
close(h)


hold off
plot(year_vec,agg_result.mu_y_dom_agg,'Linewidth',3)
hold on
plot(year_vec,agg_result_imp_pen.mu_y_dom_agg,'Linewidth',3)
xlim([year_vec(1) year_vec(end)])
legend("Domestic Markup","Without Import / Export Penetration",'location','northwest')
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax = gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h,figure+'FIGUREB7_B.pdf')
close(h)
