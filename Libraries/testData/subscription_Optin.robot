*** Settings ***
Documentation     Optin Data related to Subscription

*** Variables ***
#### General Variables ####
${subscription_msisdn}    0051121202

# Global Level #

${subscription_1st_level_accept keyword}    AUTO_YUP
${subscription_2nd_level_accept keyword}    AUTO_SURE
${subscription_1st_level_reject keyword}    AUTO_REJECT
${subscription_2nd_level_reject keyword}    AUTO_NO

${subscription_global_1st_level_optin_notification}    Global 1st level Optin: Reply [ACCEPT_KEYWORD] to accept else [REJECT_KEYWORD] to reject to shortcode [SHORT_CODE] for the requested KEYWORD [REQUESTED_KWD]
${subscription_global_2nd_level_optin_notification}    Global 2nd level Optin: Reply [ACCEPT_KEYWORD] to accept else [REJECT_KEYWORD] to reject to shortcode [SHORT_CODE] for the requested KEYWORD [REQUESTED_KWD]
${subscription_refuse notification}    Subscription: Dear Subscriber, you have rejected the request for subscription [REQUESTED_KWD]. No more notifications will be sent. Thanks.
${subscription_expiry notification}    Subscription: Dear Subscriber, you did not respond for the subscription [REQUESTED_KWD]. No more notifications will be sent. Thanks.
${subscription_periodicity_notification}    Global 1st level Optin: Reply [ACCEPT_KEYWORD] to accept else [REJECT_KEYWORD] to reject to shortcode [SHORT_CODE] for the requested KEYWORD [REQUESTED_KWD] of validity [PERIODICITY]

########### Tariff Level ###########

#Keyword where optin, WAP captcha is enabled and notification is configured at tariff level
${subscription_keyword1}    AUTO_ZOOZOO1
${pakage_name1}    Auto_ZooZooPack
${subscription_tariff1}    1947
${subscription_shortcode1}    8880
${PPIN_charged_price}    1232000
${subscription_expected_1st_level_global_notification1}    Global 1st level Optin: Reply ${subscription_1st_level_accept keyword} to accept else ${subscription_1st_level_reject keyword} to reject to shortcode ${subscription_shortcode1} for the requested KEYWORD ${subscription_keyword1}
${subscription_expected_2nd_level_global_notification1}    Global 2nd level Optin: Reply ${subscription_2nd_level_accept keyword} to accept else ${subscription_2nd_level_reject keyword} to reject to shortcode ${subscription_shortcode1} for the requested KEYWORD ${subscription_keyword1}
${subscription_tariff_level_notification1}    Tariff Level subscription- Reply [ACCEPT_KEYWORD] to accept else [REJECT_KEYWORD] to reject to shortcode [SHORT_CODE] for the request KEYWORD [REQUESTED_KWD]
${subscription_expected_tariff_level_notification1}    Tariff Level subscription- Reply ${subscription_1st_level_accept keyword} to accept else ${subscription_1st_level_reject keyword} to reject to shortcode ${subscription_shortcode1} for the request KEYWORD ${subscription_keyword1}
${subscription_expected_refuse_notification1}    Subscription: Dear Subscriber, you have rejected the request for subscription ${subscription_keyword1}. No more notifications will be sent. Thanks.
${subscription_expected_expiry notification1}    Subscription: Dear Subscriber, you did not respond for the subscription ${subscription_keyword1}. No more notifications will be sent. Thanks.
${subscription_expected_periodicity_notification1}    Global 1st level Optin: Reply ${subscription_1st_level_accept keyword} to accept else ${subscription_1st_level_reject keyword} to reject to shortcode ${subscription_shortcode1} for the requested KEYWORD ${subscription_keyword1} of validity${space}

#Keyword where optin is enabled, notification is not configured(blank) and WAP captcha is disabled at tariff level
${subscription_keyword2}    AUTO_ZOOZOO2
${pakage_name2}    Auto_ZooZooPack_2
${subscription_tariff2}    1950
${subscription_shortcode2}    8881
${subscription_expected_1st_level_global_notification2}    Global 1st level Optin: Reply ${subscription_1st_level_accept keyword} to accept else ${subscription_1st_level_reject keyword} to reject to shortcode ${subscription_shortcode2} for the requested KEYWORD ${subscription_keyword2}
${subscription_expected_2nd_level_global_notification2}    Global 2nd level Optin: Reply ${subscription_2nd_level_accept keyword} to accept else ${subscription_2nd_level_reject keyword} to reject to shortcode ${subscription_shortcode2} for the requested KEYWORD ${subscription_keyword2}
${subscription_expected_refuse_notification2}    Subscription: Dear Subscriber, you have rejected the request for subscription ${subscription_keyword2}. No more notifications will be sent. Thanks.
${subscription_expected_expiry notification2}    Subscription: Dear Subscriber, you did not respond for the subscription ${subscription_keyword2}. No more notifications will be sent. Thanks.
${subscription_expected_periodicity_notification2}    Global 1st level Optin: Reply ${subscription_1st_level_accept keyword} to accept else ${subscription_1st_level_reject keyword} to reject to shortcode ${subscription_shortcode2} for the requested KEYWORD ${subscription_keyword2} of validity 

#Keyword where optin is disabled at tariff level
${subscription_keyword3}    AUTO_ZOOZOO3
${pakage_name2}    Auto_ZooZooPack_3
${subscription_tariff3}    164
${subscription_shortcode3}    8882

#Periodicity related
${1_day}    1
${6_day}    6
${7_day}    7
${8_day}    8
${9_day}    9
${14_day}    14
${22_day}    22
${27_day}    27
${30_day}    30
${31_day}    31
${40_day}    40
${60_day}    60
${91_day}    91
${140_day}    140
${180_day}    180
${periodicity_replacement}    dia#dias#semanal#semana#semanas#mensual#mes#meses#semestral#and#N#${SPACE}