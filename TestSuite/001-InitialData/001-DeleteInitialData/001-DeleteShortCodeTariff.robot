*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Delete Short Code Tariff Subscription
    Check and delete short code tariff    ${cpUser}    ${shortcode_subs}

Test 002-Delete Short Code Tariff Subscription
    Check and delete short code tariff    ${cpUser}    ${shortcode_subs1}

Test 003-Delete Short Code Tariff Subscription
    Check and delete short code tariff    ${cpUser}    ${shortcode_subs2}

Test 004-Delete Short Code Tariff Subscription
    Check and delete short code tariff    ${cpUser}    ${shortcode_subs3}

Test 005-Delete Short Code Tariff OnDemand
    Check and delete short code tariff    ${cpUser}    ${shortcode_ondemand}

Test 006-Delete Short Code Tariff OnDemand
    Check and delete short code tariff    ${cpUser}    ${shortcode_ondemand1}

Test 007-Delete Short Code Tariff OnDemand
    Check and delete short code tariff    ${cpUser}    ${shortcode_ondemand2}

Test 008-Delete Short Code Tariff OnDemand
    Check and delete short code tariff    ${cpUser}    ${shortcode_ondemand3}