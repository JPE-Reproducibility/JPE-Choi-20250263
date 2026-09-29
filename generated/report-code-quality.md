## Code Quality

### Stata

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (SHELL.do, line 12)
  → capture cd "C:/Users/jaedo/Dropbox/CLRS_growth_concentration/Replication_JPE/"

[CRITICAL] Hardcoded absolute path detected — the package will not run on another machine. (SHELL.do, line 15)
  → capture cd "C:/Users/jc224773/Dropbox/CLRS_growth_concentration/Replication_JPE/"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 14)
  → drop if firmid < 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 27)
  → drop if missing(g_code3)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 45)
  → keep if inlist(episode, "chun_bribe", "ilhae", "saesedae_heart")  // Chun-era only -> first Chun bribe/donation

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 59)
  → drop if firmid < 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 69)
  → drop if _feas == 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 84)
  → keep if _everposco == 1 & _minyr >= 1988

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 135)
  → keep if inrange(year, `cg'-5, `cg'-1)	// Should have operated -5 to -1 before the event

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 149)
  → keep if inrange(year, 1977, 1978)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 184)
  → drop if missing(gcode)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 196)
  → drop if missing(gcode)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 197)
  → keep if inrange(year, 1977, 1978)	// Restrict the control firms to have operated pre-Chun period

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 213)
  → drop if firmid < 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 256)
  → keep if inrange(year, `cg'-`before', `cg'+`after')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 267)
  → keep if ever_treated==1 | never_treat==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 268)
  → drop if never_treat==1 & year >= 1988 // 1988: Roh's start of the presidency

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 279)
  → drop if _hasc==0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 396)
  → drop if missing(g_code3) | group==""

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 453)
  → drop if missing(exr) | missing(gdpdef_us)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 460)
  → keep if inlist(episode,"chun_bribe","ilhae","saesedae_heart","saesedae_edu","roh_bribe")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 462)
  → drop if missing(g_code3) | missing(year_start)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 463)
  → drop if missing(amount_bn_won) | amount_bn_won<=0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 464)
  → drop if strpos(upper(group),"TOTAL")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 476)
  → drop if missing(gcode_key) | missing(kisn)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (BRIBERY.do, line 484)
  → keep if inrange(year,1980,1993) & !missing(sale) & !missing(kisn)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 15)
  → keep if inrange(year, 1972, `=last')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 25)
  → keep if manu == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 28)
  → keep if inrange(year, 1972, `=last')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 44)
  → keep if manu == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 46)
  → keep if inrange(year, 1972, `=last')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 55)
  → keep if manu == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 61)
  → keep if manu == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 64)
  → keep if inrange(year, 1972, `=last')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 93)
  → keep if manu == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 99)
  → keep if inrange(year, 1972, `=last')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 127)
  → keep if rank <= 3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 171)
  → keep if CR`i'==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 194)
  → keep if manu == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 200)
  → keep if inrange(year, 1972, 2011)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 233)
  → keep if CR`i'==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 256)
  → keep if manu == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 262)
  → keep if inrange(year, 1972, 2011)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (CONCENTRATION.do, line 269)
  → keep if rank <= 500

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 38)
  → drop if firmid < 0 | missing(firmid)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 102)
  → keep if inlist(episode,"chun_bribe","ilhae","saesedae_heart","saesedae_edu","roh_bribe")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 103)
  → drop if group == "kukje"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 104)
  → drop if missing(g_code3) | missing(year_start)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 117)
  → drop if missing(year) | missing(g_code3) | missing(kis)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 136)
  → keep if is_treatgrp==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 150)
  → drop if missing(year)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 156)
  → drop if missing(year)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 201)
  → keep if ini_status == 1                       // the draft's DL sample (firms first observed in 1972)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 202)
  → keep if inrange(year, `est_lo', `est_hi')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 360)
  → drop if firmid <= 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (DISTRIBUTED_LAG.do, line 519)
  → drop if firmid <= 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 19)
  → drop if missing(sitc2) | missing(sec)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 20)
  → drop if inlist(sec, "_AtB", "_C")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 27)
  → drop if (sigma <= `r(r1)' | sigma >= `r(r2)')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 46)
  → drop if missing(sitc3) | missing(sec)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 47)
  → drop if inlist(sec, "_AtB", "_C")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 54)
  → drop if sigma <= `r(r1)' | sigma >= `r(r2)'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 68)
  → drop if missing(sec)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 94)
  → drop if inlist(sec, "intcons", "expen", "export", "fcons") | inlist(sec, "import", "import_cif", "import_tar") | inlist(sec, "GO", "TOT", "VADD", "WBILL")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 132)
  → keep if osec == "`var'"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 136)
  → keep if dsec == "`var'"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 170)
  → keep if dsec == "`var'"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 171)
  → drop if inlist(osec, "GO", "TOT", "VADD", "WBILL")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 408)
  → keep if year == `=last' - 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 466)
  → drop if sh_cogs <= plp

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 467)
  → drop if sh_cogs >= pup

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (ESTIMATION_PROD_FUNC.do, line 499)
  → keep if inrange(year, 1972, 2011)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (HCI_Drive.do, line 124)
  → keep if _n == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 10)
  → keep if year == 1980

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 69)
  → drop if missing(ksic) | missing(ksic_k)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 72)
  → keep if num == max_num

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 95)
  → drop if temp_max_A_or_T == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 97)
  → keep if inrange(merger_year, 1972, 2011)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 154)
  → keep if manuT == 1 & manuA == 1  // Restricting it to merger within manufacturing sectors

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 179)
  → drop if regexm(cname, "`name'") & missing(manu)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 191)
  → keep if merger_status == "`var'"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 215)
  → keep if merger_status == "`st'"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 306)
  → keep if merger_type == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 314)
  → keep if max_year == merger_year

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 327)
  → keep if exit_merger == 3

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 330)
  → keep if merger_status == "A"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 345)
  → keep if merger_status == "`mtype'"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 365)
  → keep if merger_status == "`mstatus'"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 406)
  → drop if missing(sale) | missing(emp) | missing(fasset)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 421)
  → keep if year == merger_year

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 439)
  → drop if missing(sale) | missing(emp) | missing(fasset)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 455)
  → keep if treat_id == `wid'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 457)
  → drop if kis == kis_w

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 459)
  → drop if year >= ctrl_merger_year

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 466)
  → drop if missing(zdiff)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 469)
  → keep if rank <= `nnn'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 514)
  → drop if num <= 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 545)
  → keep if treat == 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 548)
  → keep if zdiff >= `r(p99)'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 555)
  → drop if ctrl_post == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (Merger.do, line 559)
  → keep if inrange(diff, -`before', `after')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (PF_EST_RESULT.do, line 126)
  → drop if secid == 4                      // pooled into sector 6 -> single table row

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 6)
  → drop if firmid < 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 14)
  → drop if firmid < 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 34)
  → keep if rank == `n'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 65)
  → keep if top3 == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 110)
  → keep if top3 == 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 131)
  → keep if inlist(osec, "`var'")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 132)
  → drop if inlist(dsec, "expen", "export", "fcons", "import", "import_cif", "import_tar", "intcons")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 149)
  → drop if inlist(osec, "GO", "TOT", "VADD", "WBILL")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 185)
  → drop if inlist(osec, "GO", "TOT", "VADD", "WBILL")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 203)
  → keep if osecid == dsecid

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 309)
  → drop if missing(`var')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 361)
  → drop if missing(`var')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 486)
  → keep if top3==1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_CORR.do, line 497)
  → drop if year==2012

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 16)
  → keep if inrange(year, 1970, 2011)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 17)
  → keep if inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244", "_24t25") | inlist(sec, "_26", "_27t28", "_29-34t35", "_30t33", "_36t37")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 25)
  → keep if inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244", "_24t25") | inlist(sec, "_26", "_27t28", "_29-34t35", "_30t33", "_36t37")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 30)
  → keep if inlist(icode, "454100", "458960", "100000")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 31)
  → keep if inlist(ecode, "454100", "458960", "100000")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 40)
  → keep if icode == "`code'" & ecode == "100000"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 47)
  → keep if ecode == "`code'" & icode == "100000"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 75)
  → keep if icode == "458960" & ecode == "454100"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 101)
  → keep if inlist(importer, "World", "KOR", "TWN") & inlist(exporter, "World", "KOR", "TWN")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 116)
  → keep if inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244", "_24t25") | inlist(sec, "_26", "_27t28", "_29-34t35", "_30t33", "_36t37")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 121)
  → keep if exporter == "`cty'" & importer == "World"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 129)
  → keep if importer == "`cty'" & exporter == "World"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 136)
  → keep if importer == "TWN" & exporter == "KOR"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 142)
  → keep if exporter == "TWN" & importer == "KOR"

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 158)
  → keep if year >= 2000

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 214)
  → drop if firmid < 0 | missing(firmid)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 288)
  → keep if inlist(episode,"chun_bribe","ilhae","saesedae_heart","saesedae_edu","roh_bribe")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 289)
  → drop if missing(g_code3) | missing(year_start)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 304)
  → drop if missing(year) | missing(g_code3) | missing(kis)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 312)
  → keep if (_roh==0 & inC==1) | (_roh==1 & inR==1)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 321)
  → keep if inrange(year, 1972, 1982)

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 504)
  → drop if missing(`dep')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 543)
  → keep if `cond'

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 571)
  → keep if secid > 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 573)
  → keep if firmid < = 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 578)
  → keep if firmid > 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 581)
  → keep if rank == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 586)
  → keep if inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244") | inlist(sec, "_24t25", "_26", "_27t28") | inlist(sec, "_29-34t35", "_30t33", "_36t37")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 595)
  → keep if secid > 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 597)
  → keep if inlist(sec, "_15t16", "_17t19", "_20t22", "_23", "_244") | inlist(sec, "_24t25", "_26", "_27t28") | inlist(sec, "_29-34t35", "_30t33", "_36t37")

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 601)
  → keep if firmid < = 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 605)
  → keep if firmid > 0

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (SHOCK_VALIDATION.do, line 616)
  → keep if cr3_`var' == 1

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (TO_MATLAB.do, line 191)
  → keep if inrange(year, `=start', `=last')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (TO_MATLAB.do, line 229)
  → keep if inrange(year, `=start', `=last')

[ADVISORY] Sample drop (`drop if` / `keep if`) not preceded by a comment within 2 lines — consider adding a comment explaining the criterion. (TO_MATLAB.do, line 431)
  → keep if inrange(year, 1972, `=last')

