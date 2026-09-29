********************************************************************************
** Shock Correlation: Table B10
********************************************************************************
import delimited using "OUTPUT/result_base_notruncation_nosmoothing.csv", clear 	// _notruncation_no_smoothing No smoothing  
drop in 1 
drop if firmid < 0 
keep firmid year sale_vec 
save "DATA/TEMP/sale_vec", replace 
 
local IOyear = 1973 
 
import delimited using "OUTPUT/result_base_notruncation_nosmoothing.csv", clear 	// _notruncation_no_smoothing No smoothing  
drop in 1 
drop if firmid < 0 
merge n:1 firmid using "DATA/matlab_firmid_kis_mapping", keep(1 3) nogen 
merge 1:1 firmid year using "DATA/TEMP/sale_vec", keep(3) nogen 
gsort secid year -sale_vec 
bysort secid year: gen rank = _n 
capture: drop top3 
gen top3 = (rank <= 3)
xtset firmid year 
bysort firmid: egen ever_top3 = max(top3)
sort firmid year 
foreach var in a_fj tau_l tau_k df df_real {
	gen ln_`var' = ln(`var') 
	gen ht_`var' = asinh(`var')
	bysort firmid (year): gen dln_`var' = ln_`var'[_n+1] - ln_`var'
	bysort firmid (year): gen dht_`var' = ht_`var'[_n+1] - ht_`var'
}

** Top 3 firms' sales and shocks 
forv n = 1/3 {
	preserve 
		keep if rank == `n' 
		keep kis secid year sale_vec ln_* ht_* dln_* dht_*
		rename (kis sale_vec ln_* ht_* dln_* dht_*) (kis_r`n' sale_vec_r`n' ln_*_r`n' ht_*_r`n' dln_*_r`n' dht_*_r`n' ) 
		save "DATA/TEMP/sale_vec_r`n'", replace 
	restore 
}
preserve 
	use "DATA/TEMP/sale_vec_r1", clear
	merge 1:1 secid year using "DATA/TEMP/sale_vec_r2", keep(3) nogen 
	merge 1:1 secid year using "DATA/TEMP/sale_vec_r3", keep(3) nogen 
	save "DATA/TEMP/sale_vec_t3", replace 
restore 

** Top 3 firms weighted shocks for non-top 3 firms 
preserve 
	keep if top3 == 1 
	bysort secid year: egen sum_sale_vec = sum(sale_vec)
	gen wt = sale_vec / sum_sale_vec 
	 
	foreach var in a_fj tau_l tau_k df df_real {
		replace ln_`var' = wt * ln_`var'
		replace ht_`var' = wt * ht_`var'
		replace dln_`var' = wt * dln_`var'
		replace dht_`var' = wt * dht_`var'		
	}
	collapse (sum) ln_* ht_* dln_* dht_*, by(secid year)
	rename (ln_* ht_* dln_* dht_*) (t3_ln_* t3_ht_* t3_dln_* t3_dht_*)
	save "DATA/TEMP/top3_wt_shock", replace 
restore

preserve 
	keep if top3 == 1 
	merge n:1 secid year using "DATA/TEMP/sale_vec_t3", keep(3) nogen 
	xtset firmid year 
	forv r = 1/3 {
		replace sale_vec = 0 if kis == kis_r`r'
	}
	gen sum_sale_vec = sale_vec_r1 + sale_vec_r2 + sale_vec_r3 
	forv r = 1/3 {
		gen wt_r`r' = sale_vec_r`r' / sum_sale_vec 
	}
	drop sum_sale_vec 
 
	foreach var in a_fj tau_l tau_k df df_real {
		forv i = 1/1 {
			foreach type in ht ln dht dln {
				gen L`i'`type'_`var' = L`i'.`type'_`var'
				gen F`i'`type'_`var' = F`i'.`type'_`var'
				forv r = 1/3 {
					replace `type'_`var'_r`r' = 0 if kis == kis_r`r'
					gen L`i'`type'_`var'_r`r' = L`i'.`type'_`var'_r`r'
				}
				
				gen r2_`type'_`var' = 0
				gen L`i'r2_`type'_`var' = 0
				forv r = 1/3 {
					replace r2_`type'_`var' = r2_`type'_`var' + `type'_`var'_r`r' * wt_r`r'
					replace L`i'r2_`type'_`var' = L`i'r2_`type'_`var' + L`i'`type'_`var'_r`r' * wt_r`r'
				}
				bysort firmid (year): gen dL`i'`type'_`var' = L`i'`type'_`var'[_n+1] - L`i'`type'_`var'
				bysort firmid (year): gen dL`i'r2_`type'_`var' = L`i'r2_`type'_`var'[_n+1] - L`i'r2_`type'_`var'				
			}
		}
	}
	forv r = 1/3 {
		drop sale_vec_r`r' wt_r`r' 
		foreach var in a_fj tau_l tau_k df df_real {
			foreach type in ht ln dht dln {
				drop `type'_`var'_r`r'
			}
		}
	}	
	save "DATA/TEMP/shock_corr_top3", replace 
