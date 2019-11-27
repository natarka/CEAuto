*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Delete Provider Configuration Subscription
    Check and delete provider configuration    ${shortcode_subs}

Test 002-Delete Provider Configuration Subscription
    Check and delete provider configuration    ${shortcode_subs1}

Test 003-Delete Provider Configuration Subscription
    Check and delete provider configuration    ${shortcode_subs2}

Test 004-Delete Provider Configuration Subscription
    Check and delete provider configuration    ${shortcode_subs3}

Test 005-Delete Provider Configuration OnDemand
    Check and delete provider configuration    ${shortcode_ondemand}

Test 006-Delete Provider Configuration OnDemand
    Check and delete provider configuration    ${shortcode_ondemand1}
    
Test 007-Delete Provider Configuration OnDemand
    Check and delete provider configuration    ${shortcode_ondemand2}
    
Test 008-Delete Provider Configuration OnDemand
    Check and delete provider configuration    ${shortcode_ondemand3}