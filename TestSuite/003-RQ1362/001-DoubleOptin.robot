*** Settings ***
Documentation     Double Opt-in Tests
Resource          ../../Libraries/genericLibrary/commonTasks.robot    #Test Teardown    Close All Browsers
Resource          ../../Libraries/genericLibrary/dbConnections.robot
Resource          ../../Libraries/genericLibrary/webserviceTasks.robot
Resource          ../../Libraries/testData/genericData.robot
Resource          ../../Libraries/testData/subscription_Optin.robot
Resource          ../../Libraries/testData/dbQueries.robot
Resource          ../../Libraries/configurations.robot
Resource          ../../Libraries/xpathRepo/subscriptionOptInGlobalPage_xpath.robot
Resource          ../../Libraries/xpathRepo/onDemandOptInGlobalPage_xpath.robot
Resource          ../../Libraries/Resources/fireMORequestRes.robot
Resource          ../../Libraries/testData/onDemand_Optin.robot
#Test Teardown     Sleep    60s    
# Test Setup        Change Account_balance in PPIN    ${subscription_msisdn}
Suite Setup        Connect to sybase database
Suite Teardown     Close SybaseConnection

*** Test Cases ***
Test101-2
    [Tags]    OnDemand    Sanity    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    0
    # Configure OnDemand Notifications and session expiry
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification1}    str
    moRequest    ${onDemand_accept keyword}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    ${transactionID}    Get DB details    ${getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}

Test103
    [Tags]    OnDemand    Sanity    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    0    0
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    ${transactionID}    Get DB details    ${getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}


Test104-5
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    0
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification1}    str
    moRequest    ${onDemand_accept keyword}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    ${transactionID}    Get DB details    ${getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}
    

Test106
    [Tags]    OnDemand    Sanity    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    0    1
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    ${transactionID}    Get DB details    ${getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}    

Test107-09
    [Tags]    Subscription    Sanity    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    0
    Configure Subscription Notifications and session expiry
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification1}    str
    moRequest    ${subscription_1st_level_accept keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_2nd_level_global_notification1}    str
    moRequest    ${subscription_2nd_level_accept keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${isSubscripitonActive1}    1    int
    ${transactionID}    Get DB details    ${getSubscriptionTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${subscription_msisdn}    ${subscription_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${subscription_msisdn}    ${charged_price}

Test110
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    0    0
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${isSubscripitonActive1}    1    int
    ${transactionID}    Get DB details    ${getSubscriptionTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${subscription_msisdn}    ${subscription_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${subscription_msisdn}    ${charged_price}

Test115-16
    [Tags]    OnDemand    Sanity    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    0
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification1}    str
    moRequest    ${onDemand_reject keyword}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_refuse_notification1}    str
    Compare Account_balance in PPIN    ${onDemand_msisdn}    0

Test117-19
    [Tags]    Subscription    Sanity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    0
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification1}    str
    moRequest    ${subscription_1st_level_accept keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_2nd_level_global_notification1}    str
    moRequest    ${subscription_2nd_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_refuse_notification1}    str
    Compare Account_balance in PPIN    ${subscription_msisdn}    0


Test120-21
    [Tags]    Subscription    Sanity    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    0
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification1}    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_refuse_notification1}    str
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Compare Account_balance in PPIN    ${subscription_msisdn}    0
    
Test122-24
    [Tags]    OnDemand    Sanity    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    0
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification1}    str
    Log To Console    Going to sleep for ${2.5minute_sleep} seconds
    Sleep    ${2.5minute_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_expiry notification1}    str
    Compare Account_balance in PPIN    ${subscription_msisdn}    0

Test125-27
    [Tags]    Subscription    Sanity    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    0
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification1}    str
    sleep    ${2.5minute_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_expiry_notification1}    str
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Compare Account_balance in PPIN    ${subscription_msisdn}    0

