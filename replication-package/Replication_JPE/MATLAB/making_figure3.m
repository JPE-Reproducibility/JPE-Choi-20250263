% Aggregate productivity 
hold off
plot(year_vec,agg_result.A_agg/agg_result.A_agg(1),'Linewidth',3)
xlim([year_vec(1) year_vec(end)])
yticks((1:0.2:2)')
h=gcf;
ax = gca;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
h=gcf;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE3_A.pdf')
close(h)

% Aggregate markup
hold off
plot(year_vec,agg_result.mu_y_agg,'Linewidth',3)
hold on
plot(year_vec,agg_result.mu_y_agg_top3,'Linewidth',3,'Linestyle','-.')
xlim([year_vec(1) year_vec(end)])
ax = gca;
legend("Aggregate Markup","Top 3 Markup",'location','northwest')
h=gcf;
pos = get(gcf,'paperposition');
set(gcf,'paperposition',[pos(1),pos(2), 4, 4]);
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE3_B.pdf')
close(h)

% Aggregate markdown
hold off
plot(year_vec,agg_result.mu_l_agg,'Linewidth',3)
hold on
plot(year_vec,agg_result.mu_l_agg_top3,'Linewidth',3,'LineStyle','-.')
xlim([year_vec(1) year_vec(end)])
ax = gca;
legend("Aggregate Markdown","Top 3 Markdown",'location','northwest')
h=gcf;
pos = get(gcf,'paperposition');
set(gcf,'paperposition',[pos(1),pos(2), 4, 4]);
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE3_C.pdf')
close(h)
