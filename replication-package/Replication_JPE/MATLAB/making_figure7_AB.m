
hold off
line(year_vec(1:end),tau_k_top3(1:end),'linewidth',3)
hold on
yline(1,'k--')
ylim([0 1.5])
xlim([year_vec(1) year_vec(end)])
ax = gca;
gap  = 0.05 * range(ax.YLim);   % Increase for more spacing
xpos = ax.XLim(1) + 0.25 * range(ax.XLim);

text(xpos, 1 + gap, '$\uparrow$ Relative tax on the top-3', ...
'HorizontalAlignment', 'left', ...
'VerticalAlignment', 'bottom', ...
'FontSize', 16,'Interpreter','latex');

text(xpos, 1 - gap, '$\downarrow$ Relative subsidy to the top-3', ...
'HorizontalAlignment', 'left', ...
'VerticalAlignment', 'top', ...
'FontSize', 16,'Interpreter','latex');

h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
exportgraphics(h, figure+'FIGURE7_A.pdf')
close(h)


hold off
line(year_vec,s_k_vec,'linewidth',3,'color',C(1,:),'Linestyle','-.')
hold on
line(year_vec,s_k_vec_only_tau_k,'linewidth',3,'color',C(2,:))
xlim([year_vec(1) year_vec(end)])
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
legend("Factual","Counterfactual",'location','northwest')
exportgraphics(h, figure+'FIGURE7_B.pdf')
close(h)
