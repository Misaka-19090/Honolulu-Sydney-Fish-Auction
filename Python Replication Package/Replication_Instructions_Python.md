---
  output: 
    pdf_document:
      toc: true
      number_sections: true
  geometry: margin=1in
  title: "Documentation For Python Replication Packages"
---

<style type="text/css">
    h1 { counter-reset: h2counter; }
    h2 { counter-reset: h3counter; }
    h3 { counter-reset: h4counter; }
    h4 { counter-reset: h5counter; }
    h5 { }
    h2:before {
      counter-increment: h2counter;
      content: counter(h2counter) "\0000a0\0000a0";
    }
    h3:before {
      counter-increment: h3counter;
      content: counter(h2counter) "."
                counter(h3counter) "\0000a0\0000a0";
    }
    h4:before {
      counter-increment: h4counter;
      content: counter(h2counter) "."
                counter(h3counter) "."
                counter(h4counter) "\0000a0\0000a0";
    }
    h5:before {
      counter-increment: h5counter;
      content: counter(h2counter) "."
                counter(h3counter) "."
                counter(h4counter) "."
                counter(h5counter) "\0000a0\0000a0";
    }
</style>

# Prerequisites

1. You should have the following sofewares properly installed on your device:
  - `Python`
  - `Jupyter Notebook`

2. You should also have the following Python packages installed:
  - `matplotlib`
  - `numpy`
  - `pandas`
  - `scipy`
  - `scikit-learn`
  - `seaborn`
  - `statsmodels`

# Numerical Results

## Figure 1-2, Figure C.1-C.6

1. Open `Utility Difference.ipynb`.
2. Import packages and run section *Main Program*.
3. Run section *Computation* to generate numerical prediction data files (can take hours) `[n]_[aa]_[xxx].csv` where
  - `n` is the number of bidders
  - `aa` is the auction format where the Dutch auction is denoted by `da` and the Honolulu auction is denoted by `ha`
  - `xxx` is the predicted auction characteristic where `ED, ER, EUa, EUb` stands for the expected duration, selling price, utility for bidders, utility for the auctioneer respectively.
4. Run section *Relative difference* and adjust functional arguments to get
  - Figure 1
    - `graphPctHeatmap(eval_n=50, eval_interval=0.02, type="ED")`
    - `graphPctHeatmap(eval_n=50, eval_interval=0.02, type="ER")`
  - Figure 2
    - `graphPctHeatmap(eval_n=50, eval_interval=0.02, type="EUa")`
    - `graphPctHeatmap(eval_n=50, eval_interval=0.02, type="EUb")`
  - Figure C.2
    - `graphPctHeatmap2(eval_n=50, eval_interval=0.02, type="ED")`
  - Figure C.3
    - `graphPctHeatmap2(eval_n=50, eval_interval=0.02, type="ER")`
  - Figure C.4
    - `graphPctHeatmap2(eval_n=50, eval_interval=0.02, type="EUa")`
  - Figure C.5
    - `graphPctHeatmap2(eval_n=50, eval_interval=0.02, type="EUb")`
  - Figure C.6
    - `graphPctHeatmap2(eval_n=50, eval_interval=0.02, type="EUab")`
5. Run section *Jumps in the optimal starting price $s$* to get
  - Figure C.1

## Table C.1

1. Open `Fish_Auction.ipynb`.
2. Run section *Main program*.
3. Run section *Outputs for research use -> Table of concerned variables for parameters used in the experiment* to get
  - Table C.1
    - `table(a=1, b=0.45, c=0.95, list_n=[2, 5])` for columns 2L and 5L
    - `table(a=1, b=0.95, c=0.95, list_n=[2, 5])` for columns 2H and 5H


# Experimental Results

## Have all data files ready

### Raw data 

The raw data of each experimental session is stored in `all_apps_wide_[yyyy-mm-dd-nn].csv`, where `yyyy-mm-dd` is the date of the session, `nn` is the session ID assigned by the experimenter. This all-in-one date file can be separated by app. Both formats of raw data are provided. 

