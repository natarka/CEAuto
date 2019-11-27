*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
Resource    ../../../Libraries/configurations.robot
*** Test Cases ***
Test 001-Add Application OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(cpa_application_id) from CONTENT_PARTNER_APPLICATION)+1 from dual
    Disconnect connection to oracleDB
    Add Application    ${result[0][0]}    ${app_name_ondemand} 

Test 002-Add Application OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(cpa_application_id) from CONTENT_PARTNER_APPLICATION)+1 from dual
    Disconnect connection to oracleDB
    Add Application    ${result[0][0]}    ${app_name_ondemand1}
    
Test 003-Add Application OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(cpa_application_id) from CONTENT_PARTNER_APPLICATION)+1 from dual
    Disconnect connection to oracleDB
    Add Application    ${result[0][0]}    ${app_name_ondemand2}
    
Test 004-Add Application OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(cpa_application_id) from CONTENT_PARTNER_APPLICATION)+1 from dual
    Disconnect connection to oracleDB
    Add Application    ${result[0][0]}    ${app_name_ondemand3}
    
Test 005-Add Application Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(cpa_application_id) from CONTENT_PARTNER_APPLICATION)+1 from dual
    Disconnect connection to oracleDB
    Add Application    ${result[0][0]}    ${app_name_subs}
    
Test 006-Add Application Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(cpa_application_id) from CONTENT_PARTNER_APPLICATION)+1 from dual
    Disconnect connection to oracleDB
    Add Application    ${result[0][0]}    ${app_name_subs1}
    
Test 007-Add Application Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(cpa_application_id) from CONTENT_PARTNER_APPLICATION)+1 from dual
    Disconnect connection to oracleDB
    Add Application    ${result[0][0]}    ${app_name_subs2}
    
Test 008-Add Application Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(cpa_application_id) from CONTENT_PARTNER_APPLICATION)+1 from dual
    Disconnect connection to oracleDB
    Add Application    ${result[0][0]}    ${app_name_subs3}