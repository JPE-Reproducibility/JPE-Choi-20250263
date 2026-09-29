local before  = 4                         // event window = [-`before', +`after']
local after   = 6
local ref     = -1                       // Reference year 
 
********************************************************************************
** Import sales and export vector to use as weights for regression 
********************************************************************************
import delimited using "OUTPUT/result_base_notruncation_nosmoothing.csv", clear
drop in 1
capture: gen export_vec = p_x * y_x 
capture: gen sale_vec  = p_x * y_x + p_d * y_d 
keep firmid year sale_vec export_vec k l
destring firmid year sale_vec export_vec k l, replace force
drop if firmid < 0
gen double sale_dom = sale_vec - export_vec        // domestic real revenue = total - export
replace sale_dom = . if sale_dom < 0
bysort firmid year: keep if _n == 1
tempfile _salesf
save `_salesf'

********************************************************************************
** Chun-bribery firms 
********************************************************************************
import delimited using "RAW/political_events/political_events.csv", clear bindquote(strict) maxquotedrows(unlimited)
keep if inlist(episode, "roh_bribe", "chun_bribe", "ilhae", "saesedae_heart")
destring g_code3 year_start, replace force
drop if missing(g_code3)
preserve
    keep g_code3
    duplicates drop
    gen gcode = g_code3
    gen byte bribed_grp = 1
    keep gcode bribed_grp
    save "DATA/TEMP/_tmp_pc_bribing.dta", replace
restore

* Group-specific first-bribery time to Roh 
preserve
    keep if episode == "roh_bribe"
    collapse (min) rohyr = year_start, by(g_code3)
    gen gcode = g_code3
    keep gcode rohyr
    save "DATA/TEMP/_tmp_pc_roh.dta", replace
restore
keep if inlist(episode, "chun_bribe", "ilhae", "saesedae_heart")  // Chun-era only -> first Chun bribe/donation
tempfile _pc_bribes
save `_pc_bribes', replace
 
use `_pc_bribes', clear 
collapse (min) event_year = year_start, by(g_code3)
gen gcode = g_code3
keep gcode event_year
save "DATA/TEMP/_tmp_pc_chun.dta", replace
 
* Keep only cohorts whose event window overlaps the panel enough (leading terms estimable)                    
preserve
    import delimited using "OUTPUT/result_base_notruncation_nosmoothing.csv", clear
    drop in 1
    drop if firmid < 0
    qui su year
    local panel_min = r(min)
    local panel_max = r(max)
restore

gen byte _feas = (event_year - 3 >= `panel_min') & (event_year <= `panel_max')
count if _feas == 0
if r(N) {
    list gcode event_year if _feas == 0, noobs clean
    drop if _feas == 0
}
drop _feas
save "DATA/TEMP/_tmp_pc_chun.dta", replace
 
********************************************************************************
** Group membership panel  
********************************************************************************
use "DATA/group_history.dta", clear
qui summ year, meanonly
local _ghmin = r(min)
local _nyr   = 1988 - `_ghmin'
bysort kis: egen byte _everposco = max(g_code3 == "346")
bysort kis: egen double _minyr   = min(year)
preserve
    keep if _everposco == 1 & _minyr >= 1988
    bysort kis: keep if _n == 1
    keep kis
    expand `_nyr'
    bysort kis: gen year = `_ghmin' + _n - 1
    gen g_code3 = "346"
    tempfile _pfill
    save `_pfill'
