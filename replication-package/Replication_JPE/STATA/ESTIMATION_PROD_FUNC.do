set rng default

********************************************************************************
** PPI, sectoral investment deflators come from EU-KLEMS
********************************************************************************
use "DATA/EUKLEMS", clear
keep sec year PPI 
save "DATA/TEMP/temp_ppi", replace 
 
********************************************************************************
** Broda and Weinstein (2009) Elasticities 
********************************************************************************
** Broda and Weinstein estimates: 1972-1988
import excel using "RAW/BW_sigma/BW_sigma_SITC_rev2_3digit.xlsx", firstrow clear 
keep sitc2 sigma 
gen sec = ""
qui: do STATA/subcode/SUB_SITC_REV2_MAPPING.do 
qui: do STATA/subcode/SUB_SECTOR_AGG.do 
drop if missing(sitc2) | missing(sec)
drop if inlist(sec, "_AtB", "_C")
save DATA/TEMP/temp1, replace 
 
bysort sec: egen min_sigma = min(sigma)
bysort sec: egen max_sigma = max(sigma)
bysort sec: gen num = _N 
_pctile sigma, p(2 98)
 drop if (sigma <= `r(r1)' | sigma >= `r(r2)')
qui: sum sigma if inlist(sec, "_24t25", "_23"), detail 
qui: scalar chemical_mean = `r(mean)'
qui: scalar metal_mean = `r(mean)'
collapse (mean) sigma, by(sec)
replace sigma = `=chemical_mean' if inlist(sec, "_24t25", "_23")
merge n:1 sec using DATA/secid, keep(3) nogen 
sort secid 
save "DATA/TEMP/BW_sigma_1972_1988", replace 
keep secid sigma 
order secid sigma 
qui: export excel using "INPUT/BW_sigma.xlsx", sheet("1972-1988") replace   
 
** Broda and Weinstein estimates: 1990-2001 
import excel using "RAW/BW_sigma/BW_sigma_SITC_rev3_3digit.xlsx", firstrow clear 
keep sitc3 sigma 
gen sec = ""
qui: do STATA/subcode/SUB_SITC_REV3_MAPPING.do 
qui: do STATA/subcode/SUB_SECTOR_AGG.do 
drop if missing(sitc3) | missing(sec)
drop if inlist(sec, "_AtB", "_C")
save "DATA/TEMP/temp2", replace 

bysort sec: egen min_sigma = min(sigma)
bysort sec: egen max_sigma = max(sigma)
bysort sec: gen num = _N 
 _pctile sigma, p(1 99)
drop if sigma <= `r(r1)' | sigma >= `r(r2)'
qui: sum sigma if inlist(sec, "_24t25", "_23"), detail 
qui: scalar chemical_mean = `r(mean)'
collapse (mean) sigma, by(sec)
replace sigma = `=chemical_mean' if inlist(sec, "_24t25", "_23")
merge 1:1 sec using DATA/secid, keep(3) nogen 
sort secid 
save DATA/TEMP/BW_sigma_1990_2001, replace 
keep secid sigma 
order secid sigma 
qui: export excel using "INPUT/BW_sigma.xlsx", sheet("1990-2001", modify) 
 
use DATA/TEMP/temp1, clear
append using DATA/TEMP/temp2 
drop if missing(sec)
qui: sum sigma, detail  
qui: sum sigma, detail 
collapse (mean) sigma, by(sec)
merge 1:1 sec using DATA/secid, keep(3) nogen 
sort secid 
save DATA/TEMP/BW_sigma_mean, replace 
keep secid sigma 
order secid sigma 
qui: export excel using "INPUT/BW_sigma.xlsx", sheet("mean", modify)
 
********************************************************************************
** Input deflators are constructed based on the IO coefficients and PPIs
********************************************************************************
clear 
foreach year in 1970 1973 1975 1978 1980 1983 1985 1986 1987 1988 1990 1993 1995 1998 2000 2003 2005 2006 2007 2008 2009 2010 2011 {
	append using DATA/IO_`year'_3digit_all 
}
foreach od in o d{
	qui: rename `od'sec sec  
	qui: do STATA/subcode/SUB_SECTOR_AGG.do  
	qui: rename sec `od'sec 
}
collapse (sum) value, by(osec dsec year)
foreach od in o d{
	qui: rename `od'sec sec
	drop if inlist(sec, "intcons", "expen", "export", "fcons") | inlist(sec, "import", "import_cif", "import_tar") | inlist(sec, "GO", "TOT", "VADD", "WBILL")
	qui: rename sec `od'sec 
}
rename osec sec 
merge n:1 sec year using DATA/TEMP/temp_ppi, keep(3) nogen
rename sec osec  
bysort year dsec: egen sum_value = sum(value)
gen intsh = value / sum_value 
replace PPI = intsh * ln(PPI) 
collapse (sum) PPI, by(dsec year)
rename dsec sec
replace PPI = exp(PPI)
rename PPI inPPI 
egen id = group(sec)
xtset id year
tsfill, full
bysort id (sec): replace sec = sec[_N] if missing(sec)
sort id year 
* For missing years, geometric avg. 
foreach var in inPPI {
	gen tag_impu = 1 if missing(`var')
	bysort sec (year): replace `var' = (`var'[_n-1] * `var'[_n+1])^0.5 if !missing(`var'[_n-1]) & !missing(`var'[_n+1]) & missing(`var'[_n])
	bysort sec (year): replace `var' = (`var'[_n+2] / `var'[_n-1])^(1/3) * `var'[_n-1] if !missing(`var'[_n-1]) & !missing(`var'[_n+2]) & missing(`var'[_n]) & tag_impu[_n+1] == 1 
	bysort sec (year): replace `var' = (`var'[_n+1] / `var'[_n-2])^(2/3) * `var'[_n-2] if !missing(`var'[_n-2]) & !missing(`var'[_n+1]) & missing(`var'[_n]) & tag_impu[_n-1] == 1 
	drop tag_impu 
}
keep sec year inPPI 
save DATA/TEMP/temp_inPPI, replace 

