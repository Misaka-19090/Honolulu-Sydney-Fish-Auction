# Experimental Instructions

[The sample instructions  are for 2H treatment. For 5-bidder or low-cost ("L") treatments, the number of other bidders is changed from **1** to **4**, and the payoff percent adjustment per tick of the virtual clock is changed from   "**1.9**" to "**0.9**" (as indicated in the parentheses). The text in the square brackets  is not given to participants.]

## Introduction

In this part you are going to participate in a sequence of independent auction periods in which you will be buying a fictitious good. At the beginning of each auction, you will be assigned to a market with **1** (**4**) other participant(s). You will not be told which of the other participants are in your market. *What happens in your market has no effect on the participants in other markets and vice versa.*

In each auction period you will be able to place bids in an auction to purchase a single unit of a good.

## Values, Auction Duration and Earnings

**Values and Earnings** During each market period you are free to purchase a unit of a good in an auction. You will be assigned a number which describes the value of the good for you. These values may differ among bidders and market periods. Each bidder will receive a value between **0** and **50**, with each number being equally likely. *You are not to reveal your value to anyone. It is your own private information.*

Your earnings from the purchase, which are yours to keep, will depend on the difference between your value for the good and the price you pay, and on how long the auction lasts.

*Your raw (unadjusted) earnings or loss from the purchase is equal to the difference between your value and the purchase price:* That is: 
$$
    \text{YOUR UNADJUSTED EARNINGS} = \text{YOUR VALUE} - \text{PURCHASE PRICE}.
$$

**Example 1** (All values are hypothetical). If you buy a good for $15$ points and your value is $32$, then your unadjusted earnings are:
$$
    \text{UNADJUSTED EARNINGS} = 32 - 15 = 17\text{ points}.
$$

**Example 2** If you buy the good for $50$ points and your value is $32$, then your unadjusted earnings are:
$$
    \text{UNADJUSTED EARNINGS} = 32 - 50 = -18\text{ points}.
$$

ARE THERE ANY QUESTIONS?

**Auction Duration and Earnings** *Your earnings will further decrease in proportion to how long the auction lasts.* The auction duration will be measured by the virtual clock, which will tick every **1** seconds while the auction is open. Your unadjusted earnings, if positive, will shrink by **1.9** (**0.9**) percent with every tick of the virtual clock; your loss, if negative, will increase by **1.9** (**0.9**) percent with every tick of the virtual clock. That is, your time-adjusted earnings will be equal to
$$
\text{YOUR EARNINGS} = (\text{YOUR VALUE} - \text{PURCHASE PRICE}) \\ \times (\text{TIME-ADJUSTMENT FACTOR}),    
$$
where the time-adjustment factor decreases with every tick of the virtual clock for positive earnings, and increases with every tick of the virtual clock for negative earnings. The table below illustrates how your earnings will be adjusted depending on the auction duration:

[These are the table and examples appearing in the instructions for the high-cost treatments "H." For the low-cost treatments "L," the numbers in the table and the numerical examples are adjusted accordingly.]

| Elapsed time, in ticks of the virtual clock | Time-adjustment factor for positive earnings | Time-adjustment factor for negative earnings |
| :-: | :-: | :-: |
| 0 | 1 | 1 |
| 1 | 0.981 | 1.019 |
| 2 | 0.962 | 1.038 |
| 5 | 0.905 | 1.095 |
| 10 | 0.81 | 1.19 |
| 20 | 0.62 | 1.38 |
| 50 | 0.05 | 1.95 |

**Example 1 continued** (All values are hypothetical). Suppose that your value for a good is $32$, and you buy the good for $15$. Suppose the time-adjustment factor is as given above. If the auction ends after $6$ ticks of the virtual clock, then your positive earnings will shrink to $88.6$ percent, and your time-adjusted earnings will be:
$$
    \text{TIME-ADJUSTED EARNINGS} = (32 - 15) \times 0.886 = 15\text{ points}.
