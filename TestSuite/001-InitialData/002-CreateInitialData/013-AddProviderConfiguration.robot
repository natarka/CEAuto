*** Settings ***
Resource  ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Add Provider Configuration OnDemand
	Init Browser and login
	Add Provider Configuration    ${cpUser}    ${shortcode_ondemand}    N
	Logout and close browser

Test 002-Add Provider Configuration OnDemand
	Init Browser and login
	Add Provider Configuration    ${cpUser}    ${shortcode_ondemand1}    N
	Logout and close browser

Test 003-Add Provider Configuration OnDemand
	Init Browser and login
	Add Provider Configuration    ${cpUser}    ${shortcode_ondemand2}    N
	Logout and close browser

Test 004-Add Provider Configuration OnDemand
	Init Browser and login
	Add Provider Configuration    ${cpUser}    ${shortcode_ondemand3}    N
	Logout and close browser

Test 005-Add Provider Configuration Subscription
	Init Browser and login
	Add Provider Configuration    ${cpUser}    ${shortcode_subs}    Y
	Logout and close browser

Test 006-Add Provider Configuration Subscription
	Init Browser and login
	Add Provider Configuration    ${cpUser}    ${shortcode_subs1}    Y
	Logout and close browser

Test 007-Add Provider Configuration Subscription
	Init Browser and login
	Add Provider Configuration    ${cpUser}    ${shortcode_subs2}    Y
	Logout and close browser

Test 008-Add Provider Configuration Subscription
	Init Browser and login
	Add Provider Configuration    ${cpUser}    ${shortcode_subs3}    Y
	Logout and close browser