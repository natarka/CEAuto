*** Settings ***
Documentation     Charging Service related Tests
Library            String
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
Test01-03
    [Tags]    prepaid
    Change Account_balance in PPIN    ${msisdn}
    doCharge    ${shortcode_ondemand1}    N    ${msisdn}    0
    ${transactionID}    Get DB details    ${cs_getOnDemandTransactionId1}
    ${cm_count}    Get DB details    select count(1) from cdr_master where cm_transaction_id = '${transactionID}'
    ${cml_count}    Get DB details    select count(1) from cdr_master_log where cml_transaction_id = '${transactionID}'
    Should Be Equal As Integers    1    ${cm_count}
    Should Be Equal As Integers    1    ${cml_count}
    ${CDR}    GetCDR    ${transactionID}    prepaid
    ${charged_price}    Compute Charging and Validate CDR    ${msisdn}    ${keyword_ondemand1}    ${CDR}
    Compare Account_balance in PPIN    ${msisdn}    ${charged_price}
    
    Connect to oracle database
    ${result1}    Query    select * from cdr_master where cm_transaction_id = '${transactionID}'
    ${result2}    Query    select * from cdr_master_log where cml_transaction_id = '${transactionID}'
    LOG    ${result1}
    LOG    ${result2}
    
    : FOR    ${i}    IN RANGE    0    41
    \    Run Keyword If    '${result1[0][${i}]}' == '${result2[0][${i}]}'    LOG    Values are same
    Log    For loop is over
    Disconnect connection to oracleDB

Test04-06
    [Tags]    postpaid
    Change Account_balance in PPIN    ${postpaid_msisdn}
    doCharge    ${shortcode_ondemand1}    N    ${postpaid_msisdn}    0
    ${transactionID}    Get DB details    ${cs_getOnDemandTransactionId1_post}
    ${cm_count}    Get DB details    select count(1) from cdr_master where cm_transaction_id = '${transactionID}'
    ${cml_count}    Get DB details    select count(1) from cdr_master_log where cml_transaction_id = '${transactionID}'
    Should Be Equal As Integers    1    ${cm_count}
    Should Be Equal As Integers    1    ${cml_count}
    ${CDR}    GetCDR    ${transactionID}    postpaid
    ${charged_price}    Compute Charging and Validate CDR Postpaid    ${postpaid_msisdn}    ${keyword_ondemand1}    ${CDR}
    
    Connect to oracle database
    ${result1}    Query    select * from cdr_master where cm_transaction_id = '${transactionID}'
    ${result2}    Query    select * from cdr_master_log where cml_transaction_id = '${transactionID}'
    LOG    ${result1}
    LOG    ${result2}
    
    : FOR    ${i}    IN RANGE    0    41
    \    Run Keyword If    '${result1[0][${i}]}' == '${result2[0][${i}]}'    LOG    Values are same
    Log    For loop is over
    Disconnect connection to oracleDB

# TestSample
    # [Tags]    prepaid
    # Change Account_balance in PPIN    ${msisdn}
    # doCharge    ${shortcode_ondemand1}    N    ${msisdn}    0
    # ${transactionID}    Get DB details    ${cs_getOnDemandTransactionId1}
    # ${cm_count}    Get DB details    select count(1) from cdr_master where cm_transaction_id = '${transactionID}'
    # ${cml_count}    Get DB details    select count(1) from cdr_master_log where cml_transaction_id = '${transactionID}'
    # Should Be Equal As Integers    1    ${cm_count}
    # Should Be Equal As Integers    1    ${cml_count}
    # # ${CDR}    GetCDR    ${transactionID}    prepaid
    # # ${charged_price}    Compute Charging and Validate CDR    ${msisdn}    ${keyword_ondemand1}    ${CDR}
    # # Compare Account_balance in PPIN    ${msisdn}    ${charged_price}
    
    # ${result1}    Query    select * from cdr_master where cm_transaction_id = '${transactionID}'
    # ${result2}    Query    select * from cdr_master_log where cml_transaction_id = '${transactionID}'
    # LOG    ${result1}
    # LOG    ${result2}
    
    # : FOR    ${i}    IN RANGE    0    41
    # \    Run Keyword If    '${result1[0][${i}]}' == '${result2[0][${i}]}'    LOG    Values are same
    # Log    For loop is over
    