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
Library            OperatingSystem
Library            CreateExcelFile
Library            CreateExcelFile.ExcelUtility
Test Teardown     Close All Browsers
Suite Setup        Change JB_KTM_UPLOAD frequency to 1 minute
# Suite Setup        Connect to sybase database
# Suite Teardown     Close SybaseConnection

*** Test Cases ***
Test101-2
    [Tags]    Sanity    Regression
    GUI Update Bulk Upload parameters    ${ktm_global_valid_file_delimiter}    ${ktm_max_file_rows}
    Oracle DB query    ${max_file_rows}    ${ktm_max_file_rows}    int
    Oracle DB query    ${file_delimiter}    ${ktm_global_valid_file_delimiter}    str
    
Test03
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    1
    Subscription Optin    1    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    1
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0
    
Test04
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_invalid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s
    Check Upload status Negative    Y    ${ktm_valid_subscription_short_code}        ${ktm_valid_subscription_keyword}
    Check Report Count Negative    Y    ${ktm_valid_subscription_short_code}    ${Test Name}.txt    1    0    1    0    1    0    0    0    0    0    0    0
    
Test05
    [Tags]    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Prepare Excel file    ${Test Name}    ${ktm_invalid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s
    Check Upload status Negative    Y    ${ktm_valid_subscription_short_code}        ${ktm_valid_subscription_keyword}
    Check Report Count Negative    Y    ${ktm_valid_subscription_short_code}    ${Test Name}.xlsx    1    0    1    0    0    0    1    0    0    0    0    0
    
Test06
    [Tags]    Regression    Subscription
    Delete existing mapping    ${ktm_invalid_short_code}    ${ktm_valid_subscription_keyword}    0
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_invalid_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s
    Check Upload status Negative    Y    ${ktm_invalid_short_code}        ${ktm_valid_subscription_keyword}
    Check Report Count Negative    Y    ${ktm_invalid_short_code}    ${Test Name}.xlsx    1    0    1    1    0    0    0    0    0    0    0    0
    
Test07
    [Tags]    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    ${ktm_global_invalid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    0    1
    Page Should Contain    1 - Invalid Delimiter
    Check Upload status Negative    Y    ${ktm_valid_subscription_short_code}        ${ktm_valid_subscription_keyword}
    
Test08
    [Tags]    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_null_chargecode}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    0    1
    Page Should Contain    : Invalid Charge Code Id
    Check Upload status Negative    Y    ${ktm_valid_subscription_short_code}        ${ktm_valid_subscription_keyword}
    
Test09
    [Tags]    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_invalid_allow_param}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    0    1
    Page Should Contain    : Invalid Allow Param Flag
    Check Upload status Negative    Y    ${ktm_valid_subscription_short_code}        ${ktm_valid_subscription_keyword}
    
Test10
    [Tags]    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_null_allow_param}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    0    1
    Page Should Contain    : Invalid Allow Param Flag
    Check Upload status Negative    Y    ${ktm_valid_subscription_short_code}        ${ktm_valid_subscription_keyword}
    
Test11
    [Tags]    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    1    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_null_allow_optin}    ${ktm_valid_subs_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_no}    ${ktm_null_notification}    0
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0
    
Test12
    [Tags]    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    1    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    1
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds
    Sleep    100s
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.txt    1    0    1    0    0    0    0    0    1    0    0    0
    
Test13
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    1
    Subscription Optin    1    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    1
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

Test14
    [Tags]    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_null_subscription_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    0    1
    Page Should Contain    : Invalid Keyword
    Check Upload status Negative    Y    ${ktm_valid_subscription_short_code}        ${ktm_valid_subscription_keyword}

Test15
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    1    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    1
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

Test16
    [Tags]    Sanity    Regression    Subscription
    Create File    ${ktm_base_directory}/${test_name}.txt    00000|MO|SMS|0000|Subscription-00000|Keyword|N|Y|Notifcaiton${\n}
    : FOR    ${i}    In range    1    ${ktm_max_file_rows}+1
    \    Append To File    ${ktm_base_directory}/${test_name}.txt    00000|MO|SMS|0000|Subscription-00000|Keyword|N|Y|Notifcaiton${\n}    
    Bulk Upload file    ${ktm_base_directory}/${test_name}.txt
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    ${ktm_max_file_rows}    ${ktm_max_file_rows}    0
    Page Should Contain    Max limit exceded: ${ktm_max_file_rows}
    
Test17
    [Tags]    Sanity    Regression    Subscription
    Create File    ${ktm_base_directory}/${test_name}.txt    00000|MO|SMS|0000|Subscription-00000|Keyword|N|Y|Notifcaiton${\n}
    : FOR    ${i}    In range    1    ${ktm_max_file_rows}+1
    \    Append To File    ${ktm_base_directory}/${test_name}.txt    00000|MO|SMS|0000|Subscription-00000|Keyword|N|Y|Notifcaiton${\n}    
    Bulk Upload file    ${ktm_base_directory}/${test_name}.txt
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    ${ktm_max_file_rows}    ${ktm_max_file_rows}    0
    Page Should Contain    Max limit exceded: ${ktm_max_file_rows}
    
Test18
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    1    1
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    1
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.xlsx    1    1    0    0    0    0    0    0    0    0    0    0

Test19
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    1    1
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_no}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_no}    ${ktm_valid_subs_optin_notification}    0
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.xlsx    1    1    0    0    0    0    0    0    0    0    0    0
    
Test20
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    1    1
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_empty_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_empty_notification}    0
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.xlsx    1    1    0    0    0    0    0    0    0    0    0    0

Test21
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    1    0
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    0
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.xlsx    1    1    0    0    0    0    0    0    0    0    0    0

