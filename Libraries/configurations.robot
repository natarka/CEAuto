*** Variables ***
${testServer}     172.20.39.82
${adminUIPort}    8080
${smppSimPort}    8888
${sshUser}        ceadmin43
${sshPassword}    ceadmin43
${URL}            http://${testServer}:${adminUIPort}/ce-admin/login.htm    #Admin UI URL under test
${browser}        chrome    # Browser to use
${UserName}       robots    # User ID
${Password}       @demo123    # Password
${MDXUserName}       MdxAdmin    # MDX User ID
${MDXPassword}       @demo1234    # MDX Password
${dbUser}         SIT_CE43    # database user
${dbPassword}     SIT_CE43    # database password
${oracle_service_name}    SITDB    # Service Name
${sybaseServer}    172.20.41.72
${sybasePort}     5000
${sybaseDB}       PP_DB
${sybaseUser}     sa
${sybasePassword}    password
${email}    auto@tecnotree.com
${contact_number}    1234567890
## Webservice URL
${submit_sm}      {EMPTY}
## MO Simulator URL
${moURL}          http://${testServer}:${smppSimPort}
${wsdl}           http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService?wsdl
${wsdlUrl}        http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService
${cpUser}         automationcp
${cpPass}         @demo123
${cp_id}          60155
${cdrPath}        /home/ceadmin43/data/cdr/
${wapCaptchaPath}    /home/ceadmin43/data/wap/captcha/
${moGetUrl}       http://${testServer}:${smppSimPort}/inject_mo?
#SMSG/SMSC Configurations
${smsgName}    automationsmsg
${smscName}    automationsmsc
${smscIP}    172.20.39.82
${smscRxPort}    2775
${smscTxPort}    9699
${smscTRxPort}    9699
#Transmitter
${TxSystemId}    ceadmin43
${TxPassword}    ceadmin43
#Receiver
${RxSystemId}    smppclient1
${RxPassword}    password
#Application
${app_name_ondemand}    auto_ondemand
${app_name_ondemand1}    auto_appln_ondemand1
${app_name_ondemand2}    auto_appln_ondemand2
${app_name_ondemand3}    auto_appln_ondemand3
${app_name_subs}    auto_subs
${app_name_subs1}    auto_appln_subs1
${app_name_subs2}    auto_appln_subs2
${app_name_subs3}    auto_appln_subs3
#delivery channel
${delivery_channel}    SMS
#content type
${content_name_ondemand}    auto_content_ondemand
${content_name_ondemand1}    auto_content_ondemand1
${content_name_ondemand2}    auto_content_ondemand2
${content_name_ondemand3}    auto_content_ondemand3
${content_name_subs}    auto_content_subs
${content_name_subs1}    auto_content_subs1
${content_name_subs2}    auto_content_subs2
${content_name_subs3}    auto_content_subs3
${content_name_wap}    auto_content_wap
#Short Code Page
${category}    BASIC
${shortcode_ondemand}    2503
${shortcode_ondemand1}    9990
${shortcode_ondemand2}    9991
${shortcode_ondemand3}    9992
${shortcode_subs}    2504
${shortcode_subs1}    8880
${shortcode_subs2}    8881
${shortcode_subs3}    8882
#Tariff Configuration
${tax}    FLAT
${price}    10
${minPrice}    7
${shipmentPrice}    1
${commission}    1
${keyword_ondemand}		AUTOONDEMAND
${keyword_ondemand1}		AUTO_ZOOZOO_OD1
${keyword_ondemand2}		AUTO_ZOOZOO_OD2
${keyword_ondemand3}		AUTO_ZOOZOO_OD3
${keyword_subscription}		AUTOSUBSCRIPTION
${keyword_subscription1}		AUTO_ZOOZOO1
${keyword_subscription2}		AUTO_ZOOZOO2
${keyword_subscription3}		AUTO_ZOOZOO3
${keyword_optin1}    AUTO_YUP
${keyword_optin2}    AUTO_SURE
${keyword_optin3}    AUTO_CONFIRM
${keyword_optin3_alias}    AUTO_PROCEED
${keyword_reject1}    AUTO_NO
${keyword_reject2}    AUTO_REJECT
${keyword_reject2_alias}    AUTO_REJ
${cp_notif_url}    http://172.20.39.23:9902/cdc-service/services/CPNotificationServiceMock/
#Subscription Configuration
${subs_pkg_name}    automationPackage
${subs_pkg_id}    98765
${subs_pkg_dur}    5
${subs_pkg_name1}    Auto_ZooZooPack
${subs_pkg_id1}    98764
${subs_pkg_dur1}    5
${subs_pkg_name2}    Auto_ZooZooPack_2
${subs_pkg_id2}    98763
${subs_pkg_dur2}    5
${subs_pkg_name3}    Auto_ZooZooPack_3
${subs_pkg_id3}    98762
${subs_pkg_dur3}    5
#Done for RQ-1354
${external_user}    espn
${external_password}    @demo123
${external_central_user}    amxhub
${external_central_password}    @demo123
${providerId}    46100
${applicationId}    25031
${applicationId1}    25032
${serviceId}    25033
${serviceId1}    25034
${originId}    5555
${originId1}    5566
${prepaid_msisdn}    0051121203
${postpaid_msisdn}    0051999999999
${contentId}    0
${contentDescription}    espn ondemand
${keyword}    DEFAULT
${packageId}    56051
${contentName}    CONTENT
${contentName1}    CONTENT2
${date}    20170901120000
${currency}    AUP

