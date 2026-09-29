********************************************************************************
** Reduced-form specification from Choi and Levchenko (2025)
********************************************************************************
qui: import delimited using "OUTPUT/result_base.csv", clear  
qui: drop in 1 
qui: drop if firmid < 1 
qui: merge n:1 firmid using "DATA/matlab_firmid_kis_mapping", keep(1 3) nogen 
qui: merge 1:1 kis year using "DATA/firm_balance", keep(1 3) nogen 
qui: merge n:1 kis using "DATA/kis_region", keep(1 3) nogen 
qui: merge n:1 kis using "DATA/FIRM_SEC", keep(1 3) nogen 
 
qui: gen hci_sec = (inlist(sec, "_23", "_24t25", "_27t28", "_30t33", "_29-34t35"))
qui: gen hci_region = (inlist(region_id, 21000, 26000, 36020, 37010, 37050, 38010))
 
local start_pol = 1973 
local end_pol = 1979 
local start_imf = 1997

qui: gen treated = (hci_sec == 1) & (min_year <= `end_pol') & (hci_region == 1)
qui: gen ip_treated = treated * inrange(year, `start_pol', `end_pol') 
qui: gen op_treated = treated * inrange(year, `end_pol' + 1, 2011)
qui: save "DATA/TEMP/baseline_shock", replace 

qui: use "DATA/TEMP/baseline_shock", clear 
qui: drop if firmid < 0 
qui: replace startyear = min_year if missing(startyear)
foreach var in a_fj tau_l tau_k df_tilde {
		qui: gen ln_`var' = ln(`var')
}
qui: gen diff = year - `start_pol'
forv f = 0/38 {
	qui: gen ftreated`f' = treated * (diff == `f')
}
forv l = 3(-1)0 {
	qui: gen ltreated`l' = treated * (diff == -`l')
}
qui: egen reg_sec_id = group(region_id secid)
qui: gen dum_export = (export > 0)
qui: bysort kis (year): gen inidum_export = dum_export[1]
qui: gen high_inidum_export = (inidum_export == 1)
qui: gen low_inidum_export = (inidum_export == 0)
qui: bysort kis (year): gen iniht_export = asinh(export[1])
qui: save "DATA/TEMP/hci_reg", replace 

********************************************************************************
** Find the size cutoff that maximizes the adjusted R^2
********************************************************************************
qui: putexcel set "DATA/TEMP/min_adjr2.xlsx", modify
qui: putexcel A1 = "pval"
qui: putexcel B1 = "adjr2"

local excel_row = 2

local u = 22 
local syear = 1972 