- List of separated files:
  - `Dutch2_[yyyy-mm-dd-nn].csv`
  - `Honolulu2_[yyyy-mm-dd-nn].csv`
  - `Dutch5_[yyyy-mm-dd-nn].csv`
  - `Honolulu5_[yyyy-mm-dd-nn].csv`
  - `Feedback_Dutch_[yyyy-mm-dd-nn].csv`
  - `Feedback_Honolulu_[yyyy-mm-dd-nn].csv`

### Process raw data

1. The following files should be put in the same folder:
  - `all_apps_wide_[yyyy-mm-dd-nn].csv`
  - `Data Reformat.ipynb`
2. Run `Data Reformat.ipynb` from the beginning to the second last section, change `str_date` accordingly for each session. You should get the following processed data files:
  - `all_apps_wide_[yyyy-mm-dd-nn].csv`
    - `Dutch_new_[yyyy-mm-dd-nn].csv`
    - `Honolulu_new_[yyyy-mm-dd-nn].csv`
      - `Honolulu_rounded_and_accurate_[yyyy-mm-dd-nn].csv`
    - `Feedback_Dutch_new_[yyyy-mm-dd-nn].csv`
    - `Feedback_Honolulu_new_[yyyy-mm-dd-nn].csv`
3. Merge these session-wide files manually to get the following all-session processed data files:
  - `Dutch_new_all_session.csv`
  - `Honolulu_new_all_session.csv`
    - `Honolulu_rounded_and_accurate_all_session.csv`
  - `Feedback_Dutch_new_all_session.csv`
  - `Feedback_Honolulu_new_all_session.csv`
4. Run the last section of `Data Reformat.ipynb` to get the final version of processed data files:
  - `Dutch_new_all_session.csv`
    - `Dutch_paydiff_norm.csv`
  - `Honolulu_new_all_session.csv`
    - `Honolulu_rounded_and_accurate_all_session.csv`
      - `Honolulu_paydiff_norm.csv`
  - `Feedback_Dutch_new_all_session.csv`
  - `Feedback_Honolulu_new_all_session.csv`

## Table 2

Basic experimental design and session information. No code for this.

## Table 3, Table E.1, Table G.1-G.2

1. Put the following files in the same folder:
  - `Dutch_paydiff_norm.csv`
  - `Honolulu_paydiff_norm.csv`
  - `Dominated behaviour.ipynb`
2. Open `Dominated behaviour.ipynb`.
3. Import packages and data files, then run section *Three price dynamics in Honolulu* to get
  - Table 3
    - "Actual" columns
      - `priceDynamics(rmin=3, rmax=30, tol=2, is_actual=True)`
    - "Predicted" columns
      - `priceDynamics(rmin=3, rmax=30, tol=2, is_actual=False)`
  - Table E.1
    - All treatments
      - `signedRankTest(rmin=3, rmax=30, tol=2, altH="greater", altD="less", altE="less")`
      - `signedRankTest(rmin=3, rmax=30, tol=2, altH="two-sided", altD="two-sided", altE="two-sided")`
    - 2-bidder
      - `signedRankTestByNumber(rmin=3, rmax=30, tol=2, n=2, altH="greater", altD="less", altE="less")`
      - `signedRankTestByNumber(rmin=3, rmax=30, tol=2, n=2, altH="two-sided", altD="two-sided", altE="two-sided")`
    - 5-bidder
      - `signedRankTestByNumber(rmin=3, rmax=30, tol=2, n=5, altH="greater", altD="less", altE="less")`
      - `signedRankTestByNumber(rmin=3, rmax=30, tol=2, n=5, altH="two-sided", altD="two-sided", altE="two-sided")`
    - 2H
      - `signedRankTestByTreatment(rmin=3, rmax=30, tol=2, n=2, b=0.019, altH="greater", altD="less", altE="less")`
      - `signedRankTestByTreatment(rmin=3, rmax=30, tol=2, n=2, b=0.019, altH="two-sided", altD="two-sided", altE="two-sided")` 
    - 2L
      - `signedRankTestByTreatment(rmin=3, rmax=30, tol=2, n=2, b=0.009, altH="greater", altD="greater", altE="less")`
      - `signedRankTestByTreatment(rmin=3, rmax=30, tol=2, n=2, b=0.009, altH="two-sided", altD="two-sided", altE="two-sided")`
    - 5H
      - `signedRankTestByTreatment(rmin=3, rmax=30, tol=2, n=5, b=0.019, altH="greater", altD="less", altE="less")`
      - `signedRankTestByTreatment(rmin=3, rmax=30, tol=2, n=5, b=0.019, altH="two-sided", altD="two-sided", altE="two-sided")` 
    - 5L
      - `signedRankTestByTreatment(rmin=3, rmax=30, tol=2, n=5, b=0.009, altH="greater", altD="less", altE="less")`
      - `signedRankTestByTreatment(rmin=3, rmax=30, tol=2, n=5, b=0.009, altH="two-sided", altD="two-sided", altE="two-sided")` 
