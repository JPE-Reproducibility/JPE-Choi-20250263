scalar last = 2011

********************************************************************************
** Figure: Real GDP Growth
********************************************************************************

local color orange_red%90 
local lwidth 0.9
 
import delimited using "RAW/AGG/KOR_rGDPpc.csv", clear 
gen year = substr(date, 5, 4)
destring year, replace 
sort year
gen rgdppcg = 100 * (rgdppc / rgdppc[_n-1] - 1)
keep if inrange(year, 1972, `=last')
replace rgdppc = rgdppc / 1000
twoway (line rgdppc year, lwidth(`lwidth') xlabel(1970(5)`=last') ylabel(0(5)27) lcolor(`color') xtitle("Year") ytitle(""))
graph export "FIGURE/FIGURE1_A.pdf", as(pdf) replace  
 
********************************************************************************
** Figure: The Number of Firm-Year Observations
********************************************************************************
use DATA/firm_balance, clear
merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
keep if manu == 1 
bysort year: gen num = _N 
duplicates drop year, force 
keep if inrange(year, 1972, `=last')
qui: sum num 
scalar min_bar = 0.9 * `r(min)'
scalar max_bar = 1.1 * `r(max)'
twoway (bar num year, bcolor(midblue%60) xlabel(1970(5)`=last') lwidth(0.25) lc(navy) ytitle("") xtitle("Year") ///
		yscale(r(`=min_bar' `=max_bar')))  
graph export "FIGURE/FIGUREB1_A.pdf", as(pdf) replace 


