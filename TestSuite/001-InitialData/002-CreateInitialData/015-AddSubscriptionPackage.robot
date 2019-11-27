*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Add Subscription Package
    Connect to oracle database
    ${result}    Query from database    select ccm_charge_code_id from charge_code_master where ccm_scm_short_code=${shortcode_subs}
    Disconnect connection to oracleDB
    Init Browser and login
    Add Subscription Package    ${subs_pkg_name}    ${subs_pkg_id}    ${subs_pkg_dur}    ${result[0][0]}
    Logout and close browser

Test 002-Add Subscription Package
    Connect to oracle database
    ${result}    Query from database    select ccm_charge_code_id from charge_code_master where ccm_scm_short_code=${shortcode_subs1}
    Disconnect connection to oracleDB
    Init Browser and login
    Add Subscription Package    ${subs_pkg_name1}    ${subs_pkg_id1}    ${subs_pkg_dur1}    ${result[0][0]}
    Logout and close browser
    
Test 003-Add Subscription Package
    Connect to oracle database
    ${result}    Query from database    select ccm_charge_code_id from charge_code_master where ccm_scm_short_code=${shortcode_subs2}
    Disconnect connection to oracleDB
    Init Browser and login
    Add Subscription Package    ${subs_pkg_name2}    ${subs_pkg_id2}    ${subs_pkg_dur2}    ${result[0][0]}
    Logout and close browser
    
Test 004-Add Subscription Package
    Connect to oracle database
    ${result}    Query from database    select ccm_charge_code_id from charge_code_master where ccm_scm_short_code=${shortcode_subs3}
    Disconnect connection to oracleDB
    Init Browser and login
    Add Subscription Package    ${subs_pkg_name3}    ${subs_pkg_id3}    ${subs_pkg_dur3}    ${result[0][0]}
    Logout and close browser