4. Run section *SD & WD decisions* to get
  - Table G.1
    - Dutch auction "Top" columns
      - `tableSD(n=2, b=0.019, rmin=3, rmax=30, qmin=0.501, qmax=1, tol=2)`
      - `tableSD(n=2, b=0.009, rmin=3, rmax=30, qmin=0.501, qmax=1, tol=2)`
      - `tableSD(n=5, b=0.019, rmin=3, rmax=30, qmin=0.501, qmax=1, tol=2)`
      - `tableSD(n=5, b=0.009, rmin=3, rmax=30, qmin=0.501, qmax=1, tol=2)`
    - Dutch auction "Bottom" columns
      - `tableSD(n=2, b=0.019, rmin=3, rmax=30, qmin=0, qmax=0.5, tol=2)`
      - `tableSD(n=2, b=0.009, rmin=3, rmax=30, qmin=0, qmax=0.5, tol=2)`
      - `tableSD(n=5, b=0.019, rmin=3, rmax=30, qmin=0, qmax=0.5, tol=2)`
      - `tableSD(n=5, b=0.009, rmin=3, rmax=30, qmin=0, qmax=0.5, tol=2)`
    - Dutch auction "All" column
      - `tableSDAll(2, rmin=3, rmax=30, tol=2)`
      - `tableSDAll(5, rmin=3, rmax=30, tol=2)`
    - Honolulu auction "Top" columns
      - `tableWD(n=2, b=0.019, rmin=3, rmax=30, qmin=0.501, qmax=1, tol=2)`
      - `tableWD(n=2, b=0.009, rmin=3, rmax=30, qmin=0.501, qmax=1, tol=2)`
      - `tableWD(n=5, b=0.019, rmin=3, rmax=30, qmin=0.501, qmax=1, tol=2)`
      - `tableWD(n=5, b=0.009, rmin=3, rmax=30, qmin=0.501, qmax=1, tol=2)`
    - Honolulu auction "Bottom" columns
      - `tableWD(n=2, b=0.019, rmin=3, rmax=30, qmin=0, qmax=0.5, tol=2)`
      - `tableWD(n=2, b=0.009, rmin=3, rmax=30, qmin=0, qmax=0.5, tol=2)`
      - `tableWD(n=5, b=0.019, rmin=3, rmax=30, qmin=0, qmax=0.5, tol=2)`
      - `tableWD(n=5, b=0.009, rmin=3, rmax=30, qmin=0, qmax=0.5, tol=2)`
    - Honolulu auction "All" column
      - `tableWDAll(2, rmin=3, rmax=30, tol=2)`
      - `tableWDAll(5, rmin=3, rmax=30, tol=2)`
  - Table G.2
    - All treatments
      - `signedRankUndominatedDutch(rmax=30, tol=2, alt="greater")`
      - `signedRankUndominatedHonolulu(rmax=30, tol=2, altDB="greater", altCL="greater", altCB="greater", altEL="greater", altDrop="greater")`
    - 2-bidder
      - `signedRankUndominatedDutchByNumber(n=2, rmin=3, rmax=30, tol=2, alt="greater")`
      - `signedRankUndominatedHonoluluByNumber(n=2, rmin=3, rmax=30, tol=2, altDB="greater", altCL="greater", altCB="greater", altEL="greater", altDrop="greater")`
    - 5-bidder
      - `signedRankUndominatedDutchByNumber(n=5, rmin=3, rmax=30, tol=2, alt="greater")`
      - `signedRankUndominatedHonoluluByNumber(n=5, rmin=3, rmax=30, tol=2, altDB="greater", altCL="greater", altCB="greater", altEL="greater", altDrop="greater")`
    - 2H
      - `signedRankUndominatedDutchByTreatment(n=2, b=0.019, rmin=3, rmax=30, tol=2, alt="greater")`
      - `signedRankUndominatedHonoluluByTreatment(n=2, b=0.019, rmin=3, rmax=30, tol=2, altDB="greater", altCL="greater", altCB="greater", altEL="greater", altDrop="greater")`
    - 2L
      - `signedRankUndominatedDutchByTreatment(n=2, b=0.009, rmin=3, rmax=30, tol=2, alt="greater")`
      - `signedRankUndominatedHonoluluByTreatment(n=2, b=0.009, rmin=3, rmax=30, tol=2, altDB="greater", altCL="greater", altCB="greater", altEL="greater", altDrop="greater")`
    - 5H
      - `signedRankUndominatedDutchByTreatment(n=5, b=0.019, rmin=3, rmax=30, tol=2, alt="greater")`
      - `signedRankUndominatedHonoluluByTreatment(n=5, b=0.019, rmin=3, rmax=30, tol=2, altDB="greater", altCL="greater", altCB="greater", altEL="greater", altDrop="greater")`
    - 5L
      - `signedRankUndominatedDutchByTreatment(n=5, b=0.009, rmin=3, rmax=30, tol=2, alt="greater")`
      - `signedRankUndominatedHonoluluByTreatment(n=5, b=0.009, rmin=3, rmax=30, tol=2, altDB="greater", altCL="greater", altCB="greater", altEL="greater", altDrop="greater")`