********************************************************************************
** Nominal GO, VA, WBILL, export 
********************************************************************************
foreach var in GO WBILL export {
	clear 
	foreach year in 1970 1973 1975 1978 1980 1983 1985 1986 1987 1988 1990 1993 1995 1998 2000 2003 2005 2006 2007 2008 2009 2010 2011 {
		append using DATA/IO_`year'_3digit_all 
	}
	if "`var'" == "GO" | "`var'" == "VADD" | "`var'" == "WBILL" {
		keep if osec == "`var'"
		rename (dsec value) (sec `var')
	}
	else if "`var'" == "export" {
		keep if dsec == "`var'"
		rename (osec value) (sec `var')
	}
	collapse (sum) `var', by(sec year)
	egen id = group(sec)
	xtset id year
	tsfill, full
	bysort id (sec): replace sec = sec[_N] if missing(sec)
	sort id year 
	* For missing years, geometric avg. 	
	foreach v in `var' {
		gen tag_impu = 1 if missing(`v')
		bysort sec (year): replace `v' = (`v'[_n-1] * `v'[_n+1])^0.5 if !missing(`v'[_n-1]) & !missing(`v'[_n+1]) & missing(`v'[_n])
		bysort sec (year): replace `v' = (`v'[_n+2] / `v'[_n-1])^(1/3) * `v'[_n-1] if !missing(`v'[_n-1]) & !missing(`v'[_n+2]) & missing(`v'[_n]) & tag_impu[_n+1] == 1 
		bysort sec (year): replace `v' = (`v'[_n+1] / `v'[_n-2])^(2/3) * `v'[_n-2] if !missing(`v'[_n-2]) & !missing(`v'[_n+1]) & missing(`v'[_n]) & tag_impu[_n-1] == 1 
		drop tag_impu 
	}
	keep sec year `var'
	if "`var'" == "export" {
		rename export EX 
	}
	save DATA/TEMP/temp_`var', replace 
}
 
********************************************************************************
** Import shares
********************************************************************************
clear
foreach year in 1970 1973 1975 1978 1980 1983 1985 1986 1987 1988 1990 1993 1995 1998 2000 2003 2005 2006 2007 2008 2009 2010 2011 {
	append using "DATA/IO_`year'_3digit_all" 
}
collapse (sum) value, by(osec dsec year)
foreach var in expen import {
	preserve 
		keep if dsec == "`var'"
		drop if inlist(osec, "GO", "TOT", "VADD", "WBILL")
		rename value `var'
		collapse (sum) `var', by(osec year)
		rename osec sec 
		save DATA/TEMP/temp_`var', replace 
	restore
}
use DATA/TEMP/temp_expen, clear
merge 1:1 sec year using DATA/TEMP/temp_import, keep(3) nogen
gen imsh = import / expen 
egen id = group(sec)
xtset id year
tsfill, full
bysort id (sec): replace sec = sec[_N] if missing(sec)
sort id year 
foreach var in imsh {
	gen tag_impu = 1 if missing(`var')
	bysort sec (year): replace `var' = (`var'[_n-1] * `var'[_n+1])^0.5 if !missing(`var'[_n-1]) & !missing(`var'[_n+1]) & missing(`var'[_n])
	bysort sec (year): replace `var' = (`var'[_n+2] / `var'[_n-1])^(1/3) * `var'[_n-1] if !missing(`var'[_n-1]) & !missing(`var'[_n+2]) & missing(`var'[_n]) & tag_impu[_n+1] == 1 
	bysort sec (year): replace `var' = (`var'[_n+1] / `var'[_n-2])^(2/3) * `var'[_n-2] if !missing(`var'[_n-2]) & !missing(`var'[_n+1]) & missing(`var'[_n]) & tag_impu[_n-1] == 1 
	drop tag_impu 
}
keep sec year imsh  
save "DATA/TEMP/temp_imsh", replace 

