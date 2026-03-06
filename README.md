# PLEASE READ ME FIRST

## About Replication Packages

You can refer to `helpme_source_files_for_Figures_and_Tables_Feb_2026.docx` to quickly locate source files for tables and figures.

### Python Replication Package

Please follow the instruction in `Replication_Instructions_Python.pdf` step by step. You may jump to subsections for specific tables or figures, but please ensure you have the program prerequisites and all data files ready.

### Stata Replication Package

Please follow the instruction in `Stata files flow chart for replication_2026.xlsx` step by step.

## About Data Dictionary

Please refer to `Experimental Data -> Data organisation.pdf` for a complete dictionary which explains all variables that appear in any kind of data files (raw, reformatted, behavioural).

## About Experimental Program

You need to have the Python package `oTree` installed in your device to demo the experimenal program.

---

## DATA ANALYSIS FILES FOR TABLES AND FIGURES

### Main Text -- Figures

- **Figure 1-2**: Predicted auction characteristics
  - **Python**: `Utility Difference.ipynb` → `Relative difference`
- **Figure 3-4** Actual auction characteristics
  - **Python**: `Summary statistics.ipynb` → `Auction characteristics`
  - **Stata**: `group_analysis_main.do`
- **Figure 5** Bids in Dutch auctions and regressions for it
  - **Python**: `Summary statistics.ipynb` → `Bid distribution` → `Top and bottom earners`
  - **Stata**: `strategies_dutch-auctions.do`
- **Figure 6-7** Honolulu bids and corresponding regressions
  - **Python**: `Summary statistics.ipynb` → `Bid distribution` → `Top and bottom earners`
  - **Stata**: `strategies_hnl-auctions.do`
- **Figure 8** – Dutch and Dutch‑Stage bid deviations from theory
  - Basic calculation and plotting
    - **Python**: `Summary statistics.ipynb` → `Bid deviation` → `Top and bottom earners`
  - p‑values for the figure:
    - **Python**: `Bootstrap estimation_individual behaviour.ipynb` → `Top‑bottom Data`
    - **Stata**: `strategies_dutch-auctions.do`, `strategies_hnl-auctions.do`
- **Figure 9-10** – Winner and loser regret
  - **Python**: `Feedback plots.ipynb`

### Main Text -- Tables

- **Table 2**: Experiment summary
- **Table 3**: Price dynamics
  - **Python**: `Dominated behaviour.ipynb` → `Three price dynamics in Honolulu`
  - **Stata**: `group_analysis_main.do`
- **Table 4**: Predicted and actual auction characteristics by treatment
  - **Python**: `Summary statistics.ipynb` → `Auction characteristics`
  - **Stata**: `group_analysis_main.do`
- **Table 5** – Hypotheses testing by treatment, and **Tables D.1 - D.3** in Appendix D
  - **Python**: `Bootstrap estimation_auction characteristics.ipynb` → `Blocked Bootstrap`
  - **Stata**: `group_analysis_hypotheses_tests_bootstrap.do`
- **Table 6** – Decision-outcome patterns in Honolulu auctions
  - **Stata**: `strategies_hnl-auctions.do`

### Appendices -- Figures and Tables

- **C – Numerical Results**
  - **Figure C.1**: Jumps in the optimal starting price
    - **Python**: `Utility Difference.ipynb` → `Jumps in the optimal starting price`
  - **Figure C.2-C.6**: Details on predicted auction characteristics
    - **Python**: `Utility Difference.ipynb` → `Relative difference`
  - **Table C.1**: Theoretical performance comparison
    - **Python**: `Fish_Auction.ipynb` → `Outputs for research use` → `Table of concerned variables for parameters used in the experiment`
  - **Figure C.7, Table C.2** – Social welfare in the experiment
    - **Python**: `Summary statistics.ipynb` → `Auction characteristics`
- **D – Hypotheses tests of experimental auction comparative performances**
  - **Tables D.1 - D.3** in Appendix D: Hypotheses testing by treatment
    - **Stata**: `group_analysis_hypotheses_tests_bootstrap.do`
    - **Python**: `Bootstrap estimation_auction characteristics.ipynb` → `Baseline Regression and Prediction`
    - **Python**: `Bootstrap estimation_auction characteristics.ipynb` → `Blocked Bootstrap`
- **E – Price Dynamics**
  - **Table E.1** in Appendix E: Price Dynamics
    - **Python**: `Dominated behaviour.ipynb` → `Three price dynamics in Honolulu`
- **F – Auction performance with zero-cost prediction**
  - **Figure F.1** – Zero-cost auction duration
    - **Python**: `Summary statistics.ipynb` → `Auction characteristics` → `Duration`
- **G – Additional analyses of bidding behavior**
  - **Figure G.1** in Appendix G: Percent payoff for Top and Bottom bidders
    - **Python**: `Payoff distribution and clustering.ipynb` → `Clustering Based On Similarity` → `Percentage paydiff distribution`
  - **Tables G.1, G.2** in Appendix G – frequencies of dominated decisions
    - **Python**: `Dominated behaviour.ipynb` → `SD & WD decisions`
    - **Stata**: `strategies_dutchl-auctions.do`, `strategies_hnl-auctions_by_stage.do`
  - **Tables G.3** in Appendix G – Dutch bids on value
    - **Stata**: `strategies_dutch-auctions.do`
    - **Python**: `Carryover tests.ipynb`
  - **Tables G.4** in Appendix G: Dutch-stage bids regression estimations
    - **Stata**: `strategies_hnl-auctions.do`
    - **Python**: `Carryover tests.ipynb`
  - **Table G.5** in Appendix G: Regression estimation of individual decisions in Honolulu auctions, by stage
    - **Stata**: `strategies_hnl-auctions.do`
  - **Table G.6** in Appendix G – English stage dropout price regression estimation
    - **Stata**: `strategies_hnl-auctions.do`
    - **Python**: `Carryover tests.ipynb`
- **H – Clustering on similarity**
  - **Figure H.1** – Multidimensional clustering of types
    - **Python**: `Payoff distribution and clustering.ipynb` → `Clustering Based On Similarity` → `K-means`
- **I – Order effects**
  - **Table I.1, Figure I.1-I.4**: Order effects
    - **Python**: `Summary statistics_carryover tests.ipynb`
    - **Stata**: `strategies_dutch-auctions.do`, `strategies_hnl-auctions.do`
- **J – Survey responses**
  - **Table J.1**
    - **Python**: Acquired from Figure 9-10 plots (no p-value computed)
    - **Stata**: `behavioral_survey_analysis.do` (means and p-values for the test of no differences)

---

## Rights & Authorship

This project accompanies an academic paper [When speed is of essence: perishable goods auctions](https://doi.org/10.1016/j.jet.2026.106149) published in *Journal of Economic Theory*. The experimental program and replication packages are the intellectual property of the authors.

**Authors:**

- [Isa Hafalir](https://sites.google.com/site/isaemin/)
- [Onur Kesten](https://profiles.sydney.edu.au/onur.kesten/)
- [Katerina Sherstyuk](https://www2.hawaii.edu/~katyas/)
- [Cong Tao](https://misaka-19090.github.io)

Hafalir, I., Kesten, O., Sherstyuk, K., & Tao, C. (2026). When speed is of essence: Perishable goods auctions. Journal of Economic Theory, 106149.
