clear
log using "strategies_hnl-auctions.log"

***********************CONTENTS *******************************************************

**PART 0: EARNINGS BY TOP-BOTTOM   
****Lines 34-44 **************************

**PART 1: DECISIONS BY STAGE ** 
** Line 49
 *************PART 1 --- RATIONAL DECISIONS BY STAGE; FIGURES 6, 7 AND REGRESSIONS *******************
**1.1 ** Line 51 
 *************PART 1.1 --- DUTCH_STAGE BIDS
**1.2 ** Line  319    
**************PART 1.2  --- CONTEST_STAGE DECISIONS
**1.3 ** Line 360   
**************PART 1.3 --- ENGLISH_STAGE BIDS 
		*****Line  628:
		******Dutch-stage delays and final auction prices -- From Group File 

**PART 2: BEHAVIOR ACROSS STAGES **
*LINE  698 
*************PART 2 -- DECISION RULES: CONNECTING DECISIONS ACROSS STAGES  ***************************
*** Line  802 
****** CLASIFICATION OF HONOLULU DECISIONS -- BY STAGE 
*** Line  944
******Decision-outcome patterns -- ANALYSIS for TABLE 6 
**** Line 1116
************** MLOGIT ON UNDER-, OVER-BIDDING and RATIONAL BEHAVIOR BY STAGE: ONLINE APPENDIX TABLE G.5 
*Line  1258
****END*********************************************************************************** 

*********************************STRATEGIES BY PAY CATEGORY *****************************
***PART 0: ******EARNINGS FOR TWO CATERGORIES: TOP AND BOTTOM *******************************************
use "Honolulu_ALL_for_bidder_analysis.dta", clear

gen cost="High" if(High==1)
replace cost="Low" if(High==0)

**MEAN PAY PERCENT FOR TOP AND BOTTOM EARNERS 
sort bidders cost top_HNL_pay
by bidders cost top_HNL_pay: sum HNL_paypercent if round_number==4
**Unlike Figure G.1 in Appendix G, these means are based on uncensored values including higher percentage losses and gains. See footnote 6 in Online Appendix G for explanation.



****************ANALYSIS OF BIDS STARTS HERE ******************* 

**********************************************************************************
 *************PART 1 --- DECISIONS BY STAGE; FIGURES 6, 7 AND REGRESSIONS **********************************************************************************

*1.1 **************
************DUTCH_STAGE BIDS *************************************************

rename predictplayeroptimal_dutch_bid dutch_bid_predict
ren  zerocostplayeroptimal_dutch_bid zerocost_dutch_bid

gen dutch_bid_actual=playeris_dutch_winner * groupdutch_final_price if(playeris_dutch_winner==1)

***These are used in the plots for Figures 6-7:
gen dutch_bid_actual1=dutch_bid_actual if(top_HNL_pay==1)
gen dutch_bid_actual0=dutch_bid_actual if(top_HNL_pay==0)


gen bidders5=(bidders==5)

***01********************
******Check for weakly dominated bids -- DUTCH STAGE ***************
* Rational bids
******Allow to overbid 2 point above value 
gen dutch_bid_rational=((item_value+2>=groupdutch_final_price))  if(playeris_dutch_winner==1)
gen dutch_bid_irrational=1-dutch_bid_rational
sum dutch_bid_rational dutch_bid_irrational
****98.1% of all dutch stage bids are rational (at or below value+2)
****1.9% of all dutch stage bids are IRrational (ABOVE value+2)

sort bidders 
by bidders: tab dutch_bid_rational 
*
sort bidders cost top_HNL_pay
by bidders cost top_HNL_pay: tab dutch_bid_rational 
*****These stats match table G1 in the Appendix for Dutch-atage bids***  


*02 
*****BASIC DUTCH_STAGE BIDS REGRESSIONS AND PLOTS --- For Figures 6, 7 ** 

***************************************
gen cell=High*10+bidders
tab cell
**************************************

gen top_pay_item_value=top_HNL_pay*item_value
gen bidders5High=bidders5*High
gen High_value=High*item_value 

label variable High "high cost"
label variable item_value "item value"
label variable High_value "item value high cost"
label variable dutch_bid_actual "dutch bid"
label variable top_HNL_pay "Top earner"
label variable top_pay_item_value "item value Top earner"


******************The regressions and graphs below appear in Figures 6, 7 

