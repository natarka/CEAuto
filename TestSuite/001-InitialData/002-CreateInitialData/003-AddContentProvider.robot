*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test AddProvider
    Init Browser and login
    Add Content Provider
    Logout and close browser