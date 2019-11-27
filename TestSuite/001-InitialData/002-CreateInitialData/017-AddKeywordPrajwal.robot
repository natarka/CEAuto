*** Settings ***
Documentation    Suite description
Resource  ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Add Keyword OnDemand
    Init Browser and login with MdxUser
    Mouse Over    //*[contains(text(),'System')]
    Wait Until Element Is Visible    //*[contains(text(),'Properties')]    5s
    Click Element    //*[contains(text(),'Properties')]
    Click Element    //*[@id='progType_chosen']/a
    Click Element    //*[@id='progType_chosen']/div/ul/li[2]
    Sleep    2s
    Input Text    //*[contains(text(),'FILE_DELIMITER')]/../td[3]/input    ,
    Input Text    //*[contains(text(),'MAX_FILE_ROWS')]/../td[3]/input    5
    Wait Until Element Is Visible    //input[@value='Update']    5s
    Click Element    //input[@value='Update']    
    logout and close browser