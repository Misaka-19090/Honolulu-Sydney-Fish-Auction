clear

log using "ipayoffs_prep.log"

frames reset

******1 ***********
******GENERATE PARTICIPANT DUTCH AND HNL ACTUAL AND PREDICTED TOTAL PAYOFFS ************* 
use "Dutch_ALL_individual.dta", clear

*******Check if all subjects are assigned unqueID'd *********
sort sessionID round_number subjectID

 list sessionID subjectID  round_number  if uniqueID==.
 **Good, all subjects have uniqueID's ******************
  
 ****************************************************************
 
sort sessionID round_number groupid_in_round playerid_in_group
 
 
sort sessionID uniqueID round_number 
tab sessionID

keep uniqueID round_number  participantpayoff participantdutch_payoff participanthonolulu_payoff playerpayoff predictplayerpayoff HNL sessionID part 

 ***********Generate Dutch payoff total ***************** 
**Check if player total Dutch payoff matches the sum of per period payoffs
sort uniqueID round_number 
by uniqueID: egen Dutchpay_sum=sum(playerpayoff)

gen dutchpayoff_discrepancy= participantdutch_payoff - Dutchpay_sum   if round_number==3
sum dutchpayoff_discrepancy
****Discrepancies are +/-2, due to rounding error. Ok.
drop dutchpayoff_discrepancy
 **********

 ***********Generate Dutch payoff total predicted 
sort uniqueID
by  uniqueID: egen Dutchpay_predict_sum=sum(predictplayerpayoff)
gen Dutchpay_ratio=Dutchpay_sum/Dutchpay_predict_sum


list uniqueID round_number Dutchpay_sum Dutchpay_predict_sum if Dutchpay_ratio==.
**Player ID 508 is predicted to earn zero; therefore the ratio to predicted cannot be calculated 


ren uniqueID globalid
sort globalid

collapse (mean) sessionID participantpayoff participantdutch_payoff participanthonolulu_payoff Dutchpay_sum Dutchpay_predict_sum (count) rounds=participantpayoff, by(globalid)

summarize

frame 
frame rename default subject_Dutch_payoffs


*******************NOW HNL PAYOFFS ******************

frame create subject_HNL_payoffs
frame change subject_HNL_payoffs

frames dir
frame

frame subject_HNL_payoffs: use "Honolulu_ALL_individual.dta", clear

frames dir
sum HNL

*******Check if all subjects are assigned unqueID'd *********
sort sessionID round_number subjectID

 list sessionID subjectID  round_number  if uniqueID==.
 **Good, all subjects have uniqueID's ******************
 
keep uniqueID round_number  participantpayoff participantdutch_payoff participanthonolulu_payoff playerpayoff predictplayerpayoff HNL sessionID part 
 
***********Generate Total HNL pyoff and TotalHNL payoff predicted
sort uniqueID
by uniqueID: egen HNLpay_sum=sum(playerpayoff)
sort uniqueID 
by  uniqueID: egen HNLpay_predict_sum=sum(predictplayerpayoff)
*
gen HNL_pay_diff=participanthonolulu_payoff - HNLpay_sum
sum HNL_pay_diff if round_number==3
****Discrepancies are +/-2, due to rounding error. Ok
drop HNL_pay_diff


ren uniqueID globalid
sort globalid

collapse (mean) sessionID participantpayoff participantdutch_payoff participanthonolulu_payoff HNLpay_sum HNLpay_predict_sum (count) rounds=participantpayoff, by(globalid)

summarize


**************NEXT MERGE FILES WITH HNL AND DUTCH PAYOFF PREDICTIONS *********

frames dir

sort globalid

frlink 1:1 sessionID globalid participantpayoff participantdutch_payoff participanthonolulu_payoff rounds, frame(subject_Dutch_payoffs)

frget Dutchpay_sum Dutchpay_predict_sum, from(subject_Dutch_payoffs)

sum 
drop subject_Dutch_payoffs

ren sessionID sessionid

