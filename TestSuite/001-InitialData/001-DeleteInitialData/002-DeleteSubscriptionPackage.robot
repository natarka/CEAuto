*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Delete Subscription Package
    Check and delete subscription package    ${subs_pkg_name}    ${shortcode_subs}

Test 002-Delete Subscription Package
    Check and delete subscription package    ${subs_pkg_name1}    ${shortcode_subs1}
    
Test 003-Delete Subscription Package
    Check and delete subscription package    ${subs_pkg_name2}    ${shortcode_subs2}
    
Test 004-Delete Subscription Package
    Check and delete subscription package    ${subs_pkg_name3}    ${shortcode_subs3}