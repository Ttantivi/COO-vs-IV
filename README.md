# COO-vs-IV
Comparing non-experimental correction on observables to instrumental variables.

This was a research paper I wrote as I was finishing up my undergrad at UC Santa Cruz, in a course under Dr. Carlos Dobkin.

## Reproducitbility

The data files have .do (Stata) files have been uploaded in the repo.

## Abstract
This paper evaluates the validity of the causal estimated average treatment effect using correction on observables (COO) with a non-experimental framework by comparing it to the local average treatment effect (LATE) derived from a randomized control trial using the instrumental variables (IV) method. The data for both these methods were obtained from a subset of a voter mobilization experiment conducted prior to the 2002 U.S. midterm election by Arcenaux et al. The first step of our analysis began with creating a balance table to verify that certain conditions are met before we began our methods. The table verified that the randomization of the experiment was successful for the RCT, but not for the COO due to how the treatment and control groups were defined. The second method used estimated the local average treatment effect using a two-stage least squares regression for the experimental data and a regression for the non-experimental data. Both methods resulted in the average treatment effect being statistically significant in our framework, however, COO overestimated the average treatment effect by 2.10 times the amount of our IV estimate due to selection and omitted variable bias.
