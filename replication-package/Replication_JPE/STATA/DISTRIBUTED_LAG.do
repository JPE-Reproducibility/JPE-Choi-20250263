local q        = 8                         // HEADLINE horizon: the .tex table reports Sigma_0^q from the lags-0..q model
local qlist      8                        
 
local chun_lo  = 1980
local chun_hi  = 1987
local roh_lo   = 1988
local roh_hi   = 1993
local est_lo   = 1970                      // standardization / estimation window (data starts 1972 -> full)
local est_hi   = 1995
  

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
import delimited using "OUTPUT/result_base_notruncation_nosmoothing.csv", clear 	// No smoothing + No truncation 
drop in 1 
drop if firmid < 0 | missing(firmid)
merge n:1 firmid using "DATA/matlab_firmid_kis_mapping", keep(1 3) nogen // Kis-value id 
merge n:1 year using "RAW/AGG/exr", keep(1 3) nogen 
gen ln_exr = ln(exr)
merge 1:1 kis year using "DATA/TEMP/kotra_temp", keep(1 3) nogen
merge 1:1 kis year using "RAW/Shock_validation/Patent/firmid_patent_adoption", keep(1  3) nogen
qui: merge n:1 kis using "DATA/kis_region", keep(1 3) nogen // Region info 
merge n:1 kis using "DATA/TEMP/first_adopt_year", keep(1 3) nogen
merge 1:1 kis year using "RAW/Shock_validation/Credit/raw_year_loan", keep(1 3) nogen	// Credit data
 
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
** Consturting bribery dataset
********************************************************************************
** (1) Bribe timing per group per regime (first Chun bribe/donation + first Roh)
import delimited using "RAW/political_events/political_events.csv", varnames(1) clear
destring g_code3 year_start year_end, replace force
keep if inlist(episode,"chun_bribe","ilhae","saesedae_heart","saesedae_edu","roh_bribe")
drop if group == "kukje"
drop if missing(g_code3) | missing(year_start)
gen byte _roh = (episode=="roh_bribe")
gen chun_yr = year_start if _roh==0
gen roh_yr  = year_start if _roh==1
collapse (min) first_chun=chun_yr first_roh=roh_yr, by(g_code3)
tempfile bribeyr
save `bribeyr'

** (2) Time-varying firm->group linkage; build the ever-affiliated dummy + the
**     treatment (bribing) group each treated firm inherits, for clustering.
import excel using "RAW/FIRM/business_group.xls", sheet("group_code") firstrow clear
keep year g_code3 kis
destring year g_code3, replace force
drop if missing(year) | missing(g_code3) | missing(kis)
capture confirm string variable kis
if _rc  tostring kis, replace format(%06.0f) force
replace kis = trim(kis)
tempfile linkraw
save `linkraw'
bysort kis year (g_code3): keep if _n==1          // one g_code3 per (kis,year), for the panel merge
keep kis year g_code3
tempfile linkdta
save `linkdta'

use `linkraw', clear
merge m:1 g_code3 using `bribeyr', keep(1 3) nogen
gen byte inC = inrange(year,`chun_lo',`chun_hi')
gen byte inR = inrange(year,`roh_lo', `roh_hi')
collapse (max) inC inR, by(kis g_code3 first_chun first_roh)
* (2a) treatment (bribing) group per firm = a bribing group it is ever-affiliated with in-regime
gen byte is_treatgrp = (inC==1 & !missing(first_chun)) | (inR==1 & !missing(first_roh))
preserve
	keep if is_treatgrp==1
	keep kis g_code3
	bysort kis (g_code3): keep if _n==1
	rename g_code3 treatgrp
	tempfile treatgrp
	save `treatgrp'
restore
* (2b) ever-affiliated status: conn=1 at first_chun / first_roh of an in-regime bribing affiliation
gen yC = first_chun if inC==1 & !missing(first_chun)
gen yR = first_roh  if inR==1 & !missing(first_roh)
keep kis yC yR
preserve
	keep kis yC
	rename yC year
	drop if missing(year)
	tempfile pc
	save `pc'
restore
keep kis yR
rename yR year
drop if missing(year)
append using `pc'
gen byte conn = 1
collapse (max) conn, by(kis year)
tempfile conndta
save `conndta'

**  Panel + regime-window, treatment-aware group cluster (grpclu)
use "DATA/TEMP/shock_valid_reg.dta", clear
merge m:1 kis year using `conndta',  keep(1 3) nogen
merge m:1 kis year using `linkdta',  keep(1 3) nogen
merge m:1 kis      using `treatgrp', keep(1 3) nogen
replace conn = 0 if missing(conn)
replace conn = 0 if !inrange(year, `chun_lo', `roh_hi')   // connection active only within the Chun-Roh window
qui: keep if inrange(year, 1972, 1995)

