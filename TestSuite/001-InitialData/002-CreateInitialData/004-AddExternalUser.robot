*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test Add External User
    Init Browser and Login
    Add External User    ${cpUser}    ${cpPass}    ${cpUser}
    Logout and close browser