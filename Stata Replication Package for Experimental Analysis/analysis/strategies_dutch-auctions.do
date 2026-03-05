clear
log using "strategies_dutch_auctions.log"

***********************CONTENTS *******************************************************
***Data prep: Lines 50-71

**0 ****
**MEAN PAY PERCENT FOR TOP AND BOTTOM EARNERS 
****Lines 73-78 **************************

***1 ****
************SHARE OF DOMINATED DECISIONS BY EARNINGS CATEGORY ****************
** Lines 79-98
 
****2 ********
**********************DUTCH BID REGRESSIONS AND PLOTS FOR FIGURE 5 ************************************************
**Lines 102-171 

***3
*********************************************************************
****Check if actual bid are equal to predicted
**Lines 175-193
 
**4 ********
*************************************************************************************************
***  TABLES G3 in ONLINE APPENDIX G: Dutch Bids Regression
**Lines 195-248

******5 
********** Dutch bid deviations from predictions: For LEFT PANEL OF FIGURE 8 AND DISCUSSION OF OVERBIDDING PREEEDING RESULT 7 
**Lines 251-296

***6
***************Do Top earners overbid signficantly less than bottom earners? ****** 
**Lines 299-313

***7
*****Are Dutch bid deviations the same in High and Low Treatments? For Appendix G ********** 
*** Lines  317-333


****8
 ********** CHECK FOR ORDER EFFECTS ***************
**** Line 336-382

****END*********************************************************************************** 
****Line 387


*********ANALYSIS OF DUTCH AUCTION BIDDING IS HERE *******************

use "Dutch_ALL_for_bidder_analysis.dta", clear

*Note: Number of test rounds is separate from "rounds". The latter refers to the number of PAID rounds.

***Re-classify the bidder with losses who is predicted to earn zero into the Bottom Pay
sum Dutchpay_predict_sum  participantdutch_payoff  Dutch_paypercent medianDutch_paypercent top_Dutch_pay if globalid==508
replace Dutch_paypercent=. if globalid==508
replace top_Dutch_pay=0 if globalid==508
***NOTE: ID 508 is predicted to earn nothing, and lost money in the Dutch auctions

********PREDICTED AND ACTUAL BIDS *****************************************************
rename predictplayerbid dutch_bid_predict
gen dutch_bid_actual=playeris_dutch_winner * groupdutch_final_price if(playeris_dutch_winner==1)

***0 ****
*********************************STRATEGIES BY PAY CATEGORY *****************************
*******************************TWO CATERGORIES: TOP AND BOTTOM *******************************************

gen cost="High" if(High==1)
replace cost="Low" if(High==0)

***0 ****
**MEAN PAY PERCENT FOR TOP AND BOTTOM EARNERS 
sort bidders cost top_Dutch_pay
by bidders cost top_Dutch_pay: sum Dutch_paypercent if round_number==4
**Unlike Figure G.1, these means are based on uncensored values including higher percentage losses. See footnote 6 in Online Appendix G for explanation.

***1 ****
************SHARE OF DOMINATED DECISIONS BY EARNINGS CATEGORY ****************
******Check for strictly dominated bids ***************
gen dutch_bid_rational=((item_value>=groupdutch_final_price))  if(playeris_dutch_winner==1)
sum dutch_bid_rational
****97.2% of all dutch bids are rational (at or below value)

sort bidders cost  top_Dutch_pay
by bidders cost top_Dutch_pay: sum dutch_bid_rational
*****High 90%+ in all treatments. 5L is the lowest becasue of one ID#112 experimenting and buying with a large loss six times. 

******************************
***NoW allow over-bidding by 2 points
gen dutch_bid_rational2=((item_value>=groupdutch_final_price-2))  if(playeris_dutch_winner==1)
sum dutch_bid_rational2
****97.5% of all dutch bids are rational (at or below value+2)

sort bidders cost  top_Dutch_pay
by bidders cost top_Dutch_pay: sum dutch_bid_rational2
***These stats match Online Appendix Table G1



****2 ********
*********************DUTCH BID REGRESSIONS AND PLOTS FOR FIGURE 5 ************************************************
*************USE TWO CATEGORIES: Bottom (0) AND Top (1) by "Dutch_paypercent"

sort bidders cost top_Dutch_pay
by bidders cost top_Dutch_pay: sum Dutch_paypercent if round_number==4