* firm-level cluster: treated -> ever-affiliated bribing group; else modal 1980-93 group; else singleton
egen long fm_treatgrp = mode(treatgrp), by(firmid) maxmode
gen g93 = g_code3 if inrange(year,`chun_lo',`roh_hi')
egen long fm_modal93 = mode(g93), by(firmid) maxmode
gen long grpclu = .
replace grpclu = fm_treatgrp if !missing(fm_treatgrp)
replace grpclu = fm_modal93  if missing(grpclu) & !missing(fm_modal93)
replace grpclu = -firmid     if missing(grpclu)
drop g93

* standardize all four regressors  
local X cum_tech ht_loan ht_kotnum conn
foreach v in `X' {
	qui: summ `v' if inrange(year, `est_lo', `est_hi')
	qui: replace `v' = (`v' - r(mean)) / r(sd)
}
 
local qmax = `q'
foreach qq of local qlist {
	if `qq' > `qmax'  local qmax = `qq'
}
xtset firmid year
forv i = 0/`qmax' {
	foreach v in `X' {
		sort firmid year
		qui: gen L`i'`v' = L`i'.`v'
		qui: replace L`i'`v' = 0 if missing(L`i'`v')
	}
}
keep if ini_status == 1                       // the draft's DL sample (firms first observed in 1972)
keep if inrange(year, `est_lo', `est_hi')

********************************************************************************
** Regression table
********************************************************************************
local rlab1 "Technology Adoption"
local rlab2 "Ihs Credit"
local rlab3 "Ihs Trade Fair Participation"
local rlab4 "Bribing (ever-affiliated dummy)"
local firstsheet = 1