## Table 4, Table C.2, Figure 3-4, Figure 5, Figure 6-7, Figure 8, Figure C.7, Figure F.1

1. Put the following files in the same folder:
  - `Dutch_paydiff_norm.csv`
  - `Honolulu_paydiff_norm.csv`
  - `Zero-cost prediction.ipynb`
  - `Summary statistics.ipynb`
2. Open `Zero-cost prediction.ipynb` and run from the beginning to the end to generate two new data files in the same folder:
  - `Dutch_paydiff_norm_zerocost.csv`
  - `Honolulu_paydiff_norm_zerocost.csv`
3. Open `Summary statistics.ipynb`.
4. Import packages and data files, then run section *Auction characteristics* to get
  - Figure 3
    - Subsection *Efficiency*
  - Figure 4(a), 
    - Subsection *Duration*
  - Figure F.1
    - Subsection *Duration zero cost*
  - Figure 4(b)
    - Subsection *Revenue*
  - Figure 4\(c)
    - Subsection *Bidder utility*
  - Figure 4(d)
    - Subsection *Auctioneer utility*
  - Table 4
    - Data acquired from Figure 3-4
  - Figure C.7
    - Subsection *Social welfare*
  - Table C.2
    - Data acquired from Figure C.7
5. Run subsection *Bid deviation -> Top and bottom earners* to get
  - Figure 8
    - Left panel
      - `plotDbid()`
    - Right panel
      - `plotDstage()`
