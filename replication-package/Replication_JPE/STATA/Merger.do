********************************************************************************
** Business group: From 1980 to 2004  
********************************************************************************
import excel using "RAW/FIRM/business_group.xls", sheet("group_code") clear firstrow 
keep old_kyel_k g_code4 g_code3 year kis firm_oldname 
rename (old_kyel_k firm_oldname) (gname cname)

forv y = 1972/1979 {
	preserve 
		keep if year == 1980 
		replace year = `y'
		save DATA/TEMP/temp`y', replace 
	restore
}

forv y = 1972/1979 {
	append using "DATA/TEMP/temp`y'"
}
// merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen
sort g_code3 kis year 
duplicates drop kis year, force
keep kis year g_code3 gname 
save DATA/group_history, replace 
 
** Ever top 3 firms' chaebol status 
use DATA/group_history, clear 
merge n:1 kis using DATA/ever_t3_list, keep(3) nogen 
duplicates drop g_code3, force 
keep g_code3 gname 
gen ever_t3_group = 1 
save DATA/TEMP/ever_t3_group, replace 

** Ever top 3 firms' chaebol-sec status 
use DATA/group_history, clear 
merge n:1 kis using DATA/ever_t3_list, keep(3) nogen 
duplicates drop g_code3 sec, force 
keep g_code3 gname sec
gen ever_t3_group_sec = 1 
save DATA/TEMP/ever_t3_group_sec, replace 
 
** Erase files 
forv y = 1972/1979 {
	qui: capture: erase "DATA/TEMP/temp`y'.dta" 
}

********************************************************************************
** Firm-level ksic 3-digit info  
********************************************************************************
use DATA/kis_ksic, clear
drop ksic_k  
save DATA/TEMP/ksic_base, replace 


use DATA/kis_ksic, clear
duplicates drop ksic_k, force 
keep ksic_base ksic_k 
save DATA/TEMP/ksic_base_list, replace 



********************************************************************************
** Import raw data
** Final output: Merger cases (kis_A-kis_T-merger_id) & (kis merger_id merger_type) 
** A: Acquirer, T: Target firms
********************************************************************************
import excel using "RAW/Merger/merger_case.xls", clear firstrow sheet("M&A")
replace ksic = substr(ksic, 1, 6)
keep ksic ksic_k
drop if missing(ksic) | missing(ksic_k)
bysort ksic_k ksic: gen num = _N 
bysort ksic_k: egen max_num = max(num)
keep if num == max_num 
sort ksic_k ksic 
duplicates drop ksic_k , force 
rename ksic ksic_list 
keep ksic_k ksic_list  
save DATA/TEMP/ksic_list, replace 
 
import excel using "RAW/Merger/merger_case.xls", clear firstrow sheet("M&A")
replace ksic = substr(ksic, 1, 6)
merge n:1 kis using DATA/TEMP/ksic_base, keep(1 3) nogen 
replace ksic = ksic_base if !missing(ksic_base)
drop ksic_base 
merge n:1 ksic_k using DATA/TEMP/ksic_base_list, keep(1 3) nogen 
replace ksic = ksic_base if !missing(ksic_base)
drop ksic_base 
merge n:1 ksic_k using DATA/TEMP/ksic_list, keep(1 3) nogen 
replace ksic = ksic_list if missing(ksic) & !missing(ksic_list)
drop ksic_list 
rename (Code_All Code_AorT firm_name_k type) (merger_id merger_a cname merger_type) 
gen merger_status = substr(merger_a, 1, 1)
rename year merger_year 
gen temp_max_A_or_T = (missing(kis) | regexm(kis, "\?"))
bysort merger_id: egen max_A_or_T = max(temp_max_A_or_T)
drop if temp_max_A_or_T == 1 
drop temp* 
keep if inrange(merger_year, 1972, 2011)
qui: merge n:1 kis using DATA/FIRM_SEC, keep(1 3) nogen  