********************************************************************************
** Exporting to Matlab 
********************************************************************************
qui: local min_year = 1985
qui: local max_year = 2011

qui: use DATA/firm_balance, clear
qui: keep if inrange(year, `min_year', `max_year') 
qui: merge m:1 kis using DATA/FIRM_SEC, keep(3) nogen
qui: merge n:1 sec using DATA/secid, keep(3) nogen
qui: keep if manu == 1 
qui: merge n:1 year sec using DATA/EUKLEMS, keep(3) nogen
qui: merge n:1 year sec using DATA/TEMP/temp_inPPI, keep(3) nogen
qui: merge n:1 year sec using DATA/TEMP/temp_imsh, keep(3) nogen
qui: merge n:1 year using RAW/AGG/usgdpdef, keep(3) nogen
qui: merge n:1 year using RAW/AGG/exr, keep(3) nogen
qui: drop GO 
qui: merge n:1 year sec using DATA/TEMP/temp_GO, keep(3) nogen
qui: merge n:1 year sec using DATA/TEMP/temp_export, keep(3) nogen 
qui: merge n:1 year sec using DATA/TEMP/temp_WBILL, keep(3) nogen

* Domestic sales 
qui: gen saled = sale - export 
qui: replace saled = sale if missing(export) | export == 0 
qui: drop if emp <= 0 
qui: drop if fasset <= 0 
qui: drop if sale <= 0 
qui: drop if saled <= 0 
qui: drop if mcogs <= 0
qui: drop if wbill <= 0 
 
qui: gen GOd = GO - EX 	//  Domestic gross output
qui: gen mratio = mcogs / sale 
qui: gen wmratio = wbill / mcogs 
qui: gen sL = (wbill / LAB) 
qui: gen s = (sale / GO) 
qui: gen sd = (saled / GOd) 
qui: gen sx = (export / EX)
 
qui: gen semp = emp / L 
qui: gen ln_semp = ln(semp)
qui: gen ln_sL = ln(sL)
 
foreach var in fasset mcogs {	
	qui: replace `var' = `var' * exr // Converting back to nominal KW 
	qui: replace `var' = `var' * gdpdef_us / 100 
}
 
qui: replace fasset = 100 * fasset / iPPI 
qui: replace mcogs = 100 * mcogs / inPPI 

foreach var in sale saled cogs export GO GOd WBILL wbill EX {	
	qui: replace `var' = `var' * exr // Converting back to nominal KW 
	qui: replace `var' = `var' * gdpdef_us / 100 
	qui: replace `var' = 100  * `var' / PPI 
}
 
qui: gen l = ln(emp / 1e3)  
qui: gen k = ln(fasset / 1e9)   
qui: gen r = ln(sale / 1e9)  
qui: gen rd = ln(saled / 1e9)  
qui: gen m = ln(mcogs / 1e9)  
qui: gen wb = ln(wbill / 1e9)  
qui: gen go = ln(GO / 1e9)  
qui: gen god = ln(GOd / 1e9)  
qui: gen ex = ln(EX / 1e9)  
qui: gen v = ln(cogs / 1e9)  
 
foreach var in rd l k m go god ex s sL {
	qui: drop if missing(`var')
}
 
** Trimming 
qui: gen tag_p1 = 2 
qui: gen tag_p99 = 98

qui: gen lkratio = emp / fasset 
qui: gen lsratio = sale / emp
qui: gen ksratio = sale / fasset 

qui: levelsof secid, local(sec_list)
foreach var in sd sL s {  
	foreach j of local sec_list {
		qui: sum `var' if secid == `j', detail
		qui: replace tag_p1 = 1 if `var' <= `r(p1)' & secid == `j'
		qui: replace tag_p99 = 1 if `var' >= `r(p99)' & secid == `j'
	}
}

* Should be consecutive 
qui: bysort panelid: gen num = _N 
qui: keep if num >= 2
qui: drop num
qui: gen Hsh = 1 - imsh
qui: replace year = year - `min_year' + 1

foreach var in r l k m v go god Hsh s sd sL sx wb mratio wmratio  {
	qui: replace `var' = round(`var', 1e-10)
}

