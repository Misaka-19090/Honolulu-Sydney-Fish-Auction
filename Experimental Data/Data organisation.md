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

# DATA ORGANISATION

## Raw oTree data

The raw data is organised in a participant-based style, where one row records a complete session for a participant, containing multiple apps and subsessions (rounds). Therefore, same variables in different apps and rounds are identified by different prefix `AppName.RoundNumber.` in their variable names. 

### Participant and session variables

| <div style="width: 17em;">variable name</div> | description |
| :--- | :--- |
| **participant.** |  |
| &emsp;code | unique hash tag for each participant |
| &emsp;label | label assigned to each participant, predefined in `.\rooms\econlab_participant.txt` |
| &emsp;label_num | convert label string to numerical value, for example `"p01"` to `1` |
| &emsp;time_started_utc | start time of the experiment for the participant, in the form of a time string `"YYYY/mm/dd HH:MM:SS"` |
| &emsp;date_num | partially convert start time string to numerical value to identify session, for example `"2022/05/06 1:30:58"` to `2022050601` |
| **session.** |  |
| &emsp;code | unique hash tag for each session (experiment) |
| &emsp;treatment_num | 3-digit numerical label for session name in configuration, where the first digit stands for number of players per group, the second digit for the order of dutch auction, and the thrid digit for the order of honolulu auction |
| **&emsp;config.** |  |
| &emsp;&emsp;real_world_cuurrency_per_point | default configurable parameter |
| &emsp;&emsp;participation_fee | default configurable parameter |
| &emsp;&emsp;name | recording the name of the session, for example, `02_D2H1` means two-players-per-group (`02`) honolulu auction first (`H1`) and then dutch auction (`D2`) |
| &emsp;&emsp;discount_a | custom configurable parameter, used to change the discount factor $d(t)=a-bt$ |
| &emsp;&emsp;discount_b | custom configurable parameter, used to change the discount factor $d(t)=a-bt$ |
| &emsp;&emsp;start_price | custom configurable parameter, starting price for the honolulu auction |
| &emsp;&emsp;price_tick | custom configurable parameter, speed of the virtual clock in the auction, it takes `price_tick` seconds for the virtual clock to tick once |
| &emsp;&emsp;num_test_rounds | number of test rounds |
| &emsp;&emsp;num_formal_rounds | number of formal rounds |
| &emsp;&emsp;start_round_dutch | custom configurable parameter, `0` if test rounds are included, otherwise it starts at `start_round_dutch`-th formal round |
| &emsp;&emsp;start_round_honolulu | same as above |
| &emsp;&emsp;skip_intro_dutch | custom configurable parameter, `0` if displaying auction introduction, `1` if skipping it |
| &emsp;&emsp;skip_intro_honolulu | same as above |

### Application, subsession, group and player variables

Every variable in this section takes the form `AppName.RoundNumber.Modle.VarName`, for example, `02_Dutch.3.group.dutch_time_elapsed` means the variable which is named as `dutch_time_elapsed` and belongs the `group` this player is allocated to in this round (`3`) in application (or say experiment part) `02_Dutch` (that is two-player-per-group dutch auction). Here `Modle` can be one of the three options: `subsession` (equivalent to round), `group` or `player`, depending on the data this variable records.

#### for auction

