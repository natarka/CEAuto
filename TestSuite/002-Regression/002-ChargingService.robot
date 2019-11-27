*** Settings ***
Documentation     Charging Service related Tests
Resource          ../../Libraries/genericLibrary/commonTasks.robot    #Test Teardown    Close All Browsers
Resource          ../../Libraries/genericLibrary/dbConnections.robot
Resource          ../../Libraries/genericLibrary/webserviceTasks.robot
Resource          ../../Libraries/testData/genericData.robot
Resource          ../../Libraries/testData/subscription_Optin.robot
Resource          ../../Libraries/testData/dbQueries.robot
Resource          ../../Libraries/testData/errorCodes.robot
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
Test01
    [Tags]    doCharge    content    prepaid
    Change Account_balance in PPIN    ${msisdn}
    doCharge    ${shortcode_ondemand1}    N    ${msisdn}    0
    ${transactionID}    Get DB details    ${cs_getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${msisdn}    ${keyword_ondemand1}    ${CDR}
    Compare Account_balance in PPIN    ${msisdn}    ${charged_price}
    
Test02
    [Tags]    doCharge    content    prepaid
    Change Account_balance to zero    ${msisdn}
    doCharge    ${shortcode_ondemand1}    N    ${msisdn}    ${INSUFFICIENT_BALANCE}
    Compare Account_balance in PPIN    ${msisdn}    0
    
Test03
    [Tags]    doCharge    content    prepaid
    Change Account_balance in PPIN    ${msisdn}
    doCharge    ${shortcode_ondemand1}    N    ${1234567}    ${SUBSCRIBER_NOT_FOUND}

Test07
    [Tags]    doCharge    content    postpaid
    Change Account_balance in PPIN    ${postpaid_msisdn}
    doCharge    ${shortcode_ondemand1}    N    ${postpaid_msisdn}    0
    ${transactionID}    Get DB details    ${cs_getOnDemandTransactionId1_post}
    ${CDR}    GetCDR    ${transactionID}    postpaid
    ${charged_price}    Compute Charging and Validate CDR Postpaid    ${postpaid_msisdn}    ${keyword_ondemand1}    ${CDR}
    
Test09
    [Tags]    doCharge
    Change Account_balance in PPIN    ${postpaid_msisdn}
    doCharge    ${shortcode_ondemand1}    N    ${1234567}    ${SUBSCRIBER_NOT_FOUND}

Test10
    [Tags]    doCharge    Subscription    prepaid
    Change Account_balance in PPIN    ${msisdn}
    FireSOAPMethod_CancelSubscription    ${cs_getSubscriptionId1}
    Sleep    ${small_sleep}    
    Oracle DB query    ${cs_isSubscripitonActive1}    0    int
    doCharge    ${shortcode_subs1}    Y    ${msisdn}    0
    ${transactionID}    Get DB details    ${cs_getSubscriptionTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${msisdn}    ${keyword_subscription1}    ${CDR}
    Compare Account_balance in PPIN    ${msisdn}    ${charged_price}
    
Test11
    [Tags]    doCharge    Subscription    prepaid
    Change Account_balance to zero    ${msisdn}
    FireSOAPMethod_CancelSubscription    ${cs_getSubscriptionId1}
    Sleep    ${small_sleep}    
    Oracle DB query    ${cs_isSubscripitonActive1}    0    int
    doCharge    ${shortcode_subs1}    Y    ${msisdn}    ${INSUFFICIENT_BALANCE}
    Compare Account_balance in PPIN    ${msisdn}    0
    
Test12
    [Tags]    doCharge    Subscription    prepaid
    Change Account_balance in PPIN    ${msisdn}
    FireSOAPMethod_CancelSubscription    ${cs_getSubscriptionId1}
    Sleep    ${small_sleep}
    Oracle DB query    ${cs_isSubscripitonActive1}    0    int
    doCharge    ${shortcode_subs1}    Y    ${1234567}    ${SUBSCRIBER_NOT_FOUND}

Test13
    [Tags]    doCharge    Subscription    postpaid
    Change Account_balance in PPIN    ${postpaid_msisdn}
    FireSOAPMethod_CancelSubscription    ${cs_getSubscriptionId1_post}
    Sleep    ${small_sleep}    
    Oracle DB query    ${cs_isSubscripitonActive1_post}    0    int
    doCharge    ${shortcode_subs1}    Y    ${postpaid_msisdn}    0
    ${transactionID}    Get DB details    ${cs_getSubscriptionTransactionId1_post}
    ${CDR}    GetCDR    ${transactionID}    postpaid
    ${charged_price}    Compute Charging and Validate CDR Postpaid    ${postpaid_msisdn}    ${keyword_subscription1}    ${CDR}

Test14
    [Tags]    doCharge    Subscription    postpaid
    # Dummy test cases as the TC written is wrong
    Change Account_balance in PPIN    ${postpaid_msisdn}
    
Test15
    [Tags]    doCharge    Subscription    postpaid
    Change Account_balance in PPIN    ${postpaid_msisdn}
    FireSOAPMethod_CancelSubscription    ${cs_getSubscriptionId1_post}
    Sleep    ${small_sleep}
    Oracle DB query    ${cs_isSubscripitonActive1}    0    int
    doCharge    ${shortcode_subs1}    Y    ${1234567}    ${SUBSCRIBER_NOT_FOUND}
    
Test16
    [Tags]    doRefund    content    prepaid
    Change Account_balance in PPIN    ${msisdn}
    ${RefundoperationId} =    doCharge    ${shortcode_ondemand1}    N    ${msisdn}    0
    ${transactionID}    Get DB details    ${cs_getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${msisdn}    ${keyword_ondemand1}    ${CDR}
    Compare Account_balance in PPIN    ${msisdn}    ${charged_price}
    
    doRefund    ${shortcode_ondemand1}    ${RefundoperationId}    N    ${msisdn}    ${EMPTY}    0
    ${transactionID}    Get DB details    ${cs_getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    Compare Account_balance in PPIN    ${msisdn}    0
    # Compute Charging and Validate Refund CDR    ${msisdn}    ${keyword_ondemand1}    ${CDR}    Prepaid

Test18
    [Tags]    doRefund    content    prepaid
    Change Account_balance in PPIN    ${msisdn}
    ${RefundoperationId} =    doCharge    ${shortcode_ondemand1}    N    ${msisdn}    0
    ${transactionID}    Get DB details    ${cs_getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${msisdn}    ${keyword_ondemand1}    ${CDR}
    Compare Account_balance in PPIN    ${msisdn}    ${charged_price}
    
    doRefund    ${shortcode_ondemand1}    ${RefundoperationId}    N    ${msisdn}    ${EMPTY}    0
    ${transactionID}    Get DB details    ${cs_getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    Compare Account_balance in PPIN    ${msisdn}    0
    
    doRefund    ${shortcode_ondemand1}    ${RefundoperationId}    N    ${msisdn}    ${EMPTY}    ${DUPLICATE_REFUND_REQUEST}
    
Test19
    [Tags]    doRefund    content    postpaid
    Change Account_balance in PPIN    ${postpaid_msisdn}
    ${RefundoperationId} =    doCharge    ${shortcode_ondemand1}    N    ${postpaid_msisdn}    0
    ${transactionID}    Get DB details    ${cs_getOnDemandTransactionId1_post}
    ${CDR}    GetCDR    ${transactionID}    postpaid
    ${charged_price}    Compute Charging and Validate CDR Postpaid    ${postpaid_msisdn}    ${keyword_ondemand1}    ${CDR}
    
    doRefund    ${shortcode_ondemand1}    ${RefundoperationId}    N    ${postpaid_msisdn}    ${EMPTY}    0
    ${transactionID}    Get DB details    ${cs_getOnDemandTransactionId1}
    ${CDR}    GetCDR    ${transactionID}    postpaid
    