6. Run subsection *Bid distribution -> Top and bottom earners* to get
  - Figure 5
    - `plotDutchDist()`
  - Figure 6
    - "Dutch stage" panel
      - `plotDstageDist(2)`
    - "Contest stage" panel (additional, no longer displayed in the main text)
      - `plotCstageDist(2)`
    - "English stage" panel
      - `plotEstageDist(2)`
  - Figure 7
    - "Dutch stage" panel
      - `plotDstageDist(5)`
    - "Contest stage" panel (additional, no longer displayed in the main text)
      - `plotCstageDist(5)`
    - "English stage" panel
      - `plotEstageDist(5)`

## Table 5, Table D.1-D.3

1. Put the following files in the same folder:
  - `Dutch_paydiff_norm.csv`
  - `Honolulu_paydiff_norm.csv`
  - `Bootstrap estimation_auction characteristics.ipynb`
2. Open `Bootstrap estimation_auction characteristics.ipynb`.
3. Import packages and data files, then run section *Functions* for preparation.
4. Run section *Baseline Regression and Prediction* to get
  - Table D.1
    - "Auctioneer payoff" columns
      - Subsection *Auctioneer utility -> reg cost, 2 bidders*
      - Subsection *Auctioneer utility -> reg cost, 5 bidders*
    - "Buyer payoff" columns
      - Subsection *Bidder utility -> reg cost, 2 bidders*
      - Subsection *Bidder utility -> reg cost, 5 bidders*
    - "Efficiency" columns
      - Subsection *Efficiency -> reg cost, 2 bidders*
      - Subsection *Efficiency -> reg cost, 5 bidders*
      - Subsection *Efficiency -> pooled*
  - Table D.2
    - "Buyer payoff" columns
      - Subsection *Bidder utility -> reg bidders, high cost*
      - Subsection *Bidder utility -> reg bidders, low cost* 
    - "Auction duration" columns
      - Subsection *Auction duration -> reg bidders, high cost*
      - Subsection *Auction duration -> reg bidders, low cost* 
    - "Selling price" columns
      - Subsection *Selling price -> reg bidders, high cost*
      - Subsection *Selling price -> reg bidders, low cost* 
5. Run section *Blocked Bootstrap* to get  
  - Table 5 (only serve as double check on Stata results, bootstrap p-values may be different because of different random seeds)
    - "Efficiency" rows
      - Subsection *Efficiency pooled -> H = D*
      - Subsection *Efficiency -> H = D (high cost) for 2 bidders, H = D (low cost) for 2 bidders*
      - Subsection *Efficiency -> H = D (high cost) for 5 bidders, H = D (low cost) for 5 bidders*
    - "Duration" rows
      - Subsection *Auction duration-> D > H (2 bidders) for high cost, D > H (5 bidders) for high cost*
      - Subsection *Auction duration-> D > H (2 bidders) for low cost, D > H (5 bidders) for low cost*
      - Subsection *Auction duration-> H/D (5 bidders) > H/D (2 bidders) for high cost*
      - Subsection *Auction duration-> H/D (5 bidders) > H/D (2 bidders) for low cost*
    - "Selling price" rows
      - Subsection *Selling price -> H/D (5 bidders) = 0.9 for high cost, H/D (2 bidders) = 0.9 for high cost*
      - Subsection *Selling price -> H/D (5 bidders) = 0.9 for low cost, H/D (2 bidders) = 0.9 for low cost*
    - "Auctioneer utility" rows
      - Subsection *Auctioneer utility -> H > D (2 bidders) for high cost, H > D (5 bidders) for high cost*
      - Subsection *Auctioneer utility -> H > D (2 bidders) for low cost, H > D (5 bidders) for low cost*
    - "Buyer utility" rows
      - Subsection *Bidder utility -> H > D (2 bidders) for high cost, H > D (5 bidders) for high cost*
      - Subsection *Bidder utility -> H > D (2 bidders) for low cost, H > D (5 bidders) for low cost*
      - Subsection *Bidder utility -> H/D (high cost) > H/D (low cost) for 2 bidders*
      - Subsection *Bidder utility -> H/D (5 bidders) < H/D (2 bidders) for high cost*
      - Subsection *Bidder utility -> H/D (5 bidders) < H/D (2 bidders) for low cost (mean and variance are not consistent)*
  - Table D.3
    - This table is acquired by modifying the "Selling price" hypotheses in the previous Table 5. This can be done by adjusting the `bootstrapT()` function.