** Dropping outlieres to improve stability of sector 5
qui: gen exratio = export / sale
qui: gen fratio = fasset / sale 
qui: gen lratio = emp / sale 
qui: save DATA/TEMP/full_est, replace 

* Full-sample 
qui: use DATA/TEMP/full_est, clear 
qui: keep secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: order secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: sort secid panelid year 
qui: export delimited using "INPUT/input_prod_func_full.csv", replace  
 
* Small-sized  
qui: use DATA/TEMP/full_est, clear 
qui: bysort secid year: egen med_ini_r = median(r)
qui: gen temp_r = (r > med_ini_r)
qui: bysort panelid: egen max_r = max(temp_r)
qui: keep if max_r == 0  
qui: keep secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: order secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: sort secid panelid year 
qui: export delimited using "INPUT/input_prod_func_small.csv", replace 
 
* large-sized  
qui: use DATA/TEMP/full_est, clear 
qui: bysort secid year: egen med_ini_r = median(r)
qui: gen temp_r = (r > med_ini_r)
qui: bysort panelid: egen max_r = max(temp_r)
qui: keep if max_r == 1
qui: keep secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: order secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: sort secid panelid year 
qui: export delimited using "INPUT/input_prod_func_large.csv", replace 
 
* Non-exporter sample 
qui: use DATA/TEMP/full_est, clear  
qui: drop if sx > 0 
qui: keep secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: order secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: sort secid panelid year 
qui: save DATA/TEMP/nonx_est, replace 
qui: export delimited using "INPUT/input_prod_func_nonx.csv", replace 
 
* Never-exporter sample 
qui: use DATA/TEMP/full_est, clear  
qui: gen temp_ever_x = (sx > 0)
qui: bysort panelid: egen ever_x = max(temp_ever_x)
qui: drop if ever_x == 1 
qui: keep secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: order secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: sort secid panelid year 
qui: save DATA/TEMP/nx_est, replace 
qui: export delimited using "INPUT/input_prod_func_nx.csv", replace  

* Exporter sample 
qui: use DATA/TEMP/full_est, clear  
qui: gen temp_ever_x = (sx > 0)
qui: bysort panelid: egen ever_x = max(temp_ever_x)
qui: keep if ever_x == 1 
qui: keep secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: order secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: sort secid panelid year 
qui: save DATA/TEMP/x_est, replace 
qui: export delimited using "INPUT/input_prod_func_x.csv", replace 

