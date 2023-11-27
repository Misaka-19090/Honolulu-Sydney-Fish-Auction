from math import ceil
from otree.api import *
from markupsafe import Markup
import random
import time

doc = """
Cong.Tao@student.uts.edu.au
"""

class C(BaseConstants):
    NAME_IN_URL = "02_h"
    PLAYERS_PER_GROUP = 2
    NUM_ROUNDS = 40

    PAYOFF_DIGIT = 1
    
    PRICE_MIN = 0
    PRICE_MAX = 50

    START_WAIT_TIME_LONG = 10
    START_WAIT_TIME_SHORT = 5
    CONTEST_TIME = 10

class Subsession(BaseSubsession):
    price_start = models.IntegerField()
    is_dutch_first = models.BooleanField()

class Group(BaseGroup):
    num_active = models.IntegerField()
    dutch_start_time = models.FloatField()
    dutch_time_elapsed = models.FloatField()
    dutch_max_time = models.FloatField()
    have_dutch_winner = models.BooleanField(initial=False)
    num_contest_no_decision = models.IntegerField()
    have_contest_winner = models.IntegerField() # 0 - No winner; 1 - have unique winner; n >= 2 - n contestants
    english_start_time = models.FloatField()
    english_time_elapsed = models.FloatField(initial=0)
    english_max_time = models.FloatField()
    dutch_final_price = models.IntegerField()
    english_final_price = models.IntegerField()
    final_price = models.IntegerField()