## Figure 8 p-values

1. Put the following files in the same folder:
  - `Dutch_paydiff_norm.csv`
  - `Honolulu_paydiff_norm.csv`
  - `Bootstrap estimation_individual behaviour.ipynb`
2. Open `Bootstrap estimation_individual behaviour.ipynb`.
3. Import packages.
4. Run section *Top-bottom Data* to get
  - Figure 8 p-values
    - Left panel
      - Subsection *Dutch auction bids*
    - Right panel
      - Subsection *Dutch stage bids*

## Figure 9-10

1. Put the following files in the same folder:
  - `Feedback_Dutch_new_all_session.csv.csv`
  - `Feedback_Honolulu_new_all_session.csv.csv`
  - `Feedback plots.ipynb`
2. Open `Feedback plots.ipynb` and run from the beginning to the end to get
  - Figure 9
    - Section *Winner regret*
  - Figure 10
    - Section *Loser regret*

## Figure G.1, Figure H.1

1. Put the following files in the same folder:
  - `Dutch_paydiff_norm.csv`
  - `Honolulu_paydiff_norm.csv`
  - `Payoff distribution and clustering.ipynb`
2. Open `Payoff distribution and clustering.ipynb`.
3. Import packages and data files, then run section *Clustering Based On Similarity* to get
  - Figure H.1
    - Subsection *K-means*
      - `plotCluster(2, 0.019, 3)`
      - `plotCluster(2, 0.009, 3)`
      - `plotCluster(5, 0.019, 3)`
      - `plotCluster(5, 0.009, 4)`
  - Figure G.1
    - Subsection *Percentage paydiff distribution*

## Table G.3, Table G.4, Table G.6, Table I.1 p-values
1. Put the following files in the same folder:
  - `Dutch_paydiff_norm.csv`
  - `Honolulu_paydiff_norm.csv`
  - `Carryover tests.ipynb`
2. Open `Carryover tests.ipynb`.
3. Import packages and data files.
4. Run section *bid and price deviation regression* to get
  - Table G.3
    - 2-bidder Bottom column
      - `regDBid(df_d, is_5_bidder=0, is_top=0).fit(use_t=True).summary()`
    - 2-bidder Top column
      - `regDBid(df_d, is_5_bidder=0, is_top=1).fit(use_t=True).summary()`
    - 5-bidder Bottom column
      - `regDBid(df_d, is_5_bidder=1, is_top=0).fit(use_t=True).summary()`
    - 5-bidder Top column
      - `regDBid(df_d, is_5_bidder=1, is_top=1).fit(use_t=True).summary()`
  - Table G.4
    - 2L Actual column
      - `regDstageBid(df_h, is_5_bidder=0, is_high_cost=0).fit(use_t=True).summary()`
    - 2H Actual column
      - `regDstageBid(df_h, is_5_bidder=0, is_high_cost=1).fit(use_t=True).summary()`
    - 5L Actual column
      - `regDstageBid(df_h, is_5_bidder=1, is_high_cost=0).fit(use_t=True).summary()`
    - 5H Actual column
      - `regDstageBid(df_h, is_5_bidder=1, is_high_cost=1).fit(use_t=True).summary()`
  - Table G.6
    - 2-bidder All column
      - `regEstageDrop(df_h, is_5_bidder=0, is_top=0, is_pooled_topbot=1).fit(use_t=True).summary()`
    - 2-bidder Bottom column
      - `regEstageDrop(df_h, is_5_bidder=0, is_top=0, is_pooled_topbot=0).fit(use_t=True).summary()`
    - 2-bidder Top column
      - `regEstageDrop(df_h, is_5_bidder=0, is_top=1, is_pooled_topbot=0).fit(use_t=True).summary()`
    - 5-bidder All column
      - `regEstageDrop(df_h, is_5_bidder=1, is_top=0, is_pooled_topbot=1).fit(use_t=True).summary()`
    - 5-bidder Bottom column
      - `regEstageDrop(df_h, is_5_bidder=1, is_top=0, is_pooled_topbot=0).fit(use_t=True).summary()`
    - 5-bidder Top column
      - `regEstageDrop(df_h, is_5_bidder=1, is_top=1, is_pooled_topbot=0).fit(use_t=True).summary()`