** Converting ksic into ISIC rev 3 for firms not in our dataset  
gen ori_sec = sec 
replace sec = "_" + ksic_2 if !missing(ksic_2)
replace sec = "_24x" if regexm(ksic_k, "의약") | regexm(ksic_k, "제약") // Pharma 
qui: do STATA/subcode/SUB_SECTOR_AGG.do 
replace sec = ori_sec if !missing(ori_sec)
foreach var in commodity manu service {
	replace `var' = 0 if missing(`var')
}
qui: do STATA/subcode/SUB_CLASSIFICATION.do 


replace ksic = "C10200" if (regexm(ksic_k, "음식료품") | regexm(ksic_k,"수산물")) & missing(ksic)
replace ksic = "C10700" if (regexm(ksic_k, "농기계") | regexm(ksic_k, "농업용기계")) & missing(ksic)
replace ksic = "C14100" if regexm(ksic_k, "의류, 잡화") & missing(ksic)
replace ksic = "C14200" if regexm(ksic_k, "모피") & missing(ksic)
replace ksic = "C22200" if (regexm(ksic_k, "플라스틱") | regexm(ksic_k, "고무"))& missing(ksic)
replace ksic = "C24100" if (regexm(ksic_k, "철강선") | regexm(ksic_k, "야금")) & missing(ksic)
replace ksic = "C25100" if (regexm(ksic_k, "철구조물")) & missing(ksic)
replace ksic = "C25900" if (regexm(ksic_k, "스틸제품")) & missing(ksic)
replace ksic = "C26100" if (regexm(ksic_k, "반도체") | regexm(ksic_k, "정밀기기")) & missing(ksic)
replace ksic = "C26200" if (regexm(ksic_k, "통신기기") | regexm(ksic_k, "정보통신기기") | regexm(ksic_k, "통신기계기구") | regexm(ksic_k, "통신장비") | regexm(ksic_k, "정보기기")) & missing(ksic)
replace ksic = "D29100" if regexm(ksic_k, "기계장비") & missing(ksic)
replace ksic = "C29200" if (regexm(ksic_k, "전자제품") | regexm(ksic_k, "전기제품") | regexm(ksic_k, "전기기기")) & missing(ksic)
replace ksic = "C31100" if regexm(ksic_k, "선박") & missing(ksic)
replace ksic = "C33900" if regexm(ksic_k, "오디오") & missing(ksic)
replace ksic = "D31900" if regexm(ksic_k, "이륜차") & missing(ksic)
replace ksic = "D34300" if regexm(ksic_k, "자동차부품") & missing(ksic)
 
/*
포장재 가공
전자, 전기, 기계기구와 그 부품 및 소재의 제조, 판매 및 임대업
목걸이용 이어폰 제조
부동산임대, 녹차재배 및 다류제조 판매업
직물류의 제조가공 및 판매
각종 기계제조 및 판매업
실험동물의 생산 및 수출입업, 생명과학 관련 연구개발업 및 관련제품 제조
보일러 탈황제거용 폐수 중화제 및 다이옥신 제거용 제조 판매
가스스토브 및 간이가스렌지 제조, 판매업, 가스충전업
공기여과필터 및 여과기기류의 제조 및 판매
케이블트레이, 케이블닥트 철구조물 제조 및 판매업
전자음악 음원 아이씨 및 관련 칩 개발 및 설계용역
소프트웨어 및 프로그램 개발, 공급업
정기간행물발행 및 광고업
음반 및 기타 음악기록매체 출판업
*/


