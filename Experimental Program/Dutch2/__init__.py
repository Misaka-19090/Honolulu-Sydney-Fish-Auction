from otree.api import *
from markupsafe import Markup
import random
import time

doc = """
Cong.Tao@student.uts.edu.au
"""

class C(BaseConstants):
    NAME_IN_URL = '02_d'
    PLAYERS_PER_GROUP = 2
    NUM_ROUNDS = 40

    PAYOFF_DIGIT = 1
    
    PRICE_MIN = 0
    PRICE_MAX = 50

    START_WAIT_TIME_LONG = 10
    START_WAIT_TIME_SHORT = 5

class Subsession(BaseSubsession):
    price_start = models.IntegerField()
    is_dutch_first = models.BooleanField()

class Group(BaseGroup):
    num_active = models.IntegerField()
    dutch_start_time = models.FloatField()
    dutch_time_elapsed = models.FloatField()
    dutch_max_time = models.FloatField()
    have_dutch_winner = models.BooleanField(initial=False)
    dutch_final_price = models.IntegerField()

class Player(BasePlayer):
    item_value = models.IntegerField()
    is_dutch_winner = models.BooleanField(initial=False)
    is_final_winner = models.BooleanField(initial=False)

    # backup for old codes
    '''
    q11 = models.IntegerField(
        choices = [
            [1, Markup("My earning from the purchase is (41 - 20) = 21 points.")],
            [2, Markup("My earning from the purchase is (20 - 41) = -21 points.")],
            [3, Markup("My earning from the purchase is (41 - 20) * 0.85 = 18 points.")],
            [4, Markup("My earning from the purchase is (20 - 41) * 1.15 = -24 points.")],
        ],
        label = Markup("<b>Question 1.1</b> Suppose your value for the good is 41, and the auction ends after 15 ticks of the virtual clock at the price of 20. The time-adjustment factor is 0.85 for positive earnings, and 1.15 for negative earnings. If you buy the good at this price and time, what is your earning?"),
        widget = widgets.RadioSelect
    )
    q12 = models.IntegerField(
        choices = [
            [1, Markup("My earning from the purchase is (41 - 60) = -19 points.")],
            [2, Markup("My earning from the purchase is (41 - 60) * 1.15= -22 points.")],
            [3, Markup("My earning from the purchase is (41 - 60) * 0.85 = -16 points.")],
            [4, Markup("My earning from the purchase is (60 - 41) * 0.85 = 16 points.")],
        ],
        label = Markup("<b>Question 1.2</b> Suppose your value for the good is 41, and the auction ends after 15 ticks of the virtual clock at the price of 60. The time-adjustment factor is 0.85 for positive earnings, and 1.15 for negative earnings. If you buy the good at this price and time, what is your earning?"),
        widget = widgets.RadioSelect
    )
    q21 = models.IntegerField(
        choices = [
            [1, Markup("The auctions will end immediately, and the person who bid first will buy the good at the time and price at which they bid.")],
            [2, Markup("The person who bid will be provisionally assigned the good, but you will have another chance to bid and resume the auction.")],
        ],
        label = Markup("<b>Question 2.1</b> Suppose the price of the good is going down, and someone else, not you, is the first person to bid. Check which statement is correct:"),
        widget = widgets.RadioSelect
    )
    '''

def creating_session(subsession: Subsession):
    subsession.price_start = C.PRICE_MAX
    
    app_seq = subsession.session.config["app_sequence"]
    d_seq = [s for s in app_seq if "Dutch" in s]
    h_seq = [s for s in app_seq if "Honolulu" in s]
    if d_seq != []:
        d_index = app_seq.index(d_seq[0])
    else:
        d_index = 65535
    if h_seq != []:
        h_index = app_seq.index(h_seq[0])
    else:
        h_index = 65535
    subsession.is_dutch_first = (d_index < h_index)

    if subsession.round_number == 1:
        for p in subsession.get_players():
            p.participant.dutch_payoff = cu(0)

#FUNCTIONS

def discount(subsession: Subsession, t, p):
    a = subsession.session.config["discount_a"]
    b = subsession.session.config["discount_b"]
    price_tick = subsession.session.config["price_tick"]
    if p >= 0:
        y = a - b * int(t / price_tick)
        if y >= 0:
            return float(y)
        else:
            return float(0)
    else:
        y = a + b * int(t / price_tick)
        return float(y)