$$

If, on the other hand, the auction ends after $34$ ticks, your earnings will shrink to $35.4$ percent by the end of the auction, and your time-adjusted earnings will be:
$$
    \text{TIME-ADJUSTED EARNINGS} = (32 - 15) \times 0.354 = 6\text{ points}.
$$

**Example 2 continued** Suppose, as in Example 2 above, that your value is $32$, you buy the good for $50$, and the time-adjustment factor is as given. If the auction ends after $6$ ticks of the virtual clock, then your loss from the purchase will grow in magnitude by $11.4$ percent, and you adjusted earnings (loss) will be:
$$
    \text{TIME-ADJUSTED EARNINGS} = (32 - 50) \times 1.114 = -20\text{ points}.
$$

If, on the other hand, your value and the purchase price are the same as above, but the auction ends after $34$ ticks, then your loss from the purchase will increase by $64.6$ percent. Your time-adjusted negative earnings will be:
$$
    \text{TIME-ADJUSTED EARNINGS} = (32 - 50) \times 1.646 = -29\text{ points}.
$$

If you do not buy the good in a given period, your earnings will be zero in this period irrespective of how long the auction lasts. 

At each point of time during the auction, your computer screen will display your value of the good, the current price at which you may buy, the time adjustment factor, and your unadjusted and time-adjusted payoffs (earnings or losses) if you were to buy the good at the current price and time.

ARE THERE ANY QUESTIONS?

**Summary of Values, Duration and Earnings**
1. You will participate in an auction to buy a fictitious good. If you buy the good, your earnings from the purchase will depend on the difference between the value of the good and the price you pay, and on how long the auction lasts.
2. If you buy the good at a price above your value, your earnings will be negative (you will lose money).
3. If you buy the good at a price below your value, your earnings will be positive (you will make money).
4. The longer the auction takes, the lower will be your earnings from the purchase, other things being equal.
5. If you do not buy, your earnings will be zero.
\end{enumerate}

**Test for Understanding** This is a test for understanding about the values, auction duration and earnings. **Please answer all questions carefully.** You will not be able to start the auction until you answer all questions correctly.
1. Suppose your value for the good is $41$, and the auction ends after several ticks of the virtual clock at the price of $20$. The time-adjustment factor is $0.85$ for positive earnings, and $1.15$ for negative earnings. If you buy the good at this price and time, what is your earning (rounded to the closest integer)? 
    
    **[Answer: 18]**
    
2. Suppose your value for the good is $31$, and the auction ends after several ticks of the virtual clock at the price of $49$. The time-adjustment factor is $0.6$ for positive earnings, and $1.4$ for negative earnings. If you buy the good at this price and time, what is your earning (rounded to the closest integer)? 
    
    **[Answer: -25]**

## Auction Organization [Dutch Auction]

The auction is organized as follows. In each auction you and **1** (**4**) other participants will compete to purchase a fictitious good. The price of the good will start at **50** points and will decrease by **1** point with every tick. Any of the bidders can stop the auction and purchase the good at the price displayed on the screen by clicking the **Bid** button. The first person to click the button buys the good and pays the price displayed on the screen, and the other bidders earn $0$ for that auction. 

After the good is sold, the auction closes for this period. Your results screen will display whether you bought the good or not; your value for the good, sale price, and your unadjusted and time-adjusted payoffs.

If you do not buy, your results screen will report your actual payoffs as zero, and will also display your payoffs if you were to buy the good at the price and time when it was sold.

Your time-adjusted earnings from all previous auctions will be displayed in the history box at the bottom of each auction's results screen.

ARE THERE ANY QUESTIONS?