restore 

preserve 
	keep if top3 == 0 
	merge n:1 secid year using "DATA/TEMP/top3_wt_shock", keep(3) nogen
	xtset firmid year 
	foreach var in a_fj tau_l tau_k df df_real  {
		forv i = 1/1 {
			foreach type in ht ln dht dln {
				gen L`i'`type'_`var' = L`i'.`type'_`var'
				gen F`i'`type'_`var' = F`i'.`type'_`var'
				gen L`i't3_`type'_`var' = L`i'.t3_`type'_`var'
				
				bysort firmid (year): gen dL`i'`type'_`var' = L`i'`type'_`var'[_n+1] - L`i'`type'_`var'
				bysort firmid (year): gen dL`i't3_`type'_`var' = L`i't3_`type'_`var'[_n+1] - L`i't3_`type'_`var'
			}
		}
	}
	save "DATA/TEMP/shock_corr_ntop3", replace 
restore 

** Upstream top 3 shocks 
foreach var in GO VADD TOT {
	use "DATA/IO_`IOyear'_3digit_all", clear
	keep if inlist(osec, "`var'")
	drop if inlist(dsec, "expen", "export", "fcons", "import", "import_cif", "import_tar", "intcons")
	rename dsec sec 
	rename value `var'
	keep sec `var'
	save "DATA/TEMP/`var'", replace 
}

use "DATA/TEMP/GO", clear
merge 1:1 sec using "DATA/TEMP/VADD", keep(3) nogen 
gen VAsh = VADD / GO 
keep sec VAsh 
merge n:1 sec using "DATA/secid", keep(3) nogen 
save "DATA/TEMP/VAsh", replace

** Upstream shocks based on cost shares 
use "DATA/IO_`IOyear'_3digit_all", clear 
drop if inlist(dsec, "expen", "export", "fcons", "import", "import_cif", "import_tar", "intcons")
drop if inlist(osec, "GO", "TOT", "VADD", "WBILL")
foreach od in o d {
	rename `od'sec sec 
	merge n:1 sec using "DATA/secid", keep(3) nogen
	rename (sec secid) (`od'sec `od'secid)
}	
rename dsec sec 
merge n:1 sec using "DATA/TEMP/TOT", keep(3) nogen 

bysort dsec: egen sum_value = sum(value)
rename sec dsec 
gen intsh = value / sum_value 
keep osec osecid dsec dsecid intsh 
sort osecid dsecid 
save "DATA/TEMP/intsh", replace 

use "DATA/TEMP/intsh", clear 
expand 2011 - 1972 + 1 
bysort osec dsec: gen year = 1971 + _n
rename (osec osecid) (sec secid)
merge n:1 secid year using "DATA/TEMP/top3_wt_shock", keep(1 3) nogen 
rename (sec secid) (osec osecid)
rename (dsec dsecid) (sec secid)
merge n:1 sec using "DATA/TEMP/VAsh", keep(3) nogen 
foreach var in tau_l tau_k a_fj df df_real {
	foreach type in ln ht dln dht {
		replace t3_`type'_`var' = 0 if missing(t3_`type'_`var')
		gen upt3_`type'_`var' = t3_`type'_`var' * (1 - VAsh) * intsh 
	}
}
collapse (sum) upt3_*, by(sec secid year)
save "DATA/TEMP/uptop3_wt_shock", replace 