********************************************************************************
** Figure: Shares of MFG sectors 
********************************************************************************
use DATA/EUKLEMS, clear 
bysort year: egen agg_GO = sum(GO)
gen manu = (inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244") | inlist(sec, "_24t25", "_26", "_27t28", "_29-34t35", "_30t33", "_36t37"))
collapse (sum) GO (mean) agg_GO, by(year manu)
keep if manu == 1 
gen manush = 100 * GO / agg_GO 
keep if inrange(year, 1972, `=last')
twoway (bar manush year, bcolor(midblue%75) xlabel(1970(5)`=last') lc(navy)  ytitle("") xtitle("Year"))  
graph export "FIGURE/FIGUREB1_C.pdf", as(pdf) replace 

********************************************************************************
** Figure: Shares of Firm-level sales
********************************************************************************
use DATA/EUKLEMS, clear 
gen manu = (inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244") | inlist(sec, "_24t25", "_26", "_27t28", "_29-34t35", "_30t33", "_36t37"))
keep if manu == 1 
collapse (sum) GO, by(year)
save DATA/TEMP/mfg_GO, replace 

use DATA/firm_balance, clear
merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
keep if manu == 1 
collapse (sum) sale, by(year)
merge 1:1 year using DATA/TEMP/mfg_GO, keep(3) nogen 
keep if inrange(year, 1972, `=last')
gen firmsh = 100 * sale / GO 
twoway (bar firmsh year, bcolor(midblue%75) xlabel(1970(5)`=last') lc(navy) ytitle("") xtitle("Year"))  
graph export "FIGURE/FIGUREB1_B.pdf", as(pdf) replace 

********************************************************************************
** Figure: Concentration
********************************************************************************

use DATA/EUKLEMS, clear
qui: do STATA/subcode/SUB_CLASSIFICATION.do
collapse (sum) GO K L LAB, by(year manu)
bysort year: egen natGO = sum(GO)
rename GO manuGO 
save DATA/TEMP/temp_natGO, replace 

foreach v in GO EX { 
	use DATA/IOimpu, clear 
	qui: do STATA/subcode/SUB_CLASSIFICATION.do
	collapse (sum) GO export, by(year manu)
	rename (GO export) (IOmanuGO IOmanuEX)
	keep year IOmanu`v' manu 
	save DATA/TEMP/temp_IOnat`v', replace 
}
 
** Sale (sale + export) concentration 
foreach var in sale sale_dom export { 
	use DATA/firm_balance, clear
	merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
	keep if manu == 1 

	merge n:1 year manu using DATA/TEMP/temp_natGO, keep(1 3) nogen 
	merge n:1 year manu using DATA/TEMP/temp_IOnatGO, keep(1 3) nogen 
	merge n:1 year manu using DATA/TEMP/temp_IOnatEX, keep(1 3) nogen 
	 
	keep if inrange(year, 1972, `=last')	
	replace wbill = . if inrange(year, 1972, 1982)
	replace IOmanuGO = manuGO if !missing(manuGO)

	* Mfg shares of Samsung Electronics (380725) and Hyundai Motor (380954)
	gen firmsh = sale / IOmanuGO 
	sum firmsh if kis == "380725" & year == `=last'
	sum firmsh if kis == "380954" & year == `=last'
	 
	gen ori_sale = sale 
	gen num = sale 
	gen den = IOmanuGO 
	if "`var'" == "sale_dom" {
		replace num = sale - export 
		replace den = IOmanuGO - IOmanuEX 
	}
	else if "`var'" == "export" {
		replace num = export 
		replace den = IOmanuEX 
	}

	* Sort by sale
	gsort sec year - ori_sale 
	bysort sec year: gen rank = _n 
	
	* List of ever top 3 firms: (This file used for Merger.do)
	if "`var'" == "sale" {
		preserve 
			keep if rank <= 3 
			duplicates drop kis, force 
			gen ever_t3 = 1 
			keep kis ever_t3 sec
			save DATA/ever_t3_list, replace 
		restore 	
	}	
	 
	* Calculate CR*
	foreach i in 1 3 5 10 {
		bysort sec year: gen CR`i' = (rank<=`i')	 
	}
	drop rank 
	gen share = num / den
 
	* CR graphs	
	if "`var'" == "sale" {
		local crlist 1 3 5 10
	}
	else {
		local crlist 3 
	}
	
	foreach i of num `crlist' {
		if "`var'" == "sale" & `i' == 3 {
			local figname FIGURE1_B 
		}
		if "`var'" == "sale" & `i' == 1 {
			local figname FIGUREB3_A
		}
		if "`var'" == "sale" & `i' == 5 {
			local figname FIGUREB3_B
		}
		if "`var'" == "sale" & `i' == 10 {
			local figname FIGUREB3_C
		}		
		if "`var'" == "sale_dom" & `i' == 3 {
			local figname FIGUREB2_A
		}
		if "`var'" == "export" & `i' == 3 {
			local figname FIGUREB2_B
		}
 
		preserve
			keep if CR`i'==1
			collapse (sum) share, by(year)
			replace share = 100 * share 
			replace share = . if share == 0 
	 
			qui: sum share 
			scalar min_bar = 0.9 * `r(min)'
			scalar max_bar = 1.1 * `r(max)'
 
			twoway (bar share year, bcolor(orange_red%60) xlabel(1970(5)`=last') lwidth(0.25) lc(navy) ytitle("") xtitle("Year") ///
				yscale(r(`=min_bar' `=max_bar'))) 
			graph export "FIGURE/`figname'.pdf", as(pdf) replace 
		restore		
	}
}

 
********************************************************************************
** Figure: Concentration across whole mfg (Figure B4-A, B)
********************************************************************************
foreach var in sale { 
	use DATA/firm_balance, clear
	merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
	keep if manu == 1 

	merge n:1 year manu using DATA/TEMP/temp_natGO, keep(1 3) nogen 
	merge n:1 year manu using DATA/TEMP/temp_IOnatGO, keep(1 3) nogen 
	merge n:1 year manu using DATA/TEMP/temp_IOnatEX, keep(1 3) nogen 
	 
	keep if inrange(year, 1972, 2011)	
	replace wbill = . if inrange(year, 1972, 1982)
	replace IOmanuGO = manuGO if !missing(manuGO)
	gen ori_sale = sale 
	if "`var'" == "sale_dom" {
		replace sale = sale - export 
		replace IOmanuGO = IOmanuGO - IOmanuEX 
	}
	else if "`var'" == "export" {
		replace sale = export 
		replace IOmanuGO = IOmanuEX 
	}

	* Sort by sale
	gsort year - ori_sale 
	bysort year: gen rank = _n 
	 
	* Calculate CR*
	foreach i in 3 5 10 33 100 {
		by year: gen CR`i' = (rank<=`i')	 
	}
	drop rank
	gen sale_share = sale / IOmanuGO    
 
	* CR graphs	
	foreach i of num 3 100 {
		if `i' == 3 {
			local figname FIGUREB4_A
		}
		if `i' == 100 {
			local figname FIGUREB4_B
		}		
		preserve
			keep if CR`i'==1
			collapse (sum) sale_share, by(year)
			replace sale_share = 100 * sale_share 
			replace sale_share = . if sale_share == 0 
	 
			qui: sum sale_share 
			scalar min_bar = 0.9 * `r(min)'
			scalar max_bar = 1.1 * `r(max)'
			
			twoway (bar sale_share year, bcolor(orange_red%60) xlabel(1970(5)2011) lwidth(0.25) lc(navy) ytitle("") xtitle("Year") ///
				yscale(r(`=min_bar' `=max_bar')))   
			graph export "FIGURE/`figname'.pdf", as(pdf) replace 
		restore		
	}
}

 
********************************************************************************
** Figure: Concentration HHI (Figure B4-C)
********************************************************************************
foreach var in sale {  
	use DATA/firm_balance, clear
	merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
	keep if manu == 1 

	merge n:1 year manu using DATA/TEMP/temp_natGO, keep(1 3) nogen 
	merge n:1 year manu using DATA/TEMP/temp_IOnatGO, keep(1 3) nogen 
	merge n:1 year manu using DATA/TEMP/temp_IOnatEX, keep(1 3) nogen 
	 
	keep if inrange(year, 1972, 2011)	
	replace wbill = . if inrange(year, 1972, 1982)
	replace IOmanuGO = manuGO if !missing(manuGO)
 
	* Sort by sale & Keep only top 50 
	gsort year -  sale 
	bysort year: gen rank = _n 
	keep if rank <= 500 
	
	* Calculate HHI
	bysort year: egen sum_sale = sum(sale)
	gen sale_share = 100 * sale / sum_sale
	gen sale_share_sq = sale_share^2
	bysort year: egen sale_HHI = sum(sale_share_sq)
 
	collapse (firstnm) sale_HHI, by(year)
	replace sale_HHI = . if sale_HHI == 0
	
	qui: sum sale_HHI, detail
	scalar min_bar = 0.9 * `r(min)'
	scalar max_bar = 1.1 * `r(max)'
			
	twoway (bar sale_HHI year, bcolor(orange_red%60) xlabel(1970(5)2011) lwidth(0.25) lc(navy) ytitle("") xtitle("Year") ///
			yscale(r(`=min_bar' `=max_bar')))  
	graph export "FIGURE/FIGUREB4_C.pdf", as(pdf) replace 
}
 
 
 

******************************************************************************** 
** Erase files
******************************************************************************** 
qui: capture: erase DATA/TEMP/temp_IOnatGO.dta 
qui: capture: erase DATA/TEMP/temp_IOnatEX.dta 
qui: capture: erase DATA/TEMP/temp_natGO.dta 
qui: capture: erase DATA/TEMP/mfg_GO.dta 
 