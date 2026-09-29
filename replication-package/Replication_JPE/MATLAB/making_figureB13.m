% A_agg
hold off
plot(year_vec,agg_granular_top3_a.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,agg_granular_top3_DF.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,agg_granular_top3_tau_k.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,agg_granular_top3_tau_l.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,agg_granular_top3.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','-')
yline(100,'k--')
legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All",'Interpreter','latex','location','southwest')
xlim([year_vec(1) year_vec(end)])
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGUREB13_A.pdf')
close(h)

% mu_y_agg
hold off
plot(year_vec,agg_granular_top3_a.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,agg_granular_top3_DF.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,agg_granular_top3_tau_k.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,agg_granular_top3_tau_l.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,agg_granular_top3.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','-')
yline(100,'k--')
% legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All",'Interpreter','latex','location','southwest')
xlim([year_vec(1) year_vec(end)])
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGUREB13_B.pdf')
close(h)

% mu_l_agg
hold off
plot(year_vec,agg_granular_top3_a.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,agg_granular_top3_DF.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,agg_granular_top3_tau_k.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,agg_granular_top3_tau_l.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,agg_granular_top3.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','-')
yline(100,'k--')
% legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All",'Interpreter','latex','location','southwest')
xlim([year_vec(1) year_vec(end)])
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGUREB13_C.pdf')
close(h)
