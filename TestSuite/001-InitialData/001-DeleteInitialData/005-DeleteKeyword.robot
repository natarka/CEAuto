*** Settings ***
Resource  ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-DeleteKeyword Subscription
    Check and delete keyword		${keyword_subscription}

Test 002-DeleteKeyword Subscription
    Check and delete keyword		${keyword_subscription1}

Test 003-DeleteKeyword Subscription
    Check and delete keyword		${keyword_subscription2}

Test 004-DeleteKeyword Subscription
    Check and delete keyword		${keyword_subscription3}

Test 005-DeleteKeyword OnDemand
    Check and delete keyword    ${keyword_ondemand}

Test 006-DeleteKeyword OnDemand
    Check and delete keyword    ${keyword_ondemand1}

Test 007-DeleteKeyword OnDemand
    Check and delete keyword    ${keyword_ondemand2}
    
Test 008-DeleteKeyword OnDemand
    Check and delete keyword    ${keyword_ondemand3}
    
Test 009-DeleteKeyword Optin
    Check and delete keyword    ${keyword_optin1}
    
Test 010-DeleteKeyword Optin
    Check and delete keyword    ${keyword_optin2}
    
Test 011-DeleteKeyword Optin
    Check and delete keyword    ${keyword_optin3}
    
Test 012-DeleteKeyword Reject
    Check and delete keyword    ${keyword_reject1}
    
Test 013-DeleteKeyword Reject
    Check and delete keyword    ${keyword_reject2}