**Summary of Auction Organization**
1. When the auction opens, the price will start to go down. The first person to click the **Bid** button will buy the good at the time and price of their bid.
2. If you buy at a price above your value, your earnings will be negative (you will lose money).
3. If you buy at a price below your value, your earnings will be positive (you will make money).
4. The longer the auction takes, the lower will be your earnings from the purchase, other things being equal.
5. If you do not buy, your earnings will be zero.
\end{enumerate}

**Test for Understanding**
1. Suppose the price of the good is going down, and someone else, not you, is the first person to bid. Check which statement is correct:
    &emsp;(a) The auctions will end immediately, and the person who bid first will buy the good at the time and price at which they bid.
    &emsp;(b) The person who bid will be provisionally assigned the good, but you will have another chance to bid and resume the auction.

    **[Answer: (a)]**

2. Suppose the price is going down, and you are the first person to bid at the price of $33$. Suppose your value for the good is $25$. Check which statement is correct:
    &emsp;(a) Even though the price of $33$ is above my value of value $25$, I will not lose money if I bid at this price because another person may also bid and buy the good.
    &emsp;(b) Because the price of $33$ is above my value of $25$, I will lose money if I bid at this price.

    **[Answer: (b)]**

## Auction Organization [Honolulu-Sydney Auction]

The auction is organized as follows. In each auction you and **1** (**4**) other participants will compete to purchase a fictitious good.

**Price is going down** The price of the good will start at some value between **0** and **50** points, set by the experimenter, and will go down by **1** point with every tick of the virtual clock. Any of the bidders can stop the auction and provisionally purchase the good at the price displayed on the screen by clicking the **Bid** button. The first person to click the **Bid** button is provisionally assigned the good at the given price and time. 

**Another chance to bid** When a bidder bids and becomes a provisional buyer, other bidders have **10** seconds to challenge the provisional buyer by clicking the **Bid** button. The virtual clock will stop, and bidder payoffs will not change, during this time.

If a bidder decides not to bid at this stage, they may leave the auction by either clicking **Leave** button, or by taking no action. This bidder then becomes inactive and cannot bid any more.

If no bidder challenges the provisionally assigned buyer by clicking the **Bid** button after **10** seconds, then the auction ends. The provisional buyer buys the good at the price and time of their bid. All other bidders earn 0 for that auction.

**Price is going up** If one or more other bidders challenge the provisional buyer by clicking the **Bid** button, then the auction and the virtual clock will resume, and the price will go up from the previously bid price by **1** point with every tick of the virtual clock. Only the provisional buyer and those bidders who challenged this buyer by clicking **Bid** will be active in the auction at this stage. (The bidders who left the auction will be inactive and will view the auction without taking any action.)
 
Any active bidder can then leave the auction at any time by clicking the **Leave** button. The auction will continue, with the price and time increasing, as long as there are two or more active bidders in the auction. The auction ends when the next to the last active bidder clicks **Leave** button. The last bidder to stay active in the auction buys the good at the price and time when the next to last bidder left. All other bidders earn 0 for that auction. If two last active bidders drop out at the same time and price, then the object will be allocated randomly to one of these bidders at the price and time when they left.

After the good is sold, the auction closes for this period. Your results screen will display whether you bought the good or not; your value for the good, sale price, and your unadjusted and time-adjusted payoffs. 

If you do not buy, your results screen will report your actual payoffs as zero, and will also display your hypothetical payoff if you were to buy the good at the price and time when it was sold.
    
Your time-adjusted earnings from all previous auctions will be displayed in the history box at the bottom of each auction's results screen.

ARE THERE ANY QUESTIONS?

