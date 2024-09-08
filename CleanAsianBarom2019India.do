log using "logofcleaningforEntropy.smcl", replace
*do file for Trial 1 of Entropy with Ordinal Variables
*filename Trials1ordinal.do
* Wendy Olsen
* grateful thanks to Mr Ziyang Zhou - Univ. of Manchester
* Univ of Manchester 2024

* Stata 18
***Data cleaning***
cd "C:\data\AsianBaro"

*Part 2:  FURTHER CLEANING
*Clean variables in the AB data for 2019 India
* make income have ten bins, ordinal cuts on a continuous variable.

*Objective:  Entropy and Regression Analysis (conferences 2024)
*Wendy Olsen
* Univ. of Manchester 2024

* file origins.  First, in \raw\ directory, the AsianBaro2019.dta was revised to give clean income.  This file was named Asianbaro2019rev1.dta. I have omitted this step and placed the cleaning codes here, below. 
* Then, in R the encoding took place and entropy was measured & compared.
* Now, we are making explicit all the coding so that regression can be done by anybody, using this file alone.

use "C:/data/AsianBaro/raw/AsianBaro2019.dta", clear
merge 1:1 IDnumber using "data\tmpAgeEduc.dta", update replace

*Aims 1. clean raw income, and Aim 2 clean the raw opinion variables.  Output the dataset in a well named form. 
tab Se14
tab SE14a
tab Se14, nol
tab SE14a, nol
*check education as it arrives to us
tab SE5
*and check the main source after recodes were done in R.
tab edu1_1 edu2_1
tab edu1_4 edu2_5
tab edu1_5 edu2_3
*the conclusion of the recoding is later on in this file. 

gen income = 5
*note, there are 92 cases which had missing Se14 and also no substantive answer to SE14a so these were coded to the category 5 income. 
replace income = 1 if Se14==1
replace income=3 if Se14==2
replace income=5 if Se14==3
replace income=7 if Se14==4
replace income=9 if Se14==5
*Note in Se14, the 9 refers to "Decline to Answer", 11% of respondents.
*Note in SE14a, the subjective options are:
*#1=Our income covers the needs well, we can save a lot.
*#2=Our income covers the needs well, we can save.
*#3=Our income covers the needs all right, without much difficulties.
*#4=Our income does not cover the needs, there are difficulties.
*#5=Our income does not cover the needs, there are great difficulties.
*#0=Not applicable.
tab Se14 SE14a, col row cell
*#7=Do not understand the question. <1% of respondents, but they gave an income quintile answer.
*#9=Decline to answer. <2% of respondents --> income is coded '5' for 24 of these, ie 0.45% of sample.
replace income=2 if Se14==9& SE14a==5
replace income=4 if Se14==9& SE14a==4
replace income=6 if Se14==9& SE14a==3
replace income=8 if Se14==9& SE14a==2
replace income=10 if Se14==9 & SE14a==1
tab income SE14a, nol
tab income
tab income Se14, nol
tab income SE5, row
*To confirm, high decile income is higher income household.
*And high educ response so far is indicated only in categoricals.


*comment, this income distribution rises from lowest decile 1 to highest 10.

*there are a high percent of people declaring in the lowest 3 deciles (42%, raw)


label variable income "Household Income Decile - Subjective"
*aim:  set up inc1 etc. so that they are cumulative coding of income.  And on the converse, i.income is the distinct coding of income. 
gen inc1 = 0 
gen inc2=0 
gen inc3=0
gen inc4=0
gen inc5=0 
gen inc6 = 0 
gen inc7=0
 gen inc8=0
 gen inc9=0
 gen inc10=0 
replace inc1=1 if income==1
replace inc2=1 if income==2
replace inc3=1 if income==3
replace inc4=1 if income==4
replace inc5=1 if income==5
replace inc6=1 if income==6
replace inc7=1 if income==7
replace inc8=1 if income==8
replace inc9=1 if income==9
replace inc10=1 if income==10
tab inc10 income
*Cumulative coding of income (scheme 2)
gen inc2_1 = 0 
gen inc2_2=0 
gen inc2_3=0
gen inc2_4=0
gen inc2_5=0 
gen inc2_6 = 0 
gen inc2_7=0
 gen inc2_8=0
 gen inc2_9=0
 gen inc2_10=0 
