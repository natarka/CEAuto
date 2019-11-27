*** Settings ***
Documentation    Suite description
Resource  ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Add Keyword OnDemand
    Init Browser and login
    Add Keyword  MO Keyword  ${keyword_ondemand}
    logout and close browser

Test 002-Add Keyword OnDemand
    Init Browser and login
    Add Keyword  MO Keyword  ${keyword_ondemand1}
    logout and close browser
    
Test 003-Add Keyword OnDemand
    Init Browser and login
    Add Keyword  MO Keyword  ${keyword_ondemand2}
    logout and close browser
    
Test 004-Add Keyword OnDemand
    Init Browser and login
    Add Keyword  MO Keyword  ${keyword_ondemand3}
    logout and close browser
    
Test 005-Add Keyword Subscription
    Init Browser and login
    Add Keyword  MO Keyword  ${keyword_subscription}
    logout and close browser
    
Test 006-Add Keyword Subscription
    Init Browser and login
    Add Keyword  MO Keyword  ${keyword_subscription1}
    logout and close browser
    
Test 007-Add Keyword Subscription
    Init Browser and login
    Add Keyword  MO Keyword  ${keyword_subscription2}
    logout and close browser
    
Test 008-Add Keyword Subscription
    Init Browser and login
    Add Keyword  MO Keyword  ${keyword_subscription3}
    logout and close browser
    
Test 009-Add Keyword Optin
    Init Browser and login
    Add Keyword  OPTIN  ${keyword_optin1}
    logout and close browser

Test 010-Add Keyword Optin
    Init Browser and login
    Add Keyword  OPTIN  ${keyword_optin2}
    logout and close browser
    
Test 011-Add Keyword Optin
    Init Browser and login
    Add Keyword with Alias  OPTIN  ${keyword_optin3}    ${keyword_optin3_alias}
    logout and close browser

Test 012-Add Keyword Reject
    Init Browser and login
    Add Keyword  REJECT_KEYWORD  ${keyword_reject1}
    logout and close browser
    
Test 013-Add Keyword Reject
    Init Browser and login
    Add Keyword with Alias  REJECT_KEYWORD  ${keyword_reject2}    ${keyword_reject2_alias}
    logout and close browser