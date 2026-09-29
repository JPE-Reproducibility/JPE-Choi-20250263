********************************************************************************
** EU-KLEMS cleaning
********************************************************************************
foreach var in vi qi vkw qkw {
	import excel using RAW/EUKLEMS/EUKLEMS_KOR_WK_2015_K_converted.xls, clear sheet("`var'") firstrow 
	rename EUKLEMScode sec
	qui: do STATA/subcode/SUB_SECTOR_AGG.do 
	collapse (sum) K, by(year sec)
	rename K `var'
	save DATA/TEMP/EUKLEMS_`var', replace 
}

use DATA/TEMP/EUKLEMS_vi, clear
foreach var in qi vkw qkw {
	merge 1:1 sec year using DATA/TEMP/EUKLEMS_`var', keep(3) nogen
}
rename (vkw qkw) (K rK)
save DATA/TEMP/EUKLEMS_K, replace 
 
foreach var in GO EMP EMPE LAB H_EMP VA {
	import excel using RAW/EUKLEMS/EUKLEMS_KOR_WK_2015_YL_converted.xls, clear sheet("`var'") firstrow 
	rename EUKLEMScode sec
	qui: do STATA/subcode/SUB_SECTOR_AGG.do
	rename YL `var' 
	collapse (sum) `var', by(year sec)
	save DATA/TEMP/EUKLEMS_`var', replace 
}

import excel using RAW/EUKLEMS/EUKLEMS_KOR_WK_2015_YL_converted.xls, clear sheet("GO(real)") firstrow 	
rename EUKLEMScode sec
qui: do STATA/subcode/SUB_SECTOR_AGG.do
rename YL rGO
collapse (sum) rGO, by(year sec)
save DATA/TEMP/EUKLEMS_rGO, replace 

use DATA/TEMP/EUKLEMS_GO, clear
foreach var in rGO K EMP EMPE LAB H_EMP VA {
	merge 1:1 sec year using DATA/TEMP/EUKLEMS_`var', keep(3) nogen
}
merge n:1 year using RAW/AGG/exr, keep(3) nogen
merge n:1 year using RAW/AGG/usgdpdef, keep(3) nogen
 
replace EMP = EMP * 1000 
replace EMPE = EMPE * 1000
foreach var in GO rGO LAB VA K rK vi qi {
	replace `var' = `var' * 1000000
	replace `var' = `var' / exr 
	replace `var' = 100 * `var' / gdpdef_us
}
replace H_EMP = 1000000 * H_EMP 
rename (EMP H_EMP) (L Lhour)
 
gen PPI = 100 * GO / rGO 
gen iPPI = 100 * vi / qi

save "DATA/EUKLEMS", replace 

********************************************************************************
** IO Tables: Source - Bank of Korea 
********************************************************************************
 
foreach IOyear in 1970 1973 1975 1978 1980 1983 1985 1986 1987 1988 1990 1993 1995 1998 2000 2003 2005 2006 2007 2008 2009 2010 2011 {  
	foreach type in all dom for{ 
		qui: use "RAW/IO_TABLE/IO_`IOyear'_3digit_`type'", clear
		save "DATA/IO_`IOyear'_3digit_`type'", replace 
	}
}

** Geometric averaged for missing IO years 
use "RAW/IO_TABLE/IOimpu", clear
save "DATA/IOimpu", replace 
 
********************************************************************************
** Firm-level data
********************************************************************************
* Industry code 
use RAW/FIRM/FIRM_SEC, clear
save DATA/FIRM_SEC, replace  

* Firm outcome 
use RAW/FIRM/firm_balance, clear
save DATA/firm_balance, replace

* Firm region info
use RAW/FIRM/kis_region, clear
save DATA/kis_region, replace 

* Firm KSIC 3-digit classification
use RAW/FIRM/kis_ksic, clear 
save DATA/kis_ksic, replace
 

********************************************************************************
** Erase files
********************************************************************************
foreach var in GO rGO K EMP EMPE LAB H_EMP VA vi qi vkw qkw{
	qui: capture: erase "DATA/TEMP/EUKLEMS_`var'.dta" 
}
 