restore
drop _everposco _minyr
append using `_pfill'
save "DATA/TEMP/_ghist_pb.dta", replace

use "DATA/TEMP/_ghist_pb.dta", clear
destring g_code3, gen(gcode) force
gen double kisn = real(kis)
keep kisn year gcode
bysort kisn year: keep if _n == 1
save "DATA/TEMP/_tmp_pc_ghist.dta", replace

* Ever-bribed to Chun 
preserve
    use "DATA/TEMP/_tmp_pc_ghist.dta", clear
    merge m:1 gcode using "DATA/TEMP/_tmp_pc_chun.dta", keep(3) keepusing(event_year) nogen
    bysort kisn: keep if _n==1
    gen byte ever_chuntr = 1
    keep kisn ever_chuntr
    save "DATA/TEMP/_tmp_pc_everchun.dta", replace
restore
 
preserve
	use "DATA/TEMP/_tmp_pc_chun.dta", clear
	levelsof gcode, local(allchun)
	foreach g of local allchun {
		qui su event_year if gcode==`g', meanonly
		local ccoh`g' = r(mean)
	}
restore

tempfile compacc

local firstc = 1

foreach g of local allchun {
    local cg = `ccoh`g''

    * Treated group 
    preserve
		use "DATA/TEMP/_ghist_pb.dta", clear
		destring g_code3, gen(gcode) force
		gen double kisn = real(kis)
		keep if inrange(year, `cg'-5, `cg'-1)	// Should have operated -5 to -1 before the event
		merge m:1 gcode using "DATA/TEMP/_tmp_pc_chun.dta", keep(1 3) keepusing(event_year) nogen
		gen byte xtr = (gcode==`g')
		gen byte xta = !missing(event_year)
		collapse (max) c_treated=xtr c_treatedany=xta, by(kisn)
		tempfile _compt
		save `_compt', replace
    restore

    * Control group 
    preserve
		use "DATA/TEMP/_ghist_pb.dta", clear
		destring g_code3, gen(gcode) force
		gen double kisn = real(kis)
		keep if inrange(year, 1977, 1978)
		merge m:1 gcode using "DATA/TEMP/_tmp_pc_bribing.dta", keep(1 3) keepusing(bribed_grp) nogen
		gen byte xbr = (bribed_grp==1)
		gen byte xgr = !missing(gcode)
		collapse (max) c_brib=xbr c_grp=xgr, by(kisn)
		tempfile _compc
		save `_compc', replace
    restore

    * Merge treated and congrol groups 
    preserve
		use `_compt', clear
		merge 1:1 kisn using `_compc', nogen
		foreach v in c_treated c_treatedany c_brib c_grp {
			replace `v' = 0 if missing(`v')
		}
		save "DATA/TEMP/_tmp_pc_comp_`g'.dta", replace
		gen double compg = `g'
		if `firstc'==1  save `compacc', replace
		else {
			append using `compacc'
			save `compacc', replace
		}
		local firstc = 0
    restore
}
preserve
	use `compacc', clear
	save "DATA/TEMP/_tmp_pc_comp.dta", replace
restore
 
preserve
	use "DATA/TEMP/_ghist_pb.dta", clear
	destring g_code3, gen(gcode) force
	gen double kisn = real(kis)
	drop if missing(gcode)
	contract kisn gcode                              
	bysort kisn (_freq gcode): keep if _n == _N     
	rename gcode hz_gcode
	keep kisn hz_gcode
	save "DATA/TEMP/_tmp_pc_modalgrp.dta", replace
restore
 
preserve
	use "DATA/TEMP/_ghist_pb.dta", clear
	destring g_code3, gen(gcode) force
	gen double kisn = real(kis)
	drop if missing(gcode)
	keep if inrange(year, 1977, 1978)	// Restrict the control firms to have operated pre-Chun period 
	merge m:1 gcode using "DATA/TEMP/_tmp_pc_bribing.dta", keep(1 3) keepusing(bribed_grp) nogen
	gen byte isbrib = (bribed_grp==1)
	contract kisn gcode isbrib                        
	gsort kisn -isbrib -_freq -gcode                   
	by kisn: keep if _n == 1
	rename gcode roh_gcode
	keep kisn roh_gcode
	save "DATA/TEMP/_tmp_pc_rohgrp.dta", replace
restore

********************************************************************************
** Merging datasets 
********************************************************************************
import delimited using "OUTPUT/result_base_notruncation_nosmoothing.csv", clear
drop in 1
drop if firmid < 0
merge n:1 firmid using "DATA/matlab_firmid_kis_mapping", keep(1 3) nogen
gen double kisn = real(kis)
foreach var in a_fj tau_l tau_k df_tilde {
    capture drop ln_`var'
    gen ln_`var' = ln(`var')
}
keep firmid kisn secid year ln_a_fj ln_tau_l ln_tau_k ln_df_tilde
 
merge m:1 kisn using "DATA/TEMP/_tmp_pc_modalgrp.dta", keep(1 3) keepusing(hz_gcode) nogen
merge m:1 kisn using "DATA/TEMP/_tmp_pc_rohgrp.dta",   keep(1 3) keepusing(roh_gcode) nogen
merge m:1 kisn using "DATA/TEMP/_tmp_pc_everchun.dta", keep(1 3) keepusing(ever_chuntr) nogen
replace ever_chuntr = 0 if missing(ever_chuntr)
save "DATA/TEMP/_tmp_pc_base.dta", replace
 