label variable High "high cost"
label variable item_value "item value"
label variable dutch_bid_actual "dutch bid"


	
**** BELOW IS THE MATERIAL FOR FIGURE 5 -- DUTCH BIDS *****
******GRAPH BIDS BY "top_Dutch_pay" ************

eststo clear
 foreach num of numlist 2  5 {
 	 eststo clear
	foreach  h in  "Low"   "High"     {
	display "************************************"	
	display "`num' bidders, Cost is `h' "	
	display "************************************"	
	 sum medianDutch_paypercent Dutch_paypercent Dutch_dpay_norm Dutchpay_sum Dutchpay_predict_sum if((bidders==`num')&(cost=="`h'"))
	eststo: reg dutch_bid_predict item_value  if((bidders==`num')&(cost=="`h'"))
	scalar slope`num'`h'predict=_b[item_value]
     scalar list
*
	foreach p of numlist 0 1  {
	display "************************************"	
	display "`num' bidders, Cost is `h', Top Dutch Pay = `p' "	
	display "************************************"	
		
	eststo: reg dutch_bid_actual  item_value  if((bidders==`num')&(cost=="`h'")&(top_Dutch_pay==`p')),  vce(cluster sessionID)
	****Tests is slope is equal to predicted
	test item_value = slope`num'`h'predict
	predict dutchreg`num'`h'`p'  if((bidders==`num')&(cost=="`h'")&(top_Dutch_pay==`p'))
	predict stdf`num'`h'`p'  if((bidders==`num')&(cost=="`h'")&(top_Dutch_pay==`p'))
	sum stdf`num'`h'`p'
			}
			
	twoway (line dutch_bid_predict item_value, lwidth(medthick) sort) ///
		(scatter dutch_bid_actual  item_value if(top_Dutch_pay==1)) ///
		(scatter dutch_bid_actual  item_value if(top_Dutch_pay==0))  ///
		(line dutchreg`num'`h'1 item_value, lstyle(p2) lwidth(medthick) sort) ///
		(line dutchreg`num'`h'0 item_value, lstyle(p3)  lwidth(medthick) sort)  if((bidders==`num')&(cost=="`h'")) , 	title(" `num' bidders, `h' cost") ///
		xlabel(0(10)50, grid) ///
		xtitle("value") ytitle("Dutch bids")  ///
		legend(label(1 "theory") label(2 "top_earn")  label(3 "bottom-earn")  label(4 "reg_top") label(5 "reg_bottom")) ///
		name(Dutch_bids_`num'`h', replace)  saving(Dutch_bids_`num'`h', replace)	
	display "************************************"	
	scalar drop _all
	foreach p of numlist 0 1   {
	drop dutchreg`num'`h'`p' stdf`num'`h'`p' 
	}
		}
	display "**************************************************************************"	
	display "`num' bidders: Regressions of DutchBids for Figure 5 	
	display "***************************************************************************"		
esttab, se b(%8.2f)  pr2 label mtitles("`num'L-pred" "`num'L-B"  "`num'L-T"  "`num'H-pred" "`num'H-B" "`num'H-T") star(* 0.10 ** 0.05 *** 0.01)  type replace   keep(item_value  _cons)
***Above are the regressions to put on Figure 5 *************
		
}
			
**********Combine DUTCH BIDS graphs 
		
graph combine Dutch_bids_2High  Dutch_bids_5High  Dutch_bids_2Low  Dutch_bids_5Low , rows(2) imargin(0 0 0 0)   xcommon iscale(.5)  title("Dutch auction bids by treatment")
*graph export All_Dutch_bids_Top_Bottom_final.pdf, replace 
******ABOVE IS FIGURE 5 IN THE PAPER*********

*************************END ANALYSIS FOR FIGURE 5 *******************************************


***3
*********************************************************************
****Check if actual bid are equal to predicted
 foreach num of numlist 2  5 {
 	foreach  h in  "Low"   "High"     {
	display "************************************"	
	foreach p of numlist 0 1 {
	display "************************************"	
	display "`num' bidders, Cost is `h', Top Dutch Pay = `p' "	
	display "************************************"	
		
	reg dutch_bid_actual  dutch_bid_predict  if((bidders==`num')&(cost=="`h'")&(top_Dutch_pay==`p')),  vce(cluster sessionID)
	****Tests if actual bid is equal to predicted
	test (_b[dutch_bid_predict] = 1) (_b[_cons] =0) 
		}
		}
}
****Bids are different from predicted in most treatments
***This is used to substantiate the claim in the paper that "overbidding is common" (Section 5.2 Result 8 and preceeding discussion, and Online Appendix G)

**4 ********
*************************************************************************************************
***  TABLES G3 in ONLINE APPENDIX G: Dutch bids Regression

*****************COMPARE IF BIDS ARE SENSIITVE TO COST OF TIME PARAMETER  *************
*
************Compare across "top_Dutch_pay" *******

gen bidders5=(bidders==5)
gen High_bidders5 = High * bidders5
gen High_value=High*item_value 

label variable High "high cost"
label variable item_value "item value"
label variable High_value "item value high cost"
label variable dutch_bid_actual "dutch bid"
label variable is_dutch_first "dutch auction first"

******BELOW IS TABLE G3 IN THE ONLINE APPENDIX
eststo clear

foreach num of numlist 2 5  {
	
	display "*********************************************"	
	display "`num' bidders
	display "*********************************************"	

eststo: reg dutch_bid_predict  item_value   High_value High   if((bidders==`num'))
	
reg dutch_bid_actual  item_value   High_value High is_dutch_first   if((bidders==`num')),  vce(cluster sessionID)


		
		foreach q of numlist 0 1    {
	display "*********************************************"	
	display "`num' bidders, Earn category is `q' "
	display "*********************************************"	
 
 eststo: bootstrap,  reps(1000) seed(245) cluster(sessionID) strata(High): reg dutch_bid_actual item_value   High_value High is_dutch_first  if((bidders==`num')&(top_Dutch_pay==`q'))
 

*****Test if bidding is sensitive to the cost of time -- based on bootstrapped standard errors****************
test High_value High

	}
}

esttab, se b(%8.2f)  ar2 label mtitles("2B theory"  "2B-B" "2B-T" "5B-theory" "5B-B" "5B-T") star(* 0.10 ** 0.05 *** 0.01)  type replace keep(item_value High_value  High is_dutch_first _cons)



******THE ABOVE IS TABLE G.3 IN THE APPENDIX 
***********END OF ANALYSIS IF BIDS ARE SENSITIVE TO THE COST OF TIME  ************


******5 
********** Dutch bid deviations from predictions ***********
****For LEFT PANEL OF FIGURE 8 AND DISCUSSION OF OVERBIDDING PREEEDING RESULT 7 

gen dutchbiddev=dutch_bid_actual - dutch_bid_predict

***Now compare to  zero-cost prediction
gen dutch_bid_zerocost=((bidders-1)/bidders)*item_value
gen dutchbiddev_zerocost = dutch_bid_actual - dutch_bid_zerocost

sum dutchbiddev dutchbiddev_zerocost
*overbid by 2.52 points above  the prediction with costs,  compared to 4.85 points above the no-cost prediction.
***This goes into discussion in Section 5.2 preceeding Result 7.

*****************Dutch bid deviations from theory by earning category

gen High5=High*bidders5
gen HighHNL=High*HNL
gen roundHNL=round_number*HNL
gen HNL5=HNL*bidders5
gen dutchfirst5=is_dutch_first*bidders5
gen dutchfirstHigh=is_dutch_first*High

gen cell=High*10+bidders
tab cell


sum dutchbiddev

sort  top_Dutch_pay
by  top_Dutch_pay: sum dutchbiddev


************These stats match the left panel of Figure 8 *********
sort bidders High top_Dutch_pay
by bidders High top_Dutch_pay: sum dutchbiddev 


*****************Graph deviations from theoretical predictions by treatment ***************
graph bar (mean)  dutchbiddev, over(top_Dutch_pay, relabel(1 "Bottom Earner" 2 "Top Earner")) over(High,  gap(33) relabel(1 "Low cost" 2 "High cost")) over(bidders, gap(33) relabel(1 "2 bidders" 2 "5 bidders"))    ///
	ytitle("Mean deviation, points")  ///
	 title("Dutch bids deviations from theory") ///
	 blabel(bar, position(outside) format(%9.1f))	 ///
	 name(Dutch_bids_deviations, replace)  saving(Dutch_bids_deviations, replace)
*graph export Dutch_bids_deviations.pdf, replace 
*****************THIS IS IDENTICAL TO FIGURE 8, LEFT PANEL IN THE PAPER*******************
 

 ***6
***************Do Top earners overbid signficantly less than bottom earners? ****** 
*****This regression supports the claim at the end of Section 5.2,  and is reported in Footnote 7 in Appedix G ******************* 

	foreach num of numlist 2  5  {
		foreach  c of numlist 0  1   { 
	display "************************************"	
	display "DUTCH BID PRICE DEVIATIONS FROM PREDICTION,  `num' bidders, `c' cost	
	display "************************************"	
	 	
bootstrap, reps(500) seed(109)   cluster(sessionID): reg dutchbiddev   top_Dutch_pay  is_dutch_first  if((High==`c')&(bidders==`num'))
		
		}
	}	
*****This regression supports the statement at the end of Section section 5.2  that "Top" overbid less than "Bottom" *******************



***7
*****Are Dutch bid deviations the same in High and Low Treatments? ********** 
***This is the difference between bid deviations in high and low cost treatments reported in Appendix G ********
 sort High 
by High: sum dutchbiddev
*****Test if Dutch bid deviations are the same in High and Low Treatments ********** 
bootstrap, reps(500) seed(922)   cluster(sessionID) strata(cell):  reg dutchbiddev  bidders5  High High_bidders5 top_Dutch_pay is_dutch_first
test  High+High_bidders5=0
*******The result is signnificant difference (p<0.01)

bootstrap, reps(500) seed(5568)   cluster(sessionID) strata(cell): reg dutchbiddev   High 
*******The result is highly signnificant difference (p<0.001)
* 
bootstrap, reps(1000) seed(229)   cluster(sessionID) strata(cell):  reg dutchbiddev  bidders5  High High_bidders5 is_dutch_first
test  High+High_bidders5=0
*******The result is signnificant at 10% (p=0.064)
 ***End on the difference between bid deviations in high and low cost treatments reported in Appendix G ********


 ****8
 ********** CHECK FOR ORDER EFFECTS -- FOR APPENDIX I ***************
 
 *****Are Dutch bid deviations the same DEPENDING ON THE ORDER OF INSITUTIONS? ********** 
***This is the difference between bid deviations BY ORDER reported in Appendix I ********
sort is_dutch_first 
by is_dutch_first: sum dutchbiddev

bootstrap, reps(1000) seed(6855)   cluster(sessionID) strata(cell): reg dutchbiddev   bidders5  is_dutch_first dutchfirst5
test  is_dutch_first+dutchfirst5 = 0
*order effet not significant for either 2 or 5-bidder auctions if we pool across High and Low cost treatments

bootstrap, reps(1000) seed(6558)   cluster(sessionID) strata(cell): reg dutchbiddev   bidders5  is_dutch_first 
*order effet not significant 

 
*****Checking order effects for High and Low  separately ******************* 

	foreach num of numlist 2  5  {
	display "************************************"	
	display "DUTCH BID PRICE DEVIATIONS FROM PREDICTION,  `num' bidders "	
	display "************************************"	
	 	
bootstrap, reps(1000) seed(1788)   cluster(sessionID): reg dutchbiddev  High  is_dutch_first dutchfirstHigh  if((bidders==`num'))
test  is_dutch_first+dutchfirstHigh	= 0		
	}
***2-bidders, LOW: "Dutch auction first is positive and significant (p<0.01)" (more overbiiding if Dutch is first)
***2-bidders, HIGH: "Dutch auction first is NS (p>0.1)"
*	
***5-bidders, LOW: "Dutch auction first is positive and marginally significant  (p=0.103)" (more overbiiding if Dutch is first)
***5-bidders, HIGH: "Dutch auction first is NEGATIVE and significant (p<0.01)". [WROING SIGN: LEss overbidding if Dutch is first]
*	

***Separate regressions for High and Low:	
	foreach num of numlist 2  5  {
	display "************************************"			
		foreach  c of numlist 0  1   { 
	display "************************************"	
	display "DUTCH BID PRICE DEVIATIONS FROM PREDICTION,  `num' bidders, High Cost= `c' "	
	display "************************************"	
	 	
bootstrap, reps(1000) seed(1314)   cluster(sessionID): reg dutchbiddev  is_dutch_first  if((High==`c')&(bidders==`num'))
		}
	}	
***Same significance levels as before**
	
********** END ORDER EFFECTS ***************	

 

***********END DUTCH BIDS ANALYSIS ******* 

log close