forv p = 75(0.5)95 {
	qui: use "DATA/TEMP/hci_reg", clear 
	qui: keep if min_year <= `syear'
	qui: keep if inrange(diff, -1, `u')

	foreach var in asset emp sale fasset {
		preserve 
			qui: keep if inrange(year, 1972, 1973)
			qui: bysort kis (year): gen ini`var' = `var'[1]
			qui: gen ln_ini`var' = ln(ini`var')
			qui: gen dum_ini`var' = (`var' > 0)
			qui: bys reg_sec_id year: egen p = pctile(ini`var'), p(`p')
			qui: gen temp_high_ini`var' = (ini`var' >= p)
			qui: gen temp_low_ini`var' = (ini`var' < p)
			qui: bysort kis: egen high_ini`var' = max(temp_high_ini`var')
			qui: gen low_ini`var' = (high_ini`var' == 0)
			qui: collapse (mean) ln_ini`var' dum_ini`var' high_ini`var' low_ini`var', by(kis)
			qui: save "DATA/TEMP/ini`var'", replace 
		restore
	}
 
	foreach var in asset emp sale fasset {
		qui: merge n:1 kis using "DATA/TEMP/ini`var'", keep(3) nogen
	}
 
	foreach var in low high {
		qui: gen `var'_ltreated1 = ltreated1 * `var'_inisale
		forv f = 0(1)`u' {
			qui: gen `var'_ftreated`f' = ftreated`f' *`var'_inisale	
		}
	}

	local Xhigh high_ltreated1
	local Xlow low_ltreated1
	
	forv f = 0(1)`u' {
		local Xhigh `Xhigh' high_ftreated`f'
		local Xlow `Xlow' low_ftreated`f'
	}	
	qui: replace high_ltreated1 = 0 
	qui: replace low_ltreated1 = 0  
	
	foreach v in op ip {
		foreach ty in high low {
			qui: gen `ty'_`v'_treated = `ty'_inisale * `v'_treated
		}
	}
 
	local cl region_id  
	local fe reg_sec_id secid##year region_id##year c.ln_inisale#i.year

	qui: reghdfe ln_a_fj `Xhigh' `Xlow', a(`fe') cluster(`cl')
	qui: putexcel A`excel_row' = `p'
	qui: scalar put =  round(e(r2_a), 1e-8)
	qui: putexcel B`excel_row' =`=put'
	disp(`p')
	disp(`=put')
	
	qui: local excel_row = `excel_row' + 1 
}
 
********************************************************************************
** Event study (heterogeneous effect based on firm size)
** Reduced-form specification from Choi and Levchenko (2025)
********************************************************************************
import excel using "DATA/TEMP/min_adjr2.xlsx", clear firstrow 
gsort -adjr2 pval 
keep if _n == 1
sum pval, detail 
scalar pval = r(mean)

local u = 22
local syear = 1972 
 
local specs 
local pos = 1 

qui: use "DATA/TEMP/hci_reg", clear 
qui: keep if min_year <= `syear'
qui: keep if inrange(diff, -1, `u')

foreach var in asset emp sale fasset {
	preserve 
		qui: keep if inrange(year, 1972, 1973)
		qui: bysort kis (year): gen ini`var' = `var'[1]
		qui: gen ln_ini`var' = ln(ini`var')
		qui: gen dum_ini`var' = (`var' > 0)
		qui: bys reg_sec_id year: egen p = pctile(ini`var'), p(`=pval')
		qui: gen temp_high_ini`var' = (ini`var' >= p)
		qui: gen temp_low_ini`var' = (ini`var' < p)
		qui: bysort kis: egen high_ini`var' = max(temp_high_ini`var')
		qui: gen low_ini`var' = (high_ini`var' == 0)
		qui: collapse (mean) ln_ini`var' dum_ini`var' high_ini`var' low_ini`var', by(kis)
		qui: save "DATA/TEMP/ini`var'", replace 
	restore
}
 
foreach var in asset emp sale fasset {
	qui: merge n:1 kis using "DATA/TEMP/ini`var'", keep(3) nogen
}
 
foreach var in low high {
	qui: gen `var'_ltreated1 = ltreated1 * `var'_inisale
	forv f = 0(1)`u' {
		qui: gen `var'_ftreated`f' = ftreated`f' *`var'_inisale		
	}
}

local Xhigh high_ltreated1
local Xlow low_ltreated1

forv f = 0(1)`u' {
	local Xhigh `Xhigh' high_ftreated`f'
	local Xlow `Xlow' low_ftreated`f'
}	
qui: replace high_ltreated1 = 0 
qui: replace low_ltreated1 = 0  

foreach v in op ip {
	foreach ty in high low {
		qui: gen `ty'_`v'_treated = `ty'_inisale * `v'_treated
	}
}

foreach dep in ln_a_fj  ln_tau_k ln_tau_l ln_df_tilde {
 
	local fe reg_sec_id secid##year region_id##year 
	local cl region_id  
		
	if "`dep'" == "ln_a_fj" {
		local fe `fe' c.ln_inisale#i.year
	}
 
	qui: reghdfe `dep' `Xhigh' `Xlow', a(`fe') cluster(`cl')
	qui: est store full_model

	local high_color #377EB8   
	local low_color #E41A1C  

	local xlab 1 "-1"
	forv i = 2(5)`u' {
		local j = `i' - 2
		local xlab `xlab' `i' "`j'"
	}

	* --------- High initial sales panel ---------
	qui: coefplot ///
		(full_model, keep(high_ftreated* high_ltreated1) ///
			omitted drop(_cons) ///
			recast(connected) ///
			lcolor(`high_color') ///
			ciopts(recast(rarea) color(`high_color'%25) ///
				   lwidth(0) lcolor(`high_color'%25)) ///
			msymbol(O) mcolor(`high_color') msize(medium)), ///
		vertical levels(90) ///
		xlabel(`xlab', grid angle(horizontal)) ///
		ylabel(, grid) ///
		yline(0, lc(gs8) lp(dash)) ///
		xline(2, lc(gs8) lp(dash)) ///
		graphregion(fcolor(white)) ///
		legend(off) ///
		title("Large Firms") ///
		name(g_high, replace)
 
	* --------- Low initial sales panel ---------
	qui: coefplot ///
		(full_model, keep(low_ftreated* low_ltreated1) ///
			omitted drop(_cons) ///
			recast(connected) ///
			lcolor(`low_color') ///
			ciopts(recast(rarea) color(`low_color'%25) ///
				   lwidth(0) lcolor(`low_color'%25)) ///
			msymbol(T) mcolor(`low_color') msize(medium)), ///
		vertical levels(90)  ///
		xlabel(`xlab', grid angle(horizontal)) ///
		ylabel(, grid) ///
		yline(0, lc(gs8) lp(dash)) ///
		xline(2, lc(gs8) lp(dash)) ///
		graphregion(fcolor(white)) ///
		legend(off) ///
		title("Small Firms") ///
		name(g_low, replace)
 
	* --------- Combine in one window, same axes ---------
	qui: graph combine g_high g_low, ///
		col(2) ycommon xcommon ///
		graphregion(fcolor(white)) ///
		b1title("Years relative to the HCI Drive")
		
	if "`dep'" == "ln_a_fj"	 local figname FIGUREB10_A
	if "`dep'" == "ln_tau_k" 	local figname FIGUREB10_B
	if "`dep'" == "ln_tau_l" 	local figname FIGUREB10_C
	if "`dep'" == "ln_df_tilde" 	local figname FIGUREB10_D
 
	qui: graph export "FIGURE/`figname'.pdf", as(pdf) replace
} 
 
 
********************************************************************************
** Erase files  
********************************************************************************
qui: capture: erase "DATA/TEMP/baseline_shock.dta"
qui: capture: erase "DATA/TEMP/fringe_c.dta"
qui: capture: erase "DATA/TEMP/hci_reg.dta"
foreach var in asset emp sale fasset {
	qui: capture: erase "DATA/TEMP/ini`var'.dta" 
}
qui: capture: erase "DATA/TEMP/min_adjr2.xlsx"
 