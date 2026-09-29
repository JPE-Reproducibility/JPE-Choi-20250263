replace sec = "_AtB" if sitc3 == 1 | inrange(sitc3, 43, 45)
replace sec = "_C" if inrange(sitc3, 272, 278) | inrange(sitc3, 281, 289)
replace sec = "_15" if inrange(sitc3, 11, 42) | inrange(sitc3, 46, 122) | inrange(sitc3, 222, 223)

replace sec = "_17" if inrange(sitc3, 261, 269)  | inrange(sitc3, 291, 292) | inrange(sitc3, 411, 431) | inrange(sitc3, 651, 659)
replace sec = "_18" if inrange(sitc3, 831, 848) 
replace sec = "_19" if inrange(sitc3, 211, 212) | sitc3 == 851
replace sec = "_20" if inrange(sitc3, 244, 251) | inrange(sitc3, 634, 642) | inrange(sitc3, 811, 821) | inrange(sitc3, 891, 893)

replace sec = "_23" if inrange(sitc3, 321, 344)
replace sec = "_24x" if sitc3 == 272 | inrange(sitc3, 511, 533) | inrange(sitc3, 551, 598)
replace sec = "_244" if inrange(sitc3, 541, 542)  
replace sec = "_25" if inrange(sitc3, 231, 232)  | inrange(sitc3, 611, 633)

replace sec = "_26" if inrange(sitc3, 661, 667)
replace sec = "_27" if inrange(sitc3, 671, 689)
replace sec = "_28" if inrange(sitc3, 691, 699)




replace sec = "_29" if inrange(sitc3, 711, 749)

replace sec = "_30t33" if inrange(sitc3, 750, 778) | inrange(sitc3, 871, 885)
replace sec = "_34" if inrange(sitc3, 781, 784) | sitc3 == 951
replace sec = "_35" if inrange(sitc3, 785, 793)

replace sec= "_36t37" if inrange(sitc3, 893, 941) | sitc3 == 971



 