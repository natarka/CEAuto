*** Settings ***
Documentation     Optin Data related to OnDemand

*** Variables ***
#### General Variables ####
${onDemand_msisdn}    0051121202

# Global Level #

${onDemand_accept keyword}    AUTO_CONFIRM
${onDemand_reject keyword}    AUTO_REJECT
${onDemand_accept_alias_keyword}    AUTO_PROCEED
${onDemand_reject_alias keyword}    AUTO_REJ


${onDemand_global_accept_notification}    Global OnDemand Optin: Reply [ACCEPT_KEYWORD] to accept else [REJECT_KEYWORD] to reject to shortcode [SHORT_CODE] for the requested KEYWORD [REQUESTED_KWD]
${onDemand_refuse notification}    OnDemand: Dear Subscriber, you have rejected the content [REQUESTED_KWD]. No more notifications will be sent. Thanks.
${onDemand_expiry notification}    OnDemand: Dear Subscriber, you did not respond for the content [REQUESTED_KWD]. No more notifications will be sent. Thanks.

########### Tariff Level ###########

#Keyword where optin, WAP captcha is enabled and notification is configured at tariff level
${onDemand_keyword1}    AUTO_ZOOZOO_OD1
${onDemand_tariff1}    1948
${onDemand_shortcode1}    9990
${onDemand_expected_global_notification1}    Global OnDemand Optin: Reply ${onDemand_accept keyword} to accept else ${onDemand_reject keyword} to reject to shortcode ${onDemand_shortcode1} for the requested KEYWORD ${onDemand_keyword1}
${onDemand_tariff_level_notification1}    Tariff Level OD- Reply [ACCEPT_KEYWORD] to accept else [REJECT_KEYWORD] to reject to shortcode [SHORT_CODE] for the request KEYWORD [REQUESTED_KWD]
${onDemand_expected_tariff_level_notification1}    Tariff Level OD- Reply ${onDemand_accept keyword} to accept else ${onDemand_reject keyword} to reject to shortcode ${onDemand_shortcode1} for the request KEYWORD ${onDemand_keyword1}
${onDemand_expected_refuse_notification1}    OnDemand: Dear Subscriber, you have rejected the content ${onDemand_keyword1}. No more notifications will be sent. Thanks.
${onDemand_expected_expiry notification1}    OnDemand: Dear Subscriber, you did not respond for the content ${onDemand_keyword1}. No more notifications will be sent. Thanks.

#Keyword where optin is enabled, notification is not configured(blank) and WAP captcha is disabled at tariff level
${onDemand_keyword2}    AUTO_ZOOZOO_OD2
${onDemand_tariff2}    1949
${onDemand_expected_global_notification2}    Global OnDemand Optin: Reply ${onDemand_accept keyword} to accept else ${onDemand_reject keyword} to reject to shortcode ${onDemand_shortcode2} for the requested KEYWORD ${onDemand_keyword2}
${onDemand_expected_refuse_notification2}    OnDemand: Dear Subscriber, you have rejected the content ${onDemand_keyword2}. No more notifications will be sent. Thanks.
${onDemand_expected_expiry notification2}    OnDemand: Dear Subscriber, you did not respond for the content ${onDemand_keyword2}. No more notifications will be sent. Thanks.
${onDemand_tariff_level_notification2}
${onDemand_shortcode2}    9991

#Keyword where optin is disabled at tariff level
${onDemand_keyword3}    AUTO_ZOOZOO_OD3
${onDemand_tariff3}    125
${onDemand_shortcode3}    9992