preserve
    use "DATA/TEMP/_tmp_pc_base.dta", clear
    keep kisn
    bysort kisn: keep if _n==1
    merge 1:m kisn using "DATA/TEMP/_tmp_pc_comp.dta", keep(3) nogen    // comp firms that are in the wedge panel
    levelsof compg if c_treated==1, local(tgroups)
restore
 
* Drop Kukge group 
local _keep
foreach g of local tgroups {
	if `g' != 28  local _keep `_keep' `g'
}
local tgroups `_keep'

foreach g of local tgroups {
	local coh_`g' = `ccoh`g''
}
 
********************************************************************************
** Building stacked dataset
********************************************************************************
local outlist  
tempfile stk
local first = 1
foreach g of local tgroups {
	local cg = `coh_`g''                                          
	use "DATA/TEMP/_tmp_pc_base.dta", clear
	keep if inrange(year, `cg'-`before', `cg'+`after')         
	merge m:1 kisn using "DATA/TEMP/_tmp_pc_comp_`g'.dta", keep(1 3) nogen 
	foreach v in c_treated c_brib c_treatedany c_grp {
		replace `v' = 0 if missing(`v')
	}
	gen byte ever_treated = c_treated                            
	gen byte never_treat = 0
	replace never_treat = (c_brib==1 & c_treatedany==0)  
	replace never_treat = 0 if ever_treated==1                     
	replace never_treat = 0 if ever_chuntr==1	//drop from aLL control pools any firm ever affiliated with a Chun-connected group 
	replace never_treat = 0 if !inrange(secid, 1, 11)
	keep if ever_treated==1 | never_treat==1
	drop if never_treat==1 & year >= 1988 // 1988: Roh's start of the presidency 
	gen double gclus = 1000000 + firmid
	
	* Constructing clustering vars 
	replace gclus = hz_gcode if !missing(hz_gcode)
	replace gclus = roh_gcode if never_treat==1 & !missing(roh_gcode)
	replace gclus = `g'      if ever_treated==1
	gen stack = `g'                                              
	gen rel   = year - `cg'
 
	bysort stack year: egen byte _hasc = max(never_treat==1)
	drop if _hasc==0
	drop _hasc
	if `first'==1  save `stk', replace
	else {
		append using `stk'
		save `stk', replace
	}
	local first = 0
}
use `stk', clear
 
** Constructing pre-event average from -5 to -1 
capture drop fsize fsize_dom fsize_l fsize_k fsize_x
gen double _cohort = year - rel
local _npre = (-1) - (-5) + 1             
preserve
	bysort stack firmid: keep if _n == 1
	keep stack firmid _cohort
	expand `_npre'
	bysort stack firmid: gen tau = (-5) + _n - 1     // -5 .. -1
	gen year = _cohort + tau
	merge m:1 firmid year using `_salesf', keep(1 3) nogen
	foreach v in sale_dom l k export_vec {             
		replace `v' = . if tau > -1 
	}
	collapse (mean) fsize_dom=sale_dom fsize_l=l fsize_k=k fsize_x=export_vec, by(stack firmid)
	tempfile _fsz
	save `_fsz'
restore
merge m:1 stack firmid using `_fsz', keep(1 3) nogen
drop _cohort
 
* Relative-time dummies  
local relvars
forvalues k = `before'(-1)1 {
	if (-`k' != `ref') {
		gen g_m`k' = (rel == -`k') & ever_treated==1
		local relvars `relvars' g_m`k'
	}
}
forvalues k = 0/`after' {
	if (`k' != `ref') {
		gen g_f`k' = (rel == `k') & ever_treated==1
		local relvars `relvars' g_f`k'
	}
}
 
* Construt weight: Pre-event size X (Nt / Nc)
bysort stack: egen double nt = total(ever_treated==1)
bysort stack: egen double nc = total(ever_treated==0)
gen double cf = cond(ever_treated==1, 1, nt/nc)          // Cengiz treated:control balance factor
save "DATA/TEMP/polcon_stacked.dta", replace

