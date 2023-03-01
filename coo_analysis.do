// Correction on Observables analysis

set more off

clear all

global directory = "/Users/Desktop/"

use "${directory} comp_ia_bootstrap4_RCT.dta"

// For my analysis I will completely ignore the 2000 vote, as midterm rates are different from general election"

// Label all variables with non self-explanatory names
label var vote02 "Which is the outcome of interest- vote in 2002"
label var treat_real "Assignment to treatment group"
label var contact "Received phone call and responded to question -Can I count on you to vote next Tuesday?- regardless of answer"
label var newreg "Newly registered voter"
label var busy "Whether the phone line was busy when call was made"
label var age "Age of the individual in years"
label var female "Gender of the individual"
label var vote00 "Voted in 2000 (prior to treatment)"
label var state "State of residence 1 for Iowa and 0 for Michigan"
label var comp_mi "Value of 1 for - competitive district in Michigan (Michigan A in the paper)"
label var comp_ia "Value of 1 for - competitive district in Iowa (Iowa A in the paper)"
label var vote98 "Voted in 98 (prior to treatment)"



// Creating a shared pool of voters that could vote in 98 and 02
gen vote02elligiblevote98 = vote02 if age>22&(treat_real==1|treat_real==0)
label var vote02elligiblevote98 "Portion of voters in 2002 that were also elligible to vote in 1998 and were in the experiment pool in 2002"

gen vote98elligible = vote98 if age>22&(treat_real==1|treat_real==0)
label var vote98elligible "Portion of voters in 1998 that were elligible to vote in 1998 and were in the experiment pool in 2002"

// I am controlling for the fact that people vote less in the midterms vs. general elections
// Therefore I will compare the effect of the treatment on people that didn't vote in 2000 vs 2002
gen vote00elligible = vote00 if age>22&(treat_real==1|treat_real==0)
label var vote00elligible "Portion of voters in 2000 that were elligible to vote in 1998 and were in the experiment pool in 2002"
gen vote00elligible_NoVote = vote00elligible if vote00elligible==0
label var vote00elligible_NoVote "Portion of voters in 2000 that were elligible to vote in 1998 and were in the experiment pool in 2002 that didn't vote"
gen vote00elligible_YesVote = vote00elligible if vote00elligible==1
label var vote00elligible_YesVote "Portion of voters in 2000 that were elligible to vote in 1998 and were in the experiment pool in 2002 that did vote"

gen vote02elligiblevote98_treated = vote02elligiblevote98 if treat_real ==1
label var vote02elligiblevote98_treated "Portion of participants in 2002 that were treated"
gen vote02elligiblevote98_control = vote02elligiblevote98 if treat_real ==0
label var vote02elligiblevote98_control "Portion of participants in 2002 that were not treated"

gen treat_real_elligible = treat_real if age>22&(treat_real==1|treat_real==0)
label var treat_real_elligible "Portion of voters elligible in 1998 that were in the experiment pool in 2002"

gen contact_elligible = contact if age>22&(treat_real==1|treat_real==0)

// part 1/2
// Creating a balance table
// Comparing the descriptive statistics of the treatment group vs. the non-treatment group. (call vs no call)
eststo Control: estpost summarize age female newreg county if treat_real_elligible == 0  
eststo Treatment: estpost summarize age female newreg county if treat_real_elligible == 1  
eststo Difference: estpost ttest age female newreg county, by(treat_real_elligible) unequal  
esttab Control Treatment Difference using "${directory}/randomization_voters_check.rtf",  cells("mean(pattern(1 1 0) fmt(3))  b(star pattern(0 0 1) fmt(3)) p(pattern(0 0 1)  fmt(4))") title("Balance Check between groups: Assigned to job phone call vs. no phone call")  label replace plain

// part 3
ttest vote02elligiblevote98 == vote98elligible												         // testing if prior is different from previous treatment
ttest vote02elligiblevote98 == vote98elligible if vote98elligible==0 & treat_real==1                 // testing if prior is different from treatment if they didn't vote in 98 and were treated
ttest vote02elligiblevote98 == vote98elligible if vote98elligible==0 & treat_real==0                 // same as line above but not treated
ttest vote02elligiblevote98_treated == vote02elligiblevote98_control if vote98elligible==0, unpaired // test difference in turnout between treated and untreated is significant
ttest vote02elligiblevote98_treated == vote02elligiblevote98_control, unpaired				         // testing if treated is equal to control in 2002
// want to know if difference between people who didn't vote in 2000, and if treatment had an effect on them
ttest vote00elligible == vote02elligiblevote98 if vote00elligible==0 & treat_real==1	           	 //  testing if 2000 is different from 2002 for those that didn't vote and were treated
ttest vote00elligible == vote02elligiblevote98 if vote00elligible==0 & treat_real==0

// part 4-5
// Creating a table of the regressions below
reg vote02elligiblevote98 treat_real_elligible
outreg2 using "${directory}/reg_vote02_on_covariates.xls", replace 
reg vote02elligiblevote98 treat_real_elligible vote98elligible
outreg2 using "${directory}/reg_vote02_on_covariates.xls", append 
reg vote02elligiblevote98 treat_real_elligible vote98elligible
outreg2 using "${directory}/reg_vote02_on_covariates.xls", append 
reg vote02elligiblevote98 treat_real_elligible vote98elligible age  
outreg2 using "${directory}/reg_vote02_on_covariates.xls", append 
reg vote02elligiblevote98 treat_real_elligible vote98elligible age female
outreg2 using "${directory}/reg_vote02_on_covariates.xls", append 
reg vote02elligiblevote98 treat_real_elligible vote98elligible age female vote00elligible
outreg2 using "${directory}/reg_vote02_on_covariates.xls", append 
