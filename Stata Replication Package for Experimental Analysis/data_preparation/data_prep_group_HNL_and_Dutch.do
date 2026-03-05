clear
log using "data_prep_group_HNL_and_Dutch.log"



************ PREPARE JOINT DUTCH-HNL AUCTIONS DATA FILES FOR GROUP ANALYSIS ****************************

******MERGE HNL and DUTCH parts together - GROUP VARIABLES ONLY ***********

use Dutch_ALL_group_vars_only.dta, clear
append using Honolulu_ALL_group_vars_only.dta


tab sessionID 
tab bidders
sum winnerID

gen location="Sydney" 
replace location="Hawaii" if((sessionID<5)|(sessionID==8)|(sessionID==12)|(sessionID==13)|(sessionID==15)|(sessionID>=18))

tab location

gen auction_type="HNL" if (HNL==1)
replace auction_type="Dutch" if (HNL==0)

tab part auction_type 

sort sessionID HNL round_number groupid_in_round 

list sessionID auction_type round_number groupid_in_round maxvalue winner_value predictgroupfinal_price winnerID duration  if winnerID==0
***These are the auctions where no one bid

list sessionID auction_type round_number groupid_in_round maxvalue winner_value groupfinal_price winnerID winner_payoff  if winner_payoff<-2
****These are the auctions with substantial bidder losses

save "Dutch_and_Honolulu_ALL_group_vars_only.dta", replace

*************************************

use  "Dutch_and_Honolulu_ALL_group_vars_only.dta", clear

tab bidders location

gen sessionid= sessionID 

gen High=(((sessionid>=5)&(sessionid<=9))|(sessionid==12)|(sessionid==13)|(sessionid==15))

gen cost="High" if(High==1)
replace cost="Low" if(High==0)

*gen bidders5=(bidders==5)
*gen bidders5High=bidders5*High

*gen round_number5=bidders5*round_number

tab cost discount_b


*********************************************************

***Value efficiency ********
gen value_eff= (winner_value / maxvalue)*100

*****Selling price **************
*gen pricediff = groupfinal_price - predictgroupfinal_price

******Duration ***********
*gen duration_diff = duration - predictduration

****Auctioneer utility
*gen auctioneer_utility_diff = groupauctioneer_utility - predictgroupauctioneer_utility

****Bidder payoff
*gen winbidderpayoff_diff= winner_payoff - predictwinpayoff

*gen late=(round_number>10)
*gen time="Early" if round_number<=10
*replace time="Late" if round_number>10
*tab time



ren groupid_in_round groupid 
ren groupdutch_time_elapsed dutch_duration 
ren groupfinal_price final_price 
ren groupauctioneer_utility auctioneer_utility

ren predictgroupdutch_time_elapsed predictdutch_duration
ren predictgroupfinal_price predictfinal_price 
ren predictgroupauctioneer_utility predictauctioneer_utility

ren round_number round

********
ren value_eff  efficiency
ren final_price  price 
ren predictfinal_price price_predict
ren predictduration duration_predict
ren auctioneer_utility  Uauctioneer
ren predictauctioneer_utility Uauctioneer_predict
ren winner_payoff winpayoff
ren predictwinpayoff winpayoff_predict
*********

save  "Dutch_and_Honolulu_ALL_group_vars_for_analysis.dta"


***END *******

log close