replace inc2_1=1 
replace inc2_2=1 if inlist(income, 2,3,4,5,6,7,8,9, 10)
replace inc2_3=1 if inlist(income, 3,4,5,6,7,8, 9, 10)
replace inc2_4=1 if inlist(income, 4,5,6,7, 8, 9, 10)
replace inc2_5=1 if inlist(income, 5,6,7,8,9,10)
replace inc2_6=1 if inlist(income, 6,7,8,9,10)
replace inc2_7=1 if inlist(income, 7,8,9,10)
replace inc2_8=1 if inlist(income, 8,9,10)
replace inc2_9=1 if inlist(income, 9,10)
replace inc2_10=1 if income==10
tab inc2_8 income
*create a distinct indicator of income. 
gen byte incomecat = income
de incomecat, detail
*it is simply income. 

*Create a cumulative age schema.
gen age2_1=0
gen age2_2=0
gen age2_3=0
gen age2_4=0
gen age2_5=0
gen age2_6=0
gen age2_7=0
gen age2_8=0
gen age2_9=0
gen age2_10=0
replace age2_1 = 1 if age91to98==1 | age83to90==1 | age75to82==1 | age67to74==1 | age59to66==1 | age51to58==1 | age43to50==1 | age35to42==1 | age27to34==1 | age18to26==1
replace age2_2 = 1 if age91to98==1 | age83to90==1 | age75to82==1 | age67to74==1 | age59to66==1 | age51to58==1 | age43to50==1 | age35to42==1 | age27to34==1 
replace age2_3 = 1 if age91to98==1 | age83to90==1 | age75to82==1 | age67to74==1 | age59to66==1 | age51to58==1 | age43to50==1 | age35to42==1 
replace age2_4 = 1 if age91to98==1 | age83to90==1 | age75to82==1 | age67to74==1 | age59to66==1 | age51to58==1 | age43to50==1 
replace age2_5 = 1 if age91to98==1 | age83to90==1 | age75to82==1 | age67to74==1 | age59to66==1 | age51to58==1 

replace age2_6 = 1 if age91to98==1 | age83to90==1 | age75to82==1 | age67to74==1 | age59to66==1 
replace age2_7 = 1 if age91to98==1 | age83to90==1 | age75to82==1 | age67to74==1 
replace age2_8 = 1 if age91to98==1 | age83to90==1 | age75to82==1 
replace age2_9=1 if  age91to98==1 | age83to90==1
replace age2_10 = 1 if age91to98==1
*create a distinct age schema.  Just use i.agecat. 
gen age1_1=0
gen age1_2=0
gen age1_3=0
gen age1_4=0
gen age1_5=0
gen age1_6=0
gen age1_7=0
gen age1_8=0
gen age1_9=0
gen age1_10=0
*work up the replacement carefully. 
replace age1_1 =1 if age18to26==1
replace age1_2 =1 if age27to34==1
replace age1_3 =1 if age35to42==1
replace age1_4 =1 if age43to50==1 
replace age1_5 =1 if age51to58==1
replace age1_6 =1 if age59to66==1
replace age1_7 =1 if age67to74==1
replace age1_8 =1 if age75to82==1
replace age1_9 =1 if age83to90==1 
replace age1_10 =1 if  age91to98==1
gen agecat=0
replace agecat=1 if age1_1==1
replace agecat=2 if age1_2==1
replace agecat=3 if age1_3==1
replace agecat=4 if age1_4==1
replace agecat=5 if age1_5==1
replace agecat=6 if age1_6==1
replace agecat=7 if age1_7==1
replace agecat=8 if age1_8==1
replace agecat=9 if age1_9==1
replace agecat=10 if age1_10==1
tab agecat SE6, col
*Strong bias to low age groups in the unweighted Asian Barometers. 

*The AB 2019 dataset has case weights. We have not used them here.
isid IDnumber


