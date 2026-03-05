*! master_data_preparation_file.do
* This master do-file runs all data preparation do-files in order.

* Set working directory (optional, adjust path as needed)
*cd "...."

* Set more off to prevent output from pausing
set more off 

* Run the main data preparation file for HNL auctions
display "Running `data_prep_main_hnl.do'..."
do data_prep_main_hnl.do

* Run the main data preparation file for zero-cost predictions in HNL auctions  
display "Running `data_prep_hnl_zero_cost.do'..."
do data_prep_hnl_zero_cost.do

* Run the main data preparation file for Dutch auctions
display "Running `data_prep_main_Dutch.do'..."
do data_prep_main_Dutch.do

* Run the file to merge data for Dutch and HNL auctions
display "Running `data_prep_group_HNL_and_Dutch.do'..."
do data_prep_group_HNL_and_Dutch.do

* Run the data preparation file for bidder behavior analysis
display "Running `participant_payoffs_prep_file.do'..."
do participant_payoffs_prep_file.do


* Turn set more back on
*set more on

display "Master data preparation file 'master_data_preparation_file.do' finished."
