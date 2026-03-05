clear
log using "group-analysis_main.log"


******************GROUP ANALYSIS **************************************

******************************GO TO LINE 11 FOR PRICE DYNAMICS IN HNL AUCTIONS STATS TABLE (TABLE 3)  ******************************GO TO LINE 65 FOR GROUP SUMMARY STATS TABLE (TABLE 4)  *********
******************************GO TO LINE 123-297 FOR GRAPHS THAT MATCH FIGURES 3-4 ********


*********STEP 1: PRICE DYNAMICS IN HNL AUCTIONS: FOR TABLE 3 ************************** 

use Honolulu_ALL_group_vars_only.dta, clear

gen price_drop_Dutch= start_price - groupdutch_final_price
gen predictprice_drop_Dutch= start_price- predictgroupdutch_final_price


sum price_drop_Dutch groupenglish_time_elapsed if ((price_drop_Dutch<=2)&(groupenglish_time_elapsed>0))
sum predictprice_drop_Dutch predictgroupenglish_time_elapsed if ((predictprice_drop_Dutch<=2)&(predictgroupenglish_time_elapsed>0))

**Classify the dynamics according to  the number of contestants at starting and the Dutch bid (or zero, if no one bids in Dutch) price. (Note: price drops within 2 units are considered "at starting price"): 

*if bid at the starting price, and not contested => "Dutch;"
*if bid at the starting price, and contested => "English" (this includes cases where the second highest value=starting price; the bidder with the second highest value bids at the contest stage, then drops immediately);
*if bid below the starting price, and not contested => "Dutch;"
*if bid below the starting price, and contested => "Dutch then English;"

gen dynamics="English" if ((price_drop_Dutch<=2)&(contestants>1))
replace dynamics="Dutch then English" if  ((price_drop_Dutch>2)&(contestants>1))
replace dynamics="Dutch" if  ((contestants<=1))

tab dynamics


gen predict_dynamics="English" if ((predictprice_drop_Dutch<=2)&(predictcontestants>1))
replace predict_dynamics="Dutch then English" if  ((predictprice_drop_Dutch>2)&(predictcontestants>1))
replace predict_dynamics="Dutch" if  (predictcontestants<=1)

tab predict_dynamics 

tab predict_dynamics dynamics


tab discount_b

gen cost="High" if(discount_b>0.01)
replace cost="Low" if(discount_b<0.01)
tab cost discount_b


gen treatment="2H" if ((bidders==2)&(cost=="High"))
replace treatment="2L" if ((bidders==2)&(cost=="Low"))
replace treatment="5H" if ((bidders==5)&(cost=="High"))
replace treatment="5L" if ((bidders==5)&(cost=="Low"))
tab treatment

tab treatment dynamics 
**The above matches Table 3 stats
tab treatment predict_dynamics 
**The above matches Table 3 stats
 


**************************************************************
*********************STEP 2: SUMMARY TABLE BY TREATMENT ***************

**********************
use  "Dutch_and_Honolulu_ALL_group_vars_for_analysis.dta", clear


************* These are the three categories that we group the graphs by ****************
tab auction_type 
tab cost bidders
tab discount_b

******************************************
****Summary stats **

sort bidders  cost auction_type 
by bidders  cost auction_type: sum efficiency price_predict  price duration_predict  duration  Uauctioneer_predict Uauctioneer winpayoff_predict  winpayoff 
*[THESE STATS SHOULD MATCH TABLE 3 IN THE PAPER]

*******************************************

gen treatment="2H_HNL" if((bidders==2)&(cost=="High")&(auction_type=="HNL"))
replace treatment="2L_HNL" if((bidders==2)&(cost=="Low")&(auction_type=="HNL"))
*
replace treatment="2H_Dutch" if((bidders==2)&(cost=="High")&(auction_type=="Dutch"))
replace treatment="2L_Dutch" if((bidders==2)&(cost=="Low")&(auction_type=="Dutch"))
*
replace treatment="5H_HNL" if((bidders==5)&(cost=="High")&(auction_type=="HNL"))
replace treatment="5L_HNL" if((bidders==5)&(cost=="Low")&(auction_type=="HNL"))
*
replace treatment="5H_Dutch" if((bidders==5)&(cost=="High")&(auction_type=="Dutch"))
replace treatment="5L_Dutch" if((bidders==5)&(cost=="Low")&(auction_type=="Dutch"))
*
tab treatment