def live_dutch(player: Player, data):
    group = player.group
    subsession = player.subsession
    time_elapsed = time.time() - group.dutch_start_time
    price_tick = subsession.session.config["price_tick"]
    if (data == True) and (group.have_dutch_winner == False) and (time_elapsed <= group.dutch_max_time):
        group.have_dutch_winner = True
        group.dutch_time_elapsed = time_elapsed
        group.num_active = 1
        player.is_dutch_winner = True
    current_price = subsession.price_start - int(time_elapsed / price_tick)
    unadjusted_payoff = player.item_value - current_price
    discount_factor = discount(subsession, time_elapsed, unadjusted_payoff)
    adjusted_payoff = round(unadjusted_payoff * discount_factor, C.PAYOFF_DIGIT)
    return {
        player.id_in_group: dict(
            have_winner = group.have_dutch_winner,
            num_active = group.num_active,
            current_price = current_price,
            time_elapsed = int(time_elapsed / price_tick),
            unadjusted_payoff = unadjusted_payoff,
            discount_factor = round(discount_factor, 4),
            adjusted_payoff = adjusted_payoff,
        )
    }

def set_payoffs(group: Group):
    players = group.get_players()
    subsession = group.subsession
    price_tick = subsession.session.config["price_tick"]
    if group.have_dutch_winner == 0:
        for p in players:
            p.payoff = 0
    else:
        for p in players:
            if p.is_dutch_winner == 1:
                p.is_final_winner = True
                if subsession.round_number > subsession.session.config["num_test_rounds"]:
                    current_price = subsession.price_start - int(group.dutch_time_elapsed / price_tick)
                    time_elapsed = group.dutch_time_elapsed
                    unadjusted_payoff = p.item_value - current_price
                    discount_factor = discount(subsession, time_elapsed, unadjusted_payoff)
                    p.payoff = round(unadjusted_payoff * discount_factor, C.PAYOFF_DIGIT)
                else:
                    p.payoff = 0
            else:
                p.payoff = 0
    for p in players:
            p.participant.dutch_payoff += p.payoff

# PAGES
class Introduction(Page):

    def is_displayed(subsession: Subsession):
        return (subsession.round_number == 1 and subsession.session.config["skip_intro_dutch"] == 0)
    
    def vars_for_template(player: Player):
        b = player.session.config["discount_b"]
        equiv30 = int(30 * (C.PRICE_MAX - C.PRICE_MIN) / 100 + C.PRICE_MIN)
        equiv64 = int(64 * (C.PRICE_MAX - C.PRICE_MIN) / 100 + C.PRICE_MIN)
        equiv100 = int(100 * (C.PRICE_MAX - C.PRICE_MIN) / 100 + C.PRICE_MIN)
        equivtick13 = int(13 * (C.PRICE_MAX - C.PRICE_MIN) / 100)
        equivtick69 = int(69 * (C.PRICE_MAX - C.PRICE_MIN) / 100)
        equivpos13 = round(1 - b * equivtick13, 4)
        equivpos69 = round(1 - b * equivtick69, 4)
        equivneg13 = round(1 + b * equivtick13, 4)
        equivneg69 = round(1 + b * equivtick69, 4)
        return dict(
            num_other = C.PLAYERS_PER_GROUP - 1,
            tick = round(player.session.config["price_tick"], 1),
            pct_b = round(b * 100, 2),
            pos_discount_1 = round(1 - b, 4),
            neg_discount_1 = round(1 + b, 4),
            pos_discount_2 = round(1 - b * 2, 4),
            neg_discount_2 = round(1 + b * 2, 4),
            pos_discount_5 = round(1 - b * 5, 4),
            neg_discount_5 = round(1 + b * 5, 4),
            pos_discount_10 = round(1 - b * 10, 4),
            neg_discount_10 = round(1 + b * 10, 4),
            pos_discount_20 = round(1 - b * 20, 4),
            neg_discount_20 = round(1 + b * 20, 4),
            pos_discount_50 = round(1 - b * 50, 4),
            neg_discount_50 = round(1 + b * 50, 4),
            ex1_bid = equiv30,
            ex1_val = equiv64,
            ex1_uadj = equiv64 - equiv30,
            ex2_bid = equiv100,
            ex2_val = equiv64,
            ex2_uadj = equiv64 - equiv100,
            tick13 = equivtick13,
            tick69 = equivtick69,
            ex1_discount_13 = equivpos13,
            ex1_pct_13 = round(equivpos13 * 100, 2),
            ex1_adj_13 = int((equiv64 - equiv30) * equivpos13),
            ex1_discount_69 = equivpos69,
            ex1_pct_69 = round(equivpos69 * 100, 2),
            ex1_adj_69 = int((equiv64 - equiv30) * equivpos69),
            ex2_discount_13 = equivneg13,
            ex2_pct_13 = round(equivneg13 * 100 - 100, 2),
            ex2_adj_13 = int((equiv64 - equiv100) * equivneg13),
            ex2_discount_69 = equivneg69,
            ex2_pct_69 = round(equivneg69 * 100 - 100, 2),
            ex2_adj_69 = int((equiv64 - equiv100) * equivneg69),
        )

