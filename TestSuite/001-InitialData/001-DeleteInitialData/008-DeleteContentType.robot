*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Delete Content Subscription
    Check and Delete Content    ${content_name_subs}
    
Test 002-Delete Content Subscription
    Check and Delete Content    ${content_name_subs1}
    
Test 003-Delete Content Subscription
    Check and Delete Content    ${content_name_subs2}
    
Test 004-Delete Content Subscription
    Check and Delete Content    ${content_name_subs3}

Test 005-Delete Content OnDemand
    Check and Delete Content    ${content_name_ondemand}

Test 006-Delete Content OnDemand
    Check and Delete Content    ${content_name_ondemand1}
    
Test 007-Delete Content OnDemand
    Check and Delete Content    ${content_name_ondemand2}
    
Test 008-Delete Content OnDemand
    Check and Delete Content    ${content_name_ondemand3}