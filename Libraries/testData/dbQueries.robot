*** Settings ***
Resource          ../../Libraries/testData/subscription_Optin.robot
Resource          ../../Libraries/testData/onDemand_Optin.robot
Resource          genericData.robot
Resource        ../configurations.robot

*** Variables ***
# Suscription related queries #

${isSubscripitonActive1}    select count(*) from sub_subscriber_detail where ssd_active = 'A' and ssd_source_msisdn = '${subscription_msisdn}' and ssd_keyword = '${subscription_keyword1}'
${getSubscriptionId1}    select ssd_id from sub_subscriber_detail where ssd_active = 'A' and ssd_source_msisdn = '${subscription_msisdn}' and ssd_keyword = '${subscription_keyword1}'

${isSubscripitonActive2}    select count(*) from sub_subscriber_detail where ssd_active = 'A' and ssd_source_msisdn = '${subscription_msisdn}' and ssd_keyword = '${subscription_keyword2}'
${getSubscriptionId2}    select ssd_id from sub_subscriber_detail where ssd_active = 'A' and ssd_source_msisdn = '${subscription_msisdn}' and ssd_keyword = '${subscription_keyword2}'

${isSubscripitonActive3}    select count(*) from sub_subscriber_detail where ssd_active = 'A' and ssd_source_msisdn = '${subscription_msisdn}' and ssd_keyword = '${subscription_keyword3}'
${getSubscriptionId3}    select ssd_id from sub_subscriber_detail where ssd_active = 'A' and ssd_source_msisdn = '${subscription_msisdn}' and ssd_keyword = '${subscription_keyword3}'

${isSubscriptionOptinSessionActive1}       select count(*) from cgw_validate_optin_session where cvos_msisdn = '${subscription_msisdn}' and CVOS_FIRST_ACTIVITY_DTIME > trunc(sysdate) and cvos_shortcode = '${Subscription_shortcode1}' and cvos_pkg_keyword = '${Subscription_keyword1}'
${isSubscriptionOptinSessionActive2}       select count(*) from cgw_validate_optin_session where cvos_msisdn = '${subscription_msisdn}' and CVOS_FIRST_ACTIVITY_DTIME > trunc(sysdate) and cvos_shortcode = '${Subscription_shortcode2}' and cvos_pkg_keyword = '${Subscription_keyword2}'
${isSubscriptionOptinSessionActive3}       select count(*) from cgw_validate_optin_session where cvos_msisdn = '${subscription_msisdn}' and CVOS_FIRST_ACTIVITY_DTIME > trunc(sysdate) and cvos_shortcode = '${Subscription_shortcode3}' and cvos_pkg_keyword = '${Subscription_keyword3}'

${getSubscriptionTransactionId1}    select * from (select td_transaction_id from transaction_details where TD_CREATED_DATE > trunc(sysdate) and td_msisdn = ${subscription_msisdn} and td_content_id != 0 and td_origin_id = ${Subscription_shortcode1} order by td_event_time_stamp desc) where ROWNUM=1
${getSubscriptionTransactionId2}    select * from (select td_transaction_id from transaction_details where TD_CREATED_DATE > trunc(sysdate) and td_msisdn = ${subscription_msisdn} and td_content_id != 0 and td_origin_id = ${Subscription_shortcode2} order by td_event_time_stamp desc) where ROWNUM=1
${getSubscriptionTransactionId3}    select * from (select td_transaction_id from transaction_details where TD_CREATED_DATE > trunc(sysdate) and td_msisdn = ${subscription_msisdn} and td_content_id != 0 and td_origin_id = ${Subscription_shortcode3} order by td_event_time_stamp desc) where ROWNUM=1

${getTransactionId}    select * from (select td_transaction_id from transaction_details where td_msisdn = ${prepaid_msisdn} and td_origin_id = ${originId} order by td_event_time_stamp desc) where ROWNUM=1

${updateAccountBalSubscription}    update Subscriber set Account_balance = 9999999 where Sub_id='${subscription_msisdn}'
${getAccountBalSubscription}    select Account_balance from Subscriber where Sub_id='${subscription_msisdn}'
${getProviderId}    select cpm_id from content_partner_master where cpm_code = '${providerName}'

# onDemand realted queries #
${isonDemandOptinSessionActive1}       select count(*) from cgw_validate_optin_session where cvos_msisdn = '${onDemand_msisdn}' and CVOS_FIRST_ACTIVITY_DTIME > trunc(sysdate) and cvos_shortcode = '${onDemand_shortcode1}' and cvos_pkg_keyword = '${onDemand_keyword1}'
${isonDemandOptinSessionActive2}       select count(*) from cgw_validate_optin_session where cvos_msisdn = '${onDemand_msisdn}' and CVOS_FIRST_ACTIVITY_DTIME > trunc(sysdate) and cvos_shortcode = '${onDemand_shortcode2}' and cvos_pkg_keyword = '${onDemand_keyword2}'
${isonDemandOptinSessionActive3}       select count(*) from cgw_validate_optin_session where cvos_msisdn = '${onDemand_msisdn}' and CVOS_FIRST_ACTIVITY_DTIME > trunc(sysdate) and cvos_shortcode = '${onDemand_shortcode3}' and cvos_pkg_keyword = '${onDemand_keyword3}'