**Summary of Auction Organization**
1. When the auction opens, the price will start to go down. The first person to click the **Bid** button will be provisionally assigned the good at the time and price of their bid. After that, all other bidders will be given another chance to bid.
2. Only the bidders who click **Bid**, either when the price is going down, or at "Another Chance to Bid" stage, will have a chance to buy. Bidders who do not bid will not be able to buy the good in this auction and will earn zero.
3. If more than one bidder clicks the **Bid** button, the price will start going up, and all bidders who are active (i.e., they pressed **Bid** earlier) will be considered willing to buy at the current price. You have to press the **Leave** button to exit bidding. The last bidder to stay active in the auction will buy the good at the price and time when the next to last bidder left.
4. If the price is above your value, and you bid (if the price is going down or at "Another Chance to Bid" stage) or you do not leave the auction (if the price is going up), you may end up buying the good at a price above your value, and lose money.
5. If the price is below your value and you do not bid (at "Another Chance to Bid" stage), or you leave the auction (when the price is going up), you may forgo a chance to buy at a price below your value and earn a positive profit.

**Test for Understanding** This is another test for understanding about the auction organization. **Please answer all questions carefully.** You will not be able to start the auction until you answer all questions correctly.
1. Suppose the price is going down, and you are the first person to bid at the price of $24$. Suppose your value for the good is $17$. Check which statement is correct:
    &emsp;(a) Even though the price of $24$ is above your value of value $17$, I will not lose money if I bid at this price because another person may also bid and buy the good.
    &emsp;(b) Because the price of $24$ is above my value of $17$, I may lose money if I bid at this price.

    **[Answer: (b)]**

2. Suppose the price was going down, but then it stopped at $35$, and you are given "Another Chance to Bid". Suppose your value for the good is $41$. Check which statement is correct:
    &emsp;(a) If I click **Bid**, I will continue bidding and may have a chance to buy and make a positive earning. If I do not click **Bid** or click the **Leave** button, I will forgo a chance to buy and earn money.
    &emsp;(b) I should not bid. Instead, I should leave the auction because the price is too high.

    **[Answer: (a)]**

3. Suppose again that the price was going down, but then it stopped at $18$, and you are given "Another Chance to Bid". Suppose now your value for the good is $11$. Check which statement is correct:
    &emsp;(a) If I click **Bid** I will continue bidding and may have a chance to buy and make a positive earning. If I do not click **Bid** or click the **Leave** button, I will forgo a chance to buy and earn money.
    &emsp;(b) Because the price is above my value, I should not bid if I want to avoid losses. If I click **Bid**, I may buy at the current price or higher, and I will lose money if I buy.

    **[Answer: (b)]**

4. Suppose the price of the good is going up and is currently at $14$. Suppose you are an active bidder, and your value of the good is $28$. Check which statement is correct:
    &emsp;(a) I have to click **Bid** with every price increase to remain active in the auction and have a chance to buy the good.
    &emsp;(b) If I click the **Leave** button at this price, I will forgo my chance to buy at a price below my value and earn a positive payoff.
    &emsp;\(c) Even if I click the **Leave** button at this price, I will still have a chance to bid at a later point and buy in this auction.

    **[Answer: (b)]**

5. Suppose the price of the good is going up and is currently at $14$. Suppose you are an active bidder, and your value of the good is $9$. Check which statement is correct:
    &emsp;(a) If I do not leave, I will continue bidding, and may buy the good at a price below my value and earn money. If I click the **Leave** button at this price, I will forgo my chance to buy at a price below value and earn a positive payoff.
    &emsp;(b) Because the price of $14$ is above my value of $9$, and the price is going up, I will not be able to buy and make money in this auction. If I do not click **Leave**, I will continue bidding, I may buy the good at a price below my value and lose money.

    **[Answer: (b)]**

**Matching**

You will be randomly re-matched with new participants in every auction. You will not be told which of the other participants you are matched with in any given auction, and they will not be told that you are matched with them. What happens in your auction has no effect on what happens in any other auction, and vice versa.

This will continue for a number of periods. Your total earnings in this part of the session are given by the sum of your period earnings. Your cumulative earnings in all parts will be displayed on your computer screen at all times during the auction.

The first **2** periods will be practice. You will receive no earnings for these periods. If you have a question, please raise your hand and I will answer your question in private.

ARE THERE ANY QUESTIONS?