** Downstream shocks based on cost shares 
use "DATA/IO_`IOyear'_3digit_all", clear 
drop if inlist(dsec, "expen", "export", "fcons", "import", "import_cif", "import_tar", "intcons")
drop if inlist(osec, "GO", "TOT", "VADD", "WBILL")
foreach od in o d {
	rename `od'sec sec 
	merge n:1 sec using "DATA/secid", keep(3) nogen
	rename (sec secid) (`od'sec `od'secid)
}	
rename osec sec 
merge n:1 sec using DATA/TEMP/GO, keep(3) nogen
merge n:1 sec using DATA/TEMP/VADD, keep(3) nogen
rename sec osec 
bysort osec: egen sum_value = sum(value)
gen salesh = value / GO 
keep osec osecid dsec dsecid salesh 
sort osecid dsecid 
save "DATA/TEMP/salesh", replace 

foreach var in intsh salesh {
	use "DATA/TEMP/`var'", clear
	keep if osecid == dsecid 
	keep osecid osec `var'
	rename (osecid osec `var') (secid sec own_`var')
	save "DATA/TEMP/own_`var'", replace 
}

use DATA/TEMP/salesh, clear 
expand 2011 - 1972 + 1 
bysort osec dsec: gen year = 1971 + _n
rename (dsec dsecid) (sec secid)
merge n:1 secid year using DATA/TEMP/top3_wt_shock, keep(1 3) nogen 
rename (sec secid) (dsec dsecid)
rename (osec osecid) (sec secid) 
foreach var in tau_l tau_k a_fj df df_real {
	foreach type in ln ht dln dht {
		replace t3_`type'_`var' = 0 if missing(t3_`type'_`var')
		gen downt3_`type'_`var' = t3_`type'_`var' * salesh
	}
}
collapse (sum) downt3_*, by(sec secid year)
save "DATA/TEMP/downtop3_wt_shock", replace 

** Combining datasets
use "DATA/TEMP/shock_corr_top3", clear 
append using "DATA/TEMP/shock_corr_ntop3" 
merge n:1 secid year using "DATA/TEMP/downtop3_wt_shock", keep(3) nogen 
merge n:1 secid year using "DATA/TEMP/uptop3_wt_shock", keep(3) nogen 
foreach var in a_fj tau_l tau_k df df_real {
	foreach type in ht ln dht dln {
		replace t3_`type'_`var' = r2_`type'_`var' if top3 == 1 
		forv i = 1/1 {			
			replace L`i't3_`type'_`var' = L`i'r2_`type'_`var' if top3 == 1 
			replace L`i'r2_`type'_`var' = 0 if top3 == 0 

			replace dL`i't3_`type'_`var' = dL`i'r2_`type'_`var' if top3 == 1 
			replace dL`i'r2_`type'_`var' = 0 if top3 == 0 				
		}
	}
}
xtset firmid year 
egen sec_year_id = group(secid year)
gen hci = (inlist(secid, 4, 8, 9, 10))
egen hci_year_id = group(hci year)
gen ones = 1 

** Correction for top 3 firms 
preserve 
	use "DATA/TEMP/top3_wt_shock", clear
	rename (t3_*) (own_t3_*)
	save "DATA/TEMP/own_top3_wt_shock", replace 
restore 

merge n:1 secid using "DATA/TEMP/own_salesh", keep(3) nogen 
merge n:1 secid using "DATA/TEMP/own_intsh", keep(3) nogen 
merge n:1 secid using "DATA/TEMP/VAsh", keep(3) nogen 
merge n:1 secid year using "DATA/TEMP/own_top3_wt_shock", keep(3) nogen 

foreach var in tau_l tau_k a_fj df df_real {
	foreach type in ln ht dln dht {
		** own_t3_* : Top 3 own sector 
		** r2_* : Top 3 own sector, excluding own firm. The correction only requires one sector. So, by running the following two lines, we are effectively adjusting own sectors 
		replace upt3_`type'_`var' = upt3_`type'_`var'  + (r2_`type'_`var' - own_t3_`type'_`var') * (1 - VAsh) * own_intsh if top3 == 1 			
		replace downt3_`type'_`var' =  downt3_`type'_`var' + (r2_`type'_`var' - own_t3_`type'_`var') * own_salesh if top3 == 1
	}
}
drop own_t3* own_intsh own_salesh
save "DATA/TEMP/shock_corr_reg", replace 
 

********************************************************************************
** Reporting to Matlab Inputs: Used for Panel E of Table 7 
********************************************************************************
use "DATA/TEMP/salesh", clear  
rename (osecid osec dsecid dsec) (secid sec other_secid other_sec)
save "DATA/TEMP/salesh_sym", replace 

