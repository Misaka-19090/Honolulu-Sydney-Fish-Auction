clear
log using "group-analysis_bootstrap.log", replace

******************************BOOTSTRAP FOR TABLE 5 STARTS ON LINE 36
use "Dutch_and_Honolulu_ALL_group_vars_for_analysis.dta", clear

******************************************
****Summary stats ** MATCH TABLE 4 IN THE PAPER

sort bidders  cost auction_type 
by bidders  cost auction_type: sum efficiency price_predict  price duration_predict  duration  Uauctioneer_predict Uauctioneer winpayoff_predict  winpayoff 


********************************************
gen high=(cost=="High")
gen round2=round*round
gen bidders5=(bidders==5)
gen high5=high*bidders5
gen highHNL=high*HNL
gen roundHNL=round*HNL
gen HNL5=HNL*bidders5

   
label variable high "high cost"
label variable HNL "HNL auction"
label variable round "round"
label variable round2 "round squared"
label variable bidders5 "5 bidders"
label variable high5 "5 bidders high cost"
label variable highHNL "high cost HNL"
label variable roundHNL "round HNL"
label variable HNL5 "5 bidders HNL"


*********** * BOOTSTRAP: TESTS ON PERFORMACE CHARACTERISTICS COMPARISONS -- FOR TABLE 5
*0*********Efficiency ********* 

***HYPOTHESIS Efficiency Pooled: H=D  -- IN TABLE 5
*Baseline regression in Table D.1
reg efficiency HNL, cluster(sessionID) 


bootstrap   Eff_diff=(_b[HNL]), reps(1000) seed(1115)   cluster(sessionID) strata(bidders high): reg efficiency HNL
***Highly significant (p=0.001), bootstr s.e=0.45
****TABLE 5: bootstr s.e=0.45, p=0.000


**HYPOTHESIS EFFICENCY 2 bidder  Hh=Dh, Hl=Dl,  -- IN TABLE 5
*Baseline regression in Table D.1
reg efficiency HNL high highHNL if(bidders==2), cluster(sessionID)

bootstrap   Eff_diff2_high=( _b[HNL] + _b[highHNL])  Eff_diff2_low=( _b[HNL]), reps(1000) seed(8010)   cluster(sessionID) strata(high): reg efficiency HNL high highHNL if(bidders==2)
***Highly significant (p=0.000), for High cost, n/s (p=0.148) for low cost (sigificant one-sided) -- in TABLE 5


***HYPOTHESIS EFFICENCY 5 bidder  Hh=Dh, Hl=Dl, 5 bidders  -- IN TABLE 5
*Baseline regression in Table D.1
reg efficiency HNL high highHNL if(bidders==5), cluster(sessionID)

bootstrap   Eff_diff5_high=( _b[HNL] + _b[highHNL])  Eff_diff5_low=( _b[HNL]), reps(1000) seed(8652)   cluster(sessionID) strata(high): reg efficiency HNL high highHNL if(bidders==5)
***Not signficant (p=0.815) two-sided for high cost, Signficant at 10% (p=0.095) low cost -- in TABLE 5


*1****************DURATION *************
*******************
******DURATION  REGRESSION, SEPARATE FOR High and Low cost 

*****DURATION HIGH COST
*Baseline regression in Table D.2
reg duration HNL bidders5 HNL5  if(high==1), cluster(sessionID)


***HYPOTHESIS DURATION (2-5 BIDDERS, HIGH COST): H5/D5 -H2/D2 >0, HIGH COST
bootstrap   DurationD2H2_high=(_b[HNL])  DurationD5H5_high=(_b[HNL]+_b[HNL5])   Duration_diff52_high=( (_b[_cons] +_b[HNL]+_b[HNL5]+_b[bidders5])/(_b[_cons] + _b[bidders5]) -   (_b[_cons] + _b[HNL] )/(_b[_cons]) ), reps(1000) seed(776)   cluster(sessionID) strata(bidders): reg duration HNL bidders5 HNL5  if(high==1)
***Highly significant (p=0.004), p=0.002 one-sided  -- IN TABLE 5

*****DURATION LOW COST
*Baseline regression in Table D.2
reg duration HNL bidders5 HNL5  if(high==0), cluster(sessionID)

***HYPOTHESIS DURATION (2-5 BIDDERS, LOW COST): H5/D5 -H2/D2 >0, LOW COST
bootstrap  DurationD2H2_low=(_b[HNL])  DurationD5H5_low=(_b[HNL]+_b[HNL5])    Duration_diff52_low=( (_b[_cons] +_b[HNL]+_b[HNL5]+_b[bidders5])/(_b[_cons] + _b[bidders5]) -   (_b[_cons] + _b[HNL] )/(_b[_cons]) ), reps(1000) seed(124)   cluster(sessionID) strata(bidders): reg duration HNL bidders5 HNL5  if(high==0)
***Highly significant (p=0.000)  -- IN TABLE 5


*2****************PRICE ********************************

*2*****PRICE  REGRESSIONs, SEPARATE FOR High and Low cost

*****PRICE HIGH COST --- Baseline regression in Table D.2
reg price HNL bidders5 HNL5  if(high==1), cluster(sessionID) 

