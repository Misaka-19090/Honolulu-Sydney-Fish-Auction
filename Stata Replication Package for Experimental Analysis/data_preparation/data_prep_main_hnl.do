clear
log using "data_prep_HNL.log"

*************STEP 0 *************************************
*********************************** 
**paste  "Honolulu_paydiff_norm.csv'
  *
 *tab sessioncode
 * 15 sessions     
*save "Honolulu_ALL_raw_with_pred.dta"


**********STEP 1 ********************** 
*****CREATE GENERAL-PURPOSE DATA FILE WITH GROUP AND INDIVIDUAL-LEVEL DATA ******

use "Honolulu_ALL_raw_with_pred.dta", clear
 
********************************************
*************GENRATE GROUP-LEVEL VARIABLES WITH PREDICTIONS ****************

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
 
gen HNL=1


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

sum part



*******Drop observations from test rounds 
drop if round_number <= num_test_rounds
sum round_number

 ren groupid_in_subsession groupid_in_round

sort sessionID round_number groupid_in_round

by sessionID round_number groupid_in_round: egen bidders=max(playerid_in_group) 
by sessionID round_number: egen num_groups=max(groupid_in_round) 

sum bidders num_groups



******************************** 

*Generate Max value for each group period, and the identity of the highest value bidders

sort sessionID round_number groupid_in_round

by sessionID round_number groupid_in_round: egen maxvalue=max(item_value)
gen hashighestvalue=(item_value==maxvalue)


sum  maxvalue hashighestvalue


sort sessionID round_number groupid_in_round  playerid_in_group
 
*****LOOK FOR likely errors -- big losses
list sessionID round_number subjectID groupid_in_round item_value  playeris_final_winner groupfinal_price playerpayoff playerid_in_group if( playerpayoff  < -5)
***There are 24 instances of bidder losses! We kept them. 


**SAVE THIS GENERAL_PURPOSE DATA FILE BEFORE PROCEEDING **  

sort sessionID round_number groupid_in_round playerid_in_group
save "Honolulu_ALL_individual.dta" 
*, replace
************THIS IS THE FILE THAT CONTAINS INDIVIDUAL_LEVEL DATA WITH PREDICTIONS FOR HNL AUCTION


**********STEP 3 ********************** 
**NOW GENERATE GROUP_LEVEL DATA FILE

use "Honolulu_ALL_individual.dta", clear
sort sessionID round_number groupid_in_round playerid_in_group

gen winID_temp=playeris_final_winner *uniqueID
gen winvalue_temp=playeris_final_winner * item_value
sort sessionID round_number groupid_in_round
by sessionID round_number groupid_in_round: egen winner_value=max(winvalue_temp)
by sessionID round_number groupid_in_round: egen winnerID=max(winID_temp)

list  sessionID round_number groupid_in_round playerid_in_group subjectID playeris_final_winner item_value winner_value winnerID if((sessionID==5)&(round_number==5)&(groupid_in_round==1))

drop winvalue_temp  winID_temp

gen duration =(groupdutch_time_elapsed + groupenglish_time_elapsed)/ price_tick
gen predictduration=( predictgroupdutch_time_elapsed + predictgroupenglish_time_elapsed) / price_tick


gen calcplayer_payoff=(item_value - groupfinal_price)*(1-discount_b*duration)*playeris_final_winner
replace calcplayer_payoff=(item_value - groupfinal_price)*(1+discount_b*duration)*playeris_final_winner if(item_value < groupfinal_price)

gen winpayoff_temp=calcplayer_payoff if (playeris_final_winner ==1)
sort sessionID round_number groupid_in_round
by sessionID round_number groupid_in_round: egen winner_payoff=mean(winpayoff_temp)
sum winner_payoff winpayoff_temp

gen predictwinpayoff_temp=predictplayerpayoff if (predictplayeris_final_winner ==1)
sort sessionID round_number groupid_in_round
by sessionID round_number groupid_in_round: egen predictwinpayoff=mean(predictwinpayoff_temp)
sum winner_payoff winpayoff_temp predictwinpayoff predictwinpayoff_temp

