% CR3
hold off
plot(year_vec,CR3_samsung(:,1)*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,CR3_samsung(:,2)*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,CR3_samsung(:,3)*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,CR3_samsung(:,4)*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,CR3_samsung(:,5)*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,CR3_result*100,'Linewidth',1)
legend("$a$","$D^x$","$\tau^K$","$\tau^L$","All","Data",'Interpreter','latex','location','northwest')
xlim([year_vec(1) year_vec(end)])
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE5_A.pdf')
close(h)

% Counterfactual GDP
hold off
plot(year_vec,GDP_samsung(:,1)./GDP_result*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,GDP_samsung(:,2)./GDP_result*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,GDP_samsung(:,3)./GDP_result*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,GDP_samsung(:,4)./GDP_result*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,GDP_samsung(:,5)./GDP_result*100,'Linewidth',1,'Linestyle','-')
yline(100,'k--')
xlim([year_vec(1) year_vec(end)])
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE5_B.pdf')
close(h)

% CR3
hold off
plot(year_vec,CR3_hyundai(:,1)*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,CR3_hyundai(:,2)*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,CR3_hyundai(:,3)*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,CR3_hyundai(:,4)*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,CR3_hyundai(:,5)*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,CR3_result*100,'Linewidth',1)
xlim([year_vec(1) year_vec(end)])

h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE5_C.pdf')
close(h)

% Counterfactual GDP
hold off
plot(year_vec,GDP_hyundai(:,1)./GDP_result*100,'Linewidth',1,'Linestyle','-.')
hold on
plot(year_vec,GDP_hyundai(:,2)./GDP_result*100,'Linewidth',1,'Linestyle','-')
plot(year_vec,GDP_hyundai(:,3)./GDP_result*100,'Linewidth',1,'Linestyle',':','color','black')
plot(year_vec,GDP_hyundai(:,4)./GDP_result*100,'Linewidth',1,'Linestyle','--')
plot(year_vec,GDP_hyundai(:,5)./GDP_result*100,'Linewidth',1,'Linestyle','-')
yline(100,'k--')
xlim([year_vec(1) year_vec(end)])

h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
ax=gca;
ax.FontSize=15;
set(gcf, 'Color', 'w');
exportgraphics(h, figure+'FIGURE5_D.pdf')
close(h)