| <div style="width: 15em;">variable name</div> | description |
| :--- | :--- |
| **AppName.RoundNumber.** |  |
| **&emsp;subsession.** |  |
| &emsp;&emsp;round_number | number of round, should be the same as `RoundNumber` |
| &emsp;&emsp;price_start | starting price of the auction in this round |
| **&emsp;group.** |  |
| &emsp;&emsp;id_in_subsession | unique group id in a given subsession, taking the form of `1, 2, 3, ...` |
| &emsp;&emsp;dutch_time_elapsed | time spent in dutch stage in seconds |
| &emsp;&emsp;dutch_final_price | item price when dutch stage ends |
| &emsp;&emsp;have_dutch_winner | `1` if someone bids in dutch stage, `0` if no one bids in dutch stage |
| &emsp;&emsp;have_contest_winner | (honolulu only) `0` if no one bids in dutch and the contest stages, `1` if no challenger in the contest stage and the dutch winner buys the item, otherwise a number of `have_contest_winner` players compete for the item in english stage <br/><br/>the combination of `have_dutch_winner, have_contest_winner` records how the game goes on: `0, 0` if no one has ever bid until the end of the auction, `0,1` if no one bid in the dutch stage but someone won the item at min price in the contest stage, `0, n` if no one bid in dutch stage but `n` bidders competed for the min price and then played the english stage, `1, 1` if no one challenged the dutch winner; `1, n+1` if dutch winner was challenged by `n` other bidders |
| &emsp;&emsp;english_time_elapsed | (honolulu only) time spent in english stage in seconds |
| &emsp;&emsp;english_final_price | (honolulu only) item price when english stage ends |
| &emsp;&emsp;final_price | (honolulu only) final price of the item when the honolulu auction ends |
| **&emsp;player.** |  |
| &emsp;&emsp;id_in_group | unique player id in a given group, taking the form of `1, 2, 3, ...` |
| &emsp;&emsp;payoff | payoff in this round |
| &emsp;&emsp;item_value | item value in this round |
| &emsp;&emsp;is_dutch_winner | `1` if is dutch winner, otherwise `0` |
| &emsp;&emsp;contest_status | (honolulu only) `1` if is dutch winner or is contest challenger; `2` if is not dutch winner and leaving the contest; `0` if is not dutch winner and no response in the contest |
| &emsp;&emsp;is_english_winner | (honolulu only) `1` if being active until the end of english stage; `0` if leaving the english stage in the middle or not participating the english stage <br/><br/>can have multiple winners |
| &emsp;&emsp;english_dropout_elpased | (honolulu only) `None` (empty) if not participating the english stage, otherwise `english_dropout_elpased` seconds elapsed from english start to dropout |
| &emsp;&emsp;is_final_winner | `1` if is the final buyer of the item, otherwise `0` |

#### for auction feedback

| <div style="width: 15em;">variable name</div> | description |
| :--- | :--- |
| **AppName.RoundNumber.** |  |
| **&emsp;player.** |  |
| &emsp;&emsp;auc0 | question on frequency of buying the item, `1` if alwyas bought, `2` if sometimes bought, `3` if never bought |
| &emsp;&emsp;auc1 | question 1 on degree of agreement, `1-7` scale, `1` if completely disagree, `7` if completely agree |
| &emsp;&emsp;auc2 | question 2 on degree of agreement, same as above |
| &emsp;&emsp;auc3 | question 3 on degree of agreement, same as above |
| &emsp;&emsp;auc4 | question 4 on degree of agreement, same as above |
| &emsp;&emsp;auc5 | question on feeling of buying the item, `1-7` scale, `1` if exteremely sad, `7` if exteremely happy |
| &emsp;&emsp;auc6 | question on feeling of not buying the item, same as above |

## Reformatted oTree data

Using [Data Reformat.ipynb](./Data%20Reformat.ipynb) to generate reformatted data from raw data, which is organised in a round-based style, where one row records one round of action for a participant.

### Participant and session variables

Same as raw data.

### Application, subsession, group and player variables

`AppName.RoundNumber` is no longer required. Others are the same as raw data.

The table below explains newly added variable(s) calculated from raw data variables:
| <div style="width: 15em;">variable name</div> | description |
| :--- | :--- |
| **group.** |  |
| &emsp;auctioneer_utility | the actual auctioneer's utility from that group of auction |
| **player.** |  |
| &emsp;dropout_price | the displayed price the player saw in the experiment when he clicked "Leave" on the contest stage or the english stage, or won the item |
| &emsp;dropout_payoff | the player's payoff if he were to win the item at the displayed dropout price |
| &emsp;dropout_price_accurate | the accurate price when the player clicked "Leave" on the contest stage or the english stage, or won the item |
| &emsp;dropout_payoff_accurate | the player's payoff if he were to win the item at the accurate dropout price |
| paydiff_norm | the average per period point deviations of bidder payoffs from the theoretical prediction by period |
| paydiff_pct | the average percentage deviations of bidder payoffs from the theoretical prediction |

### Prediction variables