*Descriptives
tab Q63 
tab Q69
tab Q146
gen female=0
replace female=1 if SE2==2
hist w
tab Region
tab Level
tab Q63 
tab Q63 , nol
*Variable based on "Q63. When a mother-in-law and a daughter-in- law come into conflict, even if the mother- in-law is in the wrong, the husband should still persuade his wife to obey his mother."
gen rural=0
replace rural=1 if Level==1
gen edu=0
replace edu=1 if SE5==1|SE5==2
replace edu=2 if SE5==3
replace edu=3 if SE5==4|SE5==6
replace edu=4 if SE5==5|SE5==7
replace edu=5 if SE5==8|SE5==9|SE5==10
replace edu=1 if SE5==99
tab edu
label define educ 1 "Below Primary" 2 "Primary" 3 "Incomplete Secondary" 4 "Complete Secondary" 5 "Higher Educ", modify
label values edu educ
*Note. This is the original recoding of Education but we could alternatively receive the one-hot encoded variables as vectors from R using merge. The one that was in R is called Edu (sic)
*But. When we use R we kept the edu1 and edu2 encoded blocks in dataframes.  So one has to start combining etc. before a single write.csv and it's not really worth it.


*Scheme 1 distinct coding - it arrived from R. 
*gen edu1_1=0
*gen edu1_2=0
*gen edu1_3=0
*gen edu1_4=0
*gen edu1_5=0
*replace edu1_1=1 if edu==1
*replace edu1_2=1 if edu==2
*replace edu1_3=1 if edu==3
*replace edu1_4=1 if edu==4
*replace edu1_5=1 if edu==5
*Scheme 2 cumulative coding
*gen edu2_1=0
*gen edu2_2=0
*gen edu2_3=0
*gen edu2_4=0
*gen edu2_5=0
*replace edu2_1=1 if inlist(edu, 1)
*replace edu2_2=1 if inlist(edu, 1,2)
*replace edu2_3=1 if inlist(edu, 1,2,3)
*replace edu2_4=1 if inlist(edu, 1,2,3,4)
*replace edu2_5=1 if inlist(edu, 1,2,3,4,5)
tab edu2_4 edu
tab edu1_2 edu
 tab edu2_2 edu
tab edu2_5 edu
tab edu1_3 edu 
tab edu2_3 edu
*
gen state=Region
gen muslim=0
replace muslim=1 if SE6==40
label define muslim  0 "No" 1 "Muslim", modify
label values muslim muslim
summ Q63, detail
tab Q63
*Preferring that a daughter-in-law NOT concede to husband's mother is a high value on this ordinal scale.
gen op1=Q63
replace op1=4 if Q63==3
replace op1=5 if Q63==4
*take care of Do not understand the question 7 Can't choose 8 and Decline to answer 9. 
replace op1=3 if Q63==7|Q63==8|Q63==9
tab op1
gen opinDIL=op1

* NOtes: Do not understand the question |         7
*> 7        1.45       92.20
 *                 Can't choose |        22
*> 0        4.14       96.33
 *            Decline to answer |        19
*> 5        3.67      100.00

tab Q69, nol
*Preferring to have girl children is a high value on the ordinal scale.
gen op2=Q69
replace op2=4 if Q69==3
replace op2=5 if Q69==4
*take care of Do not understand the question 7 Can't choose 8 and Decline to answer 9. 
replace op2=3 if Q69==7|Q69==8|Q69==9
tab op2
gen opinBOY=op2

summ Q146, detail
tab Q146, nol
* Preferring to have women engaged in politics is a high value on the ordinal scale.
gen op3=Q146
replace op3=4 if Q146==3
replace op3=5 if Q146==4
*take care of Do not understand the question 7 Can't choose 8 and Decline to answer 9. 
replace op3=3 if Q146==7|Q146==8|Q146==9
tab op3
gen opinFEM=op3
table (female), stat(mean op1-op3) nformat(%9.1f)
format op1-op3 %9.1f
corr op1-op3, noformat
save "C:/data/AsianBaro/data/AsianBaro2019revForEntropy.dta", replace
*Note: opinFEM is the one about women in politics, FEM being the view that women should be engaged in politics.                     opinDIL is the one about daughters-in-law: Variable based on "Q63. When a mother-in-law and a daughter-in- law come into conflict, even if the mother- in-law is in the wrong, the husband should still persuade his wife to obey his mother.             And, opinBOY is the view about preferring to have a boy child, if only 1 child can be had. 