foreach qq of local qlist {
	matrix B  = J(4,4,.)
	matrix S  = J(4,4,.)
	matrix P  = J(4,4,.)
	matrix S1 = J(4,4,.)
	matrix P1 = J(4,4,.)
	matrix NN = J(1,4,.)

	* lag list for THIS horizon (explicit, NOT the `-' range operator)
	local Xlag
	foreach v in `X' {
		forv l = 0/`qq' {
			local Xlag `Xlag' L`l'`v'
		}
	}
 
	local col = 0
	foreach dep in ln_a_fj ln_tau_k ln_tau_l ln_df {
		local col = `col' + 1

		* firm-clustered SE/p per regressor
		qui: reghdfe `dep' `Xlag', a(firmid sec_year_id) cluster(firmid)
		matrix NN[1, `col'] = e(N)

		local rr = 0
		foreach x in `X' {
			local rr = `rr' + 1
			local ex (_b[L0`x']
			forv l = 1/`qq' {
				local ex `ex' + _b[L`l'`x']
			}
			local ex `ex')
			qui: testnl `ex' = 0
			matrix P1[`rr', `col'] = r(p)
			qui: nlcom `ex'
			matrix B[`rr',  `col'] = r(b)[1,1]
			matrix S1[`rr', `col'] = (r(V)[1,1])^0.5
		}
	}
 
	****************************************************************************
	** Table 5 
	****************************************************************************
	local shname "cum_b0_b`qq'_firm"
	local cldesc "cluster(firmid)"

	if `firstsheet' == 1 {
		qui: putexcel set "TABLE/TABLE5.xlsx", sheet("`shname'") replace
		local firstsheet = 0
	}
	else {
		qui: putexcel set "TABLE/TABLE5.xlsx", sheet("`shname'", replace) modify
	}
	qui: putexcel A1 = "Cumulative sum_{tau=0}^{`qq'} beta (b / se / p) from the DL estimated with lags 0..`qq'; FE firm+sector-year; `cldesc'"
	qui: putexcel B2 = "Log a"  C2 = "Log tauk"  D2 = "Log taul"  E2 = "Log Df"
	local row = 3
	forv r = 1/4 {
		qui: putexcel A`row' = "`rlab`r''"
		local row = `row' + 3
	}
	qui: putexcel A15 = "N"

	local col = 0
	foreach dep in ln_a_fj ln_tau_k ln_tau_l ln_df {
		local col = `col' + 1
		local L : word `col' of B C D E
		qui: putexcel `L'15 = `=NN[1,`col']'
		local row = 3
		forv r = 1/4 {
			qui: putexcel `L'`row' = `=round(B[`r',`col'], 1e-3)'
			qui: putexcel `L'`=`row'+1' = `=round(S1[`r',`col'], 1e-3)'
			qui: putexcel `L'`=`row'+2' = `=round(P1[`r',`col'], 1e-3)'
 
			local row = `row' + 3
		}
	}
}
 
********************************************************************************
** Collecting estimates from the distributed lag model 
********************************************************************************
forv q = 8/8 {
	use "DATA/TEMP/shock_valid_reg", clear
	merge m:1 kis year using `conndta', keep(1 3) nogen
	replace conn = 0 if missing(conn)
	replace conn = 0 if !inrange(year, `chun_lo', `roh_hi')
	local cl firmid
	local FE firmid sec_year_id
	local X cum_tech ht_loan ht_kotnum conn

	qui: keep if inrange(year, 1972, 1995)
	qui: keep if ini_status == 1  
	qui: sort firmid year
	qui: xtset firmid year

	foreach v in `X' {
		forv i = 0/`q' {
			qui: gen L`i'`v' = L`i'.`v'
			qui: replace L`i'`v' = 0 if missing(L`i'`v')
		}
	}

	local Xlag
	foreach v in `X' {
		forv l = 0/`q' {
			local Xlag `Xlag' L`l'`v'
		}
	}

	foreach dep in ln_a_fj ln_tau_k ln_tau_l ln_df {
		qui: reghdfe `dep' `Xlag', a(`FE') cluster(`cl')
		qui: gen bcons_`dep' = _b[_cons]

		foreach x in `X' {
			forv l = 0/`q' {
				qui: gen b`l'`x'_`dep' = _b[L`l'`x']
			}
		}

		preserve
			qui: gen ones = 1
			qui: duplicates drop ones, force
			qui: keep b*tech* b*loan* b*kot* b*conn* bcons* ones
			qui: save "DATA/TEMP/dlcoef_polcon_`dep'", replace
		restore
	}

	clear
	qui: use "DATA/TEMP/dlcoef_polcon_ln_a_fj", clear
	foreach dep in ln_tau_k ln_tau_l ln_df {
		qui: merge 1:1 ones using "DATA/TEMP/dlcoef_polcon_`dep'", nogen
	}
	save "DATA/TEMP/dlcoef_polcon_q`q'", replace

	foreach dep in ln_a_fj ln_tau_k ln_tau_l ln_df {
		qui: capture: erase "DATA/TEMP/dlcoef_polcon_`dep'.dta"
	}
}

********************************************************************************
** Construction of alternative shock series baed on the estimates from the Distributed Lag model 
********************************************************************************
import delimited using "OUTPUT/result_base.csv", clear
keep firmid year a_fj tau_k tau_l df top3 
foreach var in a_fj tau_k tau_l df  {
	gen ln_`var' = ln(`var')
}
drop if firmid <= 0
save "DATA/TEMP/baseline_shock", replace

