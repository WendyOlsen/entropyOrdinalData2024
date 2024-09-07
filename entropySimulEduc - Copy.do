log using "logofSimulationforEntropy.smcl", replace

*do file for Simulation of Education's Entropy 
*filename entropySimulEduc.do
* Wendy Olsen
* grateful thanks to Mr Ziyang Zhou - Univ. of Manchester
* Univ of Manchester 2024

* Stata 18

 ssc install estout

 ***Data already exist but results go in \results folder ***
cd "C:\data\AsianBaro"

** Part 4 Aggregate Exercise - see separate do file.
* Hypothesis.  Using simulation, the MSE of H is higher for ordinal education than for cumulative education when it is multinomial in 5 categories. 
*   We emulated education in five levels from the Asian Barometers, unweighted.
*this dataset has nothing in comment with the rest of the data. 

use "\data\Edtmp.dta", clear
*Note the Edtmp file has the standard, distinct encodings. 

de
summ(X1)
drop N
drop p1 p2 p3 p4 p5
drop hsim 
gen N=5318
gen p1 = X1/N
gen p2 = X2/N
gen p3 = X3/N
gen p4 = X4/N
gen p5 = X5/N
gen hsim =- [(p1*ln(p1))+(p2*ln(p2))+(p3*ln(p3))+(p4*ln(p4))+(p5*ln(p5))]
summ(hsim)
 *Helpful notes egen [type] newvar = fcn(arguments) [if] [in] [, options]
 * &      pctile(exp) [, p(#) autotype]    
egen hsimUL = pctile(hsim ), p(97.5)
egen hsimLL = pctile(hsim), p(2.5)
summ hsimUL hsim hsimLL
egen hsimmean=pctile(hsim), p(50)
*the MSE is defined as the sum of squared deviations, divided by N.
gen hsimMSEsubs=(hsim- hsimmean)^2
egen hsimMSEaggreg = total(hsimMSEsubs)
summarize(hsimMSEaggreg)

*Step 2. use "\data\EdCumtmp.dta", clear
*Note the Edcumtmp file has cumulative encodings. 

de
summ(X1)


gen p1cum = X1cum/N
gen p2cum = X2cum/N
gen p3cum = X3cum/N
gen p4cum = X4cum/N
gen p5cum = X5cum/N
gen hsimcum =- [(p1*ln(p1))+(p2*ln(p2))+(p3*ln(p3))+(p4*ln(p4))+(p5*ln(p5))]
summ(hsim)
 *Helpful notes egen [type] newvar = fcn(arguments) [if] [in] [, options]
 * &      pctile(exp) [, p(#) autotype]    
egen hsimUL = pctile(hsim ), p(97.5)
egen hsimLL = pctile(hsim), p(2.5)
summarize  hsimUL hsim hsimLL

* generate relative entropy 


log close

translate "logofSimulationforEntropy.smcl" "logofSimulationforEntropy.pdf", replace
