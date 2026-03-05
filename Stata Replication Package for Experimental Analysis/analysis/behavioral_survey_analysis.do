clear
***********ANALYSIS OF SURVEY RESPONSES *****************
log using "survey-responses.log", replace


 *********GO TO LINE 95 FOR ANALYSIS FOR Table J.1 in Online Appendix J

**********DATA PREP **********************
****post from csv file "Feedback_Honolulu_new_all_session.csv"
*gen HNL=1
*save "feedback_Honolulu_all_sessions.dta"
*, replace


***post from csv file  "Feedback_Dutch_new_all_session.csv"
*gen HNL=0
*save "feedback_Dutch_all_sessions.dta"
*, replace

*********MERGE HNL and DUTCH FEEDBACK **********

use "feedback_Dutch_all_sessions.dta", clear
append using "feedback_Honolulu_all_sessions.dta"


sum HNL
sort HNL
by HNL: sum auc0 auc1 auc2 auc3 auc4 auc5 auc6

tab sessioncode

*session.cod |
*          e |      Freq.     Percent        Cum.
*------------+-----------------------------------
*   15t0rnnr |         20        6.33        6.33
*   5m969a1u |         16        5.06       11.39
*   785y9gdo |         24        7.59       18.99
*   7xbozwc7 |         20        6.33       25.32
*   a2ehf0h4 |         20        6.33       31.65
*   btnhfeao |         20        6.33       37.97
*   c9oliyzc |         16        5.06       43.04
*   cbdt6t3s |         20        6.33       49.37
*   hie4719f |         20        6.33       55.70
*   nli0vb0t |         20        6.33       62.03
*   ogo32l47 |         30        9.49       71.52
*   p66lw61j |         20        6.33       77.85
*   r6ovli5x |         30        9.49       87.34
*   w4lqxa01 |         20        6.33       93.67
*   yq06059v |         20        6.33      100.00
*------------+-----------------------------------
*      Total |        316      100.00


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

 ren  participantlabel_num subjectID
tab subjectID
 
***Participant ID's
 gen uniqueID=sessionID*100+subjectID
 
 sum subjectID uniqueID
******************************** 
save "feedback_Dutch_and_HNL_all.dta", replace 
***********THE ABOVE FILE IS FOR ANALYSIS OF SURVEY RESPONSES *****************


****************************************************************
*******ANALYSIS FOR TABLE J.1  HERE ************************* 

use "feedback_Dutch_and_HNL_all.dta", clear

reshape wide auc0 auc1 auc2 auc3 auc4 auc5 auc6,  i(uniqueID) j(HNL)
 
 
 foreach num of numlist 0 1 2 3 4 5 6 {
	
display "*****************************************************"
	display "***********  Post-auction Question `num': Response means  *****************"
display "*****************************************************"

	gen auc`num'diffHD=auc`num'1 - auc`num'0
	sum auc`num'1 auc`num'0 auc`num'diffHD  
			
}				
			
		
 foreach num of numlist 0 1 2 3 4 5 6 {
	
display "*****************************************************"
	display "***********  Post-auction Question `num': Test for differences in responses  *****************"
display "*****************************************************"

			reg auc`num'diffHD, cluster(sessionID) vce(bootstrap)		
}	
***The above are consistent with p-values reported in Table J.1 in Online Appendix J

***********END HERE ***************


******************************
*Post-auction questionnaire is:

*Please provide the feedback on the auction that you just participated in:

*Rate how much you agree with the following  statements on a scale of 1 - 7 
*1 - Completely Disagree and 7 - Completely agree 

*1. When I bid, I all I cared about was buying as fast as possible 
*1  2  3  4  5  6  7

*2. When I bid, all I cared about was paying the lowest price possible
*1  2  3  4  5  6  7

*3. When I bought the object, I often thought that I could have bought it at a lower price if I bid differently
 *1  2  3  4  5  6  7

*4. When I did not buy the object, I often thought that I could have bought it and made a profit if I bid differently 
* 1  2  3  4  5  6  7

*5. On the scale from 1 (extremely sad) to 7 (extremely happy), indicate how you felt when you bought an object in the auction: 
*1  2  3  4  5  6  7 

*6. On the scale from 1 (extremely sad) to 7 (extremely happy), indicate how you felt when you did not buy an object in the auction: 
*1  2  3  4  5  6  7
*END Post-auction questionnaire 
******************************
log close