eststo clear
 foreach num of numlist 2 5   {
 	eststo clear
 	foreach  h in   "Low" "High"    {
	display "************************************"	
	display "`num' bidders, Cost is `h' "	
	display "************************************"	
	 sum medianHNL_paypercent HNL_paypercent HNL_dpay_norm HNLpay_sum HNLpay_predict_sum if((bidders==`num')&(cost=="`h'"))
	display "*********************************************************************"	
	display "`num' bidders, Cost is `h': Predicted  Dutch-Stage Bids -- for Figures 6,7 "	
	display "*********************************************************************"	
		eststo:	tobit dutch_bid_predict item_value  if((bidders==`num')&(cost=="`h'")), ll(0) ul(price_start) 
		*no need to bootstrap for predictions 
	
***Close the two brackets below if no need to generate graphs
*		 }
*  }	
	
	foreach p of numlist 0 1  {
	display "**************************************************************************"	
	display "Regressions and Plots of Dutch-stage Bids for Figures 6, 7: `num' bidders, Cost is `h', Top HNL pay is `p' "	
	display "***************************************************************************"		
		
	eststo: tobit dutch_bid_actual  item_value  if((bidders==`num')&(cost=="`h'")&(top_HNL_pay==`p')), ll(0) ul vce(cluster sessionID)
	predict dbidtobit`num'`h'`p'  if((bidders==`num')&(cost=="`h'")&(top_HNL_pay==`p'))
	predict stdf`num'`h'`p'  if((bidders==`num')&(cost=="`h'")&(top_HNL_pay==`p')), stdf
	sum stdf`num'`h'`p'
			}
	twoway 	(scatter dutch_bid_actual1  item_value if(top_HNL_pay==1), pstyle(p2) sort) ///
		(scatter dutch_bid_actual0  item_value if(top_HNL_pay==0), pstyle(p3) sort)  ///
		(line dbidtobit`num'`h'1 item_value, lstyle(p2) lwidth(medthick) sort) ///
		(line dbidtobit`num'`h'0 item_value, lstyle(p3)  lwidth(medthick) sort) ///
		(line dutch_bid_predict item_value,  lstyle(p1)  lwidth(medthick) sort) if((bidders==`num')&(cost=="`h'")) , 	title(" `num' bidders, `h' cost") ///
				xlabel(0(10)50, grid) ///
		xtitle("value") ytitle("Dutch stage bids")  ///
		legend(label(1 "bid Top")  label(2 "bid Bottom")  label(3 "regression Top") label(4 "regression Bottom") label(5 "theory") ) ///
		name(Dutch_stage_bids_`num'`h', replace)  saving(Dutch_stage_bids_`num'`h', replace)
*graph export Dutch_stage_bids_`num'`h'.pdf, replace 	
	display "************************************"	
	drop dbidtobit`num'`h'1 dbidtobit`num'`h'0   stdf`num'`h'1 stdf`num'`h'0
		}
	display "**************************************************************************"	
	display "`num' bidders: Regressions of Dutch-stage Bids for Figures 6, 7	
	display "***************************************************************************"		
esttab, se b(%8.2f)  pr2 label mtitles("`num'L-pred" "`num'L-B"  "`num'L-T"  "`num'H-pred" "`num'H-B" "`num'H-T") star(* 0.10 ** 0.05 *** 0.01)  type replace   keep(item_value  _cons)
***Above are the regressions to put on the top panels of Figures 6, 7 *************
		
		
}
*****The graphs above are for Dutch-stage bids graphs in Figure 6 and 7.

*****************COMBINE DUTCH STAGE GRAPHS -- by the number of bidders********

foreach num of numlist 2 5 {
graph combine Dutch_stage_bids_`num'High Dutch_stage_bids_`num'Low,  imargin(0 0 0 0)  ycommon title("Dutch stage bids") name(Dutch_stage_bids_`num'bidder, replace)  saving(Dutch_stage_bids_`num'bidder, replace)
*graph export Dutch_stage_bids_`num'bidder.pdf, replace 
}

***Above are replications of the top panels for Figures 6 and 7 (add regression equations to the graphs manually) 
*******************

*****************FURTHER ON DUTCH_STAGE BIDS ************
 
****03
************ CHECK HOW FREQUENT ARE BIDS ABOVE ZERO ****************
****This is used to substantiate Result 7, and the  paragraph  preceding it.

gen dutch_bid_near_zero=(dutch_bid_actual <=2) if(dutch_bid_actual != .) 
sort bidders cost
by bidders cost: tab dutch_bid_near_zero
*
sort bidders 
by bidders: tab dutch_bid_near_zero


gen dutch_bid_predict0=(dutch_bid_predict<=2)    if(dutch_bid_actual != .) 

sort bidders 
by bidders: tab dutch_bid_predict0 dutch_bid_near_zero
*

sort bidders 
by bidders: tab dutch_bid_near_zero if(dutch_bid_predict>2) 

***2-bidder auctions: out of all bids predicted to be above zero, only 130/551=23.6% were at zero.
****Out of 96 bids predicted to be at zero (within 2 units), only half (49, or 51%) were at zero, and 47 (49%) were above zero
***5-bidder acutions: All bid are above zero 
************END SUPPORT FOR RESULT 7  *******************

****04
*******DUTCH STAGE BID DEVIATIONS FROM PREDICTIONS -- For Figure 8 (right) and Result 8 ************************

***Check average Dutch bid Deviation from Theory
gen dutchbid_dev=dutch_bid_actual-dutch_bid_predict
sum dutchbid_dev
sort bidders cost top_HNL_pay 
by bidders cost top_HNL_pay: sum  dutchbid_dev
****This matches Figure 8 (right)

sort bidders cost predictplayeris_dutch_winner
by bidders cost predictplayeris_dutch_winner: sum dutchbid_dev 
************Predicted Dutch winners under-bid, whereas predicted Dutch non-winners over-bid! Since predicted Dutch winners have higher values, the overall result is  under-bidding.  
*This is used in the narrative preceding Result 8 in the paper. 


****05
 ********** CHECK FOR ORDER EFFECTS IN DUTCH BID DEVIATIONS -- FOR ONLINE APPENDIX I ***************

gen dutchfirst5=bidders5*is_dutch_first
gen dutchfirstHigh= High*is_dutch_first 


 *****Are Dutch-stage bid deviations the same DEPENDING ON THE ORDER OF INSITUTIONS? ********** 
***These are the differences between bid deviations BY ORDER reported in Appendix I ********
 sort is_dutch_first 
by is_dutch_first: sum dutchbid_dev
*****Test if Dutch-stage bid deviations are the same by order, controlling for the number of bidders and High and Low Treatments ********** 
bootstrap, reps(1000) seed(229)   cluster(sessionID) strata(cell):  reg dutchbid_dev  bidders5  High bidders5High is_dutch_first 
bootstrap, reps(1000) seed(6558)   cluster(sessionID) strata(cell): reg dutchbid_dev   bidders5  is_dutch_first 
*******."is_dutch_first" is negative and signnificant at 10%  (p=0.070) (if we impose the same fixed effect for both 2- and 5-bidders)


******Allow for different order effects in 2- and 5-bidder auctions ******** 
*
bootstrap, reps(1000) seed(6855)   cluster(sessionID) strata(cell): reg dutchbid_dev   bidders5  is_dutch_first dutchfirst5
test  is_dutch_first+dutchfirst5 = 0
*order effect is negative but not significant with 2 bidders, but negative and just misses significance level (p=0.111) in 5-bidder auctions if we pool across High and Low cost treatments
*overall, order effect is NOT significant  
 

*****Checking order effects for 2- and 5-bidder auctions separately******************* 
***Including separate regressions for High and Low:	
	foreach num of numlist 2  5  {
	display "************************************"	
	display "DUTCH BID PRICE DEVIATIONS FROM PREDICTION,  `num' bidders"	
bootstrap, reps(1000) seed(2689)   cluster(sessionID): reg dutchbid_dev  is_dutch_first  if((bidders==`num'))
	
		foreach  c of numlist 0  1   { 
	display "************************************"	
	display "DUTCH BID PRICE DEVIATIONS FROM PREDICTION,  `num' bidders, High Cost= `c' "	
	display "************************************"	
	 	
bootstrap, reps(1000) seed(1314)   cluster(sessionID): reg dutchbid_dev  is_dutch_first  if((High==`c')&(bidders==`num'))
		}
	}	
***The above results match those reported in Table I.1 in Appendix I, up to the p-value variations due to differences in seed used for bootstrap estimations **
	

**Separate estimations for Top and Bottom 		
sort bidders top_HNL_pay is_dutch_first
by bidders top_HNL_pay is_dutch_first: sum  dutchbid_dev
	
	
	foreach num of numlist 2  5  {
	display "************************************"			
		foreach  c of numlist 0  1   { 
	display "************************************"	
	display "DUTCH BID PRICE DEVIATIONS FROM PREDICTION,  `num' bidders, Top= `c' "	
	display "************************************"	
	 	
bootstrap, reps(1000) seed(9011)   cluster(sessionID): reg dutchbid_dev   is_dutch_first   if((top_HNL_pay==`c')&(bidders==`num'))
	
		}
	}	
****The above qualitatively matches Figure I.2 in the appendix, up to the p-value variations due to differences in seed used for bootstrap estimations **
 
**********END DUTCH STAGE BID DEVIATIONS BY ORDER ************************


**06
***#ADDTIONAL Dutch-Stage BIDS REGRESSIONS: TABLE G4 in Appendix G ***********

label variable item_value "item value"
label variable top_pay_item_value "item value top earner"
label variable top_HNL_pay "top earner"
label variable is_dutch_first "Dutch auction first"

********In Online Appendix G: Dutch-stage bid estimations 
eststo clear
 foreach num of numlist 2 5   {
 	foreach  h in   "Low" "High"    {
	display "************************************"	
	display "`num' bidders, Cost is `h' "	
	display "************************************"	
	 sum medianHNL_paypercent HNL_paypercent HNL_dpay_norm HNLpay_sum HNLpay_predict_sum if((bidders==`num')&(cost=="`h'"))
	display "*********************************************************************"	
	display "`num' bidders, Cost is `h': Predicted Bid and ACTUAL Dutch-Stage Bids -- for Table G4 "	
	display "*********************************************************************"	
		eststo:	tobit dutch_bid_predict item_value  if((bidders==`num')&(cost=="`h'")), ll(0) ul(price_start) 
		eststo: bootstrap, reps(1000) seed(9222)   cluster(sessionID) strata(cell): tobit dutch_bid_actual  item_value top_pay_item_value top_HNL_pay is_dutch_first  if((bidders==`num')&(cost=="`h'")), ll(0) ul 
			 }
  }	

display "*********************************************************************"	
	display "Predicted Bid and ACTUAL Dutch-Stage Bids -- Table G4 in the Appendix"	
	display "*********************************************************************"	
		
esttab, se b(%8.2f)  pr2 label mtitles("2L-pred" "2L-act"  "2H-pred" "2H-act"  "5L-pred" "5L-act"  "5H-pred" "5H-act") star(* 0.10 ** 0.05 *** 0.01)  type replace   keep(item_value top_pay_item_value top_HNL_pay is_dutch_first  _cons)
*esttab using "dutch_stage_bids_reg_basic_0425.tex", se b(%8.2f)   pr2 label  mtitles("2L-pred" "2L-act"  "2H-pred" "2H-act"  "5L-pred" "5L-act"  "5H-pred" "5H-act") star(* 0.10 ** 0.05 *** 0.01)    replace  keep(item_value top_pay_item_value top_HNL_pay is_dutch_first   _cons)

***The above regression is in APPENDIX TABLE G4 For Dutch-stage Bids ****
***NOTE: "Dutch First" dummy is not significant -- Meniotned in Online Appendix I


***************************************************************************************************** 
*******For correlation of Dutch-stage delays and final auction prices: GO TO THE END OF PART 1 ****
***This is done by group, not by bidder**** 
***************************************************************************************************** 

********************END DUTCH STAGE BIDS *******************
***************************************************************************
 

**1.2 
***********************************************
************CONTEST DECISIONS *****************

*(honolulu only) playercontest_status: 1 if is dutch winner or is a contest challenger; 
*2 if is not dutch winner and leaving the contest; 0 if is not dutch winner and no response in the contest


**07
***Rational decisions at CONTEST STAGE
*
************CONSIDER BIDS/DROPS WITHIN 2 units of VALUE as "AT VALUE" ***********

gen contest_bid_rational=(item_value+2>=groupdutch_final_price) if(playercontest_status==1)

replace contest_bid_rational=. if(playeris_dutch_winner==1) 
sort bidders
 by bidders: tab contest_bid_rational
 *******The above stats match Table G.1, summary column, in the Online Appendix G
 
****************
 gen contest_drop_rational=(item_value-2<=groupdutch_final_price) if(playercontest_status!=1) 
tab contest_drop_rational 
 sort bidders
by bidders: tab contest_drop_rational
*******The above stats go into table G.1, summary column, in the Online Appendix G
*******The above stats are used to substantiate Result 8 in the paragraph preceeding the result (early droputs at the Contest stage) 
***

**************FOR TABLE G.1 in Online Appendix G ********************
**Contest decsions by Top-Bottom Earners:
sort bidders cost top_HNL_pay
by bidders cost top_HNL_pay: sum contest_bid_rational contest_drop_rational 
**These stats match Table G.1 in the appendix


********************END CONTEST-STAGE DECISIONS ************	
*************************************************************	

	

*1.3
*************************************************************************************************************
**************ENGLISH STAGE BIDS ********************
*****************************
************************************************

***********Use with the price that bidder saw at the dropout
gen price_dropout_English=playerdropout_price if((playercontest_status==1)&(playeris_english_winner==0)) 
replace price_dropout_English=. if((playercontest_status==1)&(playeris_english_winner==1)) 
*******do not count winner's prices as dropouts
replace price_dropout_English=. if(groupenglish_time_elapsed==0) 
*******dropped 240 cases without english stage  

***Adjust for auctions with multiple winners:
sort sessionid round_number groupid_in_round
by sessionid round_number groupid_in_round: egen numenglishwinners=sum(playeris_english_winner) if HNL==1
*
replace price_dropout_English=playerdropout_price if((playercontest_status==1)&(playeris_english_winner==1)&(numenglishwinners>1)) 
*
list bidders cost sessionID round_number subjectID if((playercontest_status==1)&(playeris_english_winner==1)&(numenglishwinners>1))  
*****In auctions where the last two bidders drop out at the same time, each of their dropout prices counts
****Three 5-bider auctions had two winners each 

sum price_dropout_English
**1201 obs of dropout prices

***08
***Stats on the share of early dropouts out of all dropouts at the English stage *****
gen early_drop_English=(item_value - price_dropout_English >2) if(price_dropout_English != .)
tab early_drop_English
sort bidders
by bidders: tab early_drop_English
*******The above stats are used to substantiate Result 8 in the paragraph preceeding the result
 
 
***09
**********************How often do early dropouts at Contest and English stages lead to prices below bidder's value? 
**For discussion preceeding Result 8 
gen contest_drop_price=groupdutch_final_price if(playercontest_status!=1) 
****the above are dropout prices for Dutch-stage auction non-winners and non-challengers
gen price_dropout= contest_drop_price if(playercontest_status!=1)  
replace price_dropout = price_dropout_English if(price_dropout_English != .) 
***The above defines player dropout price, at either contest or English stage
sum price_dropout
***Early droppouts: below value:
gen price_drop_early=(item_value - price_dropout >2)
replace price_drop_early=. if  price_dropout == .

sort bidders
by bidders: tab price_drop_early


gen value_finalprice_diff=item_value - groupfinal_price
*
sort bidders price_drop_early
by bidders price_drop_early: sum value_finalprice_diff if playeris_final_winner==0

gen final_price_below_value=((value_finalprice_diff>2)&(playeris_final_winner==0))
replace final_price_below_value=. if playeris_final_winner==1

sort bidders price_drop_early
by bidders price_drop_early: tab final_price_below_value

sort bidders
by bidders: tab  price_drop_early final_price_below_value
***This supports the statement preceeding Result 8 in the paper: 
***"A bidder dropping out below their value,...   resulted in a lower than competitive auction price (a price strictly below this bidder's value)  in all cases in 2-bidder auctions and in 61% of cases in 5-bidder auctions. ***


***10 
************************SHARE OF WEAKLY UNDOMINATED DECISIONS AT the ENGLISH STAGE **************
***TO MATCH TABLE G1
******************Look at all English-stage decisions, including English winners decision to stay ********
gen price_decision_English=playerdropout_price if((playercontest_status==1)&(playeris_english_winner==0)) 
***English_non-winner dropout price 
replace price_decision_English=groupenglish_final_price if((playercontest_status==1)&(playeris_english_winner==1)) 
***English_winner buying price 
replace price_decision_English=. if(groupenglish_time_elapsed==0) 
*******dropped 240 cases without the English stage  

sum price_decision_English
***2064 obs of English stage decsions for players who did not drop out before the English stage

***Prices within 2 points are considered at value
gen english_bid_rational=((item_value-price_decision_English)>=-2)
replace  english_bid_rational=2 if(((item_value-price_decision_English)<-2))
replace  english_bid_rational=0 if(((item_value-price_decision_English)>2)&(playeris_english_winner!=1))
replace  english_bid_rational=. if(price_decision_English == .)
***Rational =1 if rational, =2 if overbidding, =0 if dropout below value



tab english_bid_rational playeris_english_winner
tab playercontest_status english_bid_rational
***Only players with playercontest_status==1 participated in the English stage****

tab english_bid_rational
****6.25% of English bids were "stay above value"; (129)
****84.88% were rational (not weakly dominated)     (1752)
****8.87% were early dropouts  (183)
*****TOTAL NUMBER: 2,064.

sort bidders
by bidders: tab english_bid_rational
****84.96% bids are rational in 2-bidder acutions, and 84.81% are rational in 5-bidder auctions

sort bidders cost 
by bidders cost: tab english_bid_rational top_HNL_pay
***********The above matches the English stage panel in Table G1
***  

*****The share of weakly undominated English decisions is 85% in 2-bidder auctions and 85% in 5-bidder auctions; there is more overbidding in 5-bidder auctions 8.37% in 5-bidder vs 4.10% in 2-bidder, and more dropping out early in 2-bidder vs 5-bidder auctions (10.94% in 2-bidder vs 6.83% in 5-bidder)
 ****MATCHES TABLE G1 IN THE APPENDIX**********************************
 *****************END SHARE OF UNDOMINATED DECISIONS AT THE ENGLISH STAGE FOR TABLE G.1 *********************

**11
***************REGRESSION OF ENGLISH STAGE DROPOUT PRICES -- THEY GO ON BOTTOM PANELS OF FIGURES 6, 7 *******************

sort bidders cost sessionID round_number
list bidders cost sessionID round_number subjectID playeris_dutch_winner playeris_english_winner playeris_final_winner groupfinal_price price_dropout_English  if((groupenglish_time_elapsed==0)&(price_dropout_English!=.)) 

sum  playeris_dutch_winner playeris_english_winner playeris_final_winner if((groupenglish_time_elapsed==0)&(price_dropout_English!=.))  
***If no English stage, Dutch winners become Final winners; dropped these cases from the English-stage analysis


***************REGRESSION OF ENGLISH STAGE DROPOUT PRICES -- THEY GO ON BOTTOM PANELS OF FIGURES 6, 7 *******************
****NOTE: ALL ENGLISH_STAGE GRAPHS AND REGRESSIONS EXCLUDE 240 INDIVIDUAL OBSERVATIONS WITHOUT ENGLISH STAGE 

eststo clear
foreach num of numlist 2 5   {
	eststo clear
 	foreach  h in   "Low"   "High"     {
	display "***ENGLISH STAGE DROPOUTS  **************** "
	display "************************************"	
	display "`num' bidders, Cost is `h' "	
	display "************************************"		

reg price_dropout_English  item_value top_pay_item_value top_HNL_pay   if((bidders==`num')&(cost=="`h'")), vce(cluster sessionID)
     test (top_pay_item_value=0) (top_HNL_pay=0)
*These are regression estimations of English-stage bids that go on the bottom panels of Figures 6-7:  	 
         foreach p of numlist 0 1  {
		 display "***English-stage bids regression for Figs 6-7: `num' bidders, Cost is `h', Earn category is `p'***"		
		eststo:  reg price_dropout_English   item_value  if((bidders==`num')&(cost=="`h'")&(top_HNL_pay==`p')), vce(cluster sessionID)
                          }	
 
	display "************************************"	
		
		}
display "*****`num' bidders: REGRESSION OF ENGLISH STAGE DROPOUT PRICES -- FOR FIGURES 6, 7 *******************"
esttab, se b(%8.2f)  r2 label mtitles("`num'L_B" "`num'L-T"  "`num'H-B" "`num'H-T") star(* 0.10 ** 0.05 *** 0.01)  type replace   
		
}

**12**
***************GRAPHS OF ENGLISH STAGE DROPOUTS AND AVOIDABLE LOSSES -- THESE ARE THE BOTTOM PANELS OF FIGURES 6, 7 *******************
*
gen price_paid_English=groupenglish_final_price if(playeris_english_winner==1) 
*
***************GRAPHS OF ENGLISH STAGE DROPOUTS AND AVOIDABLE LOSSES *******************
foreach num of numlist 2 5   {
 	foreach  h in   "Low"   "High"     {
	display "***ENGLISH STAGE DROPOUTS  **************** "
	display "************************************"	
	display "`num' bidders, Cost is `h' "	
	display "************************************"		
twoway (scatter price_dropout_English  item_value  if((top_HNL_pay==1)), pstyle(p2) ms(Oh) ) ///
		(scatter price_dropout_English    item_value  if((top_HNL_pay==0)), pstyle(p3) ms(Oh)) ///
		(scatter price_paid_English  item_value  if((top_HNL_pay==1)&(price_paid_English>item_value)), pstyle(p2) ) ///
		(scatter price_paid_English    item_value  if((top_HNL_pay==0)&(price_paid_English>item_value)), pstyle(p3)) ///
		(line item_value item_value, lstyle(l1) lwidth(medthick) sort) ///
					if((bidders==`num')&(cost=="`h'")),  title(" `num' bidders, `h' cost") ///
		xtitle("value") ytitle("English dropout and paid prices")  ///
		legend(label(1 "drop Top")  label(2 "drop Bottom")   label(3 "paid Top") label(4 "paid Bottom") label(5 "theory")  )   ///
		name(English_stage_drop_prices_`num'`h', replace) saving(English_stage_drop_prices_`num'`h', replace) 
*graph export English_stage_drop_prices_`num'`h'.pdf, replace 	


	display "************************************"	
		
		}
}
************


**********Combine ENGLISH graphs 
foreach num of numlist 2 5 {
graph combine English_stage_drop_prices_`num'High English_stage_drop_prices_`num'Low,  imargin(0 0 0 0)  ycommon xcommon title("English stage dropout and paid prices") name(English_drop_prices_`num'bidder, replace) saving(English_drop_prices_`num'bidder, replace)

*graph export English_drop_prices_`num'bidder.pdf, replace 
}
*****END ENGLISH-STAGE GRAPHS FOR FIGURES 6, 7 


**********Combine DUTCH AND ENGLISH-Stage graphs 
* Dutch_stage_bids_`num'bidder.pdf 
* Contest_stage_bids_`num'bidder.pdf

foreach num of numlist 2 5 {
graph combine Dutch_stage_bids_`num'bidder  English_drop_prices_`num'bidder, rows(2) imargin(0 0 0 0)   xcommon iscale(.5)  xsize(6) ysize(8) title("Honolulu `num'-bidder auction behavior by stage")  name(ALL_Stage_bids_`num'bidder, replace)

*graph export ALL_Stage_bids_`num'bidder.pdf, replace 
}
********************************
****END GRAPHS FOR FIGURES 6, 7*************

*13
*********************************************
******REGRESSIONS OF ENGLISH_STAGE BIDS -- FOR TABLE G.6 IN THE APPENDIX***************

gen english_bid_predict = item_value


label variable High "high cost"
label variable item_value "item value"
label variable High_value "item value high cost"
label variable price_dropout_English "English dropout price"
label variable english_bid_predict "English dropout price predicted"
label variable is_dutch_first "Dutch auction first"


tab  playeris_english_winner numenglishwinners if price_dropout_English!=.
***1201 obs, 1195 non-winners, and 6 (=3*2) simultaneous dropout winnenrs 
tab  playeris_english_winner numenglishwinners if price_dropout_English==.
*1,370 bidders dropped out before the English stage and are not English winners. 863 English winners did not drop out. Hence their dropout prices are missing (2,233 cases total.) 

*****ENGLISH_STAGE BIDS REGRESSION WITH BOOTSTRAP ****************************************

*gen cell=High*10+bidders

eststo clear
foreach num of numlist 2 5   {
	
	display "*********************************************"	
	display "`num' bidders
	display "*********************************************"	
	
sum price_dropout_English grouphave_contest_winner  if(bidders==`num')


	eststo:	bootstrap, reps(1000) seed(9222)   cluster(sessionID) strata(cell): reg price_dropout_English item_value   High_value High is_dutch_first  if((bidders==`num'))


*****NOW BY PAY CATEGORY  ******************
		
		foreach q of numlist  0 1    {
	display "*********************************************"	
	display "`num' bidders, Earn category is `q' "
	display "*********************************************"	

	eststo: bootstrap, reps(1000) seed(1870)   cluster(sessionID) strata(cell):  reg price_dropout_English  item_value   High_value High  is_dutch_first   if((bidders==`num')&(top_HNL_pay==`q'))


	}
}

*** SAVE INTO A TABLE 
esttab, se b(%8.2f)  r2 label mtitles("2b-all"  "2b-B" "2b-T" "5b-all" "5b-B" "5b-T") star(* 0.10 ** 0.05 *** 0.01)  type replace keep(item_value   High_value High is_dutch_first  _cons)

*esttab using "english_stage_bids_reg_basic0425.tex", se b(%8.2f)   r2 label  mtitles("2b-all"  "2b-B" "2b-T"  "5b-all" "5b-B" "5b-T") star(* 0.10 ** 0.05 *** 0.01)    replace keep(item_value   High_value High is_dutch_first  _cons)
***This is regression TABLE G6 IN THE APPENDIX 


*****END BOOTSTRAP ENGLISH_STAGE DECISIONS -- TABLE G6 *********
********************END ENGLISH-STAGE DECISIONS *********************




**14
**********************************
***Add-on to Part 1:
***FROM GROUP ANALYSIS FILE: 
***********Check if Dutch-stage delays lead to lower prices ************ ***********
*********FOR DISCUSSION PRECEEDING RESULT 8 AND ONLINE APPENDIX G IN THE PAPER *********

use "Dutch_and_Honolulu_ALL_group_vars_for_analysis.dta",  clear

gen dutch_delay=dutch_duration-predictdutch_duration 

sort bidders cost HNL
by bidders cost HNL: sum  dutch_delay
**The above supports statement in the paper preceeding Result 8: 
***...."resulting in  the Dutch stage lasting, on average, over 4 price ticks longer than predicted in all treatments.  


drop if HNL != 1

gen dutch_price_dev=groupdutch_final_price-predictgroupdutch_final_price

reg dutch_price_dev dutch_delay, cluster(sessionID)
***As expected, the coefficient is -1******* 
sum dutch_delay  dutch_price_dev if((dutch_delay>0)&(dutch_price_dev>0))
*Differences within 1 point are possible due to  rounding 
*
*We use  "dutch_delay" as the exact measure


*Define "significant" price delay: allow 2 ticks slack
gen dutch_delay2tol=(dutch_delay>2)

sort bidders
by bidders: tab dutch_delay2tol
***Reported in Online Appendix G: In 68% of 2-bidder auctions, and 74% of 5-bidder auctions, the Dutch stage lasted more than 2 price ticks longer than predicted

****Baseline regression of final price deviations on Dutch-stage delays  *****************
gen price_dev= price-price_predict
 
sort bidders
by bidders: reg price_dev dutch_delay, cluster(sessionID)


***************************************
gen cell=High*10+bidders
tab cell
**************************************

gen bidders5=(bidders==5)
gen bidders5High=bidders5*High

gen dutch_delay5=dutch_delay*bidders5
gen dutch_delay2=dutch_delay*(1-bidders5)


bootstrap, reps(500) seed(61413)   cluster(sessionID) strata(cell): reg price_dev  bidders5 High bidders5High  dutch_delay2 dutch_delay5
***The above regression is the basis for the claim in Section 5.2:
*"On the auction level, these Dutch-stage bidding delays are associated with a significant reduction of purchase prices'
*The regression is referred to in Online Appendix G, Footnote 9, and forms the basis of Observation 3. 
******

*********End of analysis of correlation of Dutch-stage delays and Final auction prices -- for "Bidder Behavior" section ****************
******************************************************************************************************


*************END PART 1 -- RATIONAL DECISIONS BY STAGE; FIGURES 6, 7 AND REGRESSIONS **************** *****************************************************************************************************
 
 
*************************
 
*****************************PART 2 *************************************************
*******************ANALYSIS OF DECISION PATTERNS *******************************


**15
**********************************CLASIFICATION OF HONOLULU DECISIONS -- BY STAGE ************************* 

use "Honolulu_ALL_for_bidder_analysis.dta", clear

gen bidders5=(bidders==5)
gen High_bidders5 = High * bidders5

gen cost="High" if(High==1)
replace cost="Low" if(High==0)

******************DUTCH-STAGE DECISIONS ********************************

rename predictplayeroptimal_dutch_bid dutch_bid_predict
gen dutch_bid_actual=playeris_dutch_winner * groupdutch_final_price if(playeris_dutch_winner==1)

*******************************
**Classify all DUTCH-Stage decisions: "Dutch_decision"
************-1 -- Low bid or non-bid
************ 0 -- Rational no-bid
************ 1 -- eqm rational bid (atT eqm prediction +/- tolerance)
************ 1.5 -- rational bid (below value, above eqm prediction)
************ 2 -- bid over value

*******************************

***Allow "tolearance=k" below predicted as within prediction
*
gen tolerance=2
*
gen dutch_decision=1.5 if((dutch_bid_actual<=item_value+tolerance)&(dutch_bid_actual >(dutch_bid_predict+tolerance))) 
*****Bids below value but above the eqm prediction
replace dutch_decision=1 if((dutch_bid_actual<=dutch_bid_predict+tolerance)&(dutch_bid_actual >=(dutch_bid_predict-tolerance))) 
*****Equilibrium bids are those rational bids that are not low, but below value and close to eqm prediction

replace  dutch_decision=2 if((dutch_bid_actual>(item_value+tolerance)))
**********Overbidding above value
replace  dutch_decision=0 if((dutch_bid_actual==.)&(groupdutch_final_price>=dutch_bid_predict-tolerance))
**********Rational non-bid
replace  dutch_decision=-1 if(dutch_bid_actual < (dutch_bid_predict-tolerance))
*****Low bid
replace  dutch_decision=-1 if((dutch_bid_actual==.)&(groupdutch_final_price<(dutch_bid_predict-tolerance))) 
*****Low non-bid

tab dutch_decision
sort bidders 
by bidders: tab dutch_decision
****Reported in the paper: 41\% of Dutch-stage  decisions with 2 bidders are classified as delays (decision=-1), as compared to only  18\% of decisions with 5 bidders.

************CONTEST DECISIONS *****************

*(honolulu only) playercontest_status: 1 if is dutch winner or is contest challenger; 
*2 if is not dutch winner and leaving the contest; 0 if is not dutch winner and no response in the contest

gen contest_decision_low=(item_value-tolerance>groupdutch_final_price) if(playercontest_status!=1)
***These are people who decided to drop out at the contest stage, who should not have. Allow within 2 units of value
tab contest_decision_low
replace contest_decision_low=. if(playeris_dutch_winner==1)  
tab contest_decision_low

sort bidders cost
by bidders cost: tab contest_decision_low

**
***Check that low decision is defined correctly:
gen diff_value_contest=(item_value-playerdropout_price) if(playercontest_status!=1)
sort contest_decision_low
by contest_decision_low: sum diff_value_contest
***All correct

***Classify contest deciions, allow early drop within "tolerance" and late stay within 2 points of value
**CONTEST Stage : "contest_decision"
************-1 -- leave early
************ 0 -- leave rational
************ 1 -- rational bid
************ 2 -- bid over value


********THESE INCORPORATE THE TOLERANCE LEVEL OF 2 IN ALL-STAGE DECISIONS, INCLUDING CONTEST**** 
gen contest_bid_rational=(item_value+tolerance>=groupdutch_final_price) if(playercontest_status==1)
replace contest_bid_rational=. if(playeris_dutch_winner==1) 
*
gen contest_drop_rational=((item_value-groupdutch_final_price)<=tolerance) if(playercontest_status!=1) 
sum contest_bid_rational contest_drop_rational

**
gen contest_decision=1 if(contest_bid_rational==1) 
***Rational bid
replace contest_decision=0 if(contest_drop_rational==1) 
***Rational drop
replace contest_decision=2 if(contest_bid_rational==0)
**Irrational bid above value
replace contest_decision=-1 if(contest_drop_rational==0)
***Irrational drop below value
replace contest_decision=. if(playeris_dutch_winner==1) 
tab contest_decision

tab playeris_dutch_winner
**************Correct: The number of Dutch winners (1,053) + the number of Contest Decisions (2,381) = 3434, i.e., all obs
 

tab contest_decision if(playeris_dutch_winner==1) 
****Correct, no obs

sort bidders cost
by bidders cost: tab contest_decision
 


**********
***ENGLISH STAGE DECISION ******
**ENGLISH  Stage : "English_decision"
************-1 -- leave early
************-0.5 -- Rational buy below predicted HNL auction price
************ 0 -- leave rational -- within 2 units of value or no more than "tolerance" below value
************ 1 -- rational buy between eqm price and value
************ 2 -- bid (stay) above value


***Define the number of winners at the English stage to help classify winner decisions
sort sessioncode round_number groupid_in_round
by sessioncode round_number groupid_in_round: egen numenglishwinners=sum(playeris_english_winner)
tab numenglishwinners
list bidders cost sessioncode round_number groupid_in_round subjectID if((numenglishwinners>1)&(playeris_english_winner))
**In three 5-bidder auctons, two last bidders dropped out from the English stage at the same time, and the object was allocated randomly
*******************


*******Rational decision rate in the English stage
***This is replicated from Part 1 above 
*gen price_dropout_English=playerdropout_price if((playercontest_status==1)&(playeris_english_winner==0)) 
***dropped out at the English stage
*replace price_dropout_English=groupenglish_final_price if((playercontest_status==1)&(playeris_english_winner==1)) 
****won the auction at the english stage
*replace price_dropout_English=. if((playercontest_status==1)&(grouphave_contest_winner==1)) 
****won the auction being the only bidder at the contest stage, no english decision
*
*sum price_dropout_English
***2064 obs, correct!

replace playerdropout_price=groupenglish_final_price  if((playeris_english_winner==1)&(groupenglish_final_price != playerdropout_price))
**In two observations, playerdroput price=51 (due to rounding error) => Changed to 50

******English-stage decision classification ***********
*
gen english_decision=0 if(((item_value-playerdropout_price)<=tolerance)&((item_value-playerdropout_price)>=-2)    &(playeris_final_winner==0)&(playercontest_status==1))
****Rational decision 0: drop within 2 units or "tolerance" level below value 
replace english_decision=1 if(((item_value-playerdropout_price)>=-2)&(playeris_final_winner==1))  
****Rational decision=1: Buy at the price no higher than 2 units of value at_English stage
replace english_decision=2 if((item_value-playerdropout_price)<-2)  
****Decision=2: These people who stay too long at the English stage
replace english_decision=-1 if(((item_value-playerdropout_price)>tolerance)&(playeris_final_winner==0))  
****These people who leave at a price more than "tolerance"" below value at the English stage
*
replace english_decision=-0.5 if(((item_value-playerdropout_price)>tolerance)&(playeris_final_winner==1)&(predictgroupfinal_price-playerdropout_price>tolerance))  
****Rational decision=-0.5: Bought at the price more than "tolerance" units below value and below predicted competitive final price in HNL auction; could have intended to drop out early
*
***NOTE: This latter category is specifically defined to check if Dutch-stage delays lead to lower than competitive pricing  *** 
replace english_decision=-1 if(((item_value-playerdropout_price)>tolerance)&(playeris_english_winner==1)&(numenglishwinners>1))  
***For auctions with more than one "winner" at the English stage, count all winners' decisions as dropuots
replace english_decision=. if((playercontest_status!=1)|(grouphave_contest_winner==1))
***This drops observations where dropout or purchases were made at the Dutch or Contest (not ENglish) stages 

*******************************
tab english_decision
***2064 obs, correct!

tab playercontest_status if( english_decision==.)
*1370 observations with no English decisions -- for bidders who dropped out of the auction or won the auction at the contest stage (before the Engish stage began)
 
 tab playercontest_status grouphave_contest_winner if( english_decision==.)
****If a player is alone participating in the contest ((playercontest_status==1)&(grouphave_contest_winner==1)), then this bidder buys at the Contest stage, and hence they do not bid at the English stage: 240 observations like this
 
**Check if the English decision defined correctly
gen diff_value_english=item_value-playerdropout_price
*
sort english_decision
by english_decision: sum diff_value_english playeris_english_winner
*Yes, this is correct

sort bidders top_HNL_pay
by bidders top_HNL_pay: tab english_decision
*High earners both drop out early and overbid less often than Low earners

**16
*******************************************************

****UNIFY DIFFERENT-STAGE DECISIONS 

**DUTCH Stage : "Dutch_decision"
************-1 -- Low bid or non-bid
************ 0 -- Rational no-bid
************ 1 -- eqm bid (at eqm prediction)
************ 1.5 -- rational bid (below value, above eqm prediction)
************ 2 -- bid over value

**CONTEST Stage : "contest_decision"
************-1 -- leave early
************ 0 -- leave rational
************ 1 -- rational bid
************ 2 -- bid over value
*
**ENGLISH  Stage : "English_decision"
************-1 -- leave early
************ -0.5 -- bought at more than 2 below Eqm prediction -- could have intended  to drop out early, or not
************ 0 -- leave rational -- within 2 units of value
************ 1 -- buy rational within 2 units of value
************ 2 -- stay above value


*********Final decision ***********
gen final_decision= contest_decision 
replace final_decision=dutch_decision if((playercontest_status==1)&(grouphave_contest_winner==1)) 
*
replace final_decision=english_decision if((playercontest_status==1)&(grouphave_contest_winner>1)) 
*
***Change outcome for Dutch winners at low prices 
replace final_decision=-0.5 if((playercontest_status==1)&(grouphave_contest_winner==1)&(playeris_final_winner)&(groupfinal_price< predictgroupfinal_price-2)) 
*
******This one makes no changes
replace final_decision=-0.5 if((playeris_final_winner)&(groupfinal_price< predictgroupfinal_price-2)) 
***************************************


*************************Final_decision	******************			
************-1 -- leave early
************ -0.5 -- bought at English stage at more than 2 below Eqm prediction -- could have intended  to drop out early, or not
************ 0 -- leave rational (at value +/- tolerance)
************ 1 -- eqm bid at Dutch or English stage
************ 1.5 -- rational bid at the Dutch stage leading to winning the auction (below value, above eqm prediction)
************ 2 -- stay/bid over value
**********************************************************
tab final_decision 

sort bidders
by bidders: tab final_decision

sort bidders top_HNL_pay
by bidders top_HNL_pay: tab final_decision

*******************************************************

***17 
******************************************************************************
*******Decision-outcome patterns -- ANALYSIS for TABLE 6 
******************************************************************************

**CORRELATE DUTCH LOW BIDS WITH SUBSEQUENT BEHAVIOR, TO DIFFERENTIATE TIME_UNDERVALUE AND SUPPORESSED PRICE COMPETITION
******* Background for Table 6

tab dutch_decision final_decision

sort bidders
by bidders: tab final_decision if( dutch_decision==-1)
*****49% of low bids or no-bids in 2-bidder auctions and 24% in 5-bidder auctions resulted in either early droputs, or buying below the eqm price

sort bidders top_HNL_pay
by bidders top_HNL_pay: tab final_decision if( dutch_decision==-1)
**Top earners appear to drop out early less often

save "Honolulu_ALL_with_strategies.dta"


*****************BEHAVIOR *****************

use "Honolulu_ALL_with_strategies.dta", clear

**TOLERANCE LEVEL: 
tab tolerance

************* BEHAVIOR1 -- SEPARATE DROP AND BUY ******************* 

gen behavior1="Unclassified"
replace behavior1="Delay Low Price Drop" if((dutch_decision==-1)&(final_decision==-1))
replace behavior1="Delay Low Price Buy" if((dutch_decision==-1)&(final_decision==-0.5))
replace behavior1="No Delay Low Price Drop" if((dutch_decision>=0)&(final_decision==-1))
replace behavior1="Delay Competitive Drop or Buy" if((dutch_decision==-1)&(final_decision>=0))
replace behavior1="No Delay Competitive Drop" if((dutch_decision>=0)&(final_decision==0))
replace behavior1="No Delay Competitive Buy" if((dutch_decision>=0)&((final_decision==1)|(final_decision==1.5)))
replace behavior1="No Delay Low Price Buy" if((dutch_decision>=0)&((final_decision==-0.5)))
replace behavior1="No Delay Overbid" if((dutch_decision>=0)&(final_decision==2))
replace behavior1="Delay Overbid" if((dutch_decision==-1)&(final_decision==2))
replace behavior1="Delay Competitive Drop" if((dutch_decision==-1)&(final_decision==0))
replace behavior1="Delay Competitive Buy" if((dutch_decision==-1)&(final_decision>0))
replace behavior1="Delay Overbid" if((dutch_decision==-1)&(final_decision==2))
*

************************
***UNMERGED DROP AND BUY
tab behavior1 
****This is behavior with any Buy below Eqm prediction considered LOW


************* BEHAVIOR -- MERGE DROP AND BUY ******************* 
***Merge DROP AND BUY categories as in Table 6 *********
gen behavior=behavior1
replace behavior="Delay Competitive Drop or Buy"  if((behavior1=="Delay Competitive Drop")|(behavior1=="Delay Competitive Buy")) 
replace behavior="Delay Competitive Drop or Buy"  if(behavior1=="Delay Overbid") 
*Got rid of "Delay Ovebid" category since these are extremely rare -- only 7 observations total 
replace behavior="No Delay Competitive Drop or Buy"  if((behavior1=="No Delay Competitive Drop")|(behavior1=="No Delay Competitive Buy")) 

tab behavior 

sort bidders  
by bidders: tab behavior
*******2-bidder auctions have more low-price Dutch and Final bids that 5-bidder acutions. 
****THE ABOVE IS THE IN FAVOR OF SUPPRESSED PRICE COMPETITION IN 2-BIDDER AUCTIONS

**********NOW BY TREATMENT -- TABLE 6 ******************
sort bidders cost
gen cell="1-2H" if((bidders==2)&(cost=="High"))
replace cell="2-2L" if((bidders==2)&(cost=="Low"))
replace cell="3-5H" if((bidders==5)&(cost=="High"))
replace cell="4-5L" if((bidders==5)&(cost=="Low"))

table behavior cell,  statistic(percent, across(behavior))
****ABOVE IS TABLE 6 IN THE PAPER **** 
*********************************************
***END TABLE 6 
********************************************************************************

**18
********Classify behavior by individual -- for footnote 31 in the paper--**

gen eqm_conistent=((behavior=="No Delay Competitive Drop or Buy")|(behavior =="No Delay Low Price Buy"))
gen delay_collusion_consistent=((behavior=="Delay Low Price Drop")|(behavior=="Delay Low Price Buy"))
gen delay_competitive_consistent=((behavior=="Delay Competitive Drop or Buy")|(behavior=="Delay Low Price Buy"))
*
gen nodelay_collusion_consistent=((behavior=="No Delay Low Price Drop")|(behavior=="No Delay Low Price Buy"))
gen nodelay_overcomp_consistent=((behavior1=="No Delay Competitive Buy")|(behavior=="No Delay Overbid")|(behavior =="No Delay Low Price Buy"))
*
gen anycollusion_consistent=(delay_collusion_consistent|nodelay_collusion_consistent)
*
sort sessionID subjectID
by sessionID subjectID: egen share_eqm=mean(eqm_conistent)
*
sort sessionID subjectID
by sessionID subjectID: egen share_coll_delay=mean(delay_collusion_consistent)
*
sort sessionID subjectID
by sessionID subjectID: egen share_compet_delay=mean(delay_competitive_consistent)
*
sort sessionID subjectID
by sessionID subjectID: egen share_coll_nodelay=mean(nodelay_collusion_consistent)
*
sort sessionID subjectID
by sessionID subjectID: egen share_overcompet_nodelay=mean(nodelay_overcomp_consistent)
*
sort sessionID subjectID
by sessionID subjectID: egen share_coll_all=mean(anycollusion_consistent)
*********
gen modal_frequency=max(share_eqm,share_coll_all,share_compet_delay,share_overcompet_nodelay)  
sum modal_frequency
********

gen Modal_Behavior="Competitive Delay" if share_compet_delay==max(share_eqm,share_coll_all,share_compet_delay,share_overcompet_nodelay)  

replace Modal_Behavior="Over-Competitive No Delay" if share_overcompet_nodelay==max(share_eqm,share_coll_all,share_compet_delay,share_overcompet_nodelay)  

replace Modal_Behavior="Collusive" if share_coll_all==max(share_eqm,share_coll_all,share_compet_delay,share_overcompet_nodelay)  

replace Modal_Behavior="Equilibrium" if share_eqm==max(share_eqm,share_coll_all,share_compet_delay,share_overcompet_nodelay)  

************


***Share of behaviors consistent with different patterns by individual 
sort bidders cost sessionID subjectID
list bidders cost sessionID subjectID top_HNL_pay Modal_Behavior modal_frequency share_eqm share_coll_all share_compet_delay  share_overcompet_nodelay  if(round_number==3)
***********

sort bidders cost
by bidders cost: sum  modal_frequency if(round_number==3)


*Modal behaviors by treatment
sort bidders cost
by bidders cost: tab Modal_Behavior top_HNL_pay if(round_number==3)


sort bidders
by bidders: tab Modal_Behavior top_HNL_pay if(round_number==3)


*For TWO THIRDS (corrected from three-quarters) of bidders in 2-bideer auctions (51 out of 78, or 65% -- CORRECTED FROM 73%), and the overwhelming majority of bidders in 5-bidder auctions (77 out of 80, or 96%), the modal behavior is consistent with equilibrium , i.e., falls into "No Delay Competitive Drop or Buy") or "No Delay Low Price Buy"categries. Report in Footnote 31.

********End material for Footnote 31***********************

 
********************************************************************************


 ***19 
****PERCENTAGE OF DECISIONS CONSISTENT WITH NON-COMPETITIVE BEHAVIOR -- AGGREGATE BY SESSION
gen noncompetitive=(final_decision==-1)
sort sessionID 
by sessionID: egen percent_noncompetitive=mean(noncompetitive)

sort bidders sessionID 
by bidders: list sessionID bidders percent_noncompetitive if((round_number==3)&(subjectID==1))

collapse (mean) bidders High noncompetitive, by(sessionID)
sort bidders High

ttest noncompetitive, by(bidders)
ranksum noncompetitive, by(bidders)
****This is reported in the paragraph preceeding Result 9: "The difference in the frequencies of non-competitive actions between 2-bidder
*and 5-bidder auctions are highly significant"


***END MATERIAL FOR TABLE 6 AND RELATED DISCUSSION 
********************************************************************************

****20
************** RUN MLOGIT ON COMPETIVE VS NON_COMPETITIVE BEHAVIOR BY STAGE: TABLE G.5 in APPENDIX G
*
use "Honolulu_ALL_with_strategies.dta", clear
***************************************
gen cell=High*10+bidders
tab cell
**************************************

label variable High "high cost"
label variable item_value "item value"
label variable High_bidders5 "5 bidders high cost"
label variable dutch_bid_actual "dutch bid"
label variable is_dutch_first "Dutch auction first"
label variable round_number "round number"
label variable top_HNL_pay  "top pay"

****DETAILED CLASSIFICATION OF DUTCH, CONTEST AND ENGLISH STAGE DECISIONS 

**DUTCH Stage : "Dutch_decision"
************-1 -- Low bid or non-bid
************ 0 -- Rational no-bid
************ 1 -- eqm bid (at eqm prediction)
************ 1.5 -- rational bid (below value, above eqm prediction)
************ 2 -- bid over value

**CONTEST Stage : "contest_decision"
************-1 -- leave early
************ 0 -- leave rational
************ 1 -- rational bid
************ 2 -- bid over value

*******Check if contest decisions allow "rational" decision over/underbid by 2 units
gen contest_money_left=item_value-groupdutch_final_price if contest_decision==-1
gen contest_overbid=item_value-groupdutch_final_price if contest_decision==2
sum contest_money_left  contest_overbid
***YEs, over- and under-bidding by 2 units is allowed as rational in contest decisions, check that it is also true for English-stage 

*
**ENGLISH  Stage : "English_decision"
************-1 -- leave early
************ -0.5 -- bought at more than 2 below Eqm prediction -- colud have intended  to drop out early
************ 0 -- leave rational -- within 2 units of value
************ 1 -- buy rational within 2 units of value or eqm prediction 
************ 2 -- stay above value

gen English_underbid=item_value-playerdropout_price
replace English_underbid=. if english_decision==.
sort english_decision
by english_decision: sum English_underbid
***YEs, over- and under-bidding by 2 units is allowed as rational in English decisions, consistent with other stages 


****MERGE INTO 3 CATEGORIES for MLOGIT:
*0 -- underbid, i.e., delay,  in Dutch; or drop early in subsequent stages ***
*1 -- ratioanl bid/drop
*2 -- bid/stay above value

gen dutch_decision3=((dutch_decision>=0)&(dutch_decision<2))
replace dutch_decision3=2 if(dutch_decision==2) 
tab dutch_decision3
*tab  behavior
*tab  dutch_decision if(behavior=="No Delay Overbid")
****CHECKED< CORRECT ***********
sort bidders
by bidders: tab dutch_decision3


gen contest_decision3=((contest_decision==0)|(contest_decision==1))
replace contest_decision3=2 if(contest_decision==2)
replace contest_decision3=. if(contest_decision==.) 
tab contest_decision contest_decision3



gen english_decision3=((english_decision>-1)&(english_decision<2))
replace english_decision3=english_decision if((english_decision==2))
replace english_decision3=english_decision if((english_decision==.))
tab english_decision3 english_decision


********* COMBINE ALL STAGE DECISIONS ****************

*****"Final decision" defined earlier
*************************Final_decision	******************			
************-1 -- leave early
************ -0.5 -- bought at English stage at more than 2 below Eqm prediction -- could have intended  to drop out early, or not
************ 0 -- leave rational (at value +/- tolerance)
************ 1 -- eqm bid at Dutch or English stage
************ 1.5 -- rational bid at the Dutch stage leading to winning the auction (below value, above eqm prediction)
************ 2 -- stay/bid over value
**********************************************************
tab final_decision 

gen final_decision3=(final_decision>-1)
replace final_decision3=2 if(final_decision==2)
tab final_decision3 final_decision

***********=0 drop BELOW value (too early***)
***********=1 drop AT value (RATIONAL***) or buy no higher than at value
***********=2 STAY ABOVE value (too late***)


gen hnl_decision=final_decision3

tab dutch_decision3 hnl_decision
tab contest_decision3 hnl_decision
tab english_decision3 hnl_decision
tab dutch_decision3 hnl_decision if english_decision3==.
*About half over-bidding (61 out of 133) were initiated at the Dutch or Contest stages, with 4 ending auctions at the Dutch stage, and 57 carried into the English stage. The other half (76 out of 133 instances) was initiated at the English (Final) stage******


************Mlogit- estimation of proability of over- and under-bidding in the HNL auction -- all stages


**ALL MOLOGIT BY STAGE
********************Mlogit estimations of equilibrium decisions by stage in HNL auctions
************WITH BOOTSTRAP 
eststo clear
*1
eststo: bootstrap,   reps(500) seed(551)   cluster(sessionID) strata(cell): 	mlogit dutch_decision3  item_value i.bidders High  High_bidders5 is_dutch_first round_number top_HNL_pay, base(1) 
*cluster(sessionID)
*2
eststo:   bootstrap,   reps(500) seed(599)   cluster(sessionID) strata(cell): 		mlogit contest_decision3  item_value i.bidders High  High_bidders5 is_dutch_first round_number top_HNL_pay, base(1) 
*cluster(sessionID)
*3
eststo:  bootstrap,   reps(500) seed(107)   cluster(sessionID) strata(cell): 	 	mlogit english_decision3  item_value i.bidders High  High_bidders5 is_dutch_first round_number top_HNL_pay, base(1) 
*cluster(sessionID)
*4
eststo:	 bootstrap,   reps(500) seed(415)   cluster(sessionID) strata(cell): 	 mlogit hnl_decision  item_value i.bidders High  High_bidders5 is_dutch_first round_number top_HNL_pay, base(1) 
*cluster(sessionID)

esttab, se b(%8.2f) wide pr2 label nobaselevels   mtitles("Dutch bid" "Contest" "English" "Final outcome") star(* 0.10 ** 0.05 *** 0.01)  type 
*
*esttab using "hnl_bids_mlogit_bs0624.tex", se b(%8.2f) wide pr2 label nobaselevels   mtitles("Dutch stage" "Contest" "English" "Final outcome") star(* 0.10 ** 0.05 *** 0.01)    replace
*****************Above  is TABLE G.5 IN APPENDIX G  ***********

**************END ANALYSIS FOR TABLE G.5 **********  


 
******************END  ANALYSIS OF HONOLULU BIDDER BEHAVIOR *****
********************************************************************************************************************

log close
