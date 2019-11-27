*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
Resource    ../../../Libraries/genericLibrary/dbConnections.robot
*** Test Cases ***
Test 001-Add Short Code Tariff OnDemand
    Connect to oracle database
    ${result}    Query from database    select ccm_charge_code_id from charge_code_master where ccm_scm_short_code=${shortcode_ondemand}
    Disconnect connection to oracleDB
    Init Browser and login
    Add Short Code Tariff OnDemand    ${result[0][0]}    ${shortcode_ondemand}    ${keyword_ondemand}    Y    N    ${empty}
    Logout and close browser

Test 002-Add Short Code Tariff OnDemand
    Connect to oracle database
    ${result}    Query from database    select ccm_charge_code_id from charge_code_master where ccm_scm_short_code=${shortcode_ondemand3}
    Disconnect connection to oracleDB
    Init Browser and login
    Add Short Code Tariff OnDemand    ${result[0][0]}    ${shortcode_ondemand3}    ${keyword_ondemand3}    N    Y    ${empty}
    Logout and close browser

Test 003-Add Short Code Tariff OnDemand
    Connect to oracle database
    ${result}    Query from database    select ccm_charge_code_id from charge_code_master where ccm_scm_short_code=${shortcode_ondemand2}
    Disconnect connection to oracleDB
    Init Browser and login
    Add Short Code Tariff OnDemand    ${result[0][0]}    ${shortcode_ondemand2}    ${keyword_ondemand2}    N    N    ${empty}
    Logout and close browser

Test 004-Add Short Code Tariff OnDemand
    Connect to oracle database
    ${result}    Query from database    select ccm_charge_code_id from charge_code_master where ccm_scm_short_code=${shortcode_ondemand1}
    Disconnect connection to oracleDB
    Init Browser and login
    Add Short Code Tariff OnDemand    ${result[0][0]}    ${shortcode_ondemand1}    ${keyword_ondemand1}    Y    N    ${onDemand_tariff_level_notification1}
    Logout and close browser

Test 005-Add Short Code Tariff Subscription
    Connect to oracle database
    ${result}    Query from database    select spm_pkg_id from sub_package_master where spm_pkg_name='${subs_pkg_name}'
    Disconnect connection to oracleDB
    Init Browser and login
    Add Short Code Tariff Subscription    ${result[0][0]}    ${shortcode_subs}    ${keyword_subscription}    Y    N    ${empty}
    Logout and close browser
    
Test 006-Add Short Code Tariff Subscription
    Connect to oracle database
    ${result}    Query from database    select spm_pkg_id from sub_package_master where spm_pkg_name='${subs_pkg_name3}'
    Disconnect connection to oracleDB
    Init Browser and login
    Add Short Code Tariff Subscription    ${result[0][0]}    ${shortcode_subs3}    ${keyword_subscription3}    N    Y    ${empty}
    Logout and close browser
    
Test 007-Add Short Code Tariff Subscription
    Connect to oracle database
    ${result}    Query from database    select spm_pkg_id from sub_package_master where spm_pkg_name='${subs_pkg_name2}'
    Disconnect connection to oracleDB
    Init Browser and login
    Add Short Code Tariff Subscription    ${result[0][0]}    ${shortcode_subs2}    ${keyword_subscription2}    N    N    ${empty}
    Logout and close browser
    
Test 008-Add Short Code Tariff Subscription
    Connect to oracle database
    ${result}    Query from database    select spm_pkg_id from sub_package_master where spm_pkg_name='${subs_pkg_name1}'
    Disconnect connection to oracleDB
    Init Browser and login
    Add Short Code Tariff Subscription    ${result[0][0]}    ${shortcode_subs1}    ${keyword_subscription1}    Y    N    ${subscription_tariff_level_notification1}
    Logout and close browser