${getOnDemandTransactionId1}    select * from (select td_transaction_id from transaction_details where TD_CREATED_DATE > trunc(sysdate) and td_msisdn = ${onDemand_msisdn} and td_content_id = 0 and td_origin_id = ${onDemand_shortcode1} order by td_event_time_stamp desc) where ROWNUM=1
${getOnDemandTransactionId2}    select * from (select td_transaction_id from transaction_details where TD_CREATED_DATE > trunc(sysdate) and td_msisdn = ${onDemand_msisdn} and td_content_id = 0 and td_origin_id = ${onDemand_shortcode2} order by td_event_time_stamp desc) where ROWNUM=1
${getOnDemandTransactionId3}    select * from (select td_transaction_id from transaction_details where TD_CREATED_DATE > trunc(sysdate) and td_msisdn = ${onDemand_msisdn} and td_content_id = 0 and td_origin_id = ${onDemand_shortcode3} order by td_event_time_stamp desc) where ROWNUM=1

${updateAccountBalonDemand}    update Subscriber set Account_balance = 9999999 where Sub_id='${onDemand_msisdn}'
${getAccountBalonDemand}    select Account_balance from Subscriber where Sub_id='${onDemand_msisdn}'

# Generic #
${latestNotification}    select * from (select cshl_message from cgw_sbnotification_history_log where cshl_mobile_no = '${subscription_msisdn}' and cshl_dtime > trunc(sysdate) order by cshl_dtime desc) where ROWNUM=1
${duplicate_optin_notification}    Dear Subscriber, Opt-in session already available for the package

# GUI related #
${isOnDemandOptinEnabled}    select SOC_STATUS from SUB_OPT_IN_CONFIG where SOC_OPT_IN_TYPE ='O'
${isOnDemandOptinBasedOnTariffEnabled}    select SOC_ON_TARIFF_FLG from SUB_OPT_IN_CONFIG where SOC_OPT_IN_TYPE ='O'
${isCaptchaEnabled}    select acm_keyvalue from APPLICATION_CONFIG_MASTER where acm_keyname = 'SIA_CONF_CHRG_PAGE_CAPTCHA_ENABLE' and acm_status = 'Y'

${isSubscriptionOptinEnabled}    select SOC_STATUS from SUB_OPT_IN_CONFIG where SOC_OPT_IN_TYPE ='S'
${isSubscriptionBasedOnTariffEnabled}    select SOC_ON_TARIFF_FLG from SUB_OPT_IN_CONFIG where SOC_OPT_IN_TYPE ='S'
${maxConfiguredOptinLevel}    select SOC_MAX_LEVEL_CONF from SUB_OPT_IN_CONFIG where SOC_OPT_IN_TYPE ='S'

#######################################            RQ-1345 Bulk Upload related queries            ########################################

${file_delimiter}    select acm_keyvalue from application_config_master where acm_keyname = 'FILE_DELIMITER'
${max_file_rows}    select acm_keyvalue from application_config_master where acm_keyname = 'MAX_FILE_ROWS'
${get_CGW_CP_TARIFF_MASTER_count_subscription_OY}    select count(1) from CGW_CP_TARIFF_MASTER where ctm_short_code = '8880' and ctm_apply_optin = 'Y' and ctm_is_subscription = 'Y'
${get_CGW_CP_TARIFF_MASTER_count_subscription_ON}    select count(1) from CGW_CP_TARIFF_MASTER where ctm_short_code = '8880' and ctm_apply_optin = 'N' and ctm_is_subscription = 'Y'

#######################################            ChargingService related queries            ########################################

${cs_getSubscriptionId1}    select ssd_id from sub_subscriber_detail where ssd_active = 'A' and ssd_source_msisdn = '${msisdn}' and ssd_keyword = '${keyword_subscription1}'
${cs_getSubscriptionTransactionId1}    select * from (select td_transaction_id from transaction_details where TD_CREATED_DATE > trunc(sysdate) and td_msisdn = ${msisdn} and td_content_id != 0 and td_origin_id = ${shortcode_subs1} order by td_event_time_stamp desc) where ROWNUM=1
${cs_isSubscripitonActive1}    select count(*) from sub_subscriber_detail where ssd_active = 'A' and ssd_source_msisdn = '${msisdn}' and ssd_keyword = '${keyword_subscription1}'

${cs_getOnDemandTransactionId1}    select * from (select td_transaction_id from transaction_details where TD_CREATED_DATE > trunc(sysdate) and td_msisdn = ${msisdn} and td_content_id = 0 and td_origin_id = ${shortcode_ondemand1} order by td_event_time_stamp desc) where ROWNUM=1
${cs_getOnDemandTransactionId1_post}    select * from (select td_transaction_id from transaction_details where TD_CREATED_DATE > trunc(sysdate) and td_msisdn = ${postpaid_msisdn} and td_content_id = 0 and td_origin_id = ${shortcode_ondemand1} order by td_event_time_stamp desc) where ROWNUM=1

${cs_getSubscriptionId1_post}    select ssd_id from sub_subscriber_detail where ssd_active = 'A' and ssd_source_msisdn = '${postpaid_msisdn}' and ssd_keyword = '${keyword_subscription1}'
${cs_getSubscriptionTransactionId1_post}    select * from (select td_transaction_id from transaction_details where TD_CREATED_DATE > trunc(sysdate) and td_msisdn = ${postpaid_msisdn} and td_content_id != 0 and td_origin_id = ${shortcode_subs1} order by td_event_time_stamp desc) where ROWNUM=1
${cs_isSubscripitonActive1_post}    select count(*) from sub_subscriber_detail where ssd_active = 'A' and ssd_source_msisdn = '${postpaid_msisdn}' and ssd_keyword = '${keyword_subscription1}'