* Exporter sample 
qui: use DATA/TEMP/full_est, clear  
qui: keep if sx > 0
qui: keep secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: order secid panelid year rd l k m go god Hsh s sd sL sx wb mratio wmratio r
qui: sort secid panelid year 
qui: save DATA/TEMP/x_est, replace 
qui: export delimited using "INPUT/input_prod_func_ex.csv", replace 
 
******************************************************************************** 
* DLEU Markup (Figure B8-A,B,C)
******************************************************************************** 
** Step 1: Exporting to matlab 
qui: use DATA/TEMP/full_est, clear 
qui: drop if missing(v)
qui: keep secid panelid year r k v 
qui: order secid panelid year r k v 
qui: sort secid panelid year 
qui: save "DATA/TEMP/DKLmu", replace 
qui: export delimited using "INPUT/DKLmu.csv", replace  

qui: use DATA/TEMP/full_est, clear 
duplicates drop secid year, force 
bysort year: egen sum_GO = sum(GO)
gen GO_wt = GO / sum_GO 
keep secid year GO_wt 
save "DATA/TEMP/GO_wt", replace  

** Step 2: Importing the coefficients estimated by the Matlab code 
import excel using "OUTPUT/DLcoefs.xlsx", sheet("Baseline") clear 
rename (A B C) (secid vcoef kcoef)
save DATA/TEMP/DLcoefs, replace 

import excel using "OUTPUT/DLcoefs.xlsx", sheet("Rolling") clear 
rename (A B C D) (secid year vcoef_rolling kcoef_rolling)
collapse (mean) vcoef_rolling kcoef_rolling, by(secid year)
duplicates drop secid year, force 
replace vcoef_rolling = . if vcoef_rolling >= 1.5 | vcoef_rolling <= 0.5 
bysort secid (year): replace vcoef_rolling = (vcoef_rolling[_n+1] + vcoef_rolling[_n-1]) / 2 if missing(vcoef_rolling)
bysort secid (year): replace vcoef_rolling = vcoef_rolling[_n-1] if missing(vcoef_rolling)
save DATA/TEMP/DLcoefs_rolling, replace 

sum year, detail 
scalar last = `r(max)' + 1
forv i = `=last'/30 {
	use DATA/TEMP/DLcoefs_rolling, clear 
	keep if year == `=last' - 1
	replace year = `i'
	save DATA/TEMP/DLcoefs_rolling_`i', replace 
}
use DATA/TEMP/DLcoefs_rolling, clear 
forv i = `=last'/30 {
	append using DATA/TEMP/DLcoefs_rolling_`i'
}
save DATA/TEMP/DLcoefs_full_rolling, replace 


** Erase files 
forv i = `=last'/30 {
	capture: qui: erase "DATA/TEMP/DLcoefs_rolling_`i'.dta"
}

