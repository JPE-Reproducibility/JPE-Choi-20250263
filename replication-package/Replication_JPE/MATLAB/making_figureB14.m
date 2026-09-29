%% Samsung
% A_agg
hold off
plot(year_vec,agg_samsung_a.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,agg_samsung_DF.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,agg_samsung_tau_k.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,agg_samsung_tau_l.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,agg_samsung.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','-.')
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
exportgraphics(h, figure+'FIGUREB14_A.pdf')
close(h)


% mu_y_agg
hold off
plot(year_vec,agg_samsung_a.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,agg_samsung_DF.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,agg_samsung_tau_k.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,agg_samsung_tau_l.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,agg_samsung.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','-.')
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
exportgraphics(h, figure+'FIGUREB14_B.pdf')
close(h)

hold off
plot(year_vec,agg_samsung_a.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,agg_samsung_DF.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,agg_samsung_tau_k.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,agg_samsung_tau_l.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,agg_samsung.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','-.')
yline(100,'k--')
xlim([year_vec(1) year_vec(end)])
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGUREB14_C.pdf')
close(h)


%% Hyundai
% A_agg
hold off
plot(year_vec,agg_hyundai_a.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,agg_hyundai_DF.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,agg_hyundai_tau_k.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,agg_hyundai_tau_l.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,agg_hyundai.A_agg./agg_result.A_agg*100,'Linewidth',1,'Linestyle','-.')
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
exportgraphics(h, figure+'FIGUREB14_D.pdf')
close(h)


% mu_y_agg
hold off
plot(year_vec,agg_hyundai_a.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,agg_hyundai_DF.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,agg_hyundai_tau_k.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,agg_hyundai_tau_l.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,agg_hyundai.mu_y_agg./agg_result.mu_y_agg*100,'Linewidth',1,'Linestyle','-.')
yline(100,'k--')
xlim([year_vec(1) year_vec(end)])
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGUREB14_E.pdf')
close(h)

hold off
plot(year_vec,agg_hyundai_a.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,agg_hyundai_DF.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,agg_hyundai_tau_k.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,agg_hyundai_tau_l.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,agg_hyundai.mu_l_agg./agg_result.mu_l_agg*100,'Linewidth',1,'Linestyle','-.')
yline(100,'k--')
xlim([year_vec(1) year_vec(end)])
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGUREB14_F.pdf')
close(h)
