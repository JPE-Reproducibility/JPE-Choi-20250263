scalar start = 1972 
scalar last = 2011

********************************************************************************
** Names of sectors 
********************************************************************************
qui: use DATA/EUKLEMS, clear 	
qui: sort sec
qui: duplicates drop sec, force
qui: egen secid = group(sec)
qui: keep sec secid 
qui: save DATA/secid, replace 
qui: export delimited using "INPUT/seclist.csv", replace 
 
********************************************************************************
** Sectoral IO Tables
** Source: BOK 
********************************************************************************
* Exactly fit the data of sectoral import shares, sectoral exports, and sectoral gross outputs    
foreach IOyear in 1970 1973 1975 1978 1980 1983 1985 1986 1987 1988 1990 1993 1995 1998 2000 2003 2005 2006 2007 2008 2009 2010 2011 {  
	foreach type in all dom for{ 
		qui: use DATA/IO_`IOyear'_3digit_`type', clear
		qui: collapse (sum) value, by(osec dsec year)	 
		foreach od in o d{
			qui: rename `od'sec sec 
			qui: merge n:1 sec using DATA/secid, keep(1 3) nogen  
			qui: rename (sec secid) (`od'sec `od'secid )
		}
		qui: sort osec dsec 
		qui: save DATA/TEMP/temp_IO_`type'_`IOyear', replace 
	}
 
	qui: use DATA/TEMP/temp_IO_all_`IOyear', clear 
	qui: drop if inlist(dsec, "import_cif", "import_tar", "intcons")
	qui: gen dcountry = "KOR"
	qui: gen ocountry = ""
	qui: replace ocountry = "KOR" if dsec == "export"
	qui: replace dcountry = "ROW" if dsec == "export"
	qui: replace ocountry = "ROW" if dsec == "import"
	qui: replace dcountry = "KOR" if dsec == "import"
	qui: sort osec dsec ocountry dcountry 
	qui: save DATA/TEMP/temp_IO_`IOyear', replace 
 
	* Exporting final consumption good shares: alpha 
	qui: use "DATA/TEMP/temp_IO_`IOyear'", clear 
	qui: replace osec = subinstr(osec, " ", "", .)
	qui: keep if dsec == "fcons"  
	qui: rename (osec osecid) (sec secid)
	qui: drop if missing(secid)
	qui: collapse (sum) value , by(secid sec)
	qui: egen sum_value = sum(value)
	qui: gen fcons = value / sum_value 
	qui: gen year = `IOyear'
	qui: order sec secid year fcons 
	qui: keep sec secid year fcons 
	qui: sort secid 	
	qui: save "DATA/TEMP/fcons_`IOyear'", replace 
	
	* Imports 
	qui: use DATA/TEMP/temp_IO_`IOyear', clear 
	qui: keep if dsec == "import"
	qui: drop if inlist(osec, "GO", "TOT", "VADD", "WBILL")
	qui: collapse (sum) value, by(osec osecid)
	qui: rename (osec osecid value) (sec secid imports)
	qui: gen year = `IOyear'
	qui: keep sec secid year imports
	qui: order sec secid year imports
	qui: sort secid  
	qui: save DATA/TEMP/imports_`IOyear', replace 

	* Import shares 
	* To construct import shares, construct expenditure sahres 
	qui: use DATA/TEMP/temp_IO_`IOyear', clear 
	qui: keep if dsec == "expen"
	qui: drop if inlist(osec, "GO", "TOT", "VADD", "WBILL")
	qui: collapse (sum) value, by(osec osecid)
	qui: rename (osec osecid value) (sec secid expen )
	qui: gen year = `IOyear'	
	qui: keep sec secid year expen 
	qui: order sec secid year expen 
	qui: sort secid  
	qui: save DATA/TEMP/expen_`IOyear', replace 
 
	* Import shares = imports / total expenditure
	qui: use DATA/TEMP/imports_`IOyear', clear 
	qui: merge 1:1 secid using DATA/TEMP/expen_`IOyear', keep(3) nogen  
	qui: gen imsh = imports / expen 	
	qui: keep sec secid year imsh 
	qui: order sec secid year imsh 
	qui: save DATA/TEMP/imsh_`IOyear', replace 
 
	* Sectoral Exports
	qui: use DATA/TEMP/temp_IO_`IOyear', clear
	qui: keep if dsec == "export"
	qui: drop if osecid == . 
	qui: keep osecid osec value 
	qui: rename (osecid osec value) (secid sec exports)	
	qui: gen year = `IOyear'	
	qui: keep sec secid year exports 
	qui: order sec secid year exports 
	qui: save DATA/TEMP/exports_`IOyear', replace 
 
	* Value Added Share: VAsh 
	qui: use DATA/TEMP/temp_IO_`IOyear', clear
	qui: drop if inlist(dsec, "export", "fcons", "expen", "import")
	preserve 
		qui: keep if osec == "GO" 
		qui: rename value GO 
		qui: rename (dsec dsecid) (sec secid)
		qui: drop year 
		qui: gen year = `IOyear'		
		qui: keep sec secid year GO
		qui: order sec secid year GO
		qui: save DATA/TEMP/GO_`IOyear', replace 
	restore
	
	qui: keep if osec == "TOT"
	qui: rename value TOT 
	qui: rename (dsec dsecid) (sec secid)
	qui: keep sec secid TOT
	qui: merge 1:1 sec using DATA/TEMP/GO_`IOyear', keep(3) nogen  
	qui: gen VAsh = 1 - TOT/GO
	qui: drop if secid == .  
 
	qui: keep sec secid year VAsh 
	qui: order sec secid year VAsh 	
	qui: save DATA/TEMP/VAsh_`IOyear', replace 
	
	* Export shares relative to GO 
	qui: use DATA/TEMP/exports_`IOyear', clear 
	qui: merge 1:1 sec using DATA/TEMP/GO_`IOyear', keep(3) nogen  
	qui: gen exsh = exports/ GO 
	qui: save DATA/TEMP/exsh_`IOyear', replace 

	* Exporting intermediage input shares: gamma 
	qui: use DATA/TEMP/temp_IO_`IOyear', clear 
	qui: drop if inlist(osec, "GO", "TOT", "WBILL", "VADD") | inlist(dsec, "export", "fcons", "expen", "import")
	qui: sort osec dsec osecid dsecid 
	qui: collapse (sum) value, by(osec dsec osecid dsecid)
	qui: bysort dsec: egen sum_value =sum(value)
	qui: gen intsh = value / sum_value  

	* Multiple (1- VAsh) 
	qui: rename dsec sec
	qui: merge n:1 sec using DATA/TEMP/VAsh_`IOyear', keep(3)  nogen  
	qui: replace intsh = intsh * (1-VAsh)
	qui: rename sec dsec 
	qui: drop if osecid == . | dsecid == . 
	qui: drop year 
	qui: gen year = `IOyear'
	qui: keep osec dsec osecid dsecid year intsh
	qui: order osec dsec osecid dsecid year intsh
	qui: sort osecid dsecid intsh
	qui: save DATA/TEMP/intsh_`IOyear', replace 
}