forv q = 8(-1)8 {
	qui: use "DATA/TEMP/shock_valid_reg", clear
	qui: drop a_fj tau_k tau_l df ln_a_fj ln_tau_k ln_tau_l ln_df ht_df top3 
	qui: merge 1:1 firmid year using "DATA/TEMP/baseline_shock", nogen
	qui: capture: gen ones = 1

	qui: merge n:1 kis using "DATA/matlab_firmid_kis_mapping", keep(1 3) nogen
	qui: merge 1:1 kis year using "DATA/firm_balance", keep(1 3) nogen
	qui: merge n:1 kis using "DATA/kis_region", keep(1 3) nogen
	qui: merge n:1 kis using "DATA/FIRM_SEC", keep(1 3) nogen
	qui: merge n:1 ones using "DATA/TEMP/dlcoef_polcon_q`q'", keep(1 3) nogen
	* bribing dummy (ever-affiliated, bribery-only) -- the 4th regressor
	qui: merge m:1 kis year using `conndta', keep(1 3) nogen
	qui: replace conn = 0 if missing(conn)
	qui: replace conn = 0 if !inrange(year, `chun_lo', `roh_hi')
	* firm ever conn-treated: bribing corrections apply to ALL business-group firms
	qui: egen byte evconn = max(conn), by(firmid)
	qui: sort firmid year
	qui: xtset firmid year
	qui: local X cum_tech ht_loan ht_kotnum conn

	gen hci_status = (min_year >= 1972 & min_year <= 1979)

	** Ind policy
	local midy = 1979
	local iniy = 1972
	local breaky =`midy' +`q' + 1
	local growthy = `breaky' + 1

	foreach y in `iniy' `midy' {
		gen temp_cum_tech`y' = cum_tech if year == `y'
		bysort firmid: egen cum_tech`y' = max(temp_cum_tech`y')
	}

	foreach v in ht_loan ht_kotnum conn {
		forv l = 0/10 {
			qui: gen L`l'`v' = L`l'.`v'
			qui: replace L`l'`v' = 0 if missing(L`l'`v')
		}
	}

	bysort firmid (year): gen ini_cum_tech = cum_tech[1]
	forv l = 0/10 {
		qui: gen L`l'cum_tech = L`l'.cum_tech
		replace L`l'cum_tech = ini_cum_tech if missing(L`l'cum_tech) & L`l'.year == min_year
		replace L`l'cum_tech = 0 if missing(L`l'cum_tech)
	}
	capture: drop *cum_tech19*

	* Yearly growth
	foreach var in a_fj df tau_k tau_l {
		qui: gen g`var' = `var'/L1.`var'
	}

	foreach x in `X'{
		foreach v in ln_a_fj ln_df ln_tau_k ln_tau_l {
			forv k = 0/`q' {
				qui: bys year: egen temp_b`k'`x'_`v' =  max(b`k'`x'_`v')
				qui: replace b`k'`x'_`v' = temp_b`k'`x'_`v' if missing(b`k'`x'_`v')
			}
		}
	}

	** THREE counterfactual scenarios (user 2026-07-20):
	**   all   = remove ind. policy AND bribing  -> shock_DL_polcon.xlsx
	**   ind   = remove ind. policy only          -> shock_DL_polcon_ind.xlsx
	**   bribe = remove bribing only              -> shock_DL_polcon_bribe.xlsx
	foreach scen in all ind bribe {
		if "`scen'" == "all" {
			local xl_a cum_tech ht_kotnum
			local xl_k ht_loan
			local xl_l conn
			local fx "INPUT/shock_DL_polcon.xlsx"
		}
		else if "`scen'" == "ind" {
			local xl_a cum_tech ht_kotnum
			local xl_k ht_loan
			local xl_l
			local fx "INPUT/shock_DL_polcon_ind.xlsx"
		}
		else {
			local xl_a
			local xl_k
			local xl_l conn
			local fx "INPUT/shock_DL_polcon_bribe.xlsx"
		}

		capture drop cln_a_fj cln_df cln_tau_k cln_tau_l ca_fj ctau_k ctau_l cdf
		foreach var in a_fj df tau_k tau_l {
			qui: gen cln_`var' = ln_`var'
		}

		foreach v in ln_a_fj ln_tau_k ln_tau_l {
			if "`v'" == "ln_a_fj" {
				local xlist `xl_a'
			}
			else if "`v'" == "ln_tau_k" {
				local xlist `xl_k'
			}
			else if "`v'" == "ln_tau_l" {
				local xlist `xl_l'
			}

			foreach x in `xlist' {
				qui: sort firmid year
				forv k = 0/`q' {
					if "`x'" == "conn" {
						qui: replace c`v' = c`v' - b`k'`x'_`v' * L`k'`x'  if inrange(year, 1970, `breaky') 
					}
					else {
						qui: replace c`v' = c`v' - b`k'`x'_`v' * L`k'`x'  if inrange(year, 1970, `breaky') & ini_status == 1  
					}
				}
			}
		}

		foreach v in a_fj tau_k tau_l df {
			qui: gen double c`v'= exp(cln_`v')
		}
		qui: replace cdf = 0 if df == 0
 
		qui: sort firmid year
		forv y = `growthy'/2011 {
			foreach v in a_fj tau_k tau_l {
				qui: bysort firmid (year): replace c`v' = L1.c`v' * g`v' if year == `y' & (!missing(g`v') & !missing(L1.c`v')) & (ini_status == 1 | evconn == 1) 
			}
		}

		qui: replace cdf = df
		qui: count if missing(ca_fj)

		preserve
			keep secid firmid year ca_fj ctau_k ctau_l cdf
			order secid firmid year ca_fj ctau_k ctau_l cdf
			rename (ca_fj ctau_k ctau_l cdf) (a_fj tau_k tau_l df)
			capture confirm file "`fx'"
			if _rc {
				export excel using "`fx'", sheet("lag`q'") keepcellfmt firstrow(var)
			}
			else {
				export excel using "`fx'", sheet("lag`q'", modify) keepcellfmt firstrow(var)
			}
			di as txt "  exported `fx' sheet lag`q' [scenario `scen']"
		restore
	}
}


