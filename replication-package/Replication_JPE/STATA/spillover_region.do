import delimited "OUTPUT/result_counterfactual_a.csv",clear
keep firmid year a_fj
rename a_fj a_fj_counter
tempfile counter
save `counter'

import delimited "OUTPUT/result_base.csv",clear
merge m:1 firmid using "DATA/matlab_firmid_kis_mapping", keep(1 3) nogen 
merge m:1 kis using "DATA/kis_region",keep(1 3) nogen
merge m:1 firmid year using `counter',keep(1 3) nogen

local sigma=5
bys secid year region_id: egen denominator = total(a_fj^(`sigma'-1))
bys secid year region_id: egen numerator = total(a_fj^(`sigma'-1)*top3)
gen share = numerator/denominator

bys secid year region_id: egen denominator_counter = total(a_fj_counter^(`sigma'-1))
bys secid year region_id: egen numerator_counter = total(a_fj_counter^(`sigma'-1)*top3)
gen share_counter = numerator_counter/denominator_counter

gen delta_share = share_counter-share
gen change_a = exp(delta_share*0.63) 
gen a_fj_counter_adj = change_a*a_fj_counter

keep firmid year a_fj_counter_adj
export delimited using "OUTPUT/counterfactual_spillover.csv",replace