tabstat efficiency price_predict  price duration_predict  duration  Uauctioneer_predict Uauctioneer winpayoff_predict  winpayoff, by(treatment) stat(mean sd count) nototal long format(%6.2f)


est clear
estpost tabstat efficiency price_predict  price duration_predict  duration  Uauctioneer_predict Uauctioneer winpayoff_predict  winpayoff, by(treatment) c(stat) stat(mean sd) nototal

esttab, main(mean %8.2fc) aux(sd  %8.2fc) nostar nonumber unstack ///
   nonote noobs label ///
   collabels(none) ///
   eqlabels("2H_Dutch" "2H_HNL" "2L_Dutch" "2L_HNL"  "5H_Dutch" "5H_HNL" "5L_Dutch" "5L_HNL" ) /// 
   nomtitles
   
*esttab using "table_stats.tex", replace ///
*  main(mean %8.2fc) aux(sd %8.2fc) nostar nonumber unstack ///
*   compress nonote noobs gap label booktabs   ///
*   collabels(none) ///
*   eqlabels("2H_Dutch" "2H_HNL" "2L_Dutch" "2L_HNL"  "5H_Dutch" "5H_HNL" "5L_Dutch" "5L_HNL" ) /// 
*   nomtitles
*************The above summary stats table matches TABLE 4 in the paper **************



***************************************************************
********** STEP 3 -- BAR CHARTS 

********GRAPHS USING DATA BY SESSION ROUND GROUP AUCTION TYPE *********
graph close _all 
 
use "Dutch_and_Honolulu_ALL_group_vars_for_analysis.dta",  clear

gen order=1 if auction_type == "HNL"
replace order=2 if auction_type == "Dutch"


********EFFICIENCY **********
graph bar (mean) eff, over(auction_type) over(cost) over(bidders, relabel(1 "2 bidders" 2 "5 bidders") gap(*.4))  ///
ytitle("Average Efficiency") ///
title("Auction efficiency by treatment") ///
blabel(bar, position(inside) format(%9.1f) color(white))  ///
bar(1, color(cranberry)) bar(2, color(navy)) ///
name(bar_efficiency_all, replace)
*graph export bar_efficiency_all.pdf, replace 
*
***This Matches FIGURE 3 IN THE PAPER
**********************************


*********************************************************
****************** GRAPHS TO MATCH FIGURE 4 IN THE PAPER ***************************

************** 4 cells ********************

gen cell="2H_Dutch" if((HNL==0)&(bidders==2)&(discount_b>0.01))
replace cell="2H_HNL" if((HNL==1)&(bidders==2)&(discount_b>0.01))
*
replace cell="2L_Dutch" if((HNL==0)&(bidders==2)&(discount_b<0.01))
replace cell="2L_HNL" if((HNL==1)&(bidders==2)&(discount_b<0.01))
*
replace cell="5H_Dutch" if((HNL==0)&(bidders==5)&(discount_b>0.01))
replace cell="5H_HNL" if((HNL==1)&(bidders==5)&(discount_b>0.01))
*
replace cell="5L_Dutch" if((HNL==0)&(bidders==5)&(discount_b<0.01))
replace cell="5L_HNL" if((HNL==1)&(bidders==5)&(discount_b<0.01))
*
tab cell


**********FOUR CELLS FOR FOUR TREATMENTS ****************************

