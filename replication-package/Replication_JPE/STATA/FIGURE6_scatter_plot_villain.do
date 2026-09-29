grstyle set size vbig: axis_title

import delimited "OUTPUT/sale_gdp_top3.csv",clear
tempfile sale_gdp
save `sale_gdp'

import delimited "OUTPUT/villain_all.csv", clear
replace delta_gdp = -delta_gdp
replace delta_cr3 = -delta_cr3
replace delta_real_income = -delta_real_income
replace delta_agg_productivity = -delta_agg_productivity
merge 1:1 firmid using `sale_gdp',keep(3) nogen

* Get sale / GDP for each quadrant
gen quad=.
replace quad=1 if delta_gdp>0 & delta_cr3>0
replace quad=2 if delta_gdp>0 & delta_cr3<0
replace quad=3 if delta_gdp<0 & delta_cr3<0
replace quad=4 if delta_gdp<0 & delta_cr3>0
bys quad: egen sale_gdp_sum = sum(sale_gdp)
tabstat sale_gdp_sum,by(quad)

merge 1:1 firmid using "DATA/firmid_cname", keep(3) nogen

gen label_cname=""
replace label_cname = "LG Chem." if	cname=="주식회사럭키"
replace label_cname = "POSCO" if cname=="포항종합제철"
replace label_cname = "GS Caltex" if cname=="호남정유"
replace label_cname = "LG Elec." if cname=="주식회사금성사"
replace label_cname = "Samsung Elec." if cname=="삼성전자공업주식회사"
replace label_cname = "Hyundai Motor" if cname=="현대자동차주식회사"
replace label_cname = "Hyundai Heavy Mfg." if cname=="현대중공업"
replace label_cname = "Hyundai Oil" if cname=="현대오일뱅크(주)"

set seed 12345
gen random_vpos = runiformint(1, 12)
replace random_vpos=12 if label_cname=="LG Chem."
replace random_vpos=5 if label_cname=="GS Caltex"
replace random_vpos=6 if label_cname=="Hyundai Heavy Mfg."
replace random_vpos=10 if label_cname=="Hyundai Oil"
replace random_vpos=12 if label_cname=="POSCO"
replace random_vpos=3 if label_cname=="Hyundai Motor"

replace label_cname="Hyundai Heavy Mfg.   " if label_cname=="Hyundai Heavy Mfg."

twoway (scatter delta_gdp delta_cr3, mlabel(label_cname) mlabvpos(random_vpos) mlabsize(medsmall) mlabcolor(navy) mcolor(navy)),xline(0,lcolor(gray) lpattern(dash)) yline(0,lcolor(gray) lpattern(dash)) xtitle("Contribution to Concentration") ytitle("Contribution to GDP") xsc(r(-0.02 0.04)) ysc(r(-0.01 0.08)) xlabel(-0.02(0.01)0.04)
graph export "FIGURE/FIGURE6.pdf",as(pdf) replace

