
********************************************************************************
** Commodity sectors 
********************************************************************************
replace sec = "_AtB" if inlist(sec, "_1", "_2", "_A", "_B")  

/*
_10	……Mining of coal and lignite; extraction of peat 
_11	……Extraction of crude petroleum and natural gas and services
_12	……Mining of uranium and thorium ores 
_13	……Mining of metal ores 
_14	……Other mining and quarrying 
*/

replace sec = "_C" if inlist(sec, "_10", "_11", "_12", "_13", "_14")

replace sec = "_AtB" if inlist(sec, "_01", "_02", "_05", "_C") // Mining => Commodity 

********************************************************************************
** Manufacturing sectors
********************************************************************************
/*
……Food products and beverages
……Tobacco products
*/
replace sec = "_15t16" if inlist(sec, "_15", "_16")

/*
_17	………Textiles
_18	………Wearing Apparel, Dressing And Dying Of Fur
_19 Leather 
*/

replace sec = "_17t19" if inlist(sec, "_17", "_18", "_19")

// replace sec = "_17" if inlist(sec, "_17", "_18")

/*
_20	…WOOD AND PRODUCTS OF WOOD AND CORK
_21	……Pulp, paper and paper products
_221	………Publishing
_22x	………Printing and reproduction
*/

replace sec = "_20t22" if inlist(sec, "_20", "_21", "_221", "_22x", "_22")

*  "_244", 
replace sec = "_24t25" if inlist(sec, "_24", "_24x", "_25")

replace sec = "_27t28" if inlist(sec, "_27", "_28")

/*
_30	……Office, accounting and computing machinery
_313	…………Insulated wire
_31x	…………Other electrical machinery and apparatus nec
_321	…………Electronic valves and tubes
_322	…………Telecommunication equipment
_323	…………Radio and television receivers
_331t3	………Scientific instruments
_334t5	………Other instruments
*/

replace sec = "_30t33" if inlist(sec, "_30", "_31", "_32", "_30t32", "_33") | inlist(sec, "_313", "_31x", "_321", "_322", "_323", "_331t3", "_334t5")
 
/*
_29     Machinery 
_34 	Motor vehicle
_351	………Building and repairing of ships and boats
_353	………Aircraft and spacecraft
_35x	………Railroad equipment and transport equipment nec
*/


// replace sec = "_34t35" if inlist(sec, "_34", "_351", "_353", "_35x")
// replace sec = "_35" if inlist(sec, "_351", "_353", "_35x")
replace sec = "_29-34t35" if inlist(sec, "_29", "_34", "_351", "_353", "_35x", "_35")
 
/*
……Manufacturing nec
……Recycling
*/

replace sec = "_36t37" if inlist(sec, "_36", "_37", "_36t37")



/*
replace sec = "_17t19" if inlist(sec, "_17t19", "_36t37")
replace sec = "_24t25" if inlist(sec, "_23", "_244")
replace sec = "_27t28" if inlist(sec, "_26")
*/


** Aggregate
// replace sec = "_1LIGHT" if inlist(sec, "_17", "_18", "_17t18", "_19", "_36t37", "_20t22") | inlist(sec, "_15t16", "_17t19")
// replace sec = "_2HEAVY" if inlist(sec, "_23", "_24t25", "_244", "_26", "_27t28", "_30t33", "_29-34t35")

********************************************************************************
** Utility 
********************************************************************************
/*
_40x	……Electricity supply
_402	……Gas supply
_41	…WATER SUPPLY
*/

replace sec = "_UTILITY" if inlist(sec, "_40", "_40x", "_402", "_41")

********************************************************************************
** Construction 
********************************************************************************
replace sec = "_F" if inlist(sec, "_45")


********************************************************************************
** Retail
********************************************************************************
/*
……Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of  fuel
……Wholesale trade and commission trade, except of motor vehicles and motorcycles
……Retail trade, except of motor vehicles and motorcycles; repair of household goods
*/

replace sec = "_RETAIL" if inlist(sec, "_50", "_51", "_52")

********************************************************************************
** Service sectors
********************************************************************************
/*
_60	……Inland transport
_61	……Water transport
_62	……Air transport
_63	……Supporting and auxiliary transport activities; activities of travel agencies
*/

replace sec = "_TRANS" if inlist(sec, "_60", "_61", "_62", "_63")

/*
……Financial intermediation, except insurance and pension funding
……Insurance and pension funding, except compulsory social security
……Activities related to financial intermediation

_70imp	………Imputation of owner occupied rents
_70x	………Other real estate activities
_71	………Renting of machinery and equipment
_72	………Computer and related activities
_73	………Research and development
_741t4	…………Legal, technical and advertising
_745t8	…………Other business activities, nec
*/

replace sec = "_BSERVICE" if inlist(sec, "_64") | inlist(sec, "_65", "_66", "_67") | inlist(sec, "_70imp", "_70x") | inlist(sec, "_71", "_72", "_73", "_74", "_741t4", "_745t8")

/*
_H	…HOTELS AND RESTAURANTS

_L	…PUBLIC ADMIN AND DEFENCE; COMPULSORY SOCIAL SECURITY
_M	…EDUCATION
_N	…HEALTH AND SOCIAL WORK
 
_90	……Sewage and refuse disposal, sanitation and similar activities 
_91	……Activities of membership organizations nec 
_921t2	………Media activities
_923t7	………Other recreational activites
_93	……Other service activities  
*/

/*
…PRIVATE HOUSEHOLDS WITH EMPLOYED PERSONS
…EXTRA-TERRITORIAL ORGANIZATIONS AND BODIES
*/

replace sec = "_SERVICE" if inlist(sec, "_H") | inlist(sec, "_L", "_M", "_N", "_O") | inlist(sec,  "_90", "_91", "_92",  "_921t2", "_923t7", "_93") | inlist(sec, "_99", "_P", "_Q")

 