class WaitDutchStart(WaitPage):

    wait_for_all_groups = True

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_dutch"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number >= num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def after_all_players_arrive(subsession: Subsession):
        players = subsession.get_players()
        for p in players:
            p.item_value = round(random.uniform(C.PRICE_MIN, C.PRICE_MAX))

class PreparePage(Page):

    timer_text = "Auction will start in "

    def get_timeout_seconds(player: Player):
        if player.round_number <= player.session.config["num_test_rounds"] + 1:
            return C.START_WAIT_TIME_LONG
        else:
            return C.START_WAIT_TIME_SHORT

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_dutch"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number >= num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def vars_for_template(subsession: Subsession):
        return dict(
            discount_b = round(subsession.session.config["discount_b"] * 100, 2),
        )

class WaitDutchStart2(WaitPage):

    wait_for_all_groups = True

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_dutch"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number >= num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def after_all_players_arrive(subsession: Subsession):
        subsession.group_randomly()
        groups = subsession.get_groups()
        price_tick = subsession.session.config["price_tick"]
        for g in groups:
            g.num_active = len(g.get_players())
            g.dutch_start_time = time.time()
            g.dutch_max_time = (subsession.price_start - C.PRICE_MIN) * price_tick

class DPage(Page):

    live_method = live_dutch

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_dutch"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number >= num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def js_vars(player: Player):
        return dict(
            min_price = C.PRICE_MIN,
            refresh_freq = round(player.session.config["price_tick"] * 500)
        )

class DutchEndWaitPage(WaitPage):

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_dutch"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number >= num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def after_all_players_arrive(group: Group):
        subsession = group.subsession
        price_tick = subsession.session.config["price_tick"]
        if group.have_dutch_winner == False:
            group.dutch_time_elapsed = group.dutch_max_time
            group.num_active = 0
        set_payoffs(group)
        group.dutch_final_price = subsession.price_start - int(group.dutch_time_elapsed / price_tick)

class Results(Page):

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_dutch"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number >= num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def vars_for_template(player: Player):
        group = player.group
        subsession = player.subsession
        price_tick = subsession.session.config["price_tick"]
        current_price = subsession.price_start - int(group.dutch_time_elapsed / price_tick)
        time_elapsed = group.dutch_time_elapsed
        unadjusted_payoff = player.item_value - current_price
        discount_factor = discount(subsession, time_elapsed, unadjusted_payoff)
        adjusted_payoff = round(unadjusted_payoff * discount_factor, C.PAYOFF_DIGIT)
        return dict(
            current_price = current_price,
            time_elapsed = int(time_elapsed / price_tick),
            unadjusted_payoff = unadjusted_payoff,
            discount_factor = round(discount_factor, 4),
            adjusted_payoff = adjusted_payoff,
        )
    def js_vars(player: Player):
        payoff_history = "<tr><th style=\"width: 40%\">Period</th><th style=\"width: 30%\">Item value</th><th style=\"width: 30%\">Payoff</th></tr>"
        for p in player.in_all_rounds():
            payoff_history += "<tr><td>" + str(p.round_number) + "</td><td>" + str(p.item_value) + " points</td><td>" + str(p.payoff) + " points</td></tr>"
        payoff_history += "<tr><th>" + "Total" + "</th><th>&nbsp;</th><th>" + str(player.participant.dutch_payoff) + " points</th></tr>"
        return dict(
            payoff_history = payoff_history
        )

page_sequence = [
    Introduction,
    WaitDutchStart,
    PreparePage,
    WaitDutchStart2,
    DPage,
    DutchEndWaitPage,
    Results,
]