frames dir
frames drop subject_Dutch_payoffs
frame rename subject_HNL_payoffs default
frame copy default subject_HNL_and_Dutch_payoffs
frames dir
frame


****2***
*************ADD PERCENTAGE PAYOFFS, PAYOFF DEVIATIONS FROM PREDICTIONS, AND TOP/BOTTOM EARNERS ***************** 
****************


gen bidders=5
replace bidders=2 if((sessionid==6)|(sessionid==7)|(sessionid==10)|(sessionid==13)|(sessionid==15)|(sessionid>=17)) 

gen High=(((sessionid>=5)&(sessionid<=9))|(sessionid==12)|(sessionid==13)|(sessionid==15))

tab bidders High
********************************************************************
**** participant_payoff***

gen total_payoff=participantdutch_payoff + participanthonolulu_payoff
gen total_payoff_predict= Dutchpay_predict_sum  + HNLpay_predict_sum


**********Normalized payoffs and percent payoff ***********
***ALL
gen dpay_norm=(total_payoff-total_payoff_predict)/(2*rounds)
gen paypercent= 100*(total_payoff)/total_payoff_predict

************************
gen total_payoff_mean = total_payoff/(2*rounds)
gen total_payoff_predict_mean = total_payoff_predict/(2*rounds)

*********************

**Now by Auction type:*************
*******Dutch
gen Dutch_dpay_norm=(participantdutch_payoff-Dutchpay_predict_sum)/(rounds)
gen Dutch_paypercent= 100*(participantdutch_payoff)/Dutchpay_predict_sum


*******HNL
gen HNL_dpay_norm=(participanthonolulu_payoff-HNLpay_predict_sum)/(rounds)
gen HNL_paypercent= 100*(participanthonolulu_payoff)/HNLpay_predict_sum

******************
summarize Dutch_paypercent, detail
summarize HNL_paypercent, detail



sort  bidders High 
by bidders High: egen medianDutch_paypercent=median(Dutch_paypercent)
sort  bidders High 
by bidders High: egen medianHNL_paypercent=median(HNL_paypercent)

**********Classify bidders into Top and Bottom Earners based on Dutch payoff
gen top_Dutch_pay=(Dutch_paypercent>medianDutch_paypercent)

gen top_HNL_pay=(HNL_paypercent>medianHNL_paypercent)

tab top_Dutch_pay top_HNL_pay
**Just over a half of participants are consistently in the Top or Bottom category for both Dutch and HNL auctions.
****The other half are in the top for one institution, and in the bottom for the other one
**********************************

sort globalid
save "subject_HNL_and_Dutch_payoffs_with_predictions_ALL.dta", replace  
*****This file summarizes predicted and actual payoffs per bidderID, and classification into Top/Bottom earners
*****************


******2 ***********
***********DATA FILES PREPARATION FOR BIDDER ANALYSIS BY AUCTION TYPE ***************

**DATA FILE PREPARATION FOR DUTCH AUCTIONS BIDS ANALYSIS ******
************
use "Dutch_ALL_individual.dta", clear

sort sessionID
tab sessionID 

ren uniqueID globalid
sort sessionID globalid round_number

merge m:1 globalid using "subject_HNL_and_Dutch_payoffs_with_predictions_ALL.dta" 
drop _merge

save "Dutch_ALL_for_bidder_analysis.dta"
 
************** USE THE FILE ABOVE TO COMPARE HIGH AND LOW EARNERS IN DUTCH AUCTIONS *************************
****************************************************************************************

**DATA FILE PREPARATION FOR HNL AUCTION BIDS ANALYSIS ******
************

use "Honolulu_ALL_individual_with_predictions_zerocost.dta", clear

sort sessionID
tab sessionID 

ren uniqueID globalid
sort sessionID globalid round_number

merge m:1 globalid using "subject_HNL_and_Dutch_payoffs_with_predictions_ALL.dta" 
drop _merge

save "Honolulu_ALL_for_bidder_analysis.dta"

**************NOW WE CAN USE THE FILE ABOVE TO COMPARE HIGH AND LOW EARNERS *************************

******************END DATA PREPARATION *********************

log close