use "DATA/TEMP/intsh", clear 
rename (osecid osec dsecid dsec) (other_secid other_sec secid sec)
merge n:1 secid using "DATA/TEMP/VAsh", keep(3) 
gen costsh = (1 - VAsh) * intsh 
keep secid sec other_secid other_sec costsh 
order secid sec other_secid other_sec costsh 
save "DATA/TEMP/intsh_sym", replace 

use "DATA/TEMP/salesh_sym", clear
merge 1:1 secid other_secid using "DATA/TEMP/intsh_sym", keep(3) nogen 
sort secid other_secid 
keep secid sec other_secid other_sec costsh salesh 
order secid sec other_secid other_sec costsh salesh 
save "DATA/TEMP/costsh_salesh", replace 
export excel using "INPUT/costsh_salesh.xlsx", replace first(var)
export delimited using "INPUT/costsh_salesh.csv", replace
 

********************************************************************************
** Shock Correlation Regression 
********************************************************************************
qui: use "DATA/TEMP/shock_corr_reg", clear

local dep F1ln_a_fj
local X1 ln_a_fj t3_ln_a_fj
local X2 ln_a_fj t3_ln_a_fj upt3_ln_a_fj downt3_ln_a_fj 

local own_var ln_a_fj ln_tau_l ln_tau_k ht_df_real 
local t3_var t3_ln_a_fj t3_ln_tau_l t3_ln_tau_k t3_ht_df_real 
foreach var in `own_var' `t3_var' {
	drop if missing(`var')
}

local cl secid  
local FE i.year i.secid  
 
local specs 
 
forv s = 1/2 {
	qui: ivreg2 `dep' `X`s'' `FE', partial(`FE') cluster(`cl') nocons 
	qui: eststo s`s' 
	qui: capture: estadd scalar adjR2 = e(r2_a)  		 
	qui: capture: estadd scalar numC1 = e(N_clust1)  
	qui: capture: estadd scalar numC2 = e(N_clust2)  
	local specs `specs' s`s'
 
	tempname BP
	local nX : word count `X`s''
	matrix `BP' = J(1, `nX', .)
	matrix colnames `BP' = `X`s''
	local j = 0
	foreach var in `X`s'' {
		local ++j
		qui: ivreg2 `dep' `X`s'' `FE', partial(`FE') cluster(`cl') nocons 
		qui: boottest `var', nograph seed(1004)
		matrix `BP'[1, `j'] = r(p)
	}
	qui: estadd matrix bootp = `BP' : s`s'
}