********************************************************************************
** Alternative shock series only for top 3 
********************************************************************************
import delimited using "OUTPUT/result_base.csv", clear
keep firmid year a_fj tau_k tau_l df top3 
foreach var in a_fj tau_k tau_l df  {
	gen ln_`var' = ln(`var')
}
drop if firmid <= 0
save "DATA/TEMP/baseline_shock", replace


forv q = 8(-1)8 {

	qui: use "DATA/TEMP/shock_valid_reg", clear
	qui: drop a_fj tau_k tau_l df ln_a_fj ln_tau_k ln_tau_l ln_df ht_df top3 
	qui: merge 1:1 firmid year using "DATA/TEMP/baseline_shock", nogen
	qui: capture: gen ones = 1

	qui: merge n:1 kis using "DATA/matlab_firmid_kis_mapping", keep(1 3) nogen
	qui: merge 1:1 kis year using "DATA/firm_balance", keep(1 3) nogen
	qui: merge n:1 kis using "DATA/kis_region", keep(1 3) nogen
	qui: merge n:1 kis using "DATA/FIRM_SEC", keep(1 3) nogen
	qui: merge n:1 ones using "DATA/TEMP/dlcoef_polcon_q`q'", keep(1 3) nogen
	qui: merge m:1 kis year using `conndta', keep(1 3) nogen
	qui: replace conn = 0 if missing(conn)
	qui: replace conn = 0 if !inrange(year, `chun_lo', `roh_hi')
	qui: egen byte evconn = max(conn), by(firmid)
	qui: sort firmid year
	qui: xtset firmid year
	qui: local X cum_tech ht_loan ht_kotnum conn

	gen hci_status = (min_year >= 1972 & min_year <= 1979)

	** Ind policy
	local midy = 1979
	local iniy = 1972
	local breaky =`midy' +`q' + 1
	local growthy = `breaky' + 1

	foreach y in `iniy' `midy' {
		gen temp_cum_tech`y' = cum_tech if year == `y'
		bysort firmid: egen cum_tech`y' = max(temp_cum_tech`y')
	}

	foreach v in ht_loan ht_kotnum conn {
		forv l = 0/10 {
			qui: gen L`l'`v' = L`l'.`v'
			qui: replace L`l'`v' = 0 if missing(L`l'`v')
		}
	}

	bysort firmid (year): gen ini_cum_tech = cum_tech[1]
	forv l = 0/10 {
		qui: gen L`l'cum_tech = L`l'.cum_tech
		replace L`l'cum_tech = ini_cum_tech if missing(L`l'cum_tech) & L`l'.year == min_year
		replace L`l'cum_tech = 0 if missing(L`l'cum_tech)
	}
	capture: drop *cum_tech19*

	* Yearly growth
	foreach var in a_fj df tau_k tau_l {
		qui: gen g`var' = `var'/L1.`var'
	}

	foreach x in `X'{
		foreach v in ln_a_fj ln_df ln_tau_k ln_tau_l {
			forv k = 0/`q' {
				qui: bys year: egen temp_b`k'`x'_`v' =  max(b`k'`x'_`v')
				qui: replace b`k'`x'_`v' = temp_b`k'`x'_`v' if missing(b`k'`x'_`v')
			}
		}
	}

	** THREE counterfactual scenarios (user 2026-07-20):
	**   all   = remove ind. policy AND bribing  -> shock_DL_polcon.xlsx
	**   ind   = remove ind. policy only          -> shock_DL_polcon_ind.xlsx
	**   bribe = remove bribing only              -> shock_DL_polcon_bribe.xlsx
	foreach scen in all ind bribe {
		if "`scen'" == "all" {
			local xl_a cum_tech ht_kotnum
			local xl_k ht_loan
			local xl_l conn
			local fx "INPUT/shock_DL_polcon_t3.xlsx"
		}
		else if "`scen'" == "ind" {
			local xl_a cum_tech ht_kotnum
			local xl_k ht_loan
			local xl_l
			local fx "INPUT/shock_DL_polcon_ind_t3.xlsx"
		}
		else {
			local xl_a
			local xl_k
			local xl_l conn
			local fx "INPUT/shock_DL_polcon_bribe_t3.xlsx"
		}

		capture drop cln_a_fj cln_df cln_tau_k cln_tau_l ca_fj ctau_k ctau_l cdf
		foreach var in a_fj df tau_k tau_l {
			qui: gen cln_`var' = ln_`var'
		}

		foreach v in ln_a_fj ln_tau_k ln_tau_l {
			if "`v'" == "ln_a_fj" {
				local xlist `xl_a'
			}
			else if "`v'" == "ln_tau_k" {
				local xlist `xl_k'
			}
			else if "`v'" == "ln_tau_l" {
				local xlist `xl_l'
			}

			foreach x in `xlist' {
				qui: sort firmid year
				forv k = 0/`q' {
					if "`x'" == "conn" {
						qui: replace c`v' = c`v' - b`k'`x'_`v' * L`k'`x'  if inrange(year, 1970, `breaky') & top3 == 1 
					}
					else {
						qui: replace c`v' = c`v' - b`k'`x'_`v' * L`k'`x'  if inrange(year, 1970, `breaky') & ini_status == 1 & top3 == 1 
					}
				}
			}
		}

		foreach v in a_fj tau_k tau_l df {
			qui: gen double c`v'= exp(cln_`v')
		}
		qui: replace cdf = 0 if df == 0
 
		qui: sort firmid year
		forv y = `growthy'/2011 {
			foreach v in a_fj tau_k tau_l {
				qui: bysort firmid (year): replace c`v' = L1.c`v' * g`v' if year == `y' & (!missing(g`v') & !missing(L1.c`v')) & (ini_status == 1 | evconn == 1) & top3 == 1 
			}
		}
		qui: replace cdf = df
		qui: count if missing(ca_fj)

		preserve
			keep secid firmid year ca_fj ctau_k ctau_l cdf
			order secid firmid year ca_fj ctau_k ctau_l cdf
			rename (ca_fj ctau_k ctau_l cdf) (a_fj tau_k tau_l df)
			capture confirm file "`fx'"
			if _rc {
				export excel using "`fx'", sheet("lag`q'") keepcellfmt firstrow(var)
			}
			else {
				export excel using "`fx'", sheet("lag`q'", modify) keepcellfmt firstrow(var)
			}
			di as txt "  exported `fx' sheet lag`q' [scenario `scen']"
		restore
	}
}

 