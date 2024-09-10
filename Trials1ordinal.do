log using "C:\data\AsianBaro\logtrials1Entropy.smcl", replace

*do file for Trials of Entropy with Ordinal Variables
*filename Trials1ordinal.do
* Wendy Olsen
* grateful thanks to Mr Ziyang Zhou - Univ. of Manchester
* Univ of Manchester 2024

* PART 2  Trials of Ordered Probit Regression 
* Stata 18

 ssc install estout
***Data cleaning***
cd "C:\data\AsianBaro"
use "C:/data/AsianBaro/data/AsianBaro2019revForEntropy.dta", clear
tab income inc2_2
list inc2_1 inc2_2 inc2_3 inc2_4 inc2_9 if edu1_1==1 
list inc1 inc2 inc3 inc4 inc9 if edu1_1==1 

drop _merge
*Using oprobit, 
de edu*
*discrete edu is i.edu.  Stata oprobit isn't accepting this. So we have to recreate each level as a dummy.
summ(age)
summ(income)
summ agecat

*Part 1 Bivariate Regressions 

*Test Equation Age scheme 1 distinct
*oprobit i.income age
oprobit incomecat age
eststo esttrial1, title(AsianBarotrials1eq1)
*reference case age43to50
oprobit incomecat age18to26       age27to34       age35to42    age51to58       age59to66       age67to74       age75to82       age83to90       age91to98  
eststo esttrial2, title(AsianBarotrials1eq2)
twoway scatter income age ||qfit income age
oprobit incomecat 
*Handy, there is not a positive association of income with age.
* also we have avoided using weights - these results not representative. 
estat ic  
*The rev1 income variable refers to household income in the adult's estimate of their quintile, adjusted by filling in 11% missing values using the decile levels in the ladder of quantiles with variable SE14a which is about household ability to afford to live. 
estimates table esttrial1 esttrial2
etable, estimates(esttrial1  esttrial2)  mstat(N) mstat(aic) mstat(bic) mstat(df) export(trialfileTestrun.pdf, replace)

 *mstat(aic) mstat(bic) mstat(ll)
 *mstat(mstat[, mstat_opts]) 

 *    BSPS Regression Table 
 
*Equation 1a, Income by Edu scheme 1 ordinal distinct
*Leave out the lowest education category
*ib(last).mpgTiles

tab incomecat
oprobit incomecat edu1_2 edu1_3 edu1_4 edu1_5
estat ic
eststo esttrial1a
*Equation 1b, Income by Edu scheme 2 ordinal cumulative
oprobit income edu2_2 edu2_3 edu2_4 edu2_5

*age18to26       age27to34       age35to42    age51to58       age59to66       age67to74       age75to82       age83to90       age91to98  
estat ic
eststo esttrial1b
estimates table esttrial1a esttrial1b
etable, estimates(esttrial1a  esttrial1b)  mstat(N) mstat(aic) mstat(bic) mstat(ll)  mstat(df) export(trialfile1.pdf, replace)

*Equation 2a, Education by Age scheme 1 ordinal distinct
oprobit educLabel i.agecat
estat ic
eststo esttrial2a
*Equation 2b, Education by Age scheme 2 ordinal cumulative
oprobit educLabel  age2_2 age2_3 age2_4 age2_5 age2_6 age2_7 age2_8 age2_9 age2_10   
estat ic
eststo esttrial2b
estimates table esttrial2a esttrial2a
etable, estimates(esttrial2a  esttrial2b)  mstat(N) mstat(aic) mstat(bic) mstat(ll)  mstat(df) export(trialfile2.pdf, replace)
*Equation 3a, Income by Age scheme 1 ordinal distinct
oprobit incomecat      age27to34       age35to42    age43to50  age51to58       age59to66       age67to74       age75to82       age83to90       age91to98  
estat ic
eststo esttrial3a

*Equation 3b, Income by Age scheme 2 ordinal cumulative
*note, some info we need is the entropy of age in ten bins, cumlative coding, and also, the entroyp of the combination income&age2, where income is the one-vector factor. 
save "C:/data/AsianBaro/data/AsianBaro2019revForEntropy.dta", replace
keep income age2_*
*the default version from stata v18 is stata v13. 
save incomeage2coding.dta, replace
keep age2_*
save age2coding.dta, replace
use  "C:/data/AsianBaro/data/AsianBaro2019revForEntropy.dta", clear

* base case is age2_1
oprobit incomecat  age2_2 age2_3 age2_4 age2_5 age2_6 age2_7 age2_8 age2_9 age2_10      
estat ic
eststo esttrial3b
estimates table esttrial3a esttrial3b
etable, estimates(esttrial3a  esttrial3b)  mstat(N) mstat(aic) mstat(bic) mstat(ll)  mstat(df) export(trialfile3.pdf, replace)

*Equation 4a, Likert opinBOY by Educ, scheme 1 ordinal distinct
oprobit opinBOY edu1_2 edu1_3 edu1_4 edu1_5
estat ic
eststo esttrial4a
*save and compare results

*Equation 4b, Likert opinBOY by Educ, scheme 2 ordinal cumulative
oprobit opinBOY edu2_2 edu2_3 edu2_4 edu2_5
estat ic
eststo esttrial4b

estimates table esttrial4a esttrial4b
etable, estimates(esttrial4a  esttrial4b)  mstat(N) mstat(aic) mstat(bic) mstat(ll)   mstat(df) export(trialfile4.pdf, replace)


*Equation 5a, Likerts opinBOY by Age, scheme 1 ordinal distinct
oprobit opinBOY      age27to34       age35to42  age43to50   age51to58       age59to66       age67to74       age75to82       age83to90       age91to98  
eststo esttrial5a
*Equation 5b, Likerts opinBOY by Age, scheme 2 ordinal cumulative
oprobit opinBOY age2_2 age2_3 age2_4 age2_5 age2_6 age2_7 age2_8 age2_9 age2_10      
estat ic 
eststo esttrial5b
estimates table esttrial5a esttrial5b
etable, estimates(esttrial5a  esttrial5b)  mstat(N) mstat(aic) mstat(bic) mstat(ll)  mstat(df) export(trialfile5.pdf, replace)

*Equation 6a, Likerts opinBOY by Income, scheme 1 ordinal distinct
oprobit opinBOY i.incomecat
estat ic 
eststo esttrial6a

*Equation 6b, Likerts opinBOY by Income, scheme 2 ordinal cumulative
oprobit opinBOY     inc2_2 inc2_3 inc2_4 inc2_5 inc2_6 inc2_7 inc2_8 inc2_9 inc2_10 
estat ic 
eststo esttrial6b
estimates table esttrial6a esttrial6b
etable, estimates(esttrial6a  esttrial6b)  mstat(N) mstat(aic) mstat(bic) mstat(ll)  mstat(df) export(trialfile6.pdf, replace)


tab age2_9
tab inc2_2 incomecat
*#It looks odd.  But it is correct, that inc2_2 is 0 for those on income category 1, the poorest.  Then, inc2_2 is 1 for all others. 
save "C:/data/AsianBaro/data/AsianBaro2019revForEntropy2.dta", replace
*Note the new data "2" can be used outside this set of trials. 

log close
translate "C:\data\AsianBaro\logtrials1Entropy.smcl" "C:\data\AsianBaro\logtrials1Entropy.pdf", replace

