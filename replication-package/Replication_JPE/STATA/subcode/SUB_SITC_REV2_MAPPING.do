replace sec = "_AtB" if sitc == 1 | inrange(sitc2, 211, 223) | sitc2 == 261 
replace sec = "_C" if inrange(sitc2, 273, 278) |  inrange(sitc2, 281, 289) 
replace sec = "_15" if inrange(sitc2, 11, 122) | sitc2 == 271 

replace sec = "_17" if inrange(sitc2, 261, 269) | inrange(sitc2, 650, 659)
replace sec = "_18" if inrange(sitc2, 800, 847)
replace sec = "_19" if inrange(sitc2, 611, 613) | inrange(sitc2, 848, 851)
replace sec = "_20" if inrange(sitc2, 244, 251) | inrange(sitc2, 633, 642) | sitc2 == 892

replace sec = "_23" if inrange(sitc2, 322, 341)
replace sec = "_24x" if inrange(sitc2, 411, 431) | inrange(sitc2, 510, 533) | inrange(sitc2, 551, 600)
replace sec = "_244" if inrange(sitc2, 541, 541) | sitc2 == 628
replace sec = "_25" if inrange(sitc2, 232, 233) | inrange(sitc2, 621, 627)

replace sec = "_26" if inrange(sitc2, 291, 292) | inrange(sitc2, 661, 667)
replace sec = "_27" if inrange(sitc2, 671, 690)
replace sec = "_28" if inrange(sitc2, 690, 699)




replace sec = "_29" if inrange(sitc2, 700, 749)

replace sec = "_30t33" if inrange(sitc2, 750, 778) | inrange(sitc2, 871, 885)
replace sec = "_34" if inrange(sitc2, 781, 784)
replace sec = "_35" if inrange(sitc2, 785, 793)

replace sec= "_36t37" if inrange(sitc2, 800, 800) | sitc2 == 890 | inrange(sitc2, 893, 971)



 