4. Run section *bid and price deviation bootstrap* to get
  - Table I.1 p-values
    - Dutch auction panel Dutch bids
      - Subsection *D bids, 2-bidder*
      - Subsection *D bids, 5-bidder*
    - Dutch auction panel Final prices
      - Subsection *D price, 2-bidder*
      - Subsection *D price, 5-bidder*
    - Honolulu auction panel Dutch Stage bids
      - Subsection *H bids, 2-bidder*
      - Subsection *H bids, 5-bidder*
    - Honolulu auction panel Final prices
      - Subsection *H price, 2-bidder*
      - Subsection *H price, 5-bidder*
    

## Figure I.1-I.4, Table I.1
1. Put the following files in the same folder:
  - `Dutch_paydiff_norm.csv`
  - `Honolulu_paydiff_norm.csv`
  - `Summary statistics_carryover tests.ipynb`
2. Open `Summary statistics_carryover tests.ipynb`.
3. Import packages and data files.
4. Run section *carryover effects by treatment* to get
  - Table I.1
    - Dutch auction panel
      - Dutch bids (except p-values)
        - `carryoverDutchDeviation(2, "D1")`
        - `carryoverDutchDeviation(2, "D2")`
        - `carryoverDutchDeviation(5, "D1")`
        - `carryoverDutchDeviation(5, "D2")`
      - Final prices (except p-values)
        - `carryoverDutchFinalPriceDeviation(2, "D1")`
        - `carryoverDutchFinalPriceDeviation(2, "D2")`
        - `carryoverDutchFinalPriceDeviation(5, "D1")`
        - `carryoverDutchFinalPriceDeviation(5, "D2")`
    - Honolulu auction panel
      - Dutch Stage bids (except p-values)
        - `carryoverDutchStageDeviation(2, "D1")`
        - `carryoverDutchStageDeviation(2, "D2")`
        - `carryoverDutchStageDeviation(5, "D1")`
        - `carryoverDutchStageDeviation(5, "D2")`
      - Final prices (except p-values)
        - `carryoverHonoluluFinalPriceDeviation(2, "D1")`
        - `carryoverHonoluluFinalPriceDeviation(2, "D2")`
        - `carryoverHonoluluFinalPriceDeviation(5, "D1")`
        - `carryoverHonoluluFinalPriceDeviation(5, "D2")`
5. Run section *carryover effects for top and bottom earners* to get
  - Figure I.1
    - Left panel
      - `plotDbid(2)`
    - Right panel
      - `plotDbid(5)`
  - Figure I.2
    - Left panel
      - `plotDstage(2)`
    - Right panel
      - `plotDstage(5)`
  - Figure I.3
    - Left panel
      - `plotDFinal(2)`
    - Right panel
      - `plotDFinal(5)`
  - Figure I.4
    - Left panel
      - `plotHFinal(2)`
    - Right panel
      - `plotHFinal(5)`