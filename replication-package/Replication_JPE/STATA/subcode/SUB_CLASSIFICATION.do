capture: gen commodity = 0 
replace commodity = 1 if inlist(sec, "_AtB", "C")
capture: gen manu = 0
local seclist 
foreach sss in "_15" "_16" "_17" "_18" "_19" "_20"  "_21" "_22" "_21t22" "_23" "_244" "_24" "_24x" "_25" "_26" "_27" "_28" "_29" "_30" "_31" "_32" "_33" "_34" "_35" "_36" "_37 " ///
	"_20t22" "_24t25" "_27t28" "_30t32" "_30t33" "_15t16" "_17t18" "_17t19" "_29-34t35" "_34t35" "_36t37" 	///
		"_1LIGHT" "_2HEAVY" {
	replace manu = 1 if regexm(sec, "`sss'")
}
capture: gen service = 0
replace service = 1 if manu == 0 & commodity == 0
 