***exact, based on Table 4 predicted values
***HYPOTHESIS PRICE (2-5 BIDDERS, HIGH COST): H2/D2=0.917, H5/D5 =0.988, HIGH COST
bootstrap   PriceD2H2_high=((_b[_cons] + _b[HNL] )/(_b[_cons]) -0.917)  PriceD5H5_high=( (_b[_cons] +_b[HNL]+_b[HNL5]+_b[bidders5])/(_b[_cons] + _b[bidders5])-0.988), reps(1000) seed(174)   cluster(sessionID) strata(bidders): reg price HNL bidders5 HNL5  if(high==1)
***Highly significant (p=0.000), p=0.000 two-sided  -- IN TABLE D.3

***general, based on Prediction 2
***HYPOTHESIS PRICE (2-5 BIDDERS, HIGH COST): H2/D2>0.9, H2/D2<1.1;  H5/D5 >0.9,  H5/D5<1.1, HIGH COST
bootstrap   PriceD2H2_high_left=((_b[_cons] + _b[HNL] )/(_b[_cons]) -0.9)  PriceD2H2_high_right=((_b[_cons] + _b[HNL] )/(_b[_cons]) -1.1)   PriceD5H5_high_left=( (_b[_cons] +_b[HNL]+_b[HNL5]+_b[bidders5])/(_b[_cons] + _b[bidders5])-0.9)  PriceD5H5_high_right=( (_b[_cons] +_b[HNL]+_b[HNL5]+_b[bidders5])/(_b[_cons] + _b[bidders5])-1.1), reps(1000) seed(471)   cluster(sessionID) strata(bidders): reg price HNL bidders5 HNL5  if(high==1)
***


*****PRICE LOW COST --- Baseline regression in Table D.2
reg price HNL bidders5 HNL5  if(high==0), cluster(sessionID) 

***exact, based on Table 4 predicted values
***HYPOTHESIS PRICE (2-5 BIDDERS, LOW COST): H5/D5=0.991, H2/D2=1.001, LOW COST
bootstrap  PriceD2H2_low=((_b[_cons] + _b[HNL] )/(_b[_cons]) -1.001)     PriceD5H5_low=( (_b[_cons] +_b[HNL]+_b[HNL5]+_b[bidders5])/(_b[_cons] + _b[bidders5]) -   0.991 ), reps(1000) seed(4391)   cluster(sessionID) strata(bidders): reg price HNL bidders5 HNL5  if(high==0)
***Highly significant 2 bidder: (p=0.000), 5 bidder: (p=0.003) -- IN TABLE D.3

***general, based on Prediction 2
***HYPOTHESIS PRICE (2-5 BIDDERS, LOW COST): H2/D2>0.9, H2/D2<1.1;  H5/D5 >0.9,  H5/D5<1.1, LOW COST
bootstrap   PriceD2H2_low_left=((_b[_cons] + _b[HNL] )/(_b[_cons]) -0.9)  PriceD2H2_low_right=((_b[_cons] + _b[HNL] )/(_b[_cons]) -1.1)   PriceD5H5_low_left=( (_b[_cons] +_b[HNL]+_b[HNL5]+_b[bidders5])/(_b[_cons] + _b[bidders5])-0.9)  PriceD5H5_low_right=( (_b[_cons] +_b[HNL]+_b[HNL5]+_b[bidders5])/(_b[_cons] + _b[bidders5])-1.1), reps(1000) seed(1934)   cluster(sessionID) strata(bidders): reg price HNL bidders5 HNL5  if(high==0)
***


*3****************AUCTIONEER UTILITY ********************************


*3**HYPOTHESIS ON Auctioneer Utility : H>D, 2 bidders, High and Low cost

*Baseline regression in Table D.1
reg Uauctioneer HNL high highHNL if(bidders==2), cluster(sessionID)

bootstrap   UauctioneerH2D2_high=(_b[HNL]+_b[highHNL])  UauctioneerH2D2_low=(_b[HNL]), reps(1000) seed(1878)   cluster(sessionID) strata(high): reg Uauctioneer HNL high highHNL if(bidders==2)
***Not significant one-sided (the opposite is supported)  -- IN TABLE 5


*3**HYPOTHESIS ON Auctioneer Utility : H>D, 5 bidders, High and Low cost
*Baseline regression in Table D.1
reg Uauctioneer HNL high highHNL if(bidders==5), cluster(sessionID)

bootstrap   UauctioneerH5D5_high=(_b[HNL]+_b[highHNL])  UauctioneerH5D5_low=(_b[HNL]), reps(1000) seed(8781)   cluster(sessionID) strata(high): reg Uauctioneer HNL high highHNL if(bidders==5)
***Not significant one-sided (the opposite is supported)-- in TABLE 5

********************



*4****************BUYER UTILITY ********************************


****BUYER PAYOFF , 2 BIDDERS 
*Baseline regression in Table D.1
reg winpayoff HNL high highHNL if(bidders==2), cluster(sessionID)