Test22
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    1    0
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_no}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    0
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.xlsx    1    1    0    0    0    0    0    0    0    0    0    0

Test23
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    0    1
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    0
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.xlsx    1    1    0    0    0    0    0    0    0    0    0    0

Test24
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    0    1
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_no}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    0
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.xlsx    1    1    0    0    0    0    0    0    0    0    0    0

Test25
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    0    0
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    0
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.xlsx    1    1    0    0    0    0    0    0    0    0    0    0

Test26
    [Tags]    Sanity    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    0    0
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_no}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_subs_optin_notification}    0
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.xlsx    1    1    0    0    0    0    0    0    0    0    0    0

Test27
    [Tags]    Sanity    Regression    OnDemand
    Delete existing mapping    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    1
    OnDemand Optin    1    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_onDemand_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    N    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_onDemand_optin_notification}    1
    Check Report Count Positive    N    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

Test28
    [Tags]    Sanity    Regression    OnDemand
    Delete existing mapping    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    1
    OnDemand Optin    1    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_no}    ${ktm_valid_onDemand_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    N    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_no}    ${ktm_valid_onDemand_optin_notification}    0
    Check Report Count Positive    N    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

Test29
    [Tags]    Sanity    Regression    OnDemand
    Delete existing mapping    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    1
    OnDemand Optin    1    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_no}    ${ktm_empty_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    N    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_no}    ${ktm_empty_notification}    0
    Check Report Count Positive    N    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

Test30
    [Tags]    Sanity    Regression    OnDemand
    Delete existing mapping    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    1
    OnDemand Optin    1    0
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_onDemand_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    N    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_onDemand_optin_notification}    0
    Check Report Count Positive    N    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

Test31
    [Tags]    Sanity    Regression    OnDemand
    Delete existing mapping    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    1
    OnDemand Optin    1    0
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_no}    ${ktm_valid_onDemand_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    N    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_onDemand_optin_notification}    0
    Check Report Count Positive    N    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

Test32
    [Tags]    Sanity    Regression    OnDemand
    Delete existing mapping    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    1
    OnDemand Optin    0    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_onDemand_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    N    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_onDemand_optin_notification}    0
    Check Report Count Positive    N    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

Test33
    [Tags]    Sanity    Regression    OnDemand
    Delete existing mapping    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    1
    OnDemand Optin    0    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_no}    ${ktm_valid_onDemand_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    N    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_onDemand_optin_notification}    0
    Check Report Count Positive    N    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

Test34
    [Tags]    Sanity    Regression    OnDemand
    Delete existing mapping    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    1
    OnDemand Optin    0    0
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_onDemand_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    N    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_onDemand_optin_notification}    0
    Check Report Count Positive    N    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

Test35
    [Tags]    Sanity    Regression    OnDemand
    Delete existing mapping    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    1
    OnDemand Optin    0    0
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_no}    ${ktm_valid_onDemand_optin_notification}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    N    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_valid_onDemand_optin_notification}    0
    Check Report Count Positive    N    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0

Test36
    [Tags]    Regression    Subscription
    Create File    ${ktm_base_directory}/${test_name}.txt    00000|MO|SMS|0000|Subscription-00000|Keyword|N|Y|Notifcaiton|Dummy extra field
    Bulk Upload file    ${ktm_base_directory}/${test_name}.txt
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    0    1
    Page Should Contain    1 - Invalid File Content

Test37
    [Tags]    Regression    Subscription
    Create File    ${ktm_base_directory}/${test_name}.xml    00000|MO|SMS|0000|Subscription-00000|Keyword|N|Y|Notifcaiton
    Bulk Upload file    ${ktm_base_directory}/${test_name}.xml
    Alert Should Be Present    Invalid file format.

Test38
    # OCSDM-6175
    [Tags]    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    0
    Subscription Optin    1    1
    Prepare Excel file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_null_allow_optin}    ${ktm_valid_subs_optin_notification}
    Page Should Contain    File proccesed: ${TEST NAME}.xlsx
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_no}    ${ktm_valid_subs_optin_notification}    0
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.xlsx    1    1    0    0    0    0    0    0    0    0    0    0
    
Test39
    # OCSDM-6171
    [Tags]    Regression    Subscription
    Delete existing mapping    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    1
    Subscription Optin    1    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_notification_upto_320_characters}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    Y    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_subscription_short_code}    ${ktm_valid_packageID}    ${ktm_valid_subscription_keyword}    ${ktm_valid_allow_param_no}    ${ktm_valid_allow_optin_yes}    ${ktm_notification_upto_320_characters}    1
    Check Report Count Positive    Y    ${ktm_valid_subscription_short_code}    ${ktm_valid_subscription_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0
    
Test40
    # OCSDM-6171
    [Tags]    Regression    OnDemand
    Delete existing mapping    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    1
    OnDemand Optin    1    1
    Prepare Text file    ${Test Name}    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_notification_upto_320_characters}    ${ktm_global_valid_file_delimiter}
    Page Should Contain    File proccesed: ${TEST NAME}.txt
    Check count in GUI    1    1    0
    Log To Console    Sleep for 100 seconds    
    Sleep    100s    
    Check Upload status Positive    N    ${ktm_valid_cp_id}    ${ktm_valid_MO_traffic_type}    ${ktm_valid_service_type}    ${ktm_valid_onDemand_short_code}    ${ktm_valid_tariffID}    ${ktm_valid_onDemand_keyword}    ${ktm_valid_allow_param_yes}    ${ktm_valid_allow_optin_yes}    ${ktm_notification_upto_320_characters}    1
    Check Report Count Positive    N    ${ktm_valid_onDemand_short_code}    ${ktm_valid_onDemand_keyword}    ${Test Name}.txt    1    1    0    0    0    0    0    0    0    0    0    0