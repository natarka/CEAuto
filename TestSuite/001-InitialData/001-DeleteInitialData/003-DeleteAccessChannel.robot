*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Delete Access Channel Subscription
    Check and delete access channel    ${shortcode_subs}

Test 002-Delete Access Channel Subscription
    Check and delete access channel    ${shortcode_subs1}

Test 003-Delete Access Channel Subscription
    Check and delete access channel    ${shortcode_subs2}
    
Test 004-Delete Access Channel Subscription
    Check and delete access channel    ${shortcode_subs3}
    
Test 005-Delete Access Channel OnDemand
    Check and delete access channel    ${shortcode_ondemand}

Test 006-Delete Access Channel OnDemand
    Check and delete access channel    ${shortcode_ondemand1}

Test 007-Delete Access Channel OnDemand
    Check and delete access channel    ${shortcode_ondemand2}

Test 008-Delete Access Channel OnDemand
    Check and delete access channel    ${shortcode_ondemand3}