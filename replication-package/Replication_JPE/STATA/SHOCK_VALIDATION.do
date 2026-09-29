********************************************************************************
** Constructing sectoral export demand shock 
********************************************************************************
* Long-run import and export shocks  
import delimited using "RAW/Shock_validation/Trade/HS_to_ISIC3.csv", clear 
rename (hscombinedproductcode isicrevision3productcode) (hs6 isic3)
keep hs6 isic3
save "DATA/TEMP/HS_to_ISIC3", replace 

** Lagged gross output 
use "DATA/EUKLEMS", clear 
keep sec GO year
forv i = 0/5 {
	bysort sec (year): gen L`i'GO = GO[_n-`i']
}
keep if inrange(year, 1970, 2011) 
keep if inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244", "_24t25") | inlist(sec, "_26", "_27t28", "_29-34t35", "_30t33", "_36t37")
save DATA/TEMP/L1GO, replace 

** Pre-2000 Feenstra trade data 
use RAW/Shock_validation/Trade/wtf_WIOD_code, clear 
gen sec = "_" + substr(WIOD_code1, 1, 2)
replace sec = "_244" if WIOD_code1 == "24a"
qui: do STATA/subcode/SUB_SECTOR_AGG.do 
keep if inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244", "_24t25") | inlist(sec, "_26", "_27t28", "_29-34t35", "_30t33", "_36t37")
gcollapse (sum) value, by(icode ecode importer exporter sec year)
save DATA/TEMP/wtf_trade_pre2000, replace 

use DATA/TEMP/wtf_trade_pre2000, clear 
keep if inlist(icode, "454100", "458960", "100000")
keep if inlist(ecode, "454100", "458960", "100000")
foreach code in 458960 454100 {
	if "`code'" == "454100"{
		local country KOR
	}
	if "`code'" == "458960"{
		local country TWN
	}
	preserve 
		keep if icode == "`code'" & ecode == "100000"
		rename value import`country'
		keep year import`country' sec
		save DATA/TEMP/import`country', replace 
	restore

	preserve 
		keep if ecode == "`code'" & icode == "100000"
		rename value export`country'
		keep year export`country' sec
		save DATA/TEMP/export`country', replace 
	restore
}
 
use DATA/TEMP/importKOR, clear
merge 1:1 year sec using DATA/TEMP/exportKOR, nogen
merge 1:1 year sec using DATA/TEMP/importTWN, nogen
merge 1:1 year sec using DATA/TEMP/exportTWN, nogen
foreach country in KOR TWN{
	replace import`country' = 0 if import`country' == .
	replace export`country' = 0 if export`country' == . 
}
 
collapse (sum) import* export*, by(year sec)
save DATA/TEMP/import_export_KOR, replace 

** TWN export to Korea  & TWN import from Korea 
use DATA/TEMP/wtf_trade_pre2000, clear 
keep if ecode == "458960" & icode == "454100"
rename value TWNex_to_KOR 
collapse (sum) TWNex_to_KOR, by(sec year)
keep sec year TWNex_to_KOR
save DATA/TEMP/TWNex_to_KOR, replace 

use DATA/TEMP/wtf_trade_pre2000, clear 
keep if icode == "458960" & ecode == "454100"
rename value TWNim_from_KOR 
collapse (sum) TWNim_from_KOR, by(sec year)
keep sec year TWNim_from_KOR
save DATA/TEMP/TWNim_from_KOR, replace 
 
* Short-run import and export shocks  
use DATA/TEMP/import_export_KOR, clear 
merge 1:1 year sec using DATA/TEMP/TWNex_to_KOR, keep(1 3) nogen 
merge 1:1 year sec using DATA/TEMP/TWNim_from_KOR, keep(1 3) nogen 
egen sub_id = group(sec)
xtset sub_id year 
tsfill, full
bysort sub_id (sec): replace sec = sec[_N] if missing(sec)
drop sub_id 
sort sec year 
foreach var in importKOR importTWN exportKOR exportTWN TWNim_from_KOR TWNex_to_KOR{
	replace `var' = 0 if missing(`var')
}
merge 1:1 sec year using DATA/TEMP/L1GO, keep(3) nogen 
gen exshock_TWN = 2 * (exportTWN - TWNex_to_KOR) / (L2GO + L1GO)
keep sec year *exshock* *export* *GO*
save DATA/TEMP/pre2000_exshock, replace 
 

