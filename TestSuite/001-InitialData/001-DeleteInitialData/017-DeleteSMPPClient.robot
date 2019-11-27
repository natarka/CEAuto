*** Settings ***
Resource    ../../../Libraries/genericLibrary/sshTasks.robot
Resource    ../../../Libraries/configurations.robot
*** Test Cases ***
Test Delete SMPPClient
    # SSH to Server    ${testServer}    ${sshUser}    ${sshPassword}
    # ${result}    Execute shell and return    source .bash_profile;cd SMPPClient/apps/;./iwaInstanceManager
    # Sleep    2s
    # SSH to Server    ${testServer}    ${sshUser}    ${sshPassword}
    # ${result}    Execute shell and return    source .bash_profile;cd SMPPClient/apps/;./iwaMonitor stop
    # Sleep    2s
    # SSH to Server    ${testServer}    ${sshUser}    ${sshPassword}
    # ${result}    Execute shell and return    source .bash_profile;cd SMPPClient/apps/;./iwaMonitor start
    Open Connection    172.20.39.83
    Login    ceadmin43    ceadmin43
    ${result1}    Execute Command    source .bash_profile;cd SMPPClient/apps/;./iwaInstanceManager
    Log To Console    ${result1}    
    Log To Console    Step 1 complete
    Close Connection               
    Sleep    10s

	Open Connection    172.20.39.83
    Login    ceadmin43    ceadmin43
    ${result2}    Execute Command    source .bash_profile;cd SMPPClient/apps/;./iwaMonitor stop
    Log To Console    ${result2}
    Log To Console    Step 2 complete
    Close Connection               
    Sleep    10s

	Open Connection    172.20.39.83
    Login    ceadmin43    ceadmin43
    ${result3}    Execute Command    source .bash_profile;cd SMPPClient/apps/;./iwaMonitor start > /dev/null 2>&1
    Log To Console    ${result3}
    Log To Console    Step 3 complete
    Close Connection                                        