foreach var in VAsh imsh intsh exsh fcons {
	clear 
	foreach IOyear in 1970 1973 1975 1978 1980 1983 1985 1986 1987 1988 1990 1993 1995 1998 2000 2003 2005 2006 2007 2008 2009 2010 2011 {
		append using DATA/TEMP/`var'_`IOyear'
	}
	save DATA/TEMP/noimpu_`var', replace 
}

use DATA/TEMP/noimpu_VAsh, clear
merge 1:1 sec year using DATA/TEMP/noimpu_exsh, keep(3) nogen   
merge 1:1 sec year using DATA/TEMP/noimpu_imsh, keep(3) nogen  
merge 1:1 sec year using DATA/TEMP/noimpu_fcons, keep(3) nogen  
 
xtset secid year 
tsfill, full
bysort secid (sec): replace sec = sec[_N]
sort secid year 

* Imputation for missing years: Geometric average 
foreach var in VAsh exports GO imsh exsh fcons {
	gen tag_impu = 1 if missing(`var')
	bysort sec (year): replace `var' = (`var'[_n-1] * `var'[_n+1])^0.5 if !missing(`var'[_n-1]) & !missing(`var'[_n+1]) & missing(`var'[_n])
	bysort sec (year): replace `var' = `var'[_n+2]^(1/3) * `var'[_n-1]^(2/3) if !missing(`var'[_n-1]) & !missing(`var'[_n+2]) & missing(`var'[_n]) & tag_impu[_n+1] == 1 
	bysort sec (year): replace `var' = `var'[_n+1]^(2/3) * `var'[_n-2]^(1/3) if !missing(`var'[_n-2]) & !missing(`var'[_n+1]) & missing(`var'[_n]) & tag_impu[_n-1] == 1 
	drop tag_impu 
}
save DATA/TEMP/impu, replace 
keep exsh sec secid year
save DATA/TEMP/impu_exsh, replace 