Test128-129
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    # Configure periodicity    ${1_day}    ${pakage_name1}
    # GUI Update Periodicity
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}1 dia    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test130
    [Tags]    Subscription    Regression    Periodicity
    # FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    # Sleep    ${small_sleep}
    # Oracle DB query    ${isSubscripitonActive1}    0    int
    # Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${6_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}6 dias    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test131
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${7_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}semanal    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test132
    [Tags]    Subscription    Regression    Periodicity
    Sleep    ${minute_sleep}
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    # Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${14_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}2 semanas    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test133
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    # Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${8_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}1 semana and 1 dia    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test134
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    # Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${9_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}1 semana and 2 dias    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test135
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    # Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${22_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}3 semanas and 1 dia    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test136
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    # Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${27_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}3 semanas and 6 dias    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test137
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${30_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}mensual    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test138
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${40_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}1 mes and 10 dias    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test139
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${31_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}1 mes and 1 dia    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test140
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${60_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}2 meses    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test141
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    # Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${91_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}3 meses and 1 dia    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    Compare Account_balance in PPIN    ${subscription_msisdn}    0
    Configure Subscription Notifications and session expiry

Test142
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    # Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${140_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}4 meses and 20 dias    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

Test143
    [Tags]    Subscription    Regression    Periodicity
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    # Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    0
    Configure periodicity    ${180_day}    ${pakage_name1}
    # Sleep    ${micro_sleep}
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_periodicity_notification1}semestral    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
    # Configure Subscription Notifications and session expiry

# Test146-48
    # [Tags]    OnDemand    Regression    MultipleKeyword
    # Change Account_balance in PPIN    ${onDemand_msisdn}
    # OnDemand Optin    1    1
    # moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    # Sleep    ${small_sleep}
    # Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    # Oracle DB query    ${latestNotification}    ${onDemand_expected_tariff_level_notification1}    str
    # moRequest    ${onDemand_keyword2}    ${onDemand_msisdn}    ${onDemand_shortcode2}
    # Sleep    ${small_sleep}
    # Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    # Oracle DB query    ${isonDemandOptinSessionActive2}    1    int
    # Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification2}    str
    # moRequest    ${onDemand_accept keyword}    ${onDemand_msisdn}    ${onDemand_shortcode2}
    # Sleep    ${small_sleep}
    # Oracle DB query    ${isonDemandOptinSessionActive2}    0    int
    # ${transactionID}    Get DB details    ${getOnDemandTransactionId2}
    # ${CDR}    GetCDR    ${transactionID}    prepaid
    # ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword2}    ${CDR}
    # Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}

# Test146-49
    # [Tags]    OnDemand    Regression    MultipleKeyword
    # Change Account_balance in PPIN    ${onDemand_msisdn}
    # OnDemand Optin    1    1
    # moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    # Sleep    ${small_sleep}
    # Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    # Oracle DB query    ${latestNotification}    ${onDemand_expected_tariff_level_notification1}    str
    # moRequest    ${onDemand_keyword2}    ${onDemand_msisdn}    ${onDemand_shortcode2}
    # Sleep    ${small_sleep}
    # Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    # Oracle DB query    ${isonDemandOptinSessionActive2}    1    int
    # Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification2}    str
    # Log To Console    Going to sleep for ${2.5minute_sleep} seconds
    # Sleep    ${2.5minute_sleep}
    # Oracle DB query    ${isonDemandOptinSessionActive2}    0    int
    # Oracle DB query    ${latestNotification}    ${onDemand_expected_expiry notification2}    str
    # Compare Account_balance in PPIN    ${onDemand_msisdn}    0

# Test150-52
    # [Tags]    Subscription    Regression    MultipleKeyword
    # FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    # Sleep    ${small_sleep}
    # Oracle DB query    ${isSubscripitonActive1}    0    int
    # FireSOAPMethod_CancelSubscription    ${getSubscriptionId2}
    # Sleep    ${small_sleep}
    # Oracle DB query    ${isSubscripitonActive2}    0    int
    # Configure Subscription Notifications and session expiry
    # Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    1
    # moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Sleep    ${small_sleep}
    # Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    # Oracle DB query    ${latestNotification}    ${subscription_expected_tariff_level_notification1}    str
    # moRequest    ${subscription_keyword2}    ${subscription_msisdn}    ${subscription_shortcode2}
    # sleep    ${small_sleep}
    # Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    # Oracle DB query    ${isSubscriptionOptinSessionActive2}    1    int
    # Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification2}    str
    # moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode2}
    # sleep    ${small_sleep}
    # Oracle DB query    ${isSubscriptionOptinSessionActive2}    0    int
    # Oracle DB query    ${isSubscripitonActive1}    0    int
    # Oracle DB query    ${isSubscripitonActive2}    0    int
    # Oracle DB query    ${latestNotification}    ${subscription_expected_refuse_notification2}    str
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0
       
