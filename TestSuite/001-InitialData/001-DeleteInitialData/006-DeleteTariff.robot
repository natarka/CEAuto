*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Delete Tariff Subscription
    Check and delete tariff    ${shortcode_subs}

Test 002-Delete Tariff Subscription
    Check and delete tariff    ${shortcode_subs1}

Test 003-Delete Tariff Subscription
    Check and delete tariff    ${shortcode_subs2}

Test 004-Delete Tariff Subscription
    Check and delete tariff    ${shortcode_subs3}

Test 005-Delete Tariff OnDemand
    Check and delete tariff    ${shortcode_ondemand}

Test 006-Delete Tariff OnDemand
    Check and delete tariff    ${shortcode_ondemand1}

Test 007-Delete Tariff OnDemand
    Check and delete tariff    ${shortcode_ondemand2}

Test 008-Delete Tariff OnDemand
    Check and delete tariff    ${shortcode_ondemand3}