use "RAW/Shock_validation/Trade/wto_post2000_hs6", clear 
keep if inlist(importer, "World", "KOR", "TWN") & inlist(exporter, "World", "KOR", "TWN")
qui: destring hs6, replace 
gcollapse (sum) value, by(hs6 year importer exporter)
merge n:1 year using RAW/AGG/usgdpdef, keep(3) nogen
replace value = 100 * value / gdpdef_us 
merge n:1 hs6 using DATA/TEMP/HS_to_ISIC3, keep(3) nogen
tostring isic3, replace 
replace isic3 = "0" + isic3 if length(isic3) == 3 
forv i = 1/4{
	gen isic3_`i' = substr(isic3, 1, `i')
}
gen sec = "_" + isic3_2 
replace sec = "_244" if isic3 == "2423"
qui: do STATA/subcode/SUB_SECTOR_AGG.do 
collapse (sum) value, by(sec year importer exporter)
keep if inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244", "_24t25") | inlist(sec, "_26", "_27t28", "_29-34t35", "_30t33", "_36t37")
save DATA/TEMP/raw_post_2000, replace 

foreach cty in TWN KOR {
	use DATA/TEMP/raw_post_2000, clear
	keep if exporter == "`cty'" & importer == "World"
	collapse (sum) value, by(sec year)
	rename value export`cty'
	save DATA/TEMP/`cty'_export_post2000, replace 
}

foreach cty in TWN KOR {
	use DATA/TEMP/raw_post_2000, clear
	keep if importer == "`cty'" & exporter == "World"
	collapse (sum) value, by(sec year)
	rename value import`cty'
	save DATA/TEMP/`cty'_import_post2000, replace 
}

use DATA/TEMP/raw_post_2000, clear
keep if importer == "TWN" & exporter == "KOR"
collapse (sum) value, by(sec year)
rename value TWNim_from_KOR 
save DATA/TEMP/TWNim_from_KOR_post2000, replace 

use DATA/TEMP/raw_post_2000, clear
keep if exporter == "TWN" & importer == "KOR"
collapse (sum) value, by(sec year)
rename value TWNex_to_KOR 
save DATA/TEMP/TWNex_to_KOR_post2000, replace 

* Constructing long-run import export shocks
use DATA/TEMP/KOR_import_post2000, clear 
foreach data in KOR_export_post2000 TWN_export_post2000 TWN_import_post2000 TWNex_to_KOR_post2000 TWNim_from_KOR_post2000 {
	merge 1:1 sec year using DATA/TEMP/`data', nogen 
}
merge 1:1 sec year using DATA/TEMP/L1GO, keep(3) nogen 
foreach var in TWNex_to_KOR TWNim_from_KOR {
	replace `var' = 0 if missing(`var')
}
gen exshock_TWN = 2 * (exportTWN - TWNex_to_KOR) / (L2GO + L1GO)
keep sec year *exshock* *export* *GO*
keep if year >= 2000
save DATA/TEMP/post2000_exshock, replace 

use DATA/TEMP/pre2000_exshock, clear
append using DATA/TEMP/post2000_exshock 
merge n:1 sec using DATA/secid, keep(3) nogen
sort secid year 
save DATA/TEMP/exshock, replace 

********************************************************************************
** Financial Dependence: KIS-VALUE 
********************************************************************************
qui: use RAW/Shock_validation/Foreign_debt/firm_asset, clear
qui: merge 1:1 kis year using RAW/Shock_validation/Foreign_debt/firm_debt, nogen 
qui: merge 1:1 kis year using RAW/Shock_validation/Foreign_debt/firm_fordebt, nogen 
qui: merge 1:1 kis year using RAW/Shock_validation/Foreign_debt/firm_forasset, nogen  
qui: keep if inrange(year, 1996, 1997) 
foreach var in asset debt fasset fdebt{
	qui: replace `var' = 0 if `var' == .
}
qui: gen networth = asset - debt
replace networth = 0 if networth <= 0 
qui: gen nfdebt = fdebt - fasset 
gen fdratio = fdebt / asset
gen dratio = debt / asset 
collapse (mean) *ratio*, by(kis)
qui: save "DATA/TEMP/fdratio_temp", replace 

