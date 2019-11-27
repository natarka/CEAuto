*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Delete Short Code Subscription
    Check and Delete Short Code    ${shortcode_subs}

Test 002-Delete Short Code Subscription
    Check and Delete Short Code    ${shortcode_subs1}

Test 003-Delete Short Code Subscription
    Check and Delete Short Code    ${shortcode_subs2}

Test 004-Delete Short Code Subscription
    Check and Delete Short Code    ${shortcode_subs3}

Test 005-Delete Short Code OnDemand
    Check and Delete Short Code    ${shortcode_ondemand}

Test 006-Delete Short Code OnDemand
    Check and Delete Short Code    ${shortcode_ondemand1}
    
Test 007-Delete Short Code OnDemand
    Check and Delete Short Code    ${shortcode_ondemand2}
    
Test 008-Delete Short Code OnDemand
    Check and Delete Short Code    ${shortcode_ondemand3}