# Test150-53
    # [Tags]    Subscription    Regression    MultipleKeyword
    # Change Account_balance in PPIN    ${subscription_msisdn}
    # Subscription Optin    1    1
    # moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    # Sleep    ${small_sleep}
    # Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    # Oracle DB query    ${latestNotification}    ${subscription_expected_tariff_level_notification1}    str
    # moRequest    ${subscription_keyword2}    ${subscription_msisdn}    ${subscription_shortcode2}
    # sleep    ${small_sleep}
    # Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    # Oracle DB query    ${isSubscriptionOptinSessionActive2}    1    int
    # Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification2}    str
    # sleep    ${2.5minute_sleep}
    # Oracle DB query    ${isSubscriptionOptinSessionActive2}    0    int
    # Oracle DB query    ${isSubscripitonActive1}    0    int
    # Oracle DB query    ${isSubscripitonActive2}    0    int
    # Oracle DB query    ${latestNotification}    ${subscription_expected_expiry_notification2}    str
    # Compare Account_balance in PPIN    ${subscription_msisdn}    0

Test154-56
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    1
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_tariff_level_notification1}    str
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${duplicate_optin_notification}    str
    moRequest    ${subscription_1st_level_accept keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${isSubscripitonActive1}    1    int
    ${transactionID}    Get DB details    ${getSubscriptionTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${subscription_msisdn}    ${subscription_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}    

Test157-59
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    1
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_tariff_level_notification1}    str
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${duplicate_optin_notification}    str
    moRequest    ${onDemand_accept keyword}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${large_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    ${transactionID}    Get DB details    ${getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}

Test160-61
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    1
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_tariff_level_notification1}    str
    moRequest    ${subscription_1st_level_accept keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${isSubscripitonActive1}    1    int
    ${transactionID}    Get DB details    ${getSubscriptionTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${subscription_msisdn}    ${subscription_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}
    
Test162-63
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    1
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_tariff_level_notification1}    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_refuse_notification1}    str
    Compare Account_balance in PPIN    ${subscription_msisdn}    0

Test164-65
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    1
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_tariff_level_notification1}    str
    sleep    ${2.5minute_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_expiry_notification1}    str
    Compare Account_balance in PPIN    ${subscription_msisdn}    0

Test166-67
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId2}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive2}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    1
    moRequest    ${subscription_keyword2}    ${subscription_msisdn}    ${subscription_shortcode2}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive2}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification2}    str
    moRequest    ${subscription_1st_level_accept keyword}    ${subscription_msisdn}    ${subscription_shortcode2}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive2}    0    int
    Oracle DB query    ${isSubscripitonActive2}    1    int
    ${transactionID}    Get DB details    ${getSubscriptionTransactionId2}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${subscription_msisdn}    ${subscription_keyword2}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}
    
Test168-69
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId2}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive2}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    1
    moRequest    ${subscription_keyword2}    ${subscription_msisdn}    ${subscription_shortcode2}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive2}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification2}    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode2}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive2}    0    int
    Oracle DB query    ${isSubscripitonActive2}    0    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_refuse_notification2}    str
    Compare Account_balance in PPIN    ${subscription_msisdn}    0

Test170-71
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId2}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive2}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    1
    moRequest    ${subscription_keyword2}    ${subscription_msisdn}    ${subscription_shortcode2}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive2}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification2}    str
    sleep    ${2.5minute_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive2}    0    int
    Oracle DB query    ${isSubscripitonActive2}    0    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_expiry_notification2}    str
    Compare Account_balance in PPIN    ${subscription_msisdn}    0