********************************************************************************
** Kotra 
********************************************************************************
use "RAW/Shock_validation/Kotra/kotra", clear 
collapse (sum) kot kotnum kotsum, by(year kis) 
save "DATA/TEMP/kotra_temp", replace 

********************************************************************************
** First adoption year 
********************************************************************************
use "RAW/Shock_validation/Patent/firmid_patent_adoption", clear
keep if year >= 1972 
gen adopt_year = year if tech_adopt > 0
bysort kis: egen first_adopt_year = min(adopt_year)
bysort kis (first_adopt_year): replace first_adopt_year = first_adopt_year[1] if missing(first_adopt_year)
duplicates drop kis, force 
keep kis first_adopt_year 
save "DATA/TEMP/first_adopt_year", replace

********************************************************************************
** Merging data sets 
********************************************************************************
import delimited using "OUTPUT/result_base.csv", clear  
keep firmid year sale
save "DATA/TEMP/temp_sale", replace 

import delimited using "OUTPUT/result_base_notruncation_nosmoothing.csv", clear 	// No smoothing + No truncation 
drop in 1 
drop if firmid < 0 | missing(firmid)
merge n:1 firmid using "DATA/matlab_firmid_kis_mapping", keep(1 3) nogen // Kis-value id 
merge 1:1 firmid year using  "DATA/TEMP/temp_sale", keep(3) nogen
merge n:1 year using "RAW/AGG/exr", keep(1 3) nogen 
gen ln_exr = ln(exr)
merge 1:1 kis year using "DATA/TEMP/kotra_temp", keep(1 3) nogen
merge 1:1 kis year using "RAW/Shock_validation/Patent/firmid_patent_adoption", keep(1  3) nogen
qui: merge n:1 kis using "DATA/kis_region", keep(1 3) nogen // Region info 
merge n:1 kis using "DATA/TEMP/first_adopt_year", keep(1 3) nogen
merge n:1 secid year using "DATA/TEMP/exshock", keep(1 3) nogen 
merge 1:1 kis year using "RAW/Shock_validation/Credit/raw_year_loan", keep(1 3) nogen	// Credit data
foreach var in exshock_TWN exportKOR exportTWN L1GO GO {
	replace `var' = 0 if missing(`var')
	gen ln_`var' = ln(`var')
	gen ht_`var' = asinh(`var')
	bysort firmid (year): gen d`var' = `var' - `var'[_n-1]
	bysort firmid (year): gen dln_`var' = ln_`var' - ln_`var'[_n-1]
	bysort firmid (year): gen dht_`var' = ht_`var' - ht_`var'[_n-1]
}
merge n:1 kis using "DATA/TEMP/fdratio_temp", keep(1 3) nogen
replace fdratio = 0 if missing(fdratio)

bysort firmid: gen first_adopt = (year >= first_adopt_year)
 
foreach var in patent tech_adopt loan kot kotnum kotsum {
	replace `var' = 0 if missing(`var')
	gen ln_`var' = ln(`var')
	gen ht_`var' = asinh(`var')
	gen dum_`var' = (`var' > 0)
}
egen panelid = group(kis)
xtset panelid year
foreach var in tau_k tau_l a_fj df df_tilde df_real {
	gen ln_`var' = ln(`var')
	gen ht_`var' = asinh(`var')
	bysort panelid (year): gen L1ln_`var' = L1.ln_`var'
	bysort panelid (year): gen L1ht_`var' = L1.ht_`var'
}

bysort panelid (firmid): replace firmid = firmid[1] if missing(firmid)
sort panelid year 

* First differences
foreach var in ln_tau_k ln_tau_l ln_a_fj ln_df_tilde ln_df ht_df_tilde {
	bysort panelid (year): gen d`var' = `var' - L1.`var'
}
gen dum_tech = dum_tech_adopt 
replace dum_tech = 1 if patent > 0 
foreach var in first_adopt dum_tech_adopt dum_tech ht_loan ht_kotnum {
	bysort panelid (year): gen d`var' = `var' - L1.`var'
	bysort panelid (year): replace d`var' = 0 if missing(d`var')
}

bysort panelid (year): gen cum_tech = sum(tech_adopt)
gen ht_cum_tech = asinh(cum_tech)

