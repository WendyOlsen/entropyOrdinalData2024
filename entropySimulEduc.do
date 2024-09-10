log using "logofSimulationforEntropy.smcl", replace

*do file for Simulation of Education's Entropy 
*filename entropySimulEduc.do
* Wendy Olsen
* grateful thanks to Mr Ziyang Zhou - Univ. of Manchester
* Univ of Manchester 2024

* Stata 18
*This file is part 4 of the entropy project. 
*This file has two aims.  4a) First, calculate Entropy for 2 variables, one dataframe, using Stata.

*Second, do an aggregate exercise in **simulating** EDUC and calculate Entropy manually using that S=1000 repeated samples bloc of vectors. 
 ssc install estout

 ***Data already exist but results go in \results folder ***
cd "C:\data\AsianBaro"

** Part 4a Calculate Entropy in Stata for a single variable, then 2 variables.  One needs to recognise the  number of cells in 2-var exercise depends on the unique values of each one, k*j.  Whilst N is still the sum of all cell values. 
cd "C:\data\AsianBaro"
use "C:/data/AsianBaro/data/AsianBaro2019revForEntropy.dta", clear
tab income inc2_2
summ( edu2_1 edu2_2 edu2_3 edu2_4 edu2_5 ) if edu1_4==1 
egen sumedu1_1 = sum(edu1_1)
egen sumedu1_2 = sum(edu1_2)
egen sumedu1_3 = sum(edu1_3)
egen sumedu1_4 = sum(edu1_4)
egen sumedu1_5 = sum(edu1_5)
egen countedu1_1 = sum(edu1_1)
egen countedu1_2 = sum(edu1_2)
egen countedu1_3 = sum(edu1_3)
egen countedu1_4 = sum(edu1_4)
egen countedu1_5 = sum(edu1_5)
gen Nedu=countedu1_1+countedu1_2+countedu1_3+countedu1_4+countedu1_5
gen entropyofEduc1 = -((sumedu1_1/5318)*ln(sumedu1_1/5318)+(sumedu1_2/5318)*ln(sumedu1_2/5318)+(sumedu1_3/5318)*ln(sumedu1_3/5318)+(sumedu1_4/5318)*ln(sumedu1_4/5318)+(sumedu1_5/5318)*ln(sumedu1_5/5318))
summ(entropyofEduc1)


summ( edu2_1 edu2_2 edu2_3 edu2_4 edu2_5 ) if edu1_4==1 
egen sumedu2_1 = sum(edu2_1)
egen sumedu2_2 = sum(edu2_2)
egen sumedu2_3 = sum(edu2_3)
egen sumedu2_4 = sum(edu2_4)
egen sumedu2_5 = sum(edu2_5)
egen countedu2_1 = sum(edu2_1)
egen countedu2_2 = sum(edu2_2)
egen countedu2_3 = sum(edu2_3)
egen countedu2_4 = sum(edu2_4)
egen countedu2_5 = sum(edu2_5)
gen Nedu2=countedu2_1+countedu2_2+countedu2_3+countedu2_4+countedu2_5
summ(Nedu2)
#This cumulative amount depends upon Nedu and the actual data. 
gen entropyofEduc2 = -((sumedu2_1/5318)*ln(sumedu2_1/5318)+(sumedu2_2/5318)*ln(sumedu2_2/5318)+(sumedu2_3/5318)*ln(sumedu2_3/5318)+(sumedu2_4/5318)*ln(sumedu2_4/5318)+(sumedu2_5/5318)*ln(sumedu2_5/5318))
*Suppose the N is still 5318, the raw number of respondents:
summ(entropyofEduc2)
*Suppose the N is the number of responses, which are in columns 1 to 5.  First columna has 5318 but the others are data, empirical, unknown.  

gen entropyofEduc2withN2 = -((sumedu2_1/Nedu2)*ln(sumedu2_1/Nedu2)+(sumedu2_2/Nedu2)*ln(sumedu2_2/Nedu2)+(sumedu2_3/Nedu2)*ln(sumedu2_3/Nedu2)+(sumedu2_4/Nedu2)*ln(sumedu2_4/Nedu2)+(sumedu2_5/Nedu2)*ln(sumedu2_5/Nedu2))
summ(entropyofEduc2withN2)
summ(Nedu2)
** Part 4b Aggregate Exercise - see separate do file.
* Hypothesis.  Using simulation, the MSE of H is higher for ordinal education than for cumulative education when it is multinomial in 5 categories. 
*   We emulated education in five levels from the Asian Barometers, unweighted.
*this dataset has nothing in common with the rest of the data. 

use "data\edtmp.dta", clear
*Note the edtmp file has the standard, distinct encodings. 
de
summ(X1)
*drop N
*drop p1 p2 p3 p4 p5
*drop hsim 
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
egen hsimmode=pctile(hsim), p(50)
egen hsimmean=mean(hsim)
summ (hsimmean hsimmode)
*the MSE is defined as the sum of squared deviations, divided by N.
*there is one squared deviation per Sample drawn. The SquDev's are the value (Hi - Hmean )^2 for all 1000 sample replicates, i.  
gen hsimMSEsubs=(hsim- hsimmean)^2
egen tempsum=total(hsimMSEsubs)
gen hsimMSEaggreg =tempsum/1000
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
egen tempsum2 = total(RSIsimMSEsubs)
gen RSIsimMSEaggreg = tempsum2/1000
summarize(RSIsimMSEaggreg)

*Step 2. Create a block of data, EdCumtmp.dta"
*This is cumulative encodings of the previous dataset. 

gen X1cum=(X1+X2+X3+X4+X5)
gen X2cum=(X2+X3+X4+X5)
gen X3cum=(X3+X4+X5)
gen X4cum=(X4+X5)
gen X5cum=(X5)
gen newN = (X1+2*X2+3*X3+4*X4+5*X5)
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
egen tempsum3 = total(hsimcumMSEsubs)
gen hsimcumMSEaggreg  = tempsum3/1000
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
egen tempsum4= total(RSIsimcumMSEsubs)
gen RSIsimcumMSEaggreg  = tempsum4/1000
summarize(RSIsimcumMSEaggreg)


log close

translate "logofSimulationforEntropy.smcl" "logofSimulationforEntropy.pdf", replace
