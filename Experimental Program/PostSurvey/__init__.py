from otree.api import *
from markupsafe import Markup
import random

doc = """
Cong.Tao@student.uts.edu.au
"""

class C(BaseConstants):
    NAME_IN_URL = 'postsurvey'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 1

class Subsession(BaseSubsession):
    pass

class Group(BaseGroup):
    pass

class Player(BasePlayer):
    pass

#FUNCTIONS

# PAGES
class Introduction(Page):

    def vars_for_template(player: Player):
        return dict(

        )

class Survey(Page):

    def vars_for_template(player: Player):
        url1 = "https://manoahawaiiss.az1.qualtrics.com/jfe/form/SV_5v8RwYe5yzNM7EG?"
        url2 = "participant_code=" + player.participant.code + "&participant_label=" + str(player.participant.label) + "&password=" + player.session.code
        return dict(
            player_url = url1 + url2,
        )

    def before_next_page(player: Player, timeout_happened):
        player.participant.payoff *= player.session.config["real_world_currency_per_point"]

class Results(Page):
    
    def vars_for_template(player: Player):
        return dict(
            total_point = player.participant.dutch_payoff + player.participant.honolulu_payoff
        )

page_sequence = [
    Introduction,
    Survey,
    Results,
]