class Player(BasePlayer):
    item_value = models.IntegerField()
    is_dutch_winner = models.BooleanField(initial=False)
    contest_status = models.IntegerField(initial=0) # 0 - No decision; 1 - Join; 2 - Leave
    is_english_winner = models.BooleanField(initial=False)
    is_final_winner = models.BooleanField(initial=False)
    english_dropout_elpased = models.FloatField()

    # Backup for old codes
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
            [1, Markup("The auctions will end immediately, and I will buy the good at the time and price at which I bid.")],
            [2, Markup("I will be provisionally assigned the good, but other bidders will have another chance to bid. If another person bids, they will immediately buy the good, and I will not.")],
            [3, Markup("I will be provisionally assigned the good, but other bidders will have another chance to bid. If another person bids, the auction will resume, and the price will be going up. I may or may not buy the good then.")],
        ],
        label = Markup("<b>Question 2.1</b> Suppose the price of the good is going down, and you are the first person to bid. Check which statement is correct:"),
        widget = widgets.RadioSelect
    )
    q22 = models.IntegerField(
        choices = [
            [1, Markup("If I click the <strong class=\"s_bid\">Bid</strong> button at this stage, I will immediately buy the good at the current price and time.")],
            [2, Markup("If I click the <strong class=\"s_bid\">Bid</strong> button at this stage, the auction will resume and the price will be going up; I may or may not buy the good. If you do not click the <strong class=\"s_bid\">Bid</strong> button at this stage, I will not be able to participate in further bidding and will not buy the good.")],
            [3, Markup("If I do not click the <strong class=\"s_bid\">Bid</strong> button, I will still be able to participate in further bidding if another participant clicks <strong class=\"s_bid\">Bid</strong> and the auction resumes.")],
        ],
        label = Markup("<b>Question 2.2</b> Suppose the price of the good was going down, but then it stopped, and you see \"Another chance to bid\" screen. Check which statement is correct:"),
        widget = widgets.RadioSelect
    )
    q23 = models.IntegerField(
        choices = [
            [1, Markup("I have to click <strong class=\"s_bid\">Bid</strong> with every price increase to remain active in the auction. If I am the only person to click <strong class=\"s_bid\">Bid</strong> at a given price and time, I will buy the good at this price and time.")],
            [2, Markup("I am considered actively bidding until I click the <strong class=\"s_leave\">Leave</strong> button. If I do not click the <strong class=\"s_leave\">Leave</strong> button, I will buy the good at the price and time at which all other bidders leave.")],
            [3, Markup("If the price goes up above my value, I am still guaranteed against losses because I will not buy the good unless I click the <strong class=\"s_bid\">Bid</strong> button at this stage.")],
        ],
        label = Markup("<b>Question 2.3</b> Suppose the price of the good is going up, and you are an active bidder. Check which statement is correct:"),
        widget = widgets.RadioSelect
    )
    '''

def creating_session(subsession: Subsession):
    subsession.price_start = subsession.session.config["start_price"]
    
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
            p.participant.honolulu_payoff = cu(0)

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
        group.num_contest_no_decision = len(group.get_players()) - 1
        player.is_dutch_winner = True
        player.contest_status = 1
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

def live_contest(player: Player, data):
    group = player.group
    players = group.get_players()
    if data == "init":
        return{
            player.id_in_group: dict(
                status = player.contest_status,
                num_active = group.num_active,
                num_no_decision = group.num_contest_no_decision
            )
        }
    else:
        if data == 1:
            player.contest_status = 1
            group.num_active += 1
            group.num_contest_no_decision -= 1
        elif data == 2:
            player.contest_status = 2
            group.num_contest_no_decision -= 1
        return{
            p.id_in_group: dict(
                status = p.contest_status,
                num_active = group.num_active,
                num_no_decision = group.num_contest_no_decision
            ) for p in players
        }

def live_english(player: Player, data):
    group = player.group
    subsession = player.subsession
    time_elapsed = time.time() - group.english_start_time + group.dutch_time_elapsed
    price_tick = subsession.session.config["price_tick"]
    if (data == True) and (group.num_active > 1) and (time_elapsed <= group.dutch_time_elapsed + group.english_max_time):
        group.english_time_elapsed = time.time() - group.english_start_time
        player.is_english_winner = False
        group.num_active -= 1
        player.english_dropout_elpased = time.time() - group.english_start_time
    current_price = subsession.price_start + ceil((time_elapsed - 2 * group.dutch_time_elapsed) / price_tick)
    unadjusted_payoff = player.item_value - current_price
    discount_factor = discount(subsession, time_elapsed, unadjusted_payoff)
    adjusted_payoff = round(unadjusted_payoff * discount_factor, C.PAYOFF_DIGIT)
    return{
        player.id_in_group: dict(
            status = player.is_english_winner,
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
    if group.have_contest_winner == 0:
        for p in players:
            p.payoff = cu(0)
    elif group.have_contest_winner == 1:
        for p in players:
            if p.contest_status == 1:
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
    else:
        choice_list = [p for p in players if p.is_english_winner == 1]
        chosen_winner = random.choice(choice_list)
        chosen_winner.is_final_winner = True
        for p in players:
            if p == chosen_winner:
                if subsession.round_number > subsession.session.config["num_test_rounds"]:
                    current_price = subsession.price_start + ceil((group.english_time_elapsed - group.dutch_time_elapsed) / price_tick)
                    time_elapsed = group.dutch_time_elapsed + group.english_time_elapsed
                    unadjusted_payoff = p.item_value - current_price
                    discount_factor = discount(subsession, time_elapsed, unadjusted_payoff)
                    p.payoff = round(unadjusted_payoff * discount_factor, C.PAYOFF_DIGIT)
                else:
                    p.payoff = 0
            else:
                p.payoff = 0
    for p in players:
            p.participant.honolulu_payoff += p.payoff

# PAGES
class Introduction(Page):

    def is_displayed(subsession: Subsession):
        return (subsession.round_number == 1 and subsession.session.config["skip_intro_honolulu"] == 0)
    
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
        start_round = subsession.session.config["start_round_honolulu"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number > num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
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
        start_round = subsession.session.config["start_round_honolulu"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number > num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def vars_for_template(subsession: Subsession):
        return dict(
            discount_b = round(subsession.session.config["discount_b"] * 100, 2),
        )

class WaitDutchStart2(WaitPage):

    wait_for_all_groups = True

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_honolulu"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number > num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
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
        start_round = subsession.session.config["start_round_honolulu"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number > num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def js_vars(player: Player):
        return dict(
            min_price = C.PRICE_MIN,
            refresh_freq = round(player.session.config["price_tick"] * 500)
        )

class DutchEndWaitPage(WaitPage):

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_honolulu"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number > num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def after_all_players_arrive(group: Group):
        subsession = group.subsession
        price_tick = subsession.session.config["price_tick"]
        if group.have_dutch_winner == False:
            group.dutch_time_elapsed = group.dutch_max_time
            group.num_active = 0
            group.num_contest_no_decision = len(group.get_players())
        group.dutch_final_price = int(subsession.price_start - int(group.dutch_time_elapsed / price_tick))
        group.final_price = group.dutch_final_price

class ContestPage(Page):

    timeout_seconds = C.CONTEST_TIME
    timer_text = "Time left for everyone to make decision: "

    live_method = live_contest

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_honolulu"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number > num_test + start_round) and (subsession.round_number <= num_test + num_formal))

    def vars_for_template(player: Player):
        group = player.group
        subsession = player.subsession
        time_elapsed = group.dutch_time_elapsed
        price_tick = subsession.session.config["price_tick"]
        dutch_price = subsession.price_start - int(time_elapsed / price_tick)
        unadjusted_payoff = player.item_value - dutch_price
        discount_factor = discount(subsession, time_elapsed, unadjusted_payoff)
        adjusted_payoff = round(unadjusted_payoff * discount_factor, C.PAYOFF_DIGIT)
        return dict(
            dutch_price = dutch_price,
            time_elapsed = int(time_elapsed / price_tick),
            unadjusted_payoff = unadjusted_payoff,
            discount_factor = round(discount_factor, 4),
            adjusted_payoff = adjusted_payoff,
        )

class WaitEnglishStart(WaitPage):

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_honolulu"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number > num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def after_all_players_arrive(group: Group):
        group.have_contest_winner = group.num_active
        price_tick = group.session.config["price_tick"]
        if group.have_contest_winner >= 2:
            for p in group.get_players():
                if p.contest_status == 1:
                    p.is_english_winner = True
            group.english_start_time = time.time()
            group.english_max_time = group.dutch_time_elapsed + (C.PRICE_MAX - group.subsession.price_start) * price_tick
        
class EPage(Page):

    live_method = live_english

    def is_displayed(player: Player):
        num_test = player.session.config["num_test_rounds"]
        num_formal = player.session.config["num_formal_rounds"]
        start_round = player.session.config["start_round_honolulu"]
        if (start_round == 0):
            return ((player.round_number <= num_test + num_formal) and (player.group.have_contest_winner >= 2))
        else:
            return ((player.round_number > num_test + start_round) and (player.round_number <= num_test + num_formal) and (player.group.have_contest_winner >= 2))

    def js_vars(player: Player):
        return dict(
            max_price = C.PRICE_MAX,
            refresh_freq = round(player.session.config["price_tick"] * 500)
        )

class EnglishEndWaitPage(WaitPage):

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_honolulu"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number > num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def after_all_players_arrive(group: Group):
        players = group.get_players()
        subsession = group.subsession
        if sum([p.is_english_winner for p in players]) > 1:
            group.english_time_elapsed = group.english_max_time
        for p in players:
            if p.is_english_winner == True:
                p.english_dropout_elpased = group.english_time_elapsed
        set_payoffs(group)    
        group.english_final_price = subsession.price_start + ceil((group.english_time_elapsed - group.dutch_time_elapsed) / subsession.session.config["price_tick"])
        group.final_price = group.english_final_price

class Results(Page):

    def is_displayed(subsession: Subsession):
        num_test = subsession.session.config["num_test_rounds"]
        num_formal = subsession.session.config["num_formal_rounds"]
        start_round = subsession.session.config["start_round_honolulu"]
        if (start_round == 0):
            return (subsession.round_number <= num_test + num_formal)
        else:
            return ((subsession.round_number > num_test + start_round) and (subsession.round_number <= num_test + num_formal))
    
    def vars_for_template(player: Player):
        group = player.group
        subsession = player.subsession
        price_tick = subsession.session.config["price_tick"]
        current_price = subsession.price_start + ceil((group.english_time_elapsed - group.dutch_time_elapsed) / price_tick)
        time_elapsed = group.dutch_time_elapsed + group.english_time_elapsed
        unadjusted_payoff = player.item_value - current_price
        discount_factor = discount(subsession, time_elapsed, unadjusted_payoff)
        adjusted_payoff = round(unadjusted_payoff * discount_factor, C.PAYOFF_DIGIT)
        return dict(
            current_price = current_price,
            time_elapsed = int(time_elapsed / price_tick),
            unadjusted_payoff = unadjusted_payoff,
            discount_factor = round(discount_factor, 4),
            adjusted_payoff = adjusted_payoff
        )
    def js_vars(player: Player):
        payoff_history = "<tr><th style=\"width: 40%\">Period</th><th style=\"width: 30%\">Item value</th><th style=\"width: 30%\">Payoff</th></tr>"
        for p in player.in_all_rounds():
            payoff_history += "<tr><td>" + str(p.round_number) + "</td><td>" + str(p.item_value) + " points</td><td>" + str(p.payoff) + " points</td></tr>"
        payoff_history += "<tr><th>" + "Total" + "</th><th>&nbsp;</th><th>" + str(player.participant.honolulu_payoff) + " points</th></tr>"
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
    ContestPage,
    WaitEnglishStart,
    EPage,
    EnglishEndWaitPage,
    Results,
]
