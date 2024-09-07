log using "logofRunAllEntropy.smcl", replace
*do file for Trial 1 of Entropy with Ordinal Variables
*filename Trials1ordinal.do
* Wendy Olsen
* grateful thanks to Mr Ziyang Zhou - Univ. of Manchester
* Univ of Manchester 2024

* Stata 18

***Three steps in Stata follow the main step that was in R. ***
***We call them parts. 
cd "C:\data\AsianBaro"

*Part 1
*Run this part (not shown here) in R-studio as an RMD file so you can see the data objects & products. 

* if in doubt, see Www.github.com/WendyOlsen/entropyOrdinalData2024

*Part 2
run "code\CleanAsianBarom2019India.do"
*Part 3
run "code\Trials1ordinal.do"
*Part 4
run "code\entropySimulEduc.do"

log close
translate "C:\data\AsianBaro\logofRunAllEntropy.smcl" "C:\data\AsianBaro\logofRunAllEntropy.pdf", replace
