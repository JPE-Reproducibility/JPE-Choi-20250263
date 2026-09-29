% Productivity shocks
hold off
plot(year_vec,agg_result.A_avg_manu/agg_result.A_avg_manu(1) ,'Linewidth',3)
hold on
plot(year_vec,agg_result.A_top3_avg_from_sector ,'Linewidth',3,'Linestyle','-.')
legend("Average","Top 3 / Others",'location','northwest')
xlim([year_vec(1) year_vec(end)])
ax = gca;
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE2_A.pdf')
close(h)

% Export shocks
hold off
plot(year_vec,agg_result.DF_avg_manu/agg_result.DF_avg_manu(1) ,'Linewidth',3)
hold on
plot(year_vec,agg_result.DF_top3_avg_from_sector ,'Linewidth',3,'Linestyle','-.')
legend("Average","Top 3 / Others",'location','northwest')
xlim([year_vec(1) year_vec(end)])
ax = gca;
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE2_B.pdf')
close(h)

% tau_l 
hold off
plot (year_vec,agg_result.tau_l_std_from_sector,'Linewidth',3)
hold on
yyaxis right
plot(year_vec,agg_result.tau_l_top3_avg_from_sector,'Linewidth',3,'Linestyle','-.')
yticks((0.6:0.2:1.6)')
legend("Standard Deviation (left)","Top 3 / Others (right)",'location','north')
xlim([year_vec(1) year_vec(end)])
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE2_C.pdf')
close(h)

% tau_k
hold off
plot (year_vec,agg_result.tau_k_std_from_sector,'Linewidth',3)
yticks((0.6:0.05:0.85)')
ylim([0.6 0.85])
hold on
yyaxis right
plot(year_vec,agg_result.tau_k_top3_avg_from_sector,'Linewidth',3,'Linestyle','-.')
xlim([year_vec(1) year_vec(end)])
ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = 'k';
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax.FontSize=15;
legend("Standard Deviation (left)","Top 3 / Others (right)",'location','northwest')
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE2_D.pdf')
close(h)

