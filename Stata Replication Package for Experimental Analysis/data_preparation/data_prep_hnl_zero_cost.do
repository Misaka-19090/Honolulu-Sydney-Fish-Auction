clear
log using "data_prep_HNL_zero_cost.log"

*************STEP 0 *************************************
 ************RAW DATA FILE WITH ZERO-COST PREDICTIONS *********************** 

 **paste  "Honolulu_paydiff_norm_zerocost.csv'
  *
* tab sessioncode
 * 15 sessions     
*save "Honolulu_zero_cost_all_pred.dta"
 
 
*************STEP 1 *************************************
*****OPEN THE RAW DATA FILE AND MOIFY ******

use "Honolulu_zero_cost_all_pred.dta", clear

ren participantdate_num sessiondate

tab sessioncode
sort sessioncode participantlabel subsessionround_number

ren  participantlabel_num subjectID

******************************* 
 
 
gen HNL=1



rename sessionconfig* *
*this eliminated "sessionconfig" from the front of session parameter variables
ren subsession* *
*this eliminated "subsession" from the front of the round number and starting price 


ren name sessionname
* attach back the label "session" where needed

ren groupid_in_subsession groupid_in_round

ren playeritem_value item_value

*******Drop observations from test rounds 
drop if round_number <= num_test_rounds
*sum round_number
****

*************CHECK THAT PREDICTED ZERO_COST DURATION BY STAGE IS CORRECT ****************
gen High=(discount_b>0.01)
tab High

sort sessioncode
by sessioncode: egen bidders=max(playerid_in_group)

tab bidders

sort bidders High
by bidders High: sum start_price predict0groupdutch_time_elapsed predict0groupenglish_time_elapse predict0groupenglish_final_price
****YES CORRECT: DUTCH STAGE DURATION == STARTING PRICE; ENGLISH STAGE DURATION = ENGLISH FINAL PRICE 
 
keep participantcode sessioncode round_number predict0playeroptimal_dutch_bid predict0playeris_dutch_winner predict0playercontest_status predict0playerenglish_dropout_el predict0playeris_english_winner predict0playeris_final_winner predict0playerpayoff predict0groupdutch_time_elapsed predict0groupdutch_final_price predict0groupenglish_time_elapse predict0groupenglish_final_price predict0groupauctioneer_utility HNL

rename *group* ** 
 
ren predict0* zerocost*

sort sessioncode participantcode round_number

save "Honolulu_zero_cost_pred.dta"
*, replace
**************************************END ZERO COST HNL AUCTION PREDICTIONS ***********


*************STEP 3 *************************************
***MERGE WITH INDIVIDUAL-LEVEL DATA ****
use "Honolulu_ALL_individual.dta", clear

sort sessioncode participantcode round_number

merge 1:1 sessioncode participantcode round_number using "Honolulu_zero_cost_pred.dta"
drop _merge


save "Honolulu_ALL_individual_with_predictions_zerocost.dta"
*, replace
********************USE THIS FILE FOR COMPARING ACTUAL DATA WITH ZERO-COST PREDICTIONS *********************

log close
