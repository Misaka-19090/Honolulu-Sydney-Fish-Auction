clear
log using "data_prep_main_Dutch.log", replace

**************STEP 0 *************************************
 *********************************** 
  **paste 'Dutch_paydiff_norm.csv' into Stata
 
 *
 *tab sessioncode
 * 15 sessions     
 *save "Dutch_ALL_raw_with_pred.dta" 

 
*********************************

**********STEP 1 ********************** 
*****OPEN THE RAW DATA FILE AND MODIFY ******

use "Dutch_ALL_raw_with_pred.dta", clear
  
********************************************
*************GENRATE GROUP-LEVEL DATA FILE WITH PREDICTIONS ****************

tab participantdate_num 
tab sessioncode sessiontreatment_num

ren participantdate_num sessiondate


sort sessioncode participantlabel subsessionround_number

ren  participantlabel_num subjectID


tab sessioncode

*session.code	Freq.	Percent	Cum.
*			
*15t0rnnr	250	7.28	7.28
*5m969a1u	144	4.19	11.47
*785y9gdo	216	6.29	17.76
*7xbozwc7	180	5.24	23.01
*a2ehf0h4	280	8.15	31.16
*btnhfeao	250	7.28	38.44
*c9oliyzc	144	4.19	42.63
*cbdt6t3s	180	5.24	47.87
*hie4719f	280	8.15	56.03
*nli0vb0t	180	5.24	61.27
*ogo32l47	270	7.86	69.13
*p66lw61j	180	5.24	74.37
*r6ovli5x	420	12.23	86.60
*w4lqxa01	280	8.15	94.76
*yq06059v	180	5.24	100.00
*			
*Total	3,434	100.00

 
*****generate Numerical Session ID 

*Pilot sessions 1-4 are not included here **
gen sessionID = 5 if  sessioncode=="ogo32l47"
replace sessionID = 6 if  sessioncode=="cbdt6t3s"
replace sessionID = 1 if  sessioncode=="1a6f5vso"
replace sessionID = 2 if  sessioncode=="xxs3tbv8"
replace sessionID = 3 if  sessioncode=="evl8vztg"
replace sessionID = 4 if  sessioncode=="foft5c5c"
replace sessionID = 7 if  sessioncode=="nli0vb0t"
replace sessionID = 8 if  sessioncode=="15t0rnnr"
replace sessionID = 9 if  sessioncode=="w4lqxa01"
replace sessionID = 10 if  sessioncode=="5m969a1u"
replace sessionID = 11 if  sessioncode=="hie4719f"
replace sessionID = 12 if  sessioncode=="btnhfeao"
replace sessionID = 13 if  sessioncode=="7xbozwc7"
*
replace sessionID = 14 if  sessioncode=="r6ovli5x"
replace sessionID = 15 if  sessioncode=="p66lw61j"
replace sessionID = 16 if  sessioncode=="a2ehf0h4"
replace sessionID = 17 if  sessioncode=="785y9gdo"
replace sessionID = 18 if  sessioncode=="yq06059v"
replace sessionID = 19 if  sessioncode=="c9oliyzc"


tab sessionID

 
***Participant ID's
 gen uniqueID=sessionID*100+subjectID
 
 sum subjectID uniqueID
******************************** 
 
 
gen HNL=0



rename sessionconfig* *
*this eliminated "sessionconfig" from the front of session parameter valirables
ren subsession* *
*this eliminated "subsession" from the front of the round number and starting price 


ren name sessionname
* attach back the label "session" where needed


ren playeritem_value item_value

drop sessiontreatment_num
*This treatmewnt code is never used

tab discount_b


gen part=((HNL==1)&(is_dutch_first==0))
replace part=1 if((HNL==0)&(is_dutch_first==1))
replace part=2 if part==0

tab part

 
sum item_value if sessionID<=4
sum item_value if sessionID>4

*******Drop observations from test rounds 
drop if round_number <= num_test_rounds
sum round_number

ren groupid_in_subsession groupid_in_round

sort sessionID round_number groupid_in_round

***Number of bidder in group, and number of concurrent groups:
by sessionID round_number groupid_in_round: egen bidders=max(playerid_in_group) 
by sessionID round_number: egen num_groups=max(groupid_in_round) 

tab bidders num_groups


******************************** 

*Generate Max value for each group period, and the identity of the highest value bidders

sort sessionID round_number groupid_in_round