** Store column 2 of Table B10
qui: ivreg2 `dep' `X2' `FE', partial(`FE') cluster(`cl') nocons 
gen spill_t3 = _b[t3_ln_a_fj]
gen spill_upt3 = _b[upt3_ln_a_fj] 
gen spill_downt3 = _b[downt3_ln_a_fj]
collapse (mean) spill_t3 spill_upt3 spill_downt3, by(ones)
save "DATA/spill_estimates", replace 

********************************************************************************	
** LASSO-data: Second-order polynomials 
********************************************************************************
forv must = 1/2 {		
	use "DATA/TEMP/shock_corr_reg", clear
	
	local dep F1ln_a_fj 

	local own_var ln_tau_l ln_tau_k ht_df_real 
	local t3_var t3_ln_tau_l t3_ln_tau_k t3_ht_df_real 
	local upt3_var upt3_ln_tau_l upt3_ln_tau_k upt3_ht_df_real 
	local downt3_var downt3_ln_tau_l downt3_ln_tau_k downt3_ht_df_real 
	
	foreach var in `own_var' `t3_var' {
		drop if missing(`var')
	}			
		
	local own_lag ln_a_fj 
	local own_t3_lag t3_ln_a_fj 
	local own_upt3_lag upt3_ln_a_fj 
	local own_downt3_lag downt3_ln_a_fj 
 
	local FE i.year i.secid
	local cl secid   
	 
	local manyX1 `own_var' `t3_var'
	local manyX2 

	local i = 1
	local toexclude  
	if `must' == 1 {
		local loopvarlist `own_var' `t3_var' 
	}
	else if `must' == 2 {
		local loopvarlist `own_var' `t3_var' `upt3_var' `downt3_var'  
	}
	foreach var1 in `loopvarlist' { 
 
		qui: local sec_own_var: list loopvarlist - toexclude	 
		qui: disp `sec_own_var'
	 
		foreach var2 in `sec_own_var' {  
			qui: gen X2_`i' = `var1' * `var2'
			qui: label var X2_`i' "`var1' `var2'"
			qui: drop if missing(X2_`i')
			qui: local manyX2 `manyX2' X2_`i'
			qui: local i = `i' + 1 
		}
		qui: local toexclude `toexclude' `var1'
		disp "`sec_own_var'" 
	}

	foreach var in `manyX1' `manyX2' {
		qui: drop if missing(`var')
	}
 
	qui: local toexclude `dep'
	qui: local remain_t3: list t3_var - own_t3_lag 
	qui: local remain_own: list own_var - own_lag 
	qui: local remain_downt3: list downt3_var - own_downt3_lag 
	qui: local remain_upt3: list upt3_var - own_upt3_lag
	
	if `must' == 1 {
		qui: local must_var `own_lag' `own_t3_lag'  
		qui: local select_var `remain_own' `remain_t3' `remain_upt3' `remain_downt3' `manyX2'			
	}
	else if `must' == 2 {
		qui: local must_var `own_lag' `own_t3_lag' `own_upt3_lag' `own_downt3_lag' 
		qui: local select_var `remain_own' `remain_t3' `remain_upt3' `remain_downt3' `manyX2'
	}
	qui: pdslasso `dep' `must_var' (`select_var' `FE'), partial(`FE') cluster(secid) nocons 
	local select_var `e(xselected)'

	qui: ivreg2 `dep' `must_var' `select_var' `FE', partial(`FE') cluster(`cl') nocons
	qui: eststo lasso_m`must'
	qui: capture: estadd scalar adjR2 = e(r2_a)  		 
	qui: capture: estadd scalar numC1 = e(N_clust1)  
	qui: capture: estadd scalar numC2 = e(N_clust2)  

	qui: ivreg2 `dep' `must_var' `select_var' `FE', partial(`FE') cluster(`cl') nocons  
 
	tempname BP
	local nX : word count `X`must''
	matrix `BP' = J(1, `nX', .)
	matrix colnames `BP' = `X`must''
	local j = 0
	foreach var in `X`must'' {
		local ++j
		qui: ivreg2 `dep' `must_var' `select_var' `FE', partial(`FE') cluster(`cl') nocons 
		qui: boottest `var', nograph seed(1004)
		matrix `BP'[1, `j'] = r(p)
	}
	qui: estadd matrix bootp = `BP' : lasso_m`must'

	qui: local specs `specs' lasso_m`must'
}

