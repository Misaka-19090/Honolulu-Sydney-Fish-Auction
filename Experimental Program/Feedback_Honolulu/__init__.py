from otree.api import *
from markupsafe import Markup
import random

doc = """
Cong.Tao@student.uts.edu.au
"""

class C(BaseConstants):
    NAME_IN_URL = 'feedback_h'
    PLAYERS_PER_GROUP = None
    NUM_ROUNDS = 1

class Subsession(BaseSubsession):
    pass

class Group(BaseGroup):
    pass

def scale_field(label):
    return models.IntegerField(
        choices = [1, 2, 3, 4, 5, 6, 7],
        label = label,
        widget = widgets.RadioSelectHorizontal,
    )

def scale_field_allowempty(label):
    return models.IntegerField(
        choices = [1, 2, 3, 4, 5, 6, 7],
        label = label,
        widget = widgets.RadioSelectHorizontal,
        blank = True,
    )

class Player(BasePlayer):
    auc0 = models.IntegerField(
        choices = [
            [1, "always bought the object."],
            [2, "sometimes bought the object, and sometimes not."],
            [3, "never bought the object."],
        ],
        label = Markup("For every period in the auction, I"),
        widget = widgets.RadioSelectHorizontal,
    )
    auc1 = scale_field(
        label = Markup("When I bid, all I cared about was buying as fast as possible.")
    )
    auc2 = scale_field(
        label = Markup("When I bid, all I cared about was paying the lowest price possible.")
    )
    auc3 = scale_field_allowempty(
        label = Markup("When I bought the object, I often thought that I could have bought it at a lower price if I bid differently.")
    )
    auc4 = scale_field_allowempty(
        label = Markup("When I did not buy the object, I often thought that I could have bought it and made a profit if I bid differently.")
    )
    auc5 = scale_field_allowempty(
        label = Markup("When I bought an object in the auction, I felt:")
    )
    auc6 = scale_field_allowempty(
        label = Markup("When I did not buy an object in the auction, I felt:")
    )

#FUNCTIONS

# PAGES

class Survey(Page):
    form_model = "player"
    
    def get_form_fields(player):
        random.seed(player.participant.code)
        return random.sample(["auc%d" % i for i in range(1, 5)], 4) + ["auc5", "auc6", "auc0"]

    def vars_for_template(player: Player):
        return dict(
            
        )

class AfterSurveyWaitpage(WaitPage):
    wait_for_all_groups = True

page_sequence = [
    Survey,
    AfterSurveyWaitpage,
]
