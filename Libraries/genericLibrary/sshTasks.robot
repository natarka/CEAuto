*** Settings ***
Library     SSHLibrary


*** Keywords ***

SSH to Server
    [Arguments]  ${ip}  ${userid}   ${password}
    Open Connection    ${ip}
    Login    ${userid}    ${password}

Execute shell and return
    [Arguments]  ${command}
    Start Command  ${command}
    ${output}=    Read Command Output    return_stdout=True    return_stderr=True
    [Return]    ${output}