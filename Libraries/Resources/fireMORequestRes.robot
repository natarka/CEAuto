*** Settings ***
Documentation     Suite description
Resource          ../genericLibrary/webserviceTasks.robot

*** Keywords ***
moRequest
    [Arguments]    ${short_message}    ${source_addr}    ${dest_addr}
    ${moUrl}=    Get moUrl    ${short_message}    ${source_addr}    ${dest_addr}
    ${resp}=    Prepare and fire GETRequest    ${moUrl}