egen reg_sec_id = group(region_id secid)
egen sec_year_id = group(secid year)
gen hci = (inlist(secid, 4, 8, 9, 10))
egen hci_year_id = group(hci year)
qui: keep if inrange(year, 1972, 2011)

qui: bys firmid: egen min_year = min(year) 
qui: gen ini_status = (min_year == 1972)
xtset firmid year 
sort firmid year 
save "DATA/TEMP/shock_valid_reg", replace 

 
********************************************************************************
** Table B6: Correlation between firm size and industry policy-related observables
********************************************************************************
import delimited using "RAW/political_events/political_events.csv", varnames(1) clear
destring g_code3 year_start year_end, replace force
keep if inlist(episode,"chun_bribe","ilhae","saesedae_heart","saesedae_edu","roh_bribe")
drop if missing(g_code3) | missing(year_start)
replace year_end = year_start if missing(year_end) | year_end < year_start
gen byte _roh = (episode=="roh_bribe")
gen long _rid = _n
gen nyears = year_end - year_start + 1
expand nyears
bysort _rid: gen byear = year_start + _n - 1
keep g_code3 byear _roh
duplicates drop
tempfile bspan
save `bspan'

import excel using "RAW/FIRM/business_group.xls", sheet("group_code") firstrow clear
keep year g_code3 kis
destring year g_code3, replace force
drop if missing(year) | missing(g_code3) | missing(kis)
capture confirm string variable kis
if _rc  tostring kis, replace format(%06.0f) force
replace kis = trim(kis)
gen byte inC = inrange(year,1980,1987)
gen byte inR = inrange(year,1988,1993)
collapse (max) inC inR, by(kis g_code3)
joinby g_code3 using `bspan', unmatched(none)
keep if (_roh==0 & inC==1) | (_roh==1 & inR==1)
rename byear year
gen byte conn = 1
collapse (max) conn, by(kis year)
tempfile conndta
save `conndta'

use "DATA/TEMP/shock_valid_reg", clear
gen ln_sale = ln(sale)
keep if inrange(year, 1972, 1982)

local d1 dum_tech 
local d2 ht_loan
local d3 ht_kotnum

local X ln_sale 

local fe1 noa 
local fe2 a(sec_year_id) 
 
local specs 
local pos = 1 
forv d = 1/3 {
	forv f = 1/2 {
		qui: reghdfe `d`d'' `X', `fe`f'' cluster(firmid)
		qui: eststo s`pos'
		qui: capture: estadd scalar adjR2 = e(r2_a)  		 
		qui: capture: estadd scalar numC1 = e(N_clust1)  
 		
		local specs `specs' s`pos'
		local pos = `pos' + 1
	}
}

** Bribery 
qui: use "DATA/TEMP/shock_valid_reg", clear
qui: merge m:1 kis year using `conndta', keep(1 3) nogen
qui: replace conn = 0 if missing(conn)
qui: replace conn = 0 if !inrange(year, 1980, 1993)
qui: gen ln_sale = ln(sale)
qui: keep if inrange(year, 1980, 1993)
forv f = 1/2 {
	qui: reghdfe conn `X', `fe`f'' cluster(firmid)
	qui: eststo s`pos'
	qui: capture: estadd scalar adjR2 = e(r2_a)
	qui: capture: estadd scalar numC1 = e(N_clust1)

	local specs `specs' s`pos'
	local pos = `pos' + 1
}

estout `specs' using "TABLE/TABLEB6.tex", ///
	cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) ///
	starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	stats(adjR2 numC1 N, fmt(%9.2f %9.0fc %9.0fc) ///
	labels("Adj. R^{2}" "\# Clusters1" "N")) label msign($-$) lz ///
	varwidth(7) modelwidth(11) style(tex) keep(`X') order(`X') ///
	varlabel(ln_sale Logsale) replace

********************************************************************************
** Table B7: Summary statistics (Top 3 vs Non-top 3)
********************************************************************************
qui: putexcel set "TABLE/TABLEB7.xlsx", sheet("top3 vs non-top3") modify
qui: putexcel A1 = "Variables"
qui: putexcel A2 = "Dum Tech."
qui: putexcel A3 = "Ihs Credit"
qui: putexcel A4 = "Ihs Trade Fair"
qui: putexcel A5 = "Bribing dummy (1980-93)"

qui: putexcel B1 = "Top3-Mean"
qui: putexcel C1 = "Top3-Median"
qui: putexcel D1 = "Top3-SD"
qui: putexcel E1 = "Top3-N"

qui: putexcel F1 = "Non-top3-Mean"
qui: putexcel G1 = "Non-top3-Median"
qui: putexcel H1 = "Non-top3-SD"
qui: putexcel I1 = "Non-top3-N"

qui: putexcel J1 = "Diff-tstat"
qui: putexcel K1 = "Diff-tstat, p-val" 


qui: use "DATA/TEMP/shock_valid_reg", clear
qui: bysort firmid: egen ever_top3 = max(top3) 
qui: keep if inrange(year, 1972, 1982)

local rrr1 = 2 
foreach v in dum_tech ht_loan ht_kotnum {
	qui: sum `v' if ever_top3 == 1, detail  
	qui: scalar mean = round(`r(mean)', 0.01) 
	qui: scalar sd = round(`r(sd)', 0.01) 
	qui: scalar p50 = round(`r(p50)', 0.01)  
	qui: scalar N = `r(N)'
	
	qui: putexcel B`rrr1' = `=mean' 
	qui: putexcel C`rrr1' = `=p50'
	qui: putexcel D`rrr1' = `=sd'
	qui: putexcel E`rrr1' = `=N'
	
	qui: sum `v' if ever_top3 == 0, detail
	qui: scalar mean = round(`r(mean)', 0.01) 
	qui: scalar sd = round(`r(sd)', 0.01) 
	qui: scalar p50 = round(`r(p50)', 0.01) 
	qui: scalar N = `r(N)'
	
	qui: putexcel F`rrr1' = `=mean' 
	qui: putexcel G`rrr1' = `=p50'
	qui: putexcel H`rrr1' = `=sd'
	qui: putexcel I`rrr1' = `=N'
	
	qui: reghdfe `v' ever_top3, noa cluster(firmid)
	qui: scalar tstat = round(_b[ever_top3]/_se[ever_top3], 0.01)
	qui: test ever_top3 = 0
	qui: scalar tp = round(r(p), 0.01)
	qui: putexcel J`rrr1' = `=tstat'
	qui: putexcel K`rrr1' = `=tp'

	qui: local rrr1 = `rrr1' + 1
}

** Bribery 
qui: use "DATA/TEMP/shock_valid_reg", clear
qui: merge m:1 kis year using `conndta', keep(1 3) nogen
qui: replace conn = 0 if missing(conn)
qui: replace conn = 0 if !inrange(year, 1980, 1993)
qui: replace top3 = 0  if missing(top3)
qui: bysort firmid: egen ever_top3 = max(top3)
qui: keep if inrange(year, 1980, 1993)

qui: sum conn if ever_top3 == 1, detail
qui: scalar mean = round(`r(mean)', 0.01)
qui: scalar sd = round(`r(sd)', 0.01)
qui: scalar p50 = round(`r(p50)', 0.01)
qui: scalar N = `r(N)'
qui: putexcel B`rrr1' = `=mean'
qui: putexcel C`rrr1' = `=p50'
qui: putexcel D`rrr1' = `=sd'
qui: putexcel E`rrr1' = `=N'

qui: sum conn if ever_top3 == 0, detail
qui: scalar mean = round(`r(mean)', 0.01)
qui: scalar sd = round(`r(sd)', 0.01)
qui: scalar p50 = round(`r(p50)', 0.01)
qui: scalar N = `r(N)'
qui: putexcel F`rrr1' = `=mean'
qui: putexcel G`rrr1' = `=p50'
qui: putexcel H`rrr1' = `=sd'
qui: putexcel I`rrr1' = `=N'

qui: reghdfe conn ever_top3, noa cluster(firmid)
qui: scalar tstat = round(_b[ever_top3]/_se[ever_top3], 0.01)
qui: test ever_top3 = 0
qui: scalar tp = round(r(p), 0.01)
qui: putexcel J`rrr1' = `=tstat'
qui: putexcel K`rrr1' = `=tp'


********************************************************************************
** FIGURE B12: Correlation between firm size and wedges over time 
******************************************************************************** 
qui: use "DATA/TEMP/shock_valid_reg", clear
qui: gen ln_sale = ln(sale)
foreach v in tau_k tau_l {
	qui: gen corr_`v' = 0 
	forv y = 1972/2011 { 
		qui: reghdfe ln_`v' ln_sale if year ==`y', noa cluster(firmid) 
		qui: replace corr_`v' = _b[ln_sale] if year == `y'
	}
}
qui: duplicates drop year, force 
qui: tsset year 
qui: sort year 
qui: keep corr* year
qui: twoway (line corr_tau_k year, ///
	xtitle("Year")  ///
		legend(label(1 "Capital Distortion") label(2 "Labor Distortion") rows(1))) ///
	(line corr_tau_l year)
 
qui: graph export "FIGURE/FIGUREB12.pdf", as(pdf) replace 
 
********************************************************************************
** Export demand shock 
********************************************************************************
local specs 
foreach dep in dln_a_fj dln_tau_k dln_tau_l dln_df_tilde {  
	use "DATA/TEMP/shock_valid_reg", clear 
	local cl firmid 
	local FE firmid year 
	
	local X dexshock_TWN
	
	drop if missing(`dep')

	if "`dep'" == "dln_df_tilde" {
		local pre_var L1dln_a_fj L1dln_tau_k L1dln_tau_l L1dln_df_tilde 
	}
	else {
		local pre_var L1dln_a_fj L1dln_tau_k L1dln_tau_l L1dht_df_tilde 
	}
	
	reghdfe `dep' `X' , a(year) cl(secid)
	 qui: eststo s`dep'
	 qui: boottest dexshock_TWN, nograph seed(1)
	 local bp = string(r(p), "%4.2f")
	 qui: estadd local bootp "$[`bp']$" : s`dep'
		
	local specs `specs' s`dep'
}

estout `specs' using "TABLE/TABLEB9.tex", ///
cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
stats(bootp N, fmt(%9.2f %9.0fc) labels(" " "N")) label msign($-$) lz ///
varwidth(7) modelwidth(11) style(tex) keep(`X') order(`X') ///
varlabel(dexshock_TWN ExportDemandShock) replace	 
 
********************************************************************************
** Table B8: Asian Financial Crisis  
********************************************************************************
local cl firmid  
local FE secid 
local X dratio 
local specs  
foreach time in crisis pcrisis {
	if "`time'" == "crisis" {
		local cond inlist(year, 1997, 2001)
	}
	else if "`time'" == "pcrisis" {
		local cond inlist(year, 1990, 1994)
	}
	use DATA/TEMP/shock_valid_reg, clear 
	keep if `cond'
	foreach var in tau_k tau_l a_fj df_tilde {	
		bysort firmid (year): gen long_dln_`var' = ln_`var' - ln_`var'[_n-1]
		bysort firmid (year): gen ini_ln_`var' = ln_`var'[1]
	}
 
	foreach dep in ln_tau_k ln_tau_l ln_a_fj ln_df_tilde { 
		reghdfe long_d`dep' `X', a(`FE') cluster(`cl')
		eststo `time'_`dep'
		qui: capture: estadd scalar adjR2 = e(r2_a)  		 
		qui: capture: estadd scalar numC1 = e(N_clust1)  
		qui: capture: estadd scalar numC2 = e(N_clust2)  	
		local specs `specs' `time'_`dep'
	}
}	
estout `specs' using "TABLE/TABLEB8.tex", ///
cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
stats(adjR2 numC1 numC2 N, fmt(%9.2f %9.0f %9.0f %9.0f) ///
labels("Adj. R^{2}" "\# Clusters1" "\# Clusters2" "N")) label msign($-$) lz ///
varwidth(7) modelwidth(11) style(tex) keep(`X') order(`X') replace	 
 

********************************************************************************
** Figure B2 Panels C and D: Fringe-adjusted employment and capital concentration 
******************************************************************************** 
import delimited using "OUTPUT/result_base.csv", clear   
merge n:1 firmid using "DATA/matlab_firmid_kis_mapping", keep(1 3) nogen // Kis-value id 
drop in 1 
keep if secid > 0 
preserve
	keep if firmid < = 0
	tempfile fringe 
	replace kis = "fringe" + string(secid)
	save `fringe', replace 
restore 
keep if firmid > 0 
gsort secid year -s_total
bys secid year: gen rank = _n 
keep if rank == 1 
append using `fringe'
gen wl = w * l 
keep l k wl s_total year secid kis 
merge n:1 secid using DATA/secid, keep(3) nogen 
keep if inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244") | inlist(sec, "_24t25", "_26", "_27t28") | inlist(sec, "_29-34t35", "_30t33", "_36t37")
gen manu = 1 
save "DATA/TEMP/fringe", replace 
 
 
foreach var in l k  {
	import delimited using "OUTPUT/result_base.csv", clear   
	merge n:1 firmid using "DATA/matlab_firmid_kis_mapping", keep(1 3) nogen // Kis-value id 
	drop in 1 
	keep if secid > 0
	merge n:1 secid using DATA/secid, keep(3) nogen 
	keep if inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244") | inlist(sec, "_24t25", "_26", "_27t28") | inlist(sec, "_29-34t35", "_30t33", "_36t37")
	gen manu = 1 
	gen wl = w *  l  
	preserve
		keep if firmid < = 0
		tempfile fringe 
		save `fringe', replace 
	restore 
	keep if firmid > 0
	foreach v in l k wl {
		gsort secid year -`v'
		bys secid year: gen rank = _n 
		gen cr3_`v' = (rank <= 3)
		drop rank 
	} 
	append using `fringe'
	foreach v in l k wl {
		bys year: egen sum_`v' = sum(`v')
	}
	keep if cr3_`var' == 1 
	collapse (sum) `var' (mean) sum_`var' , by(year)
	gen cr3 = 100 * (`var' / sum_`var')
 
	qui: sum cr3, detail 
	scalar min_bar = 0.95 * `r(min)'
	scalar max_bar = 1.05 * `r(max)'	
	
	if "`var'" == "l" local figname FIGUREB2_C 
	if "`var'" == "k" local figname FIGUREB2_D 
	
	twoway (bar cr3 year, bcolor(orange_red%60) xlabel(1970(5)2011) lwidth(0.25) lc(navy) ytitle("") xtitle("Year") ///
		yscale(r(`=min_bar' `=max_bar')))
	graph export "FIGURE/`figname'.pdf", as(pdf) replace 
}

 
 
********************************************************************************
** Erase files
********************************************************************************
qui: capture: erase DATA/TEMP/kotra_temp.dta 
foreach cty in TWN KOR {
	qui: capture: erase DATA/TEMP/`cty'_export_post2000.dta  
	qui: capture: erase DATA/TEMP/`cty'_import_post2000.dta  
}
qui: capture: erase DATA/TEMP/TWNex_to_KOR_post2000.dta 
qui: capture: erase DATA/TEMP/TWNim_from_KOR_post2000.dta 
qui: capture: erase DATA/TEMP/fringe.dta
qui: capture: erase DATA/TEMP/shock_valid_reg.dta
qui: capture: erase DATA/TEMP/temp_sale.dta
qui: capture: erase DATA/TEMP/fdratio_temp.dta
qui: capture: erase DATA/TEMP/first_adopt_year.dta
qui: capture: erase DATA/TEMP/nt_list.dta 
qui: capture: erase DATA/TEMP/exportKOR.dta 
qui: capture: erase DATA/TEMP/exportTWN.dta 
qui: capture: erase DATA/TEMP/importKOR.dta 
qui: capture: erase DATA/TEMP/importTWN.dta 
qui: capture: erase DATA/TEMP/L1GO.dta
qui: capture: erase DATA/TEMP/TWNim_from_KOR.dta
qui: capture: erase DATA/TEMP/TWNex_to_KOR.dta
qui: capture: erase DATA/TEMP/import_export_KOR.dta
qui: capture: erase DATA/TEMP/wtf_trade_pre2000.dta
qui: capture: erase DATA/TEMP/pre2000_exshock.dta 
qui: capture: erase DATA/TEMP/post2000_exshock.dta 
qui: capture: erase DATA/TEMP/HS_to_ISIC3.dta
qui: capture: erase DATA/TEMP/exshock.dta 
qui: capture: erase DATA/TEMP/raw_post_2000.dta
