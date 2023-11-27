from os import environ

SESSION_CONFIGS = [
    dict(
        name = "02_D1H2",
        app_sequence = ["PreSurvey", "Dutch2", "Feedback_Dutch", "Honolulu2", "Feedback_Honolulu", "PostSurvey"],
        display_name = "2 Players Per Group_Dutch first",
        num_demo_participants = 2,
    ),
    dict(
        name = "05_D1H2",
        app_sequence = ["PreSurvey", "Dutch5", "Feedback_Dutch", "Honolulu5", "Feedback_Honolulu", "PostSurvey"],
        display_name = "5 Players Per Group_Dutch first",
        num_demo_participants = 5,
    ),
    dict(
        name = "02_D2H1",
        app_sequence = ["PreSurvey", "Honolulu2", "Feedback_Honolulu", "Dutch2", "Feedback_Dutch", "PostSurvey"],
        display_name = "2 Players Per Group_Honolulu first",
        num_demo_participants = 2,
    ),
    dict(
        name = "05_D2H1",
        app_sequence = ["PreSurvey", "Honolulu5", "Feedback_Honolulu", "Dutch5", "Feedback_Dutch", "PostSurvey"],
        display_name = "5 Players Per Group_Honolulu first",
        num_demo_participants = 5,
    ),
    dict(
        name = "testpresurvey",
        app_sequence = ["PreSurvey"],
        display_name = "Test Pre Survey",
        num_demo_participants = 1,
    ),
    dict(
        name = "testfeedback",
        app_sequence = ["Feedback_Dutch"],
        display_name = "Test Feedback",
        num_demo_participants = 1,
    ),
    dict(
        name = "testpostsurvey",
        app_sequence = ["PostSurvey"],
        display_name = "Test Post Survey",
        num_demo_participants = 1,
    ),
]

# if you set a property in SESSION_CONFIG_DEFAULTS, it will be inherited by all configs
# in SESSION_CONFIGS, except those that explicitly override it.
# the session config can be accessed from methods in your apps as self.session.config,
# e.g. self.session.config['participation_fee']

SESSION_CONFIG_DEFAULTS = dict(
    real_world_currency_per_point = 0.25, 
    participation_fee = 10.00, 
    doc = "",
    start_price = 21,
    discount_a = 1,
    discount_b = 0.019,
    price_tick = 1,
    num_test_rounds = 2,
    num_formal_rounds = 4,
    skip_intro_dutch = 0,
    start_round_dutch = 0,
    skip_intro_honolulu = 0,
    start_round_honolulu = 0,
)

ROOMS = [
    dict(
        name='econlab',
        display_name='Experimental Economics Lab',
        participant_label_file='rooms/econlab_participant.txt',
        #use_secure_urls=True
    ),
]

PARTICIPANT_FIELDS = ["dutch_payoff", "honolulu_payoff"]
SESSION_FIELDS = []

# ISO-639 code
# for example: de, fr, ja, ko, zh-hans
LANGUAGE_CODE = 'en'

# e.g. EUR, GBP, CNY, JPY
REAL_WORLD_CURRENCY_CODE = ""
USE_POINTS = False

ADMIN_USERNAME = 'admin'
# for security, best to set admin password in an environment variable
ADMIN_PASSWORD = environ.get('OTREE_ADMIN_PASSWORD')
OTREE_AUTH_LEVEL = "DEMO"
OTREE_PRODUCTION = 1
DEBUG = False

DEMO_PAGE_INTRO_HTML = """ """

SECRET_KEY = '8105291159150'