gen cell2H="2H_Dutch" if(cell=="2H_Dutch")
replace cell2H="2H_HNL" if(cell=="2H_HNL")
*
gen cell2L="2L_Dutch" if(cell=="2L_Dutch")
replace cell2L=cell if(cell=="2L_HNL")
*
gen cell5H=cell if(cell=="5H_Dutch")
replace cell5H=cell if(cell=="5H_HNL")
*
gen cell5L=cell if(cell=="5L_Dutch")
replace cell5L=cell if(cell=="5L_HNL")
*
tab cell2H 
drop cell

***********PRICES AND DURATION BAR CHARTS 
foreach num of numlist 2 5 {
	
	foreach b in "H" "L"  { 

foreach x in  "price"    {

graph bar (mean) `x'  `x'_predict, over(cell`num'`b') ///
legend(label(1 "actual") label(2 "predicted")) ///
   ylabel(0(10)40, grid) ///
ytitle("Average `x' ") ///
title("Average `x', treatment `num'`b' ") ///
blabel(bar, position(inside) format(%9.1f) color(white))  ///
name(bar_`x'_`num'`b', replace)
*graph export bar_`x'_`num'`b'.pdf, replace 

}
	}
}


foreach num of numlist 2 5 {
	
	foreach b in "H" "L"  { 

foreach x in   "duration"   {

graph bar (mean) `x'  `x'_predict, over(cell`num'`b') ///
legend(label(1 "actual") label(2 "predicted")) ///
ylabel(0(10)30, grid) ///
ytitle("Average `x' ") ///
title("Average `x', treatment `num'`b' ") ///
blabel(bar, position(inside) format(%9.1f) color(white))  ///
name(bar_`x'_`num'`b', replace)
*graph export bar_`x'_`num'`b'.pdf, replace 

}
	}
}


*****************COMBINE GRAPHS -- PRICE & DURATION,  by treatment ********

foreach x in  "price" "duration"   {
		graph combine bar_`x'_2H bar_`x'_5H bar_`x'_2L bar_`x'_5L, name(bar_`x'_all, replace)  
*		graph export bar_`x'_all.pdf, replace 
}


************************************************
*********** SELLER AND BUYER PAYOFFS *************************


gen Seller=Uauctioneer
gen Seller_predict=Uauctioneer_predict

gen Buyer=winpayoff
gen Buyer_predict=winpayoff_predict



foreach num of numlist 2 5 {

	foreach b in "H" "L"  { 

	foreach x in  "Buyer"     {

graph bar (mean) `x'  `x'_predict, over(cell`num'`b') ///
legend(label(1 "actual") label(2 "predicted")) ///
ylabel(0(5)15, grid) ///
ytitle("`x' ") ///
title(" `x' Payoff, treatment `num'`b' ") ///
blabel(bar, position(inside) format(%9.1f) color(white))  ///
name(bar_`x'_payoff_`num'`b', replace)
*graph export bar_`x'_payoff_`num'`b'.pdf, replace 

}

}

}

foreach num of numlist 2 5 {

	foreach b in "H" "L"  { 

	foreach x in  "Seller"   {

graph bar (mean) `x'  `x'_predict, over(cell`num'`b') ///
legend(label(1 "actual") label(2 "predicted")) ///
ylabel(0(10)30, grid) ///
ytitle(" `x' ") ///
title(" `x' Payoff, treatment `num'`b' ") ///
blabel(bar, position(inside) format(%9.1f) color(white))  ///
name(bar_`x'_payoff_`num'`b', replace)
*graph export bar_`x'_payoff_`num'`b'.pdf, replace 

}

}

}

*****************COMBINE GRAPHS -- SELLER PAYOFF & BUYER PAYOFF, by treatment ********


foreach x in  "Seller" "Buyer"   {
		graph combine bar_`x'_payoff_2H bar_`x'_payoff_5H bar_`x'_payoff_2L bar_`x'_payoff_5L, name(bar_`x'_payoff_all, replace)  
*graph export bar_`x'_payoff_all.pdf, replace 
}


**************************END GRAPHS FOR FIGURES 3, 4 IN THE PAPER ****************************************



***END *******

log close
