*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Add Short Code OnDemand
    Init Browser and login
    Add Short Code    ${shortcode_ondemand}
    Logout and close browser

Test 002-Add Short Code OnDemand
    Init Browser and login
    Add Short Code    ${shortcode_ondemand1}
    Logout and close browser

Test 003-Add Short Code OnDemand
    Init Browser and login
    Add Short Code    ${shortcode_ondemand2}
    Logout and close browser

Test 004-Add Short Code OnDemand
    Init Browser and login
    Add Short Code    ${shortcode_ondemand3}
    Logout and close browser

Test 005-Add Short Code Subscription
    Init Browser and login
    Add Short Code    ${shortcode_subs}
    Logout and close browser
    
Test 006-Add Short Code Subscription
    Init Browser and login
    Add Short Code    ${shortcode_subs1}
    Logout and close browser

Test 007-Add Short Code Subscription
    Init Browser and login
    Add Short Code    ${shortcode_subs2}
    Logout and close browser

Test 008-Add Short Code Subscription
    Init Browser and login
    Add Short Code    ${shortcode_subs3}
    Logout and close browser