drop ori_sec 
foreach v in T A {
	bysort merger_id: gen temp_manu`v' = manu if merger_status == "`v'"
	bysort merger_id: egen manu`v' = max(temp_manu`v')
	drop temp_manu`v'
}
keep if manuT == 1 & manuA == 1  // Restricting it to merger within manufacturing sectors 
foreach v in T A {
	gen sec`v' = sec if merger_status == "`v'"
	bysort merger_id (sec`v'): replace sec`v' = sec`v'[_N] if missing(sec`v')
	replace sec`v' = sec if sec`v' ~= sec & merger_status == "`v'"
}
foreach v in T A {
	gen ksic`v' = ksic if merger_status == "`v'"
	bysort merger_id (ksic`v'): replace ksic`v' = ksic`v'[_N] if missing(ksic`v')
	replace ksic`v' = ksic if ksic`v' ~= ksic & merger_status == "`v'"
}
foreach v in T A {
	gen ksic_2`v' = ksic_2 if merger_status == "`v'"
	bysort merger_id (ksic_2`v'): replace ksic_2`v' = ksic_2`v'[_N] if missing(ksic_2`v')
	replace ksic_2`v' = ksic_2 if ksic_2`v' ~= ksic_2 & merger_status == "`v'"
}
rename merger_year year 
merge n:1 kis year using DATA/group_history, keep(1 3) nogen
rename year merger_year 
foreach v in T A {
	gen g_code3`v' = g_code3 if merger_status == "`v'"
	bysort merger_id (g_code3`v'): replace g_code3`v' = g_code3`v'[_N] if missing(g_code3`v')
	replace g_code3`v' = g_code3 if g_code3`v' ~= g_code3 & merger_status == "`v'"
}
foreach name in 호텔 증권 은행 보험 증권 백화점 교통 해운 건설 방송 고속 {
	drop if regexm(cname, "`name'") & missing(manu)
}
keep kis cname merger_status merger_id merger_type merger_year sec* g_code3* ksic* 
save DATA/merger_type_cases, replace 



********************************************************************************
** Number of mergers 
********************************************************************************
foreach var in A T {
	use DATA/merger_type_cases, clear 
	keep if merger_status == "`var'"
	save DATA/TEMP/merger_`var', replace 
}

use DATA/TEMP/merger_A, clear 
keep kis cname merger_id merger_year 
rename (kis cname) (kis_A cname_A) 
save DATA/TEMP/merge_A_temp, replace 

** Merging acquirer-acquiree cases 
use DATA/TEMP/merger_T, clear 
keep kis cname merger_id merger_type merger_year 
rename (cname kis) (cname_T kis_T) 
merge 1:1 merger_id merger_year using DATA/TEMP/merge_A_temp, keep(3) nogen 
keep merger* cname_* kis_* 
preserve 
	keep merger_id 
	save DATA/TEMP/keep_merger_id, replace 
restore
save DATA/merger_cases, replace 
 
foreach st in T A {
	use DATA/merger_type_cases, clear 
	gen num = 1 
	keep if merger_status == "`st'"
	collapse (sum) num, by(merger_year)
	egen sum_num = sum(num)
	twoway bar num merger_year, ytitle("") xtitle("Year") xlabel(1972(4)2005)
	// graph export "FIGURE/merger`st'_num_year.pdf", replace
}

use DATA/merger_type_cases, clear 
gen num = 1 
collapse (sum) num, by( merger_status)


foreach st in A T {
	use "DATA/merger_cases", clear 
	gen num = 1 
	collapse (sum) num, by(merger_year)
	twoway bar num merger_year 
	// graph export "FIGURE/merger_num_year.pdf", replace
}

********************************************************************************
** Merger characteristics 
********************************************************************************
use DATA/merger_type_cases, clear
gen temp_same_sector = (secT == secA)
gen temp_same_group = (g_code3T == g_code3A) & !missing(g_code3T) & !missing(g_code3A)
gen temp_same_ksic = (ksicT == ksicA) & !missing(ksicT) & !missing(ksicA)
gen temp_same_ksic_2 = (ksic_2T == ksic_2A) & !missing(ksic_2T) & !missing(ksic_2A)
foreach var in same_sector same_group same_ksic same_ksic_2 {
	bysort merger_id: egen `var' = max(temp_`var')
}
// replace same_ksic = . if missing(ksicT) | missing(ksicA)
replace same_ksic = 0 if same_sector == 0 
duplicates drop merger_id, force 
keep merger_id same*
save DATA/TEMP/merger_char, replace 

use DATA/TEMP/merger_char, clear
sum same_ksic, detail // 9% 
sum same_ksic_2, detail // 52%
sum same_sector, detail // 61% 



********************************************************************************
** Shares of mergers by top 3 firms: 8% 
********************************************************************************
** Ever top 3 firms & ever top 3 groups 
use DATA/merger_type_cases, clear  
keep if merger_status == "A"
merge n:1 kis using DATA/ever_t3_list, keep(1 3) nogen
replace ever_t3 = 0 if missing(ever_t3)
gen ever_t3_sec = (secA == secT) & (ever_t3 == 1)
rename merger_year year 
merge n:1 kis year using DATA/group_history, keep(1 3) nogen 
merge n:1 g_code3 using DATA/TEMP/ever_t3_group, keep(1 3) nogen 
replace ever_t3_group = 0 if missing(ever_t3_group)
gen ever_t3_group_sec = (secA == secT) & (ever_t3_group == 1)
drop sec 
rename secT sec 
merge n:1 g_code3 sec using DATA/TEMP/ever_t3_group_sec, keep(1 3) nogen 
 
sum ever_t3, detail
sum ever_t3_sec, detail 
sum ever_t3_group, detail
sum ever_t3_group_sec, detail 
 
 
********************************************************************************
** Descriptive statistics 
********************************************************************************
use DATA/merger_type_cases, clear 
rename merger_year year 
merge n:1 kis year using DATA/firm_balance, keep(1 3) nogen
unique merger_id // 771 cases 
gen temp_missing = missing(sale)
bysort merger_id: egen both_missing = max(temp_missing)
foreach mstatus in T A {
	sum sale if merger_status == "`mstatus'"  , detail
}
 
 
********************************************************************************
** Target firms who exited at the timer of merger 
********************************************************************************
use DATA/merger_type_cases, clear
keep if merger_status == "T"
keep kis merger_year merger_type 
gen year = merger_year 
duplicates tag kis merger_year, gen(dup)
duplicates drop kis merger_year, force 
keep if merger_type == 1
save DATA/TEMP/temp_T_merger_year, replace 

** Number of target firms who exited at the timer of merger 
qui: use DATA/firm_balance, clear
merge n:1 kis using DATA/FIRM_SEC, keep(3) nogen 
merge n:1 kis year using DATA/TEMP/temp_T_merger_year, keep(3) nogen
bysort kis (year): replace merger_year = merger_year[_n-1] if missing(merger_year)
keep if max_year == merger_year  
keep kis merger_year 
unique kis 
save DATA/TEMP/merger_exit, replace 


use DATA/TEMP/merger_exit, clear
merge n:1 kis using DATA/ever_t3_list, keep(1 3) nogen
count if ever_t3 == 1 
 
use DATA/merger_type_cases, clear
merge n:1 kis merger_year using DATA/TEMP/merger_exit, keep(1 3) 
bysort merger_id: egen exit_merger = max(_m)
keep if exit_merger == 3
drop exit_merger _m 
merge n:1 kis using DATA/ever_t3_list, keep(1 3) nogen
keep if merger_status == "A"
count if ever_t3 == 1 


********************************************************************************
** Constructing matches for the event study 
********************************************************************************
use DATA/merger_type_cases, clear
duplicates drop kis, force 
merge n:1 kis using DATA/FIRM_SEC, keep(3) 
keep kis 
save DATA/TEMP/ever_merger_list, replace 

foreach mtype in A T {
	use DATA/merger_type_cases, clear
	keep if merger_status == "`mtype'" 
	merge n:1 kis using DATA/FIRM_SEC, keep(3) 
	keep kis merger_year 
	bysort kis: egen min_merger_year = min(merger_year)
	replace merger_year = min_merger_year 
	drop min_merger_year 
	rename merger_year ctrl_merger_year 
	duplicates drop kis, force 
	save "DATA/TEMP/ever_`mtype'_list", replace 
}


local dmatchvarlist ln_sale ln_emp ln_fasset ht_export d3ln_sale d3ln_emp d3ln_fasset d3ht_export 
local ematchvarlist sec year 

forv nnn = 1/1 {
	forv lag = 1/1 {
		foreach mstatus in T A {
 
			use DATA/merger_type_cases, clear
			keep if merger_status == "`mstatus'"
			merge n:1 kis using DATA/FIRM_SEC, keep(3) 
			keep kis merger_year merger_id merger_type 
			bysort kis: egen min_merger_year = min(merger_year)
			drop min_merger_year 
			gen treat_id = _n
			sum treat_id, detail
			scalar num_treat = `r(max)'
			save DATA/TEMP/treat_group, replace 

			use DATA/firm_balance, clear 
			gen sale_dom = sale - export 
			foreach var in fasset sale sale_dom emp cogs wbill export {
				gen ln_`var' = ln(`var')
				gen ht_`var' = asinh(`var')
				gen dum_`var' = (`var' > 0)
			}
			foreach var in fasset sale sale_dom emp cogs wbill export {
				forv l = 0/5 {
					bysort panelid (year): gen d`l'ln_`var' = ln_`var' - ln_`var'[_n-`l']
					bysort panelid (year): gen d`l'ht_`var' = ht_`var' - ht_`var'[_n-`l']
				}
			}			
			foreach var in `dmatchvarlist' {
				sum `var', detail 
				scalar std_`var' = `r(sd)'
			}

			use DATA/TEMP/treat_group, clear 
			joinby kis using DATA/firm_balance  
 
			merge n:1 kis using DATA/FIRM_SEC, keep(3) 
			keep treat_id year merger_year panelid kis fasset sale emp cogs wbill export sec merger_id merger_type 
			egen unique_id = group(treat_id panelid)
			xtset unique_id year 
			gen sale_dom = sale - export 
			foreach var in fasset sale sale_dom emp cogs wbill export {
				gen L`lag'`var' = L`lag'.`var'
				replace `var' = L`lag'`var'
				drop L`lag'`var'
			}
			drop if missing(sale) | missing(emp) | missing(fasset)
			rename (panelid kis) (panelid_w kis_w)
			foreach var in fasset sale sale_dom emp cogs wbill export {
				gen ln_`var' = ln(`var')
				gen ht_`var' = asinh(`var')
				gen dum_`var' = (`var' > 0)
				rename (`var' ln_`var' ht_`var' dum_`var') (`var'_w ln_`var'_w ht_`var'_w dum_`var'_w)
			}
			foreach var in fasset sale sale_dom emp cogs wbill export {
				forv l = 0/5 {
					bysort panelid (year): gen d`l'ln_`var' = ln_`var'_w - ln_`var'_w[_n-`l']
					bysort panelid (year): gen d`l'ht_`var' = ht_`var'_w - ht_`var'_w[_n-`l']
					rename (d`l'ln_`var' d`l'ht_`var') (d`l'ln_`var'_w d`l'ht_`var'_w)
				}
			}					 				
			keep if year == merger_year 				
			save DATA/TEMP/treat_event_balance, replace  


			use DATA/firm_balance, clear 

			merge n:1 kis using DATA/FIRM_SEC, keep(3) 

			merge n:1 kis using DATA/TEMP/ever_`mstatus'_list, keep(3) nogen
			keep year panelid kis fasset sale emp cogs wbill export sec ctrl_merger_year 

			xtset panelid year 
			gen sale_dom = sale - export 
			foreach var in fasset sale sale_dom emp cogs wbill export {
				gen L`lag'`var' = L`lag'.`var'
				replace `var' = L`lag'`var'
				drop L`lag'`var'
			}					
			drop if missing(sale) | missing(emp) | missing(fasset)
			foreach var in fasset sale sale_dom emp cogs wbill export {
				gen ln_`var' = ln(`var')
				gen ht_`var' = asinh(`var')
				gen dum_`var' = (`var' > 0)
			}
			foreach var in fasset sale sale_dom emp cogs wbill export {
				forv l = 0/5 {
					bysort panelid (year): gen d`l'ln_`var' = ln_`var' - ln_`var'[_n-`l']
					bysort panelid (year): gen d`l'ht_`var' = ht_`var' - ht_`var'[_n-`l']
				}
			}	 				
			save DATA/TEMP/control_group_balance, replace 

			forv wid = 1/`=num_treat' {
				use DATA/TEMP/treat_event_balance, clear 
				keep if treat_id == `wid' 
				merge 1:n `ematchvarlist' using DATA/TEMP/control_group_balance, keep(3) nogen 
				drop if kis == kis_w 

				drop if year >= ctrl_merger_year 

				gen zdiff = 0 
				foreach var in `dmatchvarlist`d'' {
					replace zdiff = zdiff + (`var'_w - `var')^2 / (`=std_`var'')^2
				} 
				replace zdiff = zdiff^0.5 
				drop if missing(zdiff)
				gsort zdiff 
				gen rank = _n
				keep if rank <= `nnn'
				drop *_w rank 

				keep kis treat_id merger_year zdiff merger_id merger_type ctrl_merger_year  

				gen treat = 0 
				save DATA/TEMP/temp_wid`wid', replace emptyok 
			}


			use "DATA/TEMP/treat_event_balance", clear  
			keep kis_w treat_id merger_year merger_id merger_type
			rename kis_w kis 
			gen treat = 1 
			forv wid = 1/`=num_treat' {
				append using "DATA/TEMP/temp_wid`wid'"
			}
			sort treat_id kis treat 
			save "DATA/TEMP/match_list", replace 
			
			** Erase files
			forv wid = 1/`=num_treat' {
				capture: qui: erase "DATA/TEMP/temp_wid`wid'.dta"								
			}


			use "DATA/TEMP/match_list", clear
			joinby kis using "DATA/firm_balance"
			gen sale_dom = sale - export 
			foreach var in fasset sale sale_dom emp cogs wbill export {
				gen ln_`var' = ln(`var')
				gen ht_`var' = asinh(`var')
			}
			gen dum_export = (export > 0)
			gen diff = year - merger_year 
			forv i = 0/7 {
				gen treat_after`i' = (diff == `i') * (treat == 1)
			}
			forv i = 7(-1)1{
				gen treat_before`i' = (diff == -`i') * (treat == 1)
			}
			egen mpanelid = group(panelid treat_id)
			egen match_yearFE = group(treat_id year) 
			egen match_diffFE = group(treat_id diff)
			bysort match_diffFE: gen num = _N 
			drop if num <= 1 
			drop num 					
			gen ctrl_post = (year >= ctrl_merger_year)
			save "DATA/TEMP/`mstatus'reg_n`nnn'l`lag'", replace 
		}
	}
}

  

********************************************************************************
** Dependent variable: Shocks
********************************************************************************
import delimited using "OUTPUT/result_base_notruncation_nosmoothing.csv", clear  
merge n:1 firmid using "DATA/matlab_firmid_kis_mapping", keep(3) nogen
keep kis year tau_l tau_k a_fj df_tilde 
foreach var in tau_l tau_k a_fj df_tilde {
	gen ln_`var' = ln(`var')
}
save "DATA/TEMP/shock_dep", replace 

********************************************************************************
** Event study 
********************************************************************************
foreach nnn in 1 { 
	foreach lag in 1 {				
		local dlist ln_a_fj // ln_tau_l ln_tau_k ln_df_tilde
		local specs 
		foreach mstatus in A T {								
			foreach dep in `dlist' {   
				use "DATA/TEMP/`mstatus'reg_n`nnn'l`lag'", clear 
				keep if treat == 0
				duplicates drop kis, force 
				qui: sum zdiff, detail 
				keep if zdiff >= `r(p99)'
				keep kis 
				save "DATA/TEMP/zdiff_outliers", replace 

				use "DATA/TEMP/`mstatus'reg_n`nnn'l`lag'", clear 
				merge n:1 merger_id using DATA/TEMP/merger_char, keep(3) nogen
				merge n:1 kis year using DATA/TEMP/shock_dep, keep(1 3) nogen 
				drop if ctrl_post == 1 

				local before 5
				local after 7	
				keep if inrange(diff, -`before', `after')
				local normal before1  
				
				gen wt_sales = sale if diff == - `lag'
				bysort mpanelid (wt_sales): replace wt_sales = wt_sales[1] if missing(wt_sales)

				local treat
				forv iii = `before'(-1)1{
					local treat `treat' treat_before`iii'
				}
				forv iii = 0(1)`after'{
					local treat `treat' treat_after`iii'
				}
					
				qui: replace treat_`normal' = 0	

				local cluster treat_id panelid 
				local FE match_yearFE mpanelid 

				qui: reghdfe `dep' `treat', absorb(`FE') cluster(`cluster') nocons 	
				 
				event_plot e(b)#e(V), ///
					graph_opt(xtitle("Year since merger") title("") ytitle("") xline(-1, lcolor(gs8) lpattern(dash)) ///
					yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) xlabel(-`before'(1)`after', angle(horizontal)) ///
					ylabel(, angle(horizontal))) lag_opt(color(`color')) lead_opt(color(`color') msymbol(S)) ///
					lag_ci_opt(lwidth(0.10) lcolor(`color') color(`color'%25 `color'%25)) ///
					lead_ci_opt(lwidth(0.10) lcolor(`color') color(`color'%25 `color'%25)) ///
					legend_opt(region(lstyle(none))) stub_lead(treat_before#) stub_lag(treat_after#) together alpha(0.05)	
				
				if  `lag' == 1 & "`mstatus'" == "T" & `nnn' == 1 & "`dep'" == "ln_a_fj" {
					graph export "FIGURE/FIGUREB6.pdf", as(pdf) replace 
				}
			}
		}
	}
}
 

  

********************************************************************************
** Erase files
********************************************************************************
capture: qui: erase "DATA/TEMP/control_group_balance.dta"
capture: qui: erase "DATA/TEMP/treat_event_balance.dta"
capture: qui: erase "DATA/TEMP/zdiff_outliers.dta"
capture: qui: erase "DATA/TEMP/merger_char.dta"
capture: qui: erase "DATA/TEMP/mergerA_num.dta"
capture: qui: erase "DATA/TEMP/mergerT_num.dta"
capture: qui: erase "DATA/TEMP/merge_A_temp.dta"
capture: qui: erase "DATA/TEMP/merger_T_temp.dta"
capture: qui: erase "DATA/TEMP/temp_T_merger_year.dta"
capture: qui: erase "DATA/TEMP/merger_A.dta"
capture: qui: erase "DATA/TEMP/treat_group.dta"
capture: qui: erase "DATA/TEMP/merger_T.dta"
foreach mstatus in A T {
	foreach nnn in 1 2 3 { 
		foreach lag in 0 1 2 {			
			capture: qui: erase "DATA/TEMP/`mstatus'reg_n`nnn'l`lag'.dta"
		}
	}
}
capture: qui: erase "DATA/TEMP/match_list.dta"
capture: qui: erase "DATA/TEMP/shock_dep.dta"
capture: qui: erase "DATA/TEMP/ever_t3_group_sec.dta"
capture: qui: erase "DATA/TEMP/ever_t3_group.dta"
capture: qui: erase "DATA/TEMP/ever_merger_list.dta"
capture: qui: erase "DATA/TEMP/ever_A_list.dta"
capture: qui: erase "DATA/TEMP/ever_T_list.dta"
capture: qui: erase "DATA/TEMP/merger_exit.dta"
capture: qui: erase "DATA/TEMP/keep_merger_id.dta"
capture: qui: erase "DATA/TEMP/ksic_list.dta"
capture: qui: erase "DATA/TEMP/ksic_base.dta"
capture: qui: erase "DATA/TEMP/ksic_base_list.dta"