foreach y in ln_a_fj ln_tau_l ln_tau_k ln_df_tilde {
	capture drop wt
	local _hv = cond("`y'"=="ln_a_fj","fsize_dom", cond("`y'"=="ln_tau_l","fsize_l", cond("`y'"=="ln_tau_k","fsize_k", cond("`y'"=="ln_df_tilde","fsize_x","fsize_dom"))))
	gen double wt = `_hv' * cf
	replace wt = . if wt <= 0
	local wgt "[aw=wt]"
 
	local absfe stack#firmid stack#year secid#year
	local cl gclus
	reghdfe `y' `relvars' `wgt', absorb(`absfe') cluster(`cl')
	capture drop _esamp
	gen byte _esamp = e(sample)

	* Plot graphs 
	tempfile _anres
	capture postclose _anpf
	postfile _anpf double(et b lb95 ub95 lb90 ub90) using "`_anres'", replace
	matrix _bb = e(b)
	matrix _VV = e(V)
	local _df = e(df_r)
	if missing(`_df')  local _df = e(N_clust) - 1
	local _z95 = invttail(`_df', .025)
	local _z90 = invttail(`_df', .05)
	foreach c of local relvars {
		local et = .
		if regexm("`c'","^g_m([0-9]+)$")  local et = -1*real(regexs(1))
		if regexm("`c'","^g_f([0-9]+)$")  local et =    real(regexs(1))
		local jc = colnumb(_bb, "`c'")
		if `jc' < . {
			local b  = _bb[1,`jc']
			local se = sqrt(_VV[`jc',`jc'])
			post _anpf (`et') (`b') (`b'-`_z95'*`se') (`b'+`_z95'*`se') (`b'-`_z90'*`se') (`b'+`_z90'*`se')
		}
	}
	post _anpf (`ref') (0) (0) (0) (0) (0)                          // omitted reference period pinned to 0
	postclose _anpf
	
	if "`y'" == "ln_a_fj" local figname FIGUREB11_A
	if "`y'" == "ln_tau_k" local figname FIGUREB11_B
	if "`y'" == "ln_tau_l" local figname FIGUREB11_C
	if "`y'" == "ln_df_tilde" local figname FIGUREB11_D
	
	preserve
		use "`_anres'", clear
		sort et

		twoway (rarea ub90 lb90 et, color("55 126 184%25") lwidth(none)) ///
			(connected b et, lcolor("55 126 184") mcolor("55 126 184") msymbol(O) msize(medium) lwidth(medthick)) ///
			, yline(0, lcolor(gs7) lpattern(dash) lwidth(thin)) ///
			  xline(`ref', lcolor(gs9) lpattern(shortdash) lwidth(thin)) ///
			  xtitle("Years since first bribery", size(3.82)) ///
			  xlabel(-`before'(1)`after', labsize(2.6) grid glcolor(gs14) glpattern(dash) glwidth(thin)) ///
			  ylabel(, angle(horizontal) format(%3.1f) labsize(2.6) grid glcolor(gs14) glpattern(dash) glwidth(thin)) ///
			  legend(off) graphregion(color(white)) plotregion(margin(medsmall))
		graph export "FIGURE/`figname'.pdf", replace
	restore
}
 
********************************************************************************
** Table B5: Group Bribery Summary 
********************************************************************************
import delimited using "RAW/political_events/political_events.csv", clear varnames(1) bindquote(strict) maxquotedrows(unlimited)
keep g_code3 group
destring g_code3, replace force
drop if missing(g_code3) | group==""
gen _nl = length(group)
bysort g_code3 (_nl group): keep if _n==1
rename g_code3 gcode_key
keep gcode_key group
replace group = "Taepyongyang" if strpos(group, "Taepyongyang")   
replace group = "LG" if strpos(group, "Lucky")                    
replace group = "SK" if group == "SK Group"                      
tempfile gi_names
save `gi_names'
 
preserve
	clear
	input double gcode_key str40 group
	87 "Daehan Heavy Machinery"
	107 "Dong-A Motor"
	149 "Baekhwa Brewing"
	405 "Heesung"
	end
	gen byte _src = 1
	append using `gi_names'
	replace _src = 0 if missing(_src)
	bysort gcode_key (_src): keep if _n==1
	drop _src
	save `gi_names', replace
restore

* Treated group 
use "DATA/TEMP/polcon_stacked.dta", clear
keep if ever_treated==1
gen coh = year - rel
egen _tag = tag(stack firmid)
collapse (mean) cohort=coh (sum) n_treat=_tag, by(stack)
gen gcode_key = stack
merge m:1 gcode_key using `gi_names', keep(1 3) nogen
replace group = "group " + string(stack) if missing(group)
gsort cohort -n_treat group
qui su n_treat
local Ntreat = r(sum)
local Ntg    = _N
save "DATA/TEMP/_gi_treated.dta", replace                

* Control group 
use "DATA/TEMP/polcon_stacked.dta", clear
keep if ever_treated==0
egen _ftag = tag(gclus firmid)
collapse (sum) n_ctrl_firms=_ftag, by(gclus)
gen byte _nongrp = gclus >= 1000000
gen gcode_key = gclus
merge m:1 gcode_key using `gi_names', keep(1 3) nogen
replace group = "(non-group standalone firm)" if _nongrp
replace group = "group " + string(gclus) if missing(group) & !_nongrp
gsort -n_ctrl_firms group
save "DATA/TEMP/_gi_ctrlroster.dta", replace

use "DATA/firm_balance.dta", clear
collapse (median) exr gdpdef_us, by(year)
drop if missing(exr) | missing(gdpdef_us)
qui su gdpdef_us if year==2011, meanonly
local BD = r(mean)
tempfile usdmacro
save `usdmacro'

import delimited using "RAW/political_events/political_events.csv", clear varnames(1) bindquote(strict) maxquotedrows(unlimited)
keep if inlist(episode,"chun_bribe","ilhae","saesedae_heart","saesedae_edu","roh_bribe")
destring g_code3 year_start amount_bn_won, replace force
drop if missing(g_code3) | missing(year_start)
drop if missing(amount_bn_won) | amount_bn_won<=0       
drop if strpos(upper(group),"TOTAL")
rename year_start year
merge m:1 year using `usdmacro', keep(3) nogen
gen double b_musd = (amount_bn_won*1e9/exr) * (`BD'/gdpdef_us) / 1e6
collapse (sum) bribe_musd=b_musd, by(g_code3)
rename g_code3 gcode_key
tempfile brusd
save `brusd'

use "DATA/group_history.dta", clear
destring g_code3, gen(gcode_key) force
gen double kisn = real(kis)
drop if missing(gcode_key) | missing(kisn)
keep gcode_key kisn
duplicates drop
tempfile gkis
save `gkis'

use "DATA/firm_balance.dta", clear
gen double kisn = real(kis)
keep if inrange(year,1980,1993) & !missing(sale) & !missing(kisn)
keep kisn year sale
merge m:1 year using `usdmacro', keep(3) nogen
gen double s_musd = (sale*1000/exr) * (`BD'/gdpdef_us) / 1e6   // sale in thousand won
joinby kisn using `gkis'
collapse (sum) cum=s_musd (count) ny=s_musd, by(gcode_key kisn)
bysort gcode_key (cum): keep if _n==_N                    // group's largest affiliate
gen double avgs_musd = cum/ny
keep gcode_key avgs_musd
tempfile gsales
save `gsales'

* Table B5 
file open _cb using "TABLE/TABLEB5.tex", write replace
file write _cb "\begin{sidewaystable}[htbp]\centering\footnotesize" _n
file write _cb "\caption{Treated and Control Groups: Bribery}" _n
file write _cb "\label{atable:polcon_treat_ctrl}" _n
file write _cb "\begin{tabular}{@{}c@{\hspace{2.5em}}c@{}}" _n
file write _cb "\textbf{(a) Treated groups} (event: first Chun-era bribe/donation) & \textbf{(b) Control groups (later-briber group)} \\[4pt]" _n

* Panel A 
use "DATA/TEMP/_gi_treated.dta", clear
merge m:1 gcode_key using `brusd',  keep(1 3) nogen
merge m:1 gcode_key using `gsales', keep(1 3) nogen
gen double bs_pct = 100*bribe_musd/avgs_musd if avgs_musd>0 & !missing(avgs_musd) & !missing(bribe_musd)
gsort cohort -n_treat group
qui su bribe_musd
local _btot = string(r(sum), "%12.0fc")
file write _cb "\begin{minipage}[t]{0.46\textheight}" _n
file write _cb "\centering" _n
file write _cb "\resizebox{\linewidth}{!}{" _n
file write _cb "\begin{tabular}{l c c r r}" _n "\toprule" _n
file write _cb "Group & Cohort & Firms & Bribe (\textdollar1M) & Bribe / Sale (\%) \\" _n "\midrule" _n
local _ntr = _N
forvalues i = 1/`_ntr' {
	local g = group[`i']
	local g : subinstr local g "&" "\&", all
	local ch = string(cohort[`i'], "%4.0f")
	local nf = n_treat[`i']
	local bm = cond(missing(bribe_musd[`i']), "---", string(bribe_musd[`i'], "%12.1fc"))
	local rt = cond(missing(bs_pct[`i']), "---", string(bs_pct[`i'], "%5.2f"))
	file write _cb `"`g' & `ch' & `nf' & `bm' & `rt' \\"' _n
}
file write _cb "\midrule" _n
file write _cb `"\multicolumn{5}{l}{`Ntg' groups, `Ntreat' firms; \textdollar`_btot'M in bribes} \\"' _n
file write _cb "\bottomrule" _n "\end{tabular}}\end{minipage}" _n
file write _cb "&" _n

* Panel B
use "DATA/TEMP/_gi_ctrlroster.dta", clear
merge m:1 gcode_key using `brusd',  keep(1 3) nogen
merge m:1 gcode_key using `gsales', keep(1 3) nogen
replace bribe_musd = . if _nongrp
gen double bs_pct = 100*bribe_musd/avgs_musd if avgs_musd>0 & !missing(avgs_musd) & !missing(bribe_musd)
gsort -n_ctrl_firms group
local _ncc = _N
qui su n_ctrl_firms
local _ncf = r(sum)
qui su bribe_musd
local _ctot = string(r(sum), "%12.0fc")
file write _cb "\begin{minipage}[t]{0.44\textheight}\centering\resizebox{\linewidth}{!}{" _n
file write _cb "\begin{tabular}{lrrr}" _n "\toprule" _n
file write _cb "Group & Firms & Bribe (\textdollar1M) & Bribe / Sale (\%) \\" _n "\midrule" _n
forvalues i = 1/`_ncc' {
	local g = group[`i']
	local g : subinstr local g "&" "\&", all
	local nf = n_ctrl_firms[`i']
	local bm = cond(missing(bribe_musd[`i']), "---", string(bribe_musd[`i'], "%12.1fc"))
	local rt = cond(missing(bs_pct[`i']), "---", string(bs_pct[`i'], "%5.2f"))
	file write _cb `"`g' & `nf' & `bm' & `rt' \\"' _n
}
file write _cb "\midrule" _n
file write _cb `"\multicolumn{4}{l}{`_ncc' clusters, `_ncf' firms; \textdollar`_ctot'M} \\"' _n
file write _cb "\bottomrule" _n "\end{tabular}}" _n
file write _cb "\end{minipage} " _n
file write _cb "\end{tabular}" _n
file write _cb "\end{sidewaystable}" _n
file close _cb


********************************************************************************
** Erase files 
********************************************************************************
qui: capture erase "DATA/TEMP/_tmp_pc_bribing.dta"
qui: capture erase "DATA/TEMP/_tmp_pc_roh.dta"
qui: capture erase "DATA/TEMP/_tmp_pc_modalgrp.dta"
qui: capture erase "DATA/TEMP/_tmp_pc_rohgrp.dta"
qui: capture erase "DATA/TEMP/_tmp_pc_chun.dta"
qui: capture erase "DATA/TEMP/_tmp_pc_ghist.dta"
qui: capture erase "DATA/TEMP/_tmp_pc_everchun.dta"
qui: capture erase "DATA/TEMP/_tmp_preaff.dta"
qui: capture erase "DATA/TEMP/_tmp_pc_base.dta"
qui: capture erase "DATA/TEMP/_tmp_pc_comp.dta"
foreach g of local allchun {
    qui: capture erase "DATA/TEMP/_tmp_pc_comp_`g'.dta"
}
qui: capture erase "DATA/TEMP/polcon_stacked.dta"
qui: capture erase "DATA/TEMP/_gi_treated.dta"
qui: capture erase "DATA/TEMP/_gi_ctrlroster.dta"
qui: capture erase "DATA/TEMP/_ghist_pb.dta"