***HYPOTHESIS ON BUYER PAYOFF (High-Low cost): H>D low cost; H>D high cost;  Hh/Dh -Hl/Dl >0, 2 bidders
bootstrap Buyer_payH2D2_high=(_b[HNL]+_b[highHNL]) Buyer_payH2D2_low=(_b[HNL]) Buyer_pay_diffHL=( (_b[_cons] +_b[HNL]+_b[high]+_b[highHNL])/(_b[_cons] + _b[high]) - (_b[_cons] +_b[HNL])/(_b[_cons]) ), reps(1000) seed(68)   cluster(sessionID) strata(high): reg winpayoff HNL high highHNL if(bidders==2)
***The differences b/w H and D are highly significant (p=0.000)
*******One-sided test on the ratios is not significant,  p>0.1


****BUYER PAYOFF , 5 BIDDERS 
*Baseline regression in Table D.1
reg winpayoff HNL high highHNL if(bidders==5), cluster(sessionID)

***HYPOTHESIS ON BUYER PAYOFF (High-Low cost): H>D low cost; H>D high cost;  Hh/Dh -Hl/Dl >0, 5 bidders
bootstrap Buyer_payH5D5_high=(_b[HNL]+_b[highHNL]) Buyer_payH5D5_low=(_b[HNL]), reps(1000) seed(408)   cluster(sessionID) strata(high): reg winpayoff HNL high highHNL if(bidders==5)
***The differences b/w H and D are  significant for Low,  High cost are borderline 


*****BUYER PAYOFF, SEPARATE FOR High and Low cost 


*****BUYER PAYOFF HIGH COST
*Baseline regression in Table D.2
reg winpayoff HNL bidders5 HNL5  if(high==1), cluster(sessionID)


***HYPOTHESIS BUYER PAYOFF (2-5 BIDDERS, HIGH COST):  H2/D2 - H5/D5 >0, HIGH COST
bootstrap  Buyer_pay_diff25_high= ( (_b[_cons] + _b[HNL] )/(_b[_cons]) - (_b[_cons] +_b[HNL]+_b[HNL5]+_b[bidders5])/(_b[_cons] + _b[bidders5])  ), reps(1000) seed(255)   cluster(sessionID) strata(bidders): reg winpayoff HNL bidders5 HNL5  if(high==1)
***Significant  p= 0.049, (p=0.0245 one-sided)


*****BUYER PAYOFF LOW COST
*Baseline regression in Table D.2
reg winpayoff HNL bidders5 HNL5  if(high==0), cluster(sessionID)


***HYPOTHESIS BUYER PAYOFF (2-5 BIDDERS, LOW COST): H2/D2 - H5/D5 >0, LOW COST
bootstrap   Buyer_pay_diff25_low= ( (_b[_cons] + _b[HNL] )/(_b[_cons]) - (_b[_cons] +_b[HNL]+_b[HNL5]+_b[bidders5])/(_b[_cons] + _b[bidders5])  ), reps(1000) seed(855)   cluster(sessionID) strata(bidders): reg winpayoff HNL bidders5 HNL5  if(high==0)
***Not significant  p= 0.859, (two-sided), p=0.429 one-sided


**************************************************
***Social Welfare -- For Section C.6 in Online Appendix ********************************

gen welfare= Uauctioneer + winpayoff
replace welfare=0 if welfare==.

gen welfare_predict= Uauctioneer_predict + winpayoff_predict

sort bidders high HNL
by bidders high HNL: sum welfare welfare_predict
***The above should match Table C.2 in the Online Appendix C.6

*****WELFARE HIGH COST
*Baseline regression 
reg welfare HNL bidders5 HNL5  if(high==1), cluster(sessionID)


***HYPOTHESIS ON WELFARE HIGH COST (2-5 bidders): H>D 2 bidders high  cost; H>D 5 bidders high cost
bootstrap Welfare2HD_high=(_b[HNL]) Welfare5HD_high=(_b[HNL]+_b[HNL5]), reps(1000) seed(6998)   cluster(sessionID) strata(bidders): reg welfare HNL bidders5 HNL5  if(high==1)
***The differences b/w H and D are highly significant for 2 bidders (p=0.000)
***The differences b/w H and D are marginally significant for 5 bidders (p=0.081, two-sided)
***p-values are reported in FIgure C.7 

*****WELFARE LOW COST
*Baseline regression 
reg welfare HNL bidders5 HNL5  if(high==0), cluster(sessionID)


***HYPOTHESIS ON WELFARE  LOW COST (2-5 bidders): H>D 2 bidders low cost; H>D 5 bidders low cost
bootstrap Welfare2HD_low=(_b[HNL]) Welfare5HD_low=(_b[HNL]+_b[HNL5]), reps(1000) seed(8996)   cluster(sessionID) strata(bidders): reg welfare HNL bidders5 HNL5  if(high==0)
***The differences b/w H and D are  are highly significant for 2 bidders (p=0.000), H>D
***The differences b/w H and D are  are highly significant for 5 bidders (p=0.000), H<D (the opposite to predicted)
***p-values are reported in Figure C.7 


*********END BOOTSTRAP HYPOTHESES TESTS ***************
**********************************************************

log close
