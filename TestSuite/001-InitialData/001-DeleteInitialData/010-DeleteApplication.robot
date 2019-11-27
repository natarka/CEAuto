*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
Resource    ../../../Libraries/configurations.robot
*** Test Cases ***
Test 001-Delete Application Subscription
    Check and delete application    ${app_name_subs}

Test 002-Delete Application Subscription
    Check and delete application    ${app_name_subs1}
    
Test 003-Delete Application Subscription
    Check and delete application    ${app_name_subs2}
    
Test 004-Delete Application Subscription
    Check and delete application    ${app_name_subs3}
    
Test 005-Delete Application OnDemand
    Check and delete application    ${app_name_ondemand}

Test 006-Delete Application OnDemand
    Check and delete application    ${app_name_ondemand1}
    
Test 007-Delete Application OnDemand
    Check and delete application    ${app_name_ondemand2}
    
Test 008-Delete Application OnDemand
    Check and delete application    ${app_name_ondemand3}