*Figure 0 Income and Age by Education in Asia Barometers 2019 India
*Table for Figure 0
collect:  table  (edu) (agecat) (incomecat), statistic (mean agecat) statistic(percent edu) statistic(n income) nformat (%9.0f mean) nformat (%9.0f n) 
collect export "EducationIncomeAgeIndia2019.xlsx", cell(C6) sheet(Figure0table) modify
putexcel set EducationIncomeAgeIndia2019.xlsx, sheet(Figure0table) modify
putexcel A1 ="Household Income, Age and Education of Respondent, Info for Figure 0"
putexcel A2 ="EducationIncomeAgeIndia2019"
putexcel (a3) = "University of Manchester"
putexcel C6:L6 , txtwrap
putexcel close
putexcel save
* Bar charts of original education levels reported, with age mean and Income Decile. 
gen educLabel=edu
lab var educLabel "Education Level of Adult"
lab define educLabel 1 "" 2 "Pr" 3 "" 4 "Se" 5 "Uni", modify
lab val educLabel educLabel

lab var income "Household Income Decile"
lab define inclab 1 "Worst-Off" 10 "Best-Off", modify
lab val income inclab
graph hbar  age  , over(educLabel) over(income) bar(1, color(sand)) bar(2,color(gold))   blabel(bar, format(%9.1f) size(2))  ytitle("Education Levels Clustered;  Age Shows Numeric Mean") title("Mean Age Within Education Group, By Income Decile") subtitle("High Income Is at Bottom")   
graph export "results\EducandAgeByIncomeIndia.wmf", replace
graph export "results\EducandAgeByIncomeIndia.jpg", replace

*Figure 1 Income by Education in Asia Barometers 2019 India
*Table for Figure 1
collect:  table  (edu)  (incomecat), statistic(percent edu) statistic(n income) nformat (%9.0f mean) nformat (%9.0f n) 
collect export "EducationIncomeIndia2019.xlsx", cell(C6) sheet(Figure1table) modify
putexcel set EducationIncomeIndia2019.xlsx, sheet(Figure1table) modify
putexcel A1 ="Income and Education of Respondent, Info for Figure 2"
putexcel A2 ="EducationIncomeIndia2019"
putexcel (a3) = "University of Manchester"
putexcel C6:L6 , txtwrap
putexcel close
putexcel save
* Bar charts of original education levels reported, with age mean and Income Decile. 

lab var educLabel "Education Level of Adult"
lab define educLabel 1 "Less" 2 "Prim" 3 "Some" 4 "Secy" 5 "Uni", modify
lab val educLabel educLabel
tab educLabel income
lab var income "Household Income Decile"
lab define inclab 1 "Worst-Off" 10 "Best-Off", modify
lab val income inclab
graph hbar  edu1_1 edu1_2 edu1_3 edu1_4 edu1_5, over(income) stack  percentages bar(1, color(sand)) bar(2,color(gold))   blabel(bar, format(%9.2f) size(2))  ytitle("Education Levels") title("India, % in Education Group, By Income Decile")
graph export "results\EducByIncomeIndia.wmf", replace
graph export "results\EducByIncomeIndia.jpg", replace

*Figure 2 Income Breakdown in Asia Barometers 2019 India
*Table for Figure 2
collect:  table   (incomecat), statistic(percent incomecat) statistic(n income) nformat (%9.0f mean) nformat (%9.0f n) 
collect export "IncomeIndia2019.xlsx", cell(C6) sheet(Figure2table) modify
putexcel set IncomeIndia2019.xlsx, sheet(Figure2table) modify
putexcel A1 ="Income of Respondent, Info for Figure 2"
putexcel A2 ="IncomeIndia2019"
putexcel (a3) = "University of Manchester"
putexcel C6:L6 , txtwrap
putexcel close
putexcel save
* Bar charts of original education levels reported, with age mean and Income Decile. 
lab var income "Household Income Decile"
lab define inclab 1 "Worst-Off" 10 "Best-Off", modify
lab val income inclab
*graph hbar (percent) i.income, bar(1, color(sand)) bar(2,color(gold))   blabel(bar, format(%9.2f) size(2))   title("India, % in Income Decile")

** Part 3 Aggregate Exercise - see separate do file.
* Hypothesis.  Using simulation, the MSE of H is higher for ordinal education than for cumulative education when it is multinomial in 5 categories. 
*   We emulated education in five levels from the Asian Barometers, unweighted.
*this dataset has nothing in comment with the rest of the data. 
*use "\data\Edtmp.dta", clear


save "C:/data/AsianBaro/data/AsianBaro2019revForEntropy.dta", replace
log close
translate "logofcleaningforEntropy.smcl" "logofcleaningforEntropy.pdf", replace