** Exporting VAsh, exsh, imsh
foreach var in imsh VAsh fcons {
	preserve 
		use DATA/TEMP/impu, clear
		keep if inrange(year, `=start', `=last')
		keep sec secid year `var'
		sort sec year 
		order sec secid year `var'
		export delimited using "INPUT/`var'.csv", replace 
	restore
}

** Exporting intermediate input shares 
use DATA/TEMP/noimpu_intsh, clear
egen panelid = group(osec dsec)
xtset panelid year 
tsfill, full
foreach var in osec dsec {	
	bysort panelid (`var'): replace `var' = `var'[_N] if missing(`var')
}
foreach var in osecid dsecid {
	bysort panelid (`var'): replace `var' = `var'[1] if missing(`var')
}
foreach var in intsh {
	gen tag_impu = 1 if missing(`var')
	bysort panelid (year): replace `var' = (`var'[_n-1] * `var'[_n+1])^0.5 if !missing(`var'[_n-1]) & !missing(`var'[_n+1]) & missing(`var'[_n])
	bysort panelid (year): replace `var' = `var'[_n+2]^(1/3) * `var'[_n-1]^(2/3) if !missing(`var'[_n-1]) & !missing(`var'[_n+2]) & missing(`var'[_n]) & tag_impu[_n+1] == 1 
	bysort panelid (year): replace `var' = `var'[_n+1]^(2/3) * `var'[_n-2]^(1/3) if !missing(`var'[_n-2]) & !missing(`var'[_n+1]) & missing(`var'[_n]) & tag_impu[_n-1] == 1 
	drop tag_impu 
}

* Vash + Intsh = 1 
rename dsec sec 
merge n:1 sec year using DATA/TEMP/noimpu_VAsh, keep(3) nogen
bysort sec year: egen sum_intsh = sum(intsh)
replace intsh = (intsh / sum_intsh) * (1 - VAsh)
drop sum* 
bysort sec year: egen sum_intsh = sum(intsh)
gen check = sum_intsh + VAsh 
rename sec dsec 
 
keep osec dsec osecid dsecid year intsh 
keep if inrange(year, `=start', `=last')
sort osec dsec year 
order osec dsec osecid dsecid year intsh 
export delimited using "INPUT/intsh.csv", replace 

********************************************************************************
** Real GDP growth
** Source: FRED
********************************************************************************
qui: import delimited using "RAW/AGG/population.csv", clear 
keep if inrange(year, 1972, `=last')
save "DATA/TEMP/pop", replace 

qui: import delimited using "RAW/AGG/KOR_rGDPpc.csv", clear 
qui: gen year = substr(date, 5, 8)
qui: destring year, replace 
qui: merge 1:1 year using DATA/TEMP/pop, keep(3) nogen 
qui: gen rGDP = rgdppc * population
qui: gen rGDPg = (rGDP / rGDP[_n-1] - 1)
qui: keep if inrange(year, `=start', `=last')
qui: keep year rGDPg 
qui: order year rGDPg 
qui: sort year
qui: export delimited using "INPUT/rGDPg.csv", replace 
 
********************************************************************************
** Changes in labor and capital endowment, and labor working hours 
** Source: EU-KLEMS
********************************************************************************
qui: use DATA/EUKLEMS, clear
qui: keep if inrange(year, `=start', `=last')
qui: collapse (sum) L Lhour K, by(year) 
qui: gen Lhpc = Lhour / L 
foreach var in Lhpc L K {
	qui: sort year 
    qui: gen ini_`var' = `var'[1]
	qui: gen `var'hat = `var' / ini_`var'
}

foreach var in Lhat Khat Lhpchat {
	preserve 
		qui: keep year `var'
		qui: export delimited using "INPUT/`var'.csv", replace 
	restore
}

********************************************************************************
** Setting the aggregate variables always to be larger than the sum of firm variables
********************************************************************************
qui: use "DATA/firm_balance", clear
qui: keep if inrange(year, `=start', `=last') 
qui: merge n:1 kis using "DATA/FIRM_SEC", keep(3) nogen  
qui: merge n:1 sec using "DATA/secid", keep(1 3) nogen  
qui: keep if manu == 1  
qui: egen firmid = group(kis) 
qui: save "DATA/TEMP/cleared_balance", replace 

qui: use "DATA/TEMP/cleared_balance", clear 
qui: duplicates drop firmid, force 
qui: keep kis firmid 
qui: save "DATA/matlab_firmid_kis_mapping", replace 
qui: export excel using "INPUT/matlab_firmid_kis_mapping.xlsx", replace 
 
* Looping over
forv iii = 1/20 {
	qui: use "DATA/TEMP/cleared_balance", clear 
	if `iii' == 1 {
		qui: merge n:1 sec year using "DATA/EUKLEMS", keep(3) nogen  
	}
	else {
		qui: merge n:1 sec year using "DATA/TEMP/impu", keep(3) nogen  
	}
 
	foreach var in sale fasset emp {
		qui: bysort sec year: egen sum_`var' = sum(`var')
	}
	qui: gen resid_K = K - sum_fasset 
	qui: gen resid_L = L - sum_emp 
	qui: gen resid_GO = GO - sum_sale 
	qui: duplicates drop secid year, force
	qui: xtset secid year 
	foreach var in K L GO{
		qui: gen L1`var' = L1.`var'
		qui: gen L1resid_`var' = L1.resid_`var'
		qui: gen g`var' = `var' / L1`var'
	}
	qui: keep *sec* year *resid* K L GO g* L1* sum* 
	qui: save DATA/TEMP/resid, replace 
	
	qui: use DATA/TEMP/resid, clear		 
	foreach var in K L GO {
		qui: gen tag_`var' = (resid_`var' < 0)
		qui: bysort year tag_`var': egen min_year = min(year)
		qui: replace tag_`var' = 0 if min_year != year 
		qui: drop min_year  
	}
	qui: xtset secid year 
	qui: replace resid_K = gK * L1resid_K if !missing(resid_K) & tag_K == 1 
	qui: gen double impuK = resid_K + sum_fasset  
	qui: replace K = impuK 
	 
	qui: replace resid_L = gL * L1resid_L if !missing(resid_L) & tag_L == 1 
	qui: gen double impuL = resid_L + sum_emp
	qui: replace L = impuL 
	 
	qui: replace resid_GO = gGO * L1resid_GO if !missing(resid_GO) & tag_GO == 1 
	qui: gen double impuGO = resid_GO + sum_sale 
	qui: replace GO = impuGO 
	qui: drop impu* tag*
	
	qui: keep sec year secid K L GO
	qui: save "DATA/TEMP/impu", replace 
}

********************************************************************************
** Firm-level sales, k, l
** Source: KIS-VALUE, Annual Survey
********************************************************************************
qui: use "DATA/TEMP/cleared_balance", clear 
preserve
	qui: keep firmid cname
	qui: duplicates drop firmid, force
	qui: save "DATA/firmid_cname", replace
restore
qui: merge n:1 sec year using DATA/TEMP/impu, keep(3) nogen 
qui: merge n:1 sec year using DATA/TEMP/impu_exsh, keep(3) nogen
qui: gen EX = exsh * GO 

foreach var in fasset sale emp{
	qui: bysort sec year: egen sum_`var' = sum(`var')
}
* If total sum larger than EX, adjust them 
forv iii = 1/5{
	qui: bysort sec year: egen sum_export = sum(export)
	qui: replace export = (EX / sum_export) * export if EX <= sum_export 
	qui: drop sum_export 
}
qui: bysort sec year: egen sum_export = sum(export)
qui: gen resid_K = K - sum_fasset 
qui: gen resid_L = L - sum_emp 
qui: gen resid_GO = GO - sum_sale 
qui: gen resid_EX = EX - sum_export 
qui: tab sec year if resid_GO < 0 
qui: tab sec year if resid_EX < 0 
qui: gen exratio = export / sale 
qui: bysort sec: egen mean_exratio = mean(exratio)  
* Adjustment for export of residual firms  
qui: replace resid_EX = mean_exratio * resid_GO if (resid_EX <= 0)  
qui: replace resid_EX = mean_exratio * resid_GO if (resid_EX >= resid_GO)
qui: replace EX = sum_export + resid_EX 

preserve 
	foreach var in sale emp fasset export {
		qui: recast double `var'
	}
	qui: keep sec secid firmid year sale emp fasset export startyear 
	qui: sort sec secid firmid year 
	qui: order sec secid firmid year sale emp fasset export startyear 
	qui: export delimited using "INPUT/firm.csv", replace 
restore

qui: sort sec year 
qui: duplicates drop sec year, force 
qui: keep GO K L sec year EX
qui: rename (GO K L EX) (GOimpu Kimpu Limpu EXimpu)
qui: save DATA/TEMP/EUKLEMS_impu, replace 
 
* Update the original EUKLEMS with the newly imputed ones
qui: use DATA/EUKLEMS, clear
qui: merge n:1 sec year using DATA/TEMP/EUKLEMS_impu, keep(1 3) nogen
qui: merge n:1 sec year using DATA/TEMP/impu_exsh, keep(1 3) nogen
qui: merge n:1 sec using DATA/secid, keep(3) nogen
qui: gen EX = exsh * GO 
foreach var in L K GO EX {
	qui: replace `var' = `var'impu if !missing(`var'impu)
}
qui: drop *impu* 
foreach var in L K GO PPI EX{
	preserve 
		qui: recast double `var'
		qui: keep secid sec year `var'
		qui: keep if inrange(year, `=start', `=last')
		qui: sort secid sec year 
		qui: order secid sec year `var' 
		qui: export delimited using "INPUT/`var'.csv", replace 
	restore 		
}
 
******************************************************************************** 
** Human capital stock estimate: Lee and Lee (2016, JDE)
********************************************************************************
use "RAW/Lee_human_capital/LeeLee_v1", clear  
keep if country == "Republic of Korea" & sex == "MF"
keep year hc 
tsset year 
tsfill, full 
forv iii = 1/4 {
	replace hc = hc[_n-`iii']^((5-`iii')/5) * hc[_n+(5-`iii')]^(`iii' / 5) if !missing(hc[_n-`iii']) & !missing(hc[_n+(5-`iii')]) & missing(hc)
}
insobs 1 
replace year = 2011 if missing(year)
replace hc = hc[_n-1] * (hc[_n-1] / hc[_n-2]) if year == 2011 
keep if inrange(year, 1972, `=last')
keep year hc 
export delimited using "INPUT/hc.csv", replace 

********************************************************************************
** Region-info 
********************************************************************************
use "DATA/kis_region", clear
merge n:1 sec using DATA/secid, keep(3) nogen 
merge 1:n kis using DATA/TEMP/cleared_balance, keep(1 3) nogen 
sort secid firmid 
keep secid firmid kis region_id 
export delimited using "INPUT/kis_region.csv", replace 

******************************************************************************** 
** Erase files 
********************************************************************************
qui: capture: erase DATA/TEMP/cleared_balance.dta 
qui: capture: erase DATA/TEMP/resid.dta 
qui: capture: erase DATA/TEMP/impu.dta 
qui: capture: erase DATA/TEMP/IO_impu.dta 
qui: capture: erase DATA/TEMP/temp_input.dta 
qui: capture: erase DATA/TEMP/EUKLEMS_impu.dta 
qui: capture: erase DATA/TEMP/sum_export.dta 
qui: capture: erase DATA/TEMP/impu_exsh.dta 
foreach var in GO exports imports expen VAsh imsh intsh exsh fcons {
	clear 
	foreach IOyear in 1970 1973 1975 1978 1980 1983 1985 1986 1987 1988 1990 1993 1995 1998 2000 2003 2005 2006 2007 2008 2009 2010 2011 {
		capture: qui: erase" DATA/TEMP/`var'_`IOyear'.dta" 
	}
	capture: qui: erase "DATA/TEMP/noimpu_`var'.dta" 
}
foreach IOyear in 1970 1973 1975 1978 1980 1983 1985 1986 1987 1988 1990 1993 1995 1998 2000 2003 2005 2006 2007 2008 2009 2010 2011 {
	capture: qui: erase "DATA/TEMP/temp_IO_`IOyear'.dta" 
	qui: capture: erase "DATA/TEMP/`IOyear'_export.dta" 
	qui: capture: erase "DATA/TEMP/EX_`IOyear'.dta" 
	qui: capture: erase "DATA/TEMP/`IOyear'_GO.dta"
	qui: capture: erase "DATA/TEMP/temp_IO_all_`IOyear'.dta"
	
	qui: capture: erase "DATA/TEMP/temp_IO_dom_`IOyear'.dta"
	qui: capture: erase "DATA/TEMP/temp_IO_for_`IOyear'.dta"
}
foreach var in VAsh imsh intsh exsh fcons {
	qui: capture: erase "DATA/TEMP/noimpu_`var'.dta"
}
qui: capture: erase "DATA/TEMP/pop.dta"


