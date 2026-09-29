* ---------------------------------------------------------------------------
* Replication package root.
* Either start Stata in the Replication_JPE folder, or set
*     global REPLICATION_ROOT "/full/path/to/Replication_JPE"
* before running this do-file.
* ---------------------------------------------------------------------------

if "$REPLICATION_ROOT" != "" {
	capture cd "$REPLICATION_ROOT"
}
else if c(username) == "jaedo" {
	capture cd "C:/Users/jaedo/Dropbox/CLRS_growth_concentration/Replication_JPE/"
}
else if c(username) == "jc224773" {
	capture cd "C:/Users/jc224773/Dropbox/CLRS_growth_concentration/Replication_JPE/"
	capture cd "~/Dropbox/CLRS_growth_concentration/Replication_JPE/"
}

* Stop with a clear message if the working directory is not the package root.
capture confirm file "STATA/DATA_CLEANING.do"
if _rc {
	display as error "Working directory is not the Replication_JPE root."
	display as error "Current directory: `c(pwd)'"
	display as error `"Set it with:  global REPLICATION_ROOT "/full/path/to/Replication_JPE""'
	exit 601
}
disp(c(pwd))
set type double 

** Install the following Stata packages if uninstalled 
/*
qui: capture: ssc install ftools, replace
qui: capture: ssc install gtools, replace 
qui: capture: ssc install ivreghdfe, replace 
qui: capture: ssc install lassopack, replace
qui: capture: ssc install pdslasso, replace
qui: capture: ssc install ranktest, replace 
qui: capture: ssc install reghdfe, replace 
qui: capture: ssc install require, replace 
qui: capture: ssc install winsor2, replace 
qui: capture: ssc install unique, replace 
*/

grstyle init
grstyle set plain
grstyle set symbol tufte
grstyle set color Set1
grstyle set legend, nobox
grstyle linewidth plineplot medthick
grstyle set lpattern
 
set graphics on
set rng default 


** STATA: Part 1
qui: do STATA/DATA_CLEANING.do 
qui: do STATA/CONCENTRATION.do // Firm concentration figures 
qui: do STATA/TO_MATLAB.do // Input for quantification 
qui: do STATA/ESTIMATION_PROD_FUNC.do // Input for production function estimation 
 
** STATA: Part 2 (Run after running Matlab_part1.m)
qui: do STATA/PF_EST_RESULT.do // Production function estimation results 
qui: do STATA/Merger.do // Robustness checks regarding mergers and acquisitions
qui: do STATA/SHOCK_CORR.do  // Robustness regarding shock correlation; Construct shock-series (Panel E of Table 7)
qui: do STATA/DISTRIBUTED_LAG.do // Estimate distributed-lag model (Table B5)
qui: do STATA/spillover_region.do // Construct shock-series that incorporates potential spatial spillovers, estimated from Choi and Shim (Restat, forthcoming)
qui: do STATA/HCI_Drive.do 	// External validation: Industrial policy event study (Figure B10)
qui: do STATA/BRIBERY.do	// External validation: Bribery (Table B5, Figure B11)
qui: do STATA/SHOCK_VALIDATION.do 
qui: do STATA/FIGURE6_scatter_plot_villain // Plot Figure 6 