******************************************************************************** 
** Figure B8-A,B,C
******************************************************************************** 
qui: use DATA/TEMP/full_est, clear
qui: drop if missing(v)
forv i = 1/3 {
	foreach var in v k {
		gen `var'`i' = `var'^`i' 
	}
}
gen v1k1 = v * k 
gen v2k1 = v^2 * k 
gen v1k2 = v * k^2 
gen ones = 1

local poly v1 v2 v3 k1 k2 k3 v1k1 v1k2 v2k1 

gen phi = . 
gen resid = . 
levelsof secid, local(seclist)
foreach j of local seclist {
	qui: reg r `poly' if secid == `j', cluster(panelid)
	qui: predict phi_temp 
	qui: replace phi = phi_temp if secid == `j'
	qui: replace resid = r - phi if secid == `j'
	qui: drop phi_temp 
}

merge n:1 secid using DATA/TEMP/DLcoefs, keep(3) nogen 
merge n:1 secid year using DATA/TEMP/DLcoefs_full_rolling, keep(1 3) nogen 
merge n:1 secid year using DATA/TEMP/GO_wt, keep(1 3) nogen 

gen sale_adj = exp(phi)
gen sh_cogs = exp(v) / sale_adj 

* Drop 1% outliers 
local lp 2.5
local up 97.5
 
bysort year secid: egen plp = pctile(sh_cogs), p(`lp')
bysort year secid: egen pup = pctile(sh_cogs), p(`up')
 
drop if sh_cogs <= plp 
drop if sh_cogs >= pup
 
gen markup = vcoef / sh_cogs 
gen markup_rolling = vcoef_rolling / sh_cogs 
gen markup_const = 0.85 / sh_cogs 

qui: capture: drop min_year 
bysort panelid: egen min_year = min(year)
 
foreach var in sale sale_adj cogs {
	bysort year: egen sum_`var' = sum(`var')
	gen wt_`var' = (`var' / sum_`var')
	gen markup_`var' = markup * wt_`var'  	
}
 
foreach var in sale sale_adj cogs {
	gen markup_rolling_`var' = markup_rolling * wt_`var'  
	gen markup_const_`var' = markup_const * wt_`var'
}
replace year = 1984 + year  
collapse (sum) markup*, by(year)

twoway (line markup_sale_adj year, ylabel(1.0(0.05)1.25) xlabel(1970(5)2011) ytitle("") xtitle("Year") legend(label(1 "Sale weighted") label(2 "Input weighted"))) (line markup_cogs year)
graph export "FIGURE/FIGUREB8_A.pdf", as(pdf) replace 
 
twoway (line markup_rolling_sale_adj year, ylabel(1.0(0.05)1.25) xlabel(1970(5)2011) ytitle("") xtitle("Year") legend(label(1 "Sale wgt.") label(2 "Input weighted"))) (line markup_rolling_cogs year)
graph export "FIGURE/FIGUREB8_B.pdf", as(pdf) replace 
 
** Labor shares 
use DATA/EUKLEMS, clear 
keep if inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244") | inlist(sec, "_24t25", "_26", "_27t28", "_29-34t35") | inlist(sec, "_30t33", "_36t37")
collapse (sum) LAB VA GO, by(year)
keep if inrange(year, 1972, 2011)

gen lshare_VA = 100 * LAB / VA 
gen lshare_GO = 100 * LAB / GO 

twoway (line lshare_VA year, xlabel(1970(5)2011) lcolor(orange_red) ytitle("") xtitle("Year")) 
graph export "FIGURE/FIGUREB8_C.pdf", as(pdf) replace  

  
 
********************************************************************************
** Erase files
********************************************************************************
qui: capture: erase DATA/TEMP/temp_WBILL.dta 
qui: capture: erase DATA/TEMP/temp_ppi.dta 
qui: capture: erase DATA/TEMP/temp_inPPI.dta 
qui: capture: erase DATA/TEMP/temp_imsh.dta 
qui: capture: erase DATA/TEMP/temp_GO.dta 
qui: capture: erase DATA/TEMP/temp_export.dta 
qui: capture: erase DATA/TEMP/temp_WBILL.dta 
qui: capture: erase DATA/TEMP/temp_imsh.dta 
qui: capture: erase DATA/TEMP/temp_expen.dta 
qui: capture: erase DATA/TEMP/temp_import.dta 
qui: capture: erase DATA/TEMP/full_est.dta 
qui: capture: erase DATA/TEMP/nonx_est.dta 
qui: capture: erase DATA/TEMP/nx_est.dta 
qui: capture: erase DATA/TEMP/x_est.dta 
qui: capture: erase DATA/TEMP/temp1.dta 
qui: capture: erase DATA/TEMP/temp2.dta 
qui: capture: erase DATA/TEMP/BW_sigma_mean.dta 
qui: capture: erase DATA/TEMP/BW_sigma_1972_1988.dta 
qui: capture: erase DATA/TEMP/BW_sigma_1990_2001.dta 
qui: capture: erase DATA/TEMP/DLcoefs.dta 
qui: capture: erase DATA/TEMP/DLcoefs_rolling.dta 
qui: capture: erase DATA/TEMP/DLcoefs_full_rolling.dta 
qui: capture: erase "DATA/TEMP/GO_wt.dta"
qui: capture: erase "DATA/TEMP/DKLmu.dta"
