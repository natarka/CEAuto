**** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test Add SMSG Config
    Init Browser and login
    Add SMSG Configuration
	Logout and close browser