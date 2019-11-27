*** Settings ***
Documentation     Generic Test Data

*** Variables ***
#### General Variables ####
${slide_by_30}    30
${slide_by_40}    40
${slide_by_50}    50
${already_logedin_alert}    {EMPTY}
### Delays ###
${micro_sleep}    2s
${small_sleep}    5s
${large_sleep}    10s
${xlarge_sleep}    30s
${minute_sleep}    60s
${2.5minute_sleep}    180S
${providerId}     42050
${providerName}    automationcp
${applicationId}    3579
${serviceId}      3344
${originId}       1947
${msisdn}         0051121202
${postpaid_msisdn}    0051999999999
${contentId}      49050
${contentDescription1}    RobotTests
${wap_captcha_cmd}      | tail -1 | awk 'BEGIN {FS="_"}{print $2}'
