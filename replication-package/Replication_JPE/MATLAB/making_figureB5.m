% Figure B5. Persistence of Top-3 Status
% Requires in scope: year_vec, secid_manu, num_top, top3_list, figure

C = linspecer(8);
n_sec = length(secid_manu);
T = length(year_vec);

sector_labels = ["Food","Textile","Wood","Petroleum","Pharma.","Chemicals", ...
    "Minerals","Metal","Machinery","Electronics","NEC"];
if n_sec ~= length(sector_labels)
    error('making_figureB5:SectorLabelMismatch', ...
        'Panel C expects %d manufacturing sectors, found %d.',length(sector_labels),n_sec);
end

% Panel A. Share of top-3 firms still in the top 3 after j years
cont_prob = zeros(T-1,1);
exiting_top3 = zeros(T-1,1);
for j=1:T-1
    for i=1:T-j
        exiting_top3(i) = num_top*n_sec-sum(ismember(top3_list(i+j,:),top3_list(i,:)));
    end
    cont_prob(j) = mean(1-exiting_top3/(num_top*n_sec));
end

hold off
line((1:T-1)',cont_prob,'linewidth',3,'color',C(2,:))
xlabel('Time (years)')
ax=gca;
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
ax.FontSize=15;
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
exportgraphics(h,figure+'FIGUREB5_A.pdf')
close(h)

% One-year transitions, used by Panels B and C
exiting_top3 = zeros(T-1,1);
for i=1:T-1
    exiting_top3(i) = num_top*n_sec-sum(ismember(top3_list(i+1,:),top3_list(i,:)));
end

exiting_top3_sector = zeros(T-1,n_sec);
for i=1:T-1
    for j=1:n_sec
        exiting_top3_sector(i,j) = num_top-sum(ismember( ...
            top3_list(i+1,(j-1)*num_top+1:j*num_top),top3_list(i,(j-1)*num_top+1:j*num_top)));
    end
end

% Panel B. One-year persistence by calendar year, 3-year moving average
cont_prob_year = 1-exiting_top3/(num_top*n_sec);
cont_prob_year = movmean(cont_prob_year,[3 3]);

hold off
plot(year_vec(1:end-1),cont_prob_year,'linewidth',3);
xlim([year_vec(1) year_vec(end-1)])
xlabel('Year')
ax=gca;
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
ax.FontSize=15;
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
exportgraphics(h,figure+'FIGUREB5_B.pdf')
close(h)

% Panel C. One-year persistence by sector
cont_avg_by_sector = mean(1-exiting_top3_sector/num_top,1);

hold off
bar(sector_labels,cont_avg_by_sector)
ax=gca;
h=gcf;
set(h,'Units','Inches');
pos = get(h,'Position');
ax.FontSize=15;
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
exportgraphics(h,figure+'FIGUREB5_C.pdf')
close(h)
