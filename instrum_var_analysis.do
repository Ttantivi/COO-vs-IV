// Thipbadee Tantivilaisin
// IV Analysis


set more off
clear all
global directory = "/Users/tim/Desktop/"
use "${directory}/comp_ia_bootstrap4_RCT.dta"

// Label all variables with non self-explanatory names
label var vote02 "Voted in 2002"
label var treat_real "Assigned to be called"
label var contact "Answered Call"
label var newreg "Is Newly Registered"
label var busy "Whether the phone line was busy when call was made"
label var age "Age"
label var female "If Female"
label var vote00 "Voted in 2000"
label var state "State of residence 1 for Iowa and 0 for Michigan"
label var comp_mi "Value of 1 for - competitive district in Michigan (Michigan A in the paper)"
label var comp_ia "Value of 1 for - competitive district in Iowa (Iowa A in the paper)"
label var vote98 "Voted 1998"

// part 1/2
// Creating a balance table
// Comparing the descriptive statistics of the treatment group vs. the non-treatment group. (call vs no call)
eststo Control: estpost summarize age female newreg vote98 vote00 if treat_real == 0  
eststo Treatment: estpost summarize age female newreg vote98 vote00  if treat_real == 1
eststo Difference: estpost ttest age female newreg vote98 vote00, by(treat_real) unequal  
esttab Control Treatment Difference using "${directory}/balance_check_check_IV.rtf",  cells("mean(pattern(1 1 0) fmt(3))  b(star pattern(0 0 1) fmt(3)) p(pattern(0 0 1)  fmt(4))") title("Balance Check between groups: Picking up the Call vs. Not Picking up Call")  label replace plain

//1. Differences are statistically significant
//2. Table 1 suggests that the control group does not provide a good counter factual
//3. The reason they differ is due to selection bias.

// part 4
// Creating a table of the regressions below
ivregress 2sls vote02 (contact=treat_real)
outreg2 using "${directory}/reg_vote02_IV.tex", replace title("The Effect of Receiving Voter Mobilization Message on 2002 Voter Turnout Using IV Estimator") 
ivregress 2sls vote02 age (contact=treat_real)
outreg2 using "${directory}/reg_vote02_IV.tex", append 
ivregress 2sls vote02 age female (contact=treat_real)
outreg2 using "${directory}/reg_vote02_IV.tex", append 
ivregress 2sls vote02 age female newreg (contact=treat_real)
outreg2 using "${directory}/reg_vote02_IV.tex", append 
ivregress 2sls vote02 age female newreg vote98 (contact=treat_real)
outreg2 using "${directory}/reg_vote02_IV.tex", append 
ivregress 2sls vote02 age female newreg vote98 vote00 (contact=treat_real)
outreg2 using "${directory}/reg_vote02_IV.tex", append