local keep_var `X2'   

estout `specs' using "TABLE/TABLEB10.tex", ///
	cells(b(star fmt(%9.2f)) se(par fmt(%9.2f)) bootp(par([ ]) fmt(%9.2f))) starlevels(\sym{*} 0.1 \sym{**} 0.05 \sym{***} 0.01) ///
	stats(adjR2 numC1 numC2 N, fmt(%9.2f %9.0f %9.0f %9.0f) ///
	labels("Adj. R^{2}" "\# Clusters1" "\# Clusters2" "N")) label msign($-$) lz ///
	varwidth(7) modelwidth(11) style(tex) keep(`keep_var') order(`keep_var') ///
	varlabel(ln_a_fj lna ///
	ln_tau_l lntaul /// 
	ln_tau_k lntauk /// 
	ht_df_real htdf ///
	t3_ln_a_fj t3lna ///
	upt3_ln_a_fj upt3lna ///
	downt3_ln_a_fj downt3lna ///
	t3_ln_tau_l t3lntaul ///
	t3_ln_tau_k t3lntauk ///
	t3_ht_df_real t3htdf ///
	X2_1 lna2 /// 
	X2_4 lnaIhsDx ///
	X2_5 lnat3lna ///
	X2_9 lnaupt3lna ///
	X2_11 lnaupt3lntauk ///
	X2_12 lnaupt3htdf ///
	X2_13 lnadownt3lna ///
	X2_28 lntauldownt3lna /// 
	) replace	

	
********************************************************************************
** Panel E of Table 7
** Construction of alternative shock series based on reduced-form spillover estimates
********************************************************************************	
import delimited "OUTPUT/result_counterfactual_a.csv",clear
keep if top3_prev==1
gen log_a_fj = log(a_fj)
collapse (mean) log_a_fj [w=s_total],by(secid year)

rename log_a_fj log_a_fj_counter
tempfile counter
save `counter'

import delimited "OUTPUT/result_base.csv",clear
keep if top3==1
gen log_a_fj = log(a_fj)
collapse (mean) log_a_fj [w=s_total],by(secid year)

merge m:1 secid year using `counter',keep(1 3) nogen
keep secid year log_a_fj_counter log_a_fj
tempfile log_a_fj
save `log_a_fj'
gen a_tilde_delta = log_a_fj_counter-log_a_fj
keep secid year a_tilde_delta
replace year=year+1
drop if year==2012
tempfile a_tilde_delta
save `a_tilde_delta'
 
** Upstream / downstream
import excel "INPUT/costsh_salesh.xlsx", sheet("Sheet1") clear firstrow
rename (secid other_secid) (secid_org secid)

joinby secid using `log_a_fj'
bys secid_org year: egen upstream_delta_prev = total(log_a_fj*costsh)
bys secid_org year: egen upstream_delta_counter = total(log_a_fj_counter*costsh)

bys secid_org year: egen downstream_delta_prev = total(log_a_fj*salesh)
bys secid_org year: egen downstream_delta_counter = total(log_a_fj_counter*salesh)

gen a_tilde_delta_u = upstream_delta_counter-upstream_delta_prev
gen a_tilde_delta_d = downstream_delta_counter-downstream_delta_prev

keep secid year a_tilde_delta_u a_tilde_delta_d
duplicates drop secid year,force
tempfile a_tilde_delta_io
save `a_tilde_delta_io'

import delimited "OUTPUT/result_counterfactual_a.csv",clear
merge m:1 secid year using `a_tilde_delta', nogen
merge m:1 secid year using `a_tilde_delta_io', nogen
capture: gen ones = 1 
merge n:1 ones using "DATA/spill_estimates", keep(3) nogen // Merge with the estimates from column 2 of Table B10
gen log_a_fj_counter_adj = log(a_fj) + a_tilde_delta*spill_t3 + a_tilde_delta_u*spill_upt3 + a_tilde_delta_d*spill_downt3
gen a_fj_counter_adj = exp(log_a_fj_counter_adj)
replace a_fj_counter_adj=a_fj if a_fj_counter_adj==.
keep firmid year a_fj_counter_adj
export delimited using "OUTPUT/counterfactual_shock_corr_io.csv",replace	

********************************************************************************
** Erase unnecessary files 
********************************************************************************
capture: qui: erase "DATA/TEMP/GO.dta" 
capture: qui: erase "DATA/TEMP/TOT.dta" 
capture: qui: erase "DATA/TEMP/VADD.dta" 
capture: qui: erase "DATA/TEMP/VAsh.dta" 
capture: qui: erase "DATA/TEMP/intsh.dta" 
capture: qui: erase "DATA/TEMP/salesh_sym.dta"
capture: qui: erase "DATA/TEMP/intsh_sym.dta"
capture: qui: erase "DATA/TEMP/costsh_salesh.dta"
capture: qui: erase "DATA/TEMP/sale_vec.dta" 
capture: qui: erase "DATA/TEMP/sale_vec_r1.dta" 
capture: qui: erase "DATA/TEMP/sale_vec_r2.dta" 
capture: qui: erase "DATA/TEMP/sale_vec_r3.dta" 
capture: qui: erase "DATA/TEMP/sale_vec_t3.dta"
capture: qui: erase "DATA/TEMP/top3_wt_shock.dta "
capture: qui: erase "DATA/TEMP/shock_corr_ntop3.dta "
capture: qui: erase "DATA/TEMP/shock_corr_reg.dta"
capture: qui: erase "DATA/TEMP/own_intsh.dta"
capture: qui: erase "DATA/TEMP/own_salesh.dta"
capture: qui: erase "DATA/TEMP/salesh.dta" 
capture: qui: erase "DATA/TEMP/own_top3_wt_shock.dta" 
capture: qui: erase "DATA/TEMP/downtop3_wt_shock.dta" 
capture: qui: erase "DATA/TEMP/uptop3_wt_shock.dta" 
capture: qui: erase "DATA/TEMP/shock_corr_top3.dta" 








