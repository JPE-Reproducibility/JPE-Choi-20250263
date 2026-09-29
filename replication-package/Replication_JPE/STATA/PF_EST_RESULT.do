********************************************************************************
** Baseline 
********************************************************************************
** sigma = 5
local sheet est4s5r2e4p1IV5
qui: import excel using "INPUT/pf_results_mu_x.xlsx", clear sheet("`sheet'") first 
gen ones = 1 
collapse (mean) b* g*, by(ones)

** Broda and Weisntein (2009) sigma
local sheet est4s5r2e4p1IV5
qui: import excel using "INPUT/BWpf_results_mu_x.xlsx", clear sheet("`sheet'") first 
gen ones = 1 
collapse (mean) b* g*, by(ones)

********************************************************************************
** Table B3: Sensitivity analysis of production function estimates
********************************************************************************

capture file close tb3
file open tb3 using "TABLE/TABLEB3.tex", write replace

local npanel 5
forv case = 1/`npanel' {
	if `case' == 1 {
		local sheet  est4s5r2e4p1IV5
		local ptitle `"Panel A. Baseline Estimates"'
	}
	else if `case' == 2 {
		local sheet  est2s5r2e4p1IV5
		local ptitle `"Panel B. Only Non-exporters"'
	}
	else if `case' == 3 {
		local sheet  est5s5r2e4p1IV5
		local ptitle `"Panel C. Only Exporters"'
	}
	else if `case' == 4 {
		local sheet  est4s5r2e4p1IV3
		local ptitle `"Panel D. \(\mathbf{Z}_{fjt} = [\ln k_{fj,t-1}, \ln l_{fj,t-1}, 1, \ln a_{fj,t-1}]'\)"'
	}
	else if `case' == 5 {
		local sheet  est4s5r2e4p3IV5
		local ptitle `"Panel E. \(\ln a_{fjt} = \sum_{p=0}^{3} \iota_{p} (\ln a_{fj,t-1})^{p}\)"'
	}

	qui: import excel using "INPUT/pf_results_mu_x.xlsx", clear sheet("`sheet'") first
	qui: destring _all, replace
	qui: drop if missing(secid)
	qui: drop if secid == 4
	qui: gen lshare = gl / (gl + gk)

	file write tb3 `"\multicolumn{7}{l}{\underline{\textit{`ptitle'}}} \\"' _n

	foreach s in mean p50 sd min max {
		if "`s'" == "mean" local rlab "Mean"
		if "`s'" == "p50"  local rlab "Median"
		if "`s'" == "sd"   local rlab "SD"
		if "`s'" == "min"  local rlab "Min"
		if "`s'" == "max"  local rlab "Max"

		local row "`rlab' &"
		foreach v in gl gk gm g lshare {
			qui: summ `v', detail
			local x : di %4.2f r(`s')
			local row "`row' & `x'"
		}
		file write tb3 `"`row' \\"' _n
	}
	if `case' < `npanel' file write tb3 "[1em]" _n
}
file close tb3


********************************************************************************
** Table B2: Calibrated sigma + production function estimates (baseline & BW)
********************************************************************************
 
foreach blk in bw base {
	if "`blk'" == "base" {
		local wbE "INPUT/pf_results_mu_x.xlsx"
		local wbS "INPUT/BS_pf_results_mu_x.xlsx"

		local spec est4s5r2e4p1IV5
	}
	else {
		local wbE "INPUT/BWpf_results_mu_x.xlsx"
		local wbS "INPUT/BS_BWpf_results_mu_x.xlsx"

		local spec est4s5r2e4p1IV5
	}

	qui: import excel using "`wbE'", clear sheet("`spec'") first
	qui: destring _all, replace
	qui: keep secid sigma gl gk gm g
	qui: drop if missing(secid)
	qui: rename (sigma gl gk gm g) (sig_`blk' b_gl_`blk' b_gk_`blk' b_gm_`blk' b_g_`blk')
	tempfile E_`blk'
	qui: save `E_`blk''
 
	qui: import excel using "`wbS'", clear sheet("se_`spec'") first
	qui: destring _all, replace
	qui: keep secid se_gl se_gk se_gm se_g
	qui: drop if missing(secid)
	qui: rename (se_gl se_gk se_gm se_g) (s_gl_`blk' s_gk_`blk' s_gm_`blk' s_g_`blk')
	tempfile S_`blk'
	qui: save `S_`blk''
 
	qui: import excel using "`wbS'", clear sheet("pval_`spec'") first
	qui: destring _all, replace
	qui: keep secid p_gl p_gk p_gm p_g
	qui: drop if missing(secid)
	qui: rename (p_gl p_gk p_gm p_g) (p_gl_`blk' p_gk_`blk' p_gm_`blk' p_g_`blk')
	tempfile P_`blk'
	qui: save `P_`blk''
 
	use `E_`blk'', clear
	qui: merge 1:1 secid using `S_`blk'', nogen
	qui: merge 1:1 secid using `P_`blk'', nogen
	tempfile B_`blk'
	qui: save `B_`blk''
}

use `B_base', clear
qui: merge 1:1 secid using `B_bw', nogen
qui: drop if missing(secid)
drop if secid == 4                      // pooled into sector 6 -> single table row
sort secid

gen str60 secname = ""
replace secname = "Food, Beverage, \& Tobacco"                     if secid == 1
replace secname = "Textile, Apparel, \& Leather"                   if secid == 2
replace secname = "Wood"                                           if secid == 3
replace secname = "Pharmaceuticals"                                if secid == 5
replace secname = "Chemicals, Plastics, \& Rubber (Petrochemical)" if secid == 6
replace secname = "Non-metallic minerals"                          if secid == 7
replace secname = "Metal"                                          if secid == 8
replace secname = "Machinery, \& Trans. equip."                    if secid == 9
replace secname = "Electronics"                                    if secid == 10
replace secname = "Mfg. nec"                                       if secid == 11

capture file close tb
file open tb using "TABLE/TABLEB2.tex", write replace

forvalues i = 1/`=_N' {
	local est "`=secname[`i']'"
	local ses " "
	foreach blk in base bw {
		local sg : di %4.2f sig_`blk'[`i']
		local est "`est' & `sg'"
		local ses "`ses' & "
		foreach v in gl gk gm g {
			local b : di %4.2f b_`v'_`blk'[`i']
			local s : di %4.2f s_`v'_`blk'[`i']
			local p = p_`v'_`blk'[`i']
			local st = cond(`p' < .01, "\sym{***}", cond(`p' < .05, "\sym{**}", cond(`p' < .1, "\sym{*}", "")))
			local est "`est' & `b'`st'"
			local ses "`ses' & (`s')"
		}
	}
	file write tb `"`est' \\"' _n
	file write tb `"`ses' \\"' _n
}

* Average 
local avg "Mfg. average"
foreach blk in base bw {
	qui: summ sig_`blk', meanonly
	local m : di %4.2f r(mean)
	local avg "`avg' & `m'"
	foreach v in gl gk gm g {
		qui: summ b_`v'_`blk', meanonly
		local m : di %4.2f r(mean)
		local avg "`avg' & `m'"
	}
}
file write tb "\midrule" _n
file write tb `"`avg' \\"' _n
file close tb
 