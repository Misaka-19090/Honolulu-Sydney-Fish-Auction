from otree.api import *
from sqlalchemy import true

doc = """
Cong.Tao@student.uts.edu.au
"""

class C(BaseConstants):
    NAME_IN_URL = 'presurvey'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 1

class Subsession(BaseSubsession):
    pass

class Group(BaseGroup):
    pass

class Player(BasePlayer):
    pass

#FUNCTIONS

def live_pwd(player: Player, data):
    if data == player.session.code:
        flag = True
    else:
        flag = False
    return {
        player.id_in_group: dict(
            flag = flag
        )
    }

# PAGES
class Introduction(Page):

    def vars_for_template(player: Player):
        return dict(
            rate = player.session.config["real_world_currency_per_point"],
            fee = player.session.config["participation_fee"],
        )

class SurveyPage(Page):

    live_method = live_pwd

    def vars_for_template(player: Player):
        url1 = "https://manoahawaiiss.az1.qualtrics.com/jfe/form/SV_1ES7ptDW7mqp1Gu?"
        url2 = "participant_code=" + player.participant.code + "&participant_label=" + str(player.participant.label) + "&password=" + player.session.code
        return dict(
            player_url = url1 + url2,
        )

class AfterSurveyWaitPage(WaitPage):
    pass

page_sequence = [
    Introduction,
    SurveyPage,
    AfterSurveyWaitPage,
]