by sessionID round_number groupid_in_round: egen maxvalue=max(item_value)
gen hashighestvalue=(item_value==maxvalue)


sum  maxvalue hashighestvalue

replace real_world_currency=0.1 if sessionID==19

sort sessionID round_number groupid_in_round  playerid_in_group

save "Dutch_ALL_individual.dta"

************THIS IS THE FILE THAT CONTAINS INDIVIDUAL_LEVEL DATA WITH PREDICTIONS FOR DUTCH


********************STEP 3:  **NOW GENERATE GROUP_LEVEL DATA FILE ***********************

use "Dutch_ALL_individual.dta", clear

sort sessionID round_number groupid_in_round playerid_in_group

**************Generate winner value and winner ID
gen winID_temp=playeris_final_winner *uniqueID
gen winvalue_temp=playeris_final_winner * item_value
sort sessionID round_number groupid_in_round
by sessionID round_number groupid_in_round: egen winner_value=max(winvalue_temp)
by sessionID round_number groupid_in_round: egen winnerID=max(winID_temp)

*Check that the created variables are correct:
list  sessionID round_number groupid_in_round playerid_in_group subjectID playeris_final_winner item_value winner_value winnerID if((sessionID==5)&(round_number==5)&(groupid_in_round==1))

drop winvalue_temp  winID_temp

*********Dutch auction duration
gen duration =(groupdutch_time_elapsed)/ price_tick
gen predictduration=( predictgroupdutch_time_elapsed ) / price_tick

************Player and winner payoffs **********
gen predictplayer_payoff=(item_value - predictgroupdutch_final_price)*(1-discount_b*predictduration)*predictplayeris_dutch_winner

gen calcplayer_payoff=(item_value - groupdutch_final_price)*(1-discount_b*duration)*playeris_final_winner
replace calcplayer_payoff=(item_value - groupdutch_final_price)*(1+discount_b*duration)*playeris_final_winner if(item_value < groupdutch_final_price)

***TEST THAT THE PAYOFF CALCULATIONS CORRECT *****

gen calcpayoffdiff = calcplayer_payoff - playerpayoff  
sum calcpayoffdiff

***********Calculated and actual payoffs are different because predicted bids and payoffs are not rounded 
gen roundcalcpayoff=round(calcplayer_payoff)

list calcplayer_payoff  playerpayoff  if abs(calcplayer_payoff - playerpayoff) >= 1
***There is only one obs where the differentce is just over 1. Consider correct. 

 drop calcpayoffdiff roundcalcpayoff
 ***********************************


gen winpayoff_temp=calcplayer_payoff if (playeris_final_winner ==1)
sort sessionID round_number groupid_in_round
by sessionID round_number groupid_in_round: egen winner_payoff=mean(winpayoff_temp)
*

sort bidders
by bidders: sum winner_payoff winpayoff_temp
*only winners get non-missing value for winner payoff_temp

gen predictwinpayoff_temp=predictplayer_payoff if (predictplayeris_dutch_winner ==1)
sort sessionID round_number groupid_in_round
by sessionID round_number groupid_in_round: egen predictwinpayoff=mean(predictwinpayoff_temp)
sum winner_payoff winpayoff_temp predictwinpayoff predictwinpayoff_temp
*
drop  winpayoff_temp predictwinpayoff_temp
*
 

*************RENAME VARIABLES  
 
ren  groupdutch_final_price groupfinal_price 
ren  predictplayeris_dutch_winner predictplayeris_final_winner
ren  predictgroupdutch_final_price  predictgroupfinal_price



drop participantcode participantdutch_payoff participanthonolulu_payoff participanttime_started_utc skip_intro_dutch discount_a start_round_dutch num_test_rounds start_round_honolul skip_intro_honolulu participation_fee playeris_dutch_winner grouphave_dutch_winner predictplayerbid uniqueID 


  
***********NOW SAVE JUST THE GROUP VARIABLES  
 
sort sessionID round_number groupid_in_round playerid_in_group

drop if playerid_in_group != 1 
 
***Drop participant-specific variables, leave only group variables ******
drop participantlabel participantpayoff playerid_in_group price_start item_value playeris_final_winner playerpayoff predictplayeris_final_winner subjectID hashighestvalue predictplayerpayoff calcplayer_payoff

drop predictplayer_payoff 

sort sessionID

sum

save "Dutch_ALL_group_vars_only.dta"

***************************************
****END DATA PREPARATION FILE FOR DUTCH AUCTIONS ANALYSIS
***********************************************

log close