${SIATransactionService_wsdl}    http://${testServer}:${adminUIPort}/siaarg/services/SIATransactionService?wsdl
${SIATransactionService_url}    http://${testServer}:${adminUIPort}/siaarg/services/SIATransactionService/
${SIAConfCharge_url}    http://${testServer}:${adminUIPort}/siaarg/jsp/confcharge.jsp?_transactionId=

${subscriptionService_wsdl}    http://${testServer}:${adminUIPort}/cdc-service/services/CESubscriptionService?wsdl
${subscriptionService_url}    http://${testServer}:${adminUIPort}/cdc-service/services/CESubscriptionService/

${chargingService_wsdl}    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService?wsdl
${chargingService_url}    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/


#RQ-1345 Bulk Upload related configurations
${ktm_base_directory}    D:/KTM/
${ktm_global_valid_file_delimiter}    |
${ktm_max_file_rows}    10
${ktm_global_invalid_file_delimiter}    ,

${ktm_valid_cp_id}    42050
${ktm_invalid_cp_id}    0000    

${ktm_valid_MO_traffic_type}    MO
${ktm_valid_MT_traffic_type}    MT
${ktm_invalid_traffic_type}    MR

${ktm_valid_service_type}    SMS
${ktm_invalid_service_type}    USSD

${ktm_valid_onDemand_short_code}    1947
${ktm_valid_subscription_short_code}    1947
${ktm_invalid_short_code}    0000

${ktm_valid_tariffID}    NORMAL-1948
${ktm_valid_packageID}    SUBSCRIPTION-57050
${ktm_invalid_tariffID}    NORMAL-12345
${ktm_invalid_packageID}    SUBSCRIPTION-00000
${ktm_null_chargecode}    

${ktm_valid_onDemand_keyword}    BULK_OD_01
${ktm_valid_subscription_keyword}    BULK_SUBS_02
# ${ktm_valid_subscription_keyword}    AUTO_ZOOZOO
${ktm_valid_new_onDemand_keyword}    BULK_OD_11
${ktm_valid_new_subscription_keyword}    BULK_SUBS_12
${ktm_null_subscription_keyword}


${ktm_valid_allow_param_no}    N
${ktm_valid_allow_param_yes}    Y
${ktm_invalid_allow_param}    P
${ktm_null_allow_param}

${ktm_valid_allow_optin_no}    N
${ktm_valid_allow_optin_yes}    Y
${ktm_invalid_allow_optin}    S
${ktm_null_allow_optin}

${ktm_valid_subs_optin_notification}    Bulk Upload Tariff Level Subscription: Reply [ACCEPT_KEYWORD] to accept else [REJECT_KEYWORD] to reject to shortcode [SHORT_CODE] for the request KEYWORD [REQUESTED_KWD]
${ktm_valid_onDemand_optin_notification}    Bulk Upload Tariff Level OnDemand: Reply [ACCEPT_KEYWORD] to accept else [REJECT_KEYWORD] to reject to shortcode [SHORT_CODE] for the request KEYWORD [REQUESTED_KWD]
${ktm_notification_upto_320_characters}    Bulk upload Notification more than 320 characters. Bulk upload Notification more than 320 characters. Bulk upload Notification more than 320 characters. Bulk upload Notification more than 320 characters. Bulk upload Notification more than 320 characters. Bulk upload Notification more than 320 characters. End End End
${ktm_empty_notification}    nomsg
${ktm_null_notification}
#End OF RQ-1345 Bulk Upload related configurations