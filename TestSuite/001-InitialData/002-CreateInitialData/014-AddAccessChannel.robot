*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Add Access Channel OnDemand
    Add Access Channel    ${shortcode_ondemand}

Test 002-Add Access Channel OnDemand
    Add Access Channel    ${shortcode_ondemand1}

Test 003-Add Access Channel OnDemand
    Add Access Channel    ${shortcode_ondemand2}

Test 004-Add Access Channel OnDemand
    Add Access Channel    ${shortcode_ondemand3}

Test 005-Add Access Channel Subscription
    Add Access Channel    ${shortcode_subs}

Test 006-Add Access Channel Subscription
    Add Access Channel    ${shortcode_subs1}

Test 007-Add Access Channel Subscription
    Add Access Channel    ${shortcode_subs2}

Test 008-Add Access Channel Subscription
    Add Access Channel    ${shortcode_subs3}