sort sessionID round_number groupid_in_round
by sessionID round_number groupid_in_round: egen prednumwinners = sum(predictplayeris_final_winner)

list round_number groupid_in_round playerid_in_group item_value prednumwinners predictwinpayoff if prednumwinners > 1

********In auctions where more than one bidder has the max value, all bidders are predicted to win 
*******and get the total winner payoff. However, in this case any winner is predicted to earn zero.


drop winpayoff_temp predictwinpayoff_temp

sum predictplayerpayoff if((prednumwinners > 1)&(predictplayeris_final_winner))
***Obvisously, with more than 1 winner, all winners are predicted to earn ZERO!!!

*****Use "predictplayerpayoff" to compare actual winner payoffs to predicted
*******************************************************************************************************


***TEST THAT THE PAYOFF CALCULATION IS CORRECT *****
gen calcpayoffdiff = calcplayer_payoff - playerpayoff  
sum calcpayoffdiff

gen roundcalcpayoff=round(calcplayer_payoff)

list calcplayer_payoff  playerpayoff  if abs(calcplayer_payoff - playerpayoff) >= 1
list calcplayer_payoff  playerpayoff calcpayoffdiff  if roundcalcpayoff != playerpayoff
 ****YES< CORRECT, discrepancies are less than 1 unit in all cases but two****************

 
*********************Record the number of contestants in an auction to classify auction dynamics ************ 
gen number_contestants=grouphave_contest_winner

tab number_contestants


gen contest_participant=(playercontest_status==1)
gen predictcontest_participant=(predictplayercontest_status==1)
sort sessionID round_number groupid_in_round
by sessionID round_number groupid_in_round: egen contestants=sum(contest_participant)
sort sessionID round_number groupid_in_round
by sessionID round_number groupid_in_round: egen predictcontestants=sum(predictcontest_participant)

gen contestsnts_diff=number_contestants-contestants

sum number_contestants contestants predictcontestants contestsnts_diff
** "number_contestants" and " "contestants" are the same. Can drop one.

drop number_contestants contest_participant predictcontest_participant contestsnts_diff
*******************************************


 drop participantcode participantdutch_payoff participanthonolulu_payoff participanttime_started_utc skip_intro_dutch discount_a start_round_dutch num_test_rounds start_round_honolul skip_intro_honolulu participation_fee playeris_dutch_winner grouphave_dutch_winner playercontest_status grouphave_contest_winner playeris_english_winner playerenglish_dropout_elpased predictplayeroptimal_dutch_bid predictplayeris_dutch_winner predictplayercontest_status  predictplayerenglish_dropout_ela predictplayeris_english_winner uniqueID
 
*************************************************
 
 
***********NOW SAVE JUST THE GROUP VARIABLES  
 
sort sessionID round_number groupid_in_round playerid_in_group

drop if playerid_in_group != 1 
 
***Drop participant-specific variables, leave only group variables ******
drop participantlabel participantpayoff playerid_in_group price_start item_value playeris_final_winner playerpayoff predictplayeris_final_winner subjectID hashighestvalue predictplayerpayoff calcplayer_payoff

drop playerdropout_price playerdropout_priceaccurate playerdropout_payoff playerdropout_payoffaccurate predictplayerdropout_price predictplayerdropout_priceaccura predictplayerdropout_payoff predictplayerdropout_payoffaccur 


******************************************************************************************
save "Honolulu_ALL_group_vars_only.dta"
*, replace
 ***********THIS IS THE FILE TO COMPARE GROUP DATA TO PREDICTIONS ***********************
*******************************************************************************************
 
*************************************************END DATA PREP HERE********************************
*******************************************************************************************
 

*****NEXT GO TO DATA PREP WITH ZERO COSTS **** 
*file "data_prep_hnl_zero_cost.do"

log close


