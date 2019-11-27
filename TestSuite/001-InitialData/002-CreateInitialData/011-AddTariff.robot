*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Add Tariff OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(ccm_charge_code_id) from CHARGE_CODE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Init Browser and login
    Add Tariff    ${result[0][0]}    ${content_name_ondemand}    ${app_name_ondemand}    ${shortcode_ondemand}
    Logout and close browser

Test 002-Add Tariff OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(ccm_charge_code_id) from CHARGE_CODE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Init Browser and login
    Add Tariff    ${result[0][0]}    ${content_name_ondemand1}    ${app_name_ondemand1}    ${shortcode_ondemand1}
    Logout and close browser

Test 003-Add Tariff OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(ccm_charge_code_id) from CHARGE_CODE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Init Browser and login
    Add Tariff    ${result[0][0]}    ${content_name_ondemand2}    ${app_name_ondemand2}    ${shortcode_ondemand2}
    Logout and close browser

Test 004-Add Tariff OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(ccm_charge_code_id) from CHARGE_CODE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Init Browser and login
    Add Tariff    ${result[0][0]}    ${content_name_ondemand3}    ${app_name_ondemand3}    ${shortcode_ondemand3}
    Logout and close browser

Test 005-Add Tariff Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(ccm_charge_code_id) from CHARGE_CODE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Init Browser and login
    Add Tariff    ${result[0][0]}    ${content_name_subs}    ${app_name_subs}    ${shortcode_subs}
    Logout and close browser
    
Test 006-Add Tariff Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(ccm_charge_code_id) from CHARGE_CODE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Init Browser and login
    Add Tariff    ${result[0][0]}    ${content_name_subs1}    ${app_name_subs1}    ${shortcode_subs1}
    Logout and close browser

Test 007-Add Tariff Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(ccm_charge_code_id) from CHARGE_CODE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Init Browser and login
    Add Tariff    ${result[0][0]}    ${content_name_subs2}    ${app_name_subs2}    ${shortcode_subs2}
    Logout and close browser

Test 008-Add Tariff Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(ccm_charge_code_id) from CHARGE_CODE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Init Browser and login
    Add Tariff    ${result[0][0]}    ${content_name_subs3}    ${app_name_subs3}    ${shortcode_subs3}
    Logout and close browser