For given `session.config` parameters, the theoretical model in our paper [Unusual Fish Auctions](https://address) is used to predict each player's optimal behaviour. The predictions for group and player variables are named with prefix `predict.` added to their original variable names.

The table below gives **important notes** on those prediction variables which need to be explained in a different way from their prototypes.

| <div style="width: 15em;">variable name</div> | description |
| :--- | :--- |
| **predict.** |  |
| **&emsp;group.** |  |
| &emsp;&emsp;have_contest_winner | (honolulu only) no longer needed since every auction must have a winner theoretically |
| **&emsp;player.** |  |
| &emsp;&emsp;contest_status | (honolulu only) `1` if is dutch winner or is contest challenger; `0` if is not dutch winner and leave or no response in the contest |
| &emsp;&emsp;is_final_winner | it will always be the same as `is_english_winner` since random allocation among multiple english winners cannot be predicted, don't forget to randomly decide one final winner when using this variable |

## Qualtrics data

Refer to our google document [[DRAFT] Behavioral Survey]() for question numbers mentioned in descriptions.

### Pre survey

| <div style="width: 7em;">old variable name</div> | <div style="width: 7em;">new variable name</div> | description |
| :--- | :--- | :--- |
| **ICAR test** |  |  |
| Q65 | Q1.1 | - |
|  | Q1.1_score | `1` if correct, `0` if wrong |
| Q66 | Q1.2 | - |
|  | Q1.2_score | `1` if correct, `0` if wrong |
| Q67 | Q1.3 | - |
|  | Q1.3_score | `1` if correct, `0` if wrong |
| Q68 | Q1.4 | - |
|  | Q1.4_score | `1` if correct, `0` if wrong |
| Q84 | Q1.5 | - |
|  | Q1.5_score | `1` if correct, `0` if wrong |
| **CRT test** |  |  |
| Q85 | Q2.1 | - |
|  | Q2.1_score | `1` if correct, `0` if wrong |
| Q86 | Q2.2 | - |
|  | Q2.2_score | `1` if correct, `0` if wrong |
| Q87 | Q2.3 | - |
|  | Q2.3_score | `1` if correct, `0` if wrong |
| Q88 | Q2.4 | - |
|  | Q2.4_score | `1` if correct, `0` if wrong |
| Q89 | Q2.5 | - |
|  | Q2.5_score | `1` if correct, `0` if wrong |
| **risk preference** |  |  |
| All refer to description | Q3.1_sure_offer | amount of sure payment in first choice, `"Q1": 160` |
|  | Q3.1_choice | `Sure Payment` or `50/50 Chance` |
|  | Q3.2_sure_offer | amount of sure payment in second choice, `"Q17": 240, "Q2": 80` |
|  | Q3.2_choice | `Sure Payment` or `50/50 Chance` |
|  | Q3.3_sure_offer | amount of sure payment in third choice, `"Q25": 280, "Q18": 200, "Q10": 120, "Q3": 40` |
|  | Q3.3_choice | `Sure Payment` or `50/50 Chance` |
|  | Q3.4_sure_offer | amount of sure payment in fourth choice, `"Q29": 300, "Q26": 260, "Q22": 220, "Q19": 180, "Q14": 140, "Q11": 100, "Q4": 60, "Q7": 20` |
|  | Q3.4_choice | `Sure Payment` or `50/50 Chance` |
|  | Q3.5_sure_offer | amount of sure payment in fifth choice, `"Q31": 310, "Q30": 290, "Q27": 270, "Q28": 250, "Q23": 230, "Q24": 210, "Q20": 190, "Q21": 170, "Q15": 150, "Q16": 130, "Q13": 110, "Q12": 90, "Q5": 70, "Q6": 50, "Q8": 30, "Q9": 10` |
|  | Q3.5_choice | `Sure Payment` or `50/50 Chance` |
| **time preference** |  |  |
| All refer to description | Q4.1_today_offer | amount of today payment in first choice, `"Q4.1": 154` |
|  | Q4.1_choice | `Today` or `In 12 Months` |
|  | Q4.2_today_offer | amount of today payment in second choice, `"Q4.17": 185, "Q4.2": 125` |
|  | Q4.2_choice | `Today` or `In 12 Months` |
|  | Q4.3_today_offer | amount of today payment in third choice, `Q4.18": 202, "Q4.25": 169, "Q4.10": 139, "Q4.3": 112` |
|  | Q4.3_choice | `Today` or `In 12 Months` |
|  | Q4.4_today_offer | amount of today payment in fourth choice, `"Q4.22": 210, "Q4.19": 193, "Q4.29": 177, "Q4.26": 161, "Q4.14": 146, "Q4.11": 132, "Q4.7": 119, "Q4.4": 106` |
|  | Q4.4_choice | `Today` or `In 12 Months` |
|  | Q4.5_today_offer | amount of today payment in fifth choice, `"Q4.23": 215, "Q4.24": 206, "Q4.20": 197, "Q4.21": 189, "Q4.31": 181, "Q4.30": 173, "Q4.28": 165, "Q4.27": 158, "Q4.16": 150, "Q4.15": 143, "Q4.13": 136, "Q4.12": 129, "Q4.8": 122, "Q4.9": 116, "Q4.6": 109, "Q4.5": 103` |
|  | Q4.5_choice | `Today` or `In 12 Months` |

### Post survey

| <div style="width: 15em;">variable name</div> | description |
| :--- | :--- |
| **competitive preference** |  |
| Q3 | "1. Competition brings the best out of me." |
| **risk preference** |  |
| Q10 | "2. How willing or unwilling you are to take risks?" |
| **time preference** |  |
| Q11 | "4. Are you generally an impatient person, or someone who always shows great patience?" |
| Q12 | "3. How willing are you to give up something that is beneficial for you today in order to benefit more from that in the future?" |
| **regret** |  |
| Q4 | "I try to get information about how the other alternatives turned out." |
| Q5 | "7. If I make a choice and it turns out well, I still feel like something of a failure if I find out that another choice would have turned out better." |
| Q6 | test question |
| Q7 | "5. Whenever I make a choice, I'm curious about what would have happened if I had chosen differently." |
| Q8 | "8. When I think about how I'm doing in life, I often assess opportunities I have passed up." |
| Q9 | "9. Once I make a decision, I don't look back." |
| **demographics** |  |
| Q13 | "1. What is your age?" |
| Q14 | "2. Please indicate your major" |
| Q15 | "3. What is your standing at UH?" |
| Q16 | "4. Which gender do you identify with?" |
| Q17 | "5. How many economics or business classes have you taken?" |
| Q18_1 | "Please give us feedback about the experiment: The experiment was very interesting" |
| Q18_2 | "Please give us feedback about the experiment: The instructions were easy to understand" |
| Q19 | "6. Please add any additional comments about the experiment below" |

### Embedded varibles from oTree in both surveys

These variables are used to match Qualtrics data with oTree data.

| <div style="width: 15em;">old variable name</div> | new variable name (same as variable name in otree) |
| :--- | :--- |
| participant_code | participant.code |
| participant_label | participant.label |
| password | session.code |

## Individual behavioural data

| <div style="width: 15em;">variable name</div> | description |
| :--- | :--- |
| session.code | unique hash tag for each session |
| participant.code | unique hash tag for each participant |
| **d_** | dutch auction |
| &emsp;**n_** | number of occurrence |
| &emsp;**round_** | list of occurred round numbers |
| &emsp;**dutch_** | dutch stage |
| &emsp;&emsp;irrational_bid | winning with negative payoff |
| &emsp;&emsp;correct_win | winning as predicted |
| &emsp;&emsp;correct_lose | losing because of low item value |
| &emsp;&emsp;lucky_win | winning becuase predicted winner waited for too long or himself overbid |
| &emsp;&emsp;greedy_lose | losing because of waitting for too long |
| &emsp;**diff_** | absolute difference between theoretical prediction and actual bid |
| &emsp;&emsp;correct_win | $bid_{predict} - price_{actual}$ |
| &emsp;&emsp;lucky_win | same as above |
| &emsp;&emsp;greedy_lose | same as above |
| **h_** | honolulu auction |
| &emsp;**n_** | number of occurrence |
| &emsp;**round_** | list of occurred round numbers |
| &emsp;**dutch_** | dutch stage |
| &emsp;&emsp;irrational_bid | winning with negative payoff |
| &emsp;&emsp;correct_win | winning as predicted |
| &emsp;&emsp;correct_lose | losing because of low item value |
| &emsp;&emsp;lucky_win | winning becuase predicted winner waited for too long or himself overbid |
| &emsp;&emsp;greedy_lose | losing because of waitting for too long |
| &emsp;**contest_** | contest stage |
| &emsp;&emsp;correct_bid | join contest when item value was higher than current price |
| &emsp;&emsp;correct_leave | leave contest when item value was lower than current price |
| &emsp;&emsp;irrational | join contest when item value was already lower than current price |
| &emsp;&emsp;regret | leave contest when item value was still higher than current price |
| &emsp;**english_** | english stage |
| &emsp;&emsp;irrational | leave too late |
| &emsp;&emsp;correct | leave correctly or earlier |
| &emsp;**diff_** | absolute difference between theoretical prediction and actual bid |
| &emsp;&emsp;**dutch_** |  |
| &emsp;&emsp;&emsp;correct_win | $bid_{predict} - price_{actual}$ |
| &emsp;&emsp;&emsp;lucky_win | same as above |
| &emsp;&emsp;&emsp;greedy_lose | same as above |
| &emsp;&emsp;**contest_** |  |
| &emsp;&emsp;&emsp;regret | $value_{item} - price_{actual}$ |
| &emsp;&emsp;**english_** |  |
| &emsp;&emsp;&emsp;irrational | $value_{item} - price_{dropout}$ |
| &emsp;&emsp;&emsp;correct | same as above |