Test172
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId3}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive3}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    1
    moRequest    ${subscription_keyword3}    ${subscription_msisdn}    ${subscription_shortcode3}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive3}    0    int
    Oracle DB query    ${isSubscripitonActive3}    1    int
    ${transactionID}    Get DB details    ${getSubscriptionTransactionId3}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${subscription_msisdn}    ${subscription_keyword3}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}
    
Test173-75
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    0
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification1}    str
    moRequest    ${subscription_1st_level_accept keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_2nd_level_global_notification1}    str
    moRequest    ${subscription_2nd_level_accept keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${isSubscripitonActive1}    1    int
    ${transactionID}    Get DB details    ${getSubscriptionTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${subscription_msisdn}    ${subscription_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}
    
Test176-77
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    0
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification1}    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_refuse_notification1}    str
    Compare Account_balance in PPIN    ${subscription_msisdn}    0

Test178-79
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    0
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_1st_level_global_notification1}    str
    sleep    ${2.5minute_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_expiry_notification1}    str
    Compare Account_balance in PPIN    ${subscription_msisdn}    0

Test180
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    0    0
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    1    int
    ${transactionID}    Get DB details    ${getSubscriptionTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${subscription_msisdn}    ${subscription_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}
    
Test181
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId3}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive3}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    0    0
    moRequest    ${subscription_keyword3}    ${subscription_msisdn}    ${subscription_shortcode3}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive3}    0    int
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive3}    1    int
    ${transactionID}    Get DB details    ${getSubscriptionTransactionId3}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${subscription_msisdn}    ${subscription_keyword3}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}
    
Test182-83
    [Tags]    Subscription    Regression
    FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Change Account_balance in PPIN    ${subscription_msisdn}
    Subscription Optin    1    1
    moRequest    ${subscription_keyword1}    ${subscription_msisdn}    ${subscription_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_tariff_level_notification1}    str
    moRequest    ${subscription_1st_level_reject keyword}    ${subscription_msisdn}    ${subscription_shortcode1}
    sleep    ${small_sleep}
    Oracle DB query    ${isSubscriptionOptinSessionActive1}    0    int
    Oracle DB query    ${isSubscripitonActive1}    0    int
    Oracle DB query    ${latestNotification}    ${subscription_expected_refuse_notification1}    str
    Compare Account_balance in PPIN    ${subscription_msisdn}    0

Test184-185
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    1
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_tariff_level_notification1}    str
    moRequest    ${onDemand_accept_alias_keyword}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${large_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    moRequest    ${onDemand_keyword2}    ${onDemand_msisdn}    ${onDemand_shortcode2}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive2}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification2}    str
    moRequest    ${onDemand_accept_alias_keyword}    ${onDemand_msisdn}    ${onDemand_shortcode2}
    Sleep    ${large_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive2}    0    int
    ${transactionID}    Get DB details    ${getOnDemandTransactionId2}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword2}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}
    
Test199-200
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    1
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_tariff_level_notification1}    str
    moRequest    ${onDemand_accept_keyword}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${large_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    ${transactionID}    Get DB details    ${getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}

Test201-202
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    1
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_tariff_level_notification1}    str
    moRequest    ${onDemand_reject_keyword}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${large_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_refuse_notification1}    str
    Compare Account_balance in PPIN    ${onDemand_msisdn}    0

Test203-204
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    1
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_tariff_level_notification1}    str
    Log To Console    Going to sleep for ${2.5minute_sleep} seconds
    Sleep    ${2.5minute_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_expiry_notification1}    str
    Compare Account_balance in PPIN    ${onDemand_msisdn}    0

Test205-206
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    1
    moRequest    ${onDemand_keyword2}    ${onDemand_msisdn}    ${onDemand_shortcode2}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive2}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification2}    str
    moRequest    ${onDemand_accept_keyword}    ${onDemand_msisdn}    ${onDemand_shortcode2}
    Sleep    ${large_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive2}    0    int
    Compare Account_balance in PPIN    ${onDemand_msisdn}    0

