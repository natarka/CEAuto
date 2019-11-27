*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
Resource    ../../../Libraries/configurations.robot
*** Test Cases ***
Test Add SMSC Master
    Init Browser and login
	Add SMSC Master
    Logout and close browser    