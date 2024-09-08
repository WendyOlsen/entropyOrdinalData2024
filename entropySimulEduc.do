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
*this dataset has nothing in common with the rest of the data. 

use "data\edtmp.dta", clear
*Note the edtmp file has the standard, distinct encodings. 
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

* generate relative entropy for distinct encoding.
gen RSIsim =- [(p1*ln(p1))+(p2*ln(p2))+(p3*ln(p3))+(p4*ln(p4))+(p5*ln(p5))] / ln(5)
summ(RSIsim)
 *Helpful notes egen [type] newvar = fcn(arguments) [if] [in] [, options]
 * &      pctile(exp) [, p(#) autotype]    
egen RSIsimUL = pctile(RSIsim ), p(97.5)
egen RSIsimLL = pctile(RSIsim), p(2.5)
summarize  RSIsimUL RSIsim RSIsimLL

*the MSE is defined as the sum of squared deviations, divided by N.
egen RSIsimmean=pctile(RSIsim), p(50)
gen RSIsimMSEsubs=(RSIsim- RSIsimmean)^2
egen RSIsimMSEaggreg = total(RSIsimMSEsubs)
summarize(RSIsimMSEaggreg)



*Step 2. Create a block of data, EdCumtmp.dta"
*This is cumulative encodings of the previous dataset. 

gen X1cum=(X1+X2+X3+X4+X5)
gen X2cum=(X2+X3+X4+X5)
gen X3cum=(X3+X4+X5)
gen X4cum=(X4+X5)
gen X5cum=(X5)
gen newN = (X1+X2+X3+X4+X5)
gen p1cum = X1cum/newN
gen p2cum = X2cum/newN
gen p3cum = X3cum/newN
gen p4cum = X4cum/newN
gen p5cum = X5cum/newN
gen hsimcum =- [(p1cum*ln(p1cum))+(p2cum*ln(p2cum))+(p3cum*ln(p3cum))+(p4cum*ln(p4cum))+(p5cum*ln(p5cum))]
summ(hsimcum)
 *Helpful notes egen [type] newvar = fcn(arguments) [if] [in] [, options]
 * &      pctile(exp) [, p(#) autotype]    
egen hsimcumUL = pctile(hsimcum ), p(97.5)
egen hsimcumLL = pctile(hsimcum), p(2.5)
summarize  hsimcumUL hsimcum hsimcumLL

*the MSE is defined as the sum of squared deviations, divided by N.
egen hsimcummean=pctile(hsimcum), p(50)
gen hsimcumMSEsubs=(hsimcum- hsimcummean)^2
egen hsimcumMSEaggreg = total(hsimcumMSEsubs)
summarize(hsimcumMSEaggreg)

* generate relative entropy for cumulative encoding.
gen RSIsimcum =- [(p1cum*ln(p1cum))+(p2cum*ln(p2cum))+(p3cum*ln(p3cum))+(p4cum*ln(p4cum))+(p5cum*ln(p5cum))] / ln(5)
summ(RSIsimcum)
 *Helpful notes egen [type] newvar = fcn(arguments) [if] [in] [, options]
 * &      pctile(exp) [, p(#) autotype]    
egen RSIsimcumUL = pctile(RSIsimcum ), p(97.5)
egen RSIsimcumLL = pctile(RSIsimcum), p(2.5)
summarize  RSIsimcumUL RSIsimcum RSIsimcumLL

*the MSE is defined as the sum of squared deviations, divided by N.
egen RSIsimcummean=pctile(RSIsimcum), p(50)
gen RSIsimcumMSEsubs=(RSIsimcum- RSIsimcummean)^2
egen RSIsimcumMSEaggreg = total(RSIsimcumMSEsubs)
summarize(RSIsimcumMSEaggreg)


log close

translate "logofSimulationforEntropy.smcl" "logofSimulationforEntropy.pdf", replace