Test207-208
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    1
    moRequest    ${onDemand_keyword2}    ${onDemand_msisdn}    ${onDemand_shortcode2}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive2}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification2}    str
    moRequest    ${onDemand_reject_keyword}    ${onDemand_msisdn}    ${onDemand_shortcode2}
    Sleep    ${large_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive2}    0    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_refuse_notification2}    str
    Compare Account_balance in PPIN    ${onDemand_msisdn}    0

Test209-210
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    1
    moRequest    ${onDemand_keyword2}    ${onDemand_msisdn}    ${onDemand_shortcode2}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive2}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification2}    str
    Log To Console    Going to sleep for ${2.5minute_sleep} seconds
    Sleep    ${2.5minute_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive2}    0    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_expiry_notification2}    str
    Compare Account_balance in PPIN    ${onDemand_msisdn}    0

Test211
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    1
    moRequest    ${onDemand_keyword3}    ${onDemand_msisdn}    ${onDemand_shortcode3}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive3}    0    int
    ${transactionID}    Get DB details    ${getOnDemandTransactionId3}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword3}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}

Test212-213
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    0
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification1}    str
    moRequest    ${onDemand_accept_keyword}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${large_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    ${transactionID}    Get DB details    ${getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}

Test214-215
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    0
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification1}    str
    moRequest    ${onDemand_reject_keyword}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${large_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_refuse_notification1}    str
    Compare Account_balance in PPIN    ${onDemand_msisdn}    0

Test216-217
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    1    0
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    1    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_global_notification1}    str
    Sleep    ${2.5minute_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    Oracle DB query    ${latestNotification}    ${onDemand_expected_expiry notification1}    str
    Compare Account_balance in PPIN    ${onDemand_msisdn}    0

Test218
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    0    0
    moRequest    ${onDemand_keyword1}    ${onDemand_msisdn}    ${onDemand_shortcode1}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive1}    0    int
    ${transactionID}    Get DB details    ${getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword1}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}

Test219
    [Tags]    OnDemand    Regression
    Change Account_balance in PPIN    ${onDemand_msisdn}
    OnDemand Optin    0    0
    moRequest    ${onDemand_keyword3}    ${onDemand_msisdn}    ${onDemand_shortcode3}
    Sleep    ${small_sleep}
    Oracle DB query    ${isonDemandOptinSessionActive3}    0    int
    ${transactionID}    Get DB details    ${getOnDemandTransactionId3}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${onDemand_msisdn}    ${onDemand_keyword3}    ${CDR}
    Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}
    
# Test111111
    # ${transactionID}    Get DB details    ${getSubscriptionTransactionId1}
    # ${CDR}    GetCDR    ${transactionID}    prepaid
    # FireSOAPMethod_CancelSubscription    ${getSubscriptionId1}
    # ${res}    Return TransactionDetails PartitionDate as PRT_TD_DDMMYY
    # Log To Console    ${res}
    # FireSOAPMethod_CancelSubscription    ${getSubscriptionId2}
    # TestSubsc
    # Subscription Optin    1    0
    # Configure Subscription Notifications and session expiry
    # Test108_testsybase
    # [Tags]    sybase
    # Connect to sybase database
    # Update sybase    update Subscriber set Account_balance = 9999999 where Sub_id='0051121201'
    # close sybaseConnection
# Test220
    # [Tags]    OnDemand    Regression
    # Update Global Captcha Flag    Y
    # ${response}    FireSOAPMethod_SIA    ${onDemand_tariff1}    ${onDemand_msisdn}    0
    # Initiate SIA browser transaction    ${response}
# Test1111
    # # ${chrome options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    # Call Method    ${chrome options}    add_extension    C:\\Users\\naraypr\\Desktop\\2.1.2_0.crx
    # Create Webdriver    Chrome    chrome_options=${chrome options}
    # Goto    http://172.20.39.82:8080/siaarg/jsp/confcharge.jsp?_transactionId=CESIA1470
    # Sleep    1 minute    # manually verify the extension is active