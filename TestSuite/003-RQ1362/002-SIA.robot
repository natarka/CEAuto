*** Settings ***
Resource    ../../Libraries/genericLibrary/Library.robot
Resource    ../../Libraries/genericLibrary/webserviceTasks.robot
Resource    ../../Libraries/genericLibrary/commonTasks.robot

*** Variables ***
${FF_PROFILE}    C:/Users/naraypr/AppData/Roaming/Mozilla/Firefox/Profiles/eusnuhp2.default
# ${FF_PROFILE}    C:/Users/naraypr/Downloads/i3xp1voh.default-1511428621613
# ${path_of_extension}    C:/Users/naraypr/Downloads/modify_headers-0.7.1.1-fx.xpi
${header_name}    x-nokia-msisdn
${header_value}    111111130
${sia_msisdn}    0051111111130
${sia_tariff_id}    241
${sia_content_id}    0
${accept_button}    ACEPTARACEPTAR

*** Test Cases ***
Test 001 Customise Request Header
    Prepare Request Header File    ${FF_PROFILE}/modifyheaders.conf    ${header_name}    ${header_value}

Test 002 SIA without captcha
    ${response}    FireSOAPMethod_SIA    ${sia_tariff_id}    ${sia_msisdn}    ${sia_content_id}
    ${sia_url}    Set Variable    http://${testServer}:${adminUIPort}/siaarg/jsp/confcharge.jsp?_transactionId=${response}
    Open Browser    ${sia_url}    firefox    ff_profile_dir=${FF_PROFILE}
    Click Element    //input[@value='${accept_button}']

Test 003 SIA with captcha
    ${response}    FireSOAPMethod_SIA    ${sia_tariff_id}    ${sia_msisdn}    ${sia_content_id}
    ${sia_url}    Set Variable    http://${testServer}:${adminUIPort}/siaarg/jsp/confcharge.jsp?_transactionId=${response}
    Open Browser  ${sia_url}  firefox  ff_profile_dir=${FF_PROFILE}
    Sleep    3s    
    ${captcha}    Get WAP Captcha
    Log To Console    ${captcha}
    Input Text    //input[@name='captchaText']    ${captcha}
    Click Element    //input[@value='${accept_button}']

Test Firefox
    ${firefox_path}=    Evaluate    sys.modules['selenium.webdriver'].firefox.firefox_binary.FirefoxBinary(firefox_path="C:/Program Files (x86)/Mozilla Firefox/firefox.exe", log_file=None)    sys
    Create WebDriver    Firefox    firefox_profile_dir=${FF_PROFILE}    firefox_binary=${firefox_path} 
    Go to    http://www.google.co.in
    # Open Browser    http://www.google.co.in    firefox    ff_profile_dir=${FF_PROFILE}    

*** Keywords ***
Prepare Request Header File
    [Arguments]    ${header_conf_file_path}    ${header_name}    ${header_value}
    Create File    ${header_conf_file_path}    {"headers":[{"action":"Add","name":"${header_name}","value":"${header_value}","comment":"","enabled":true}]}

FireSOAPMethod_SIA
    [Arguments]    ${srsRatingId}    ${msisdn}    ${contentId}
    Create SOAP Client    ${SIATransactionService_wsdl}
    ${userTransactionId}    Generate Random String    8    [NUMBERS]
    Set Location    ${SIATransactionService_url}
    ${response}    Call Soap Method    requestTransaction    ${userId}    ${password}    ${userTransactionId}    ${srsRatingId}    ${channel}    ${msisdn}    ${contentId}    ${contentName}    ${urlOk}    ${urlCancel}    ${urlError}    ${urlUnsusc}    ${extraParam}
    ${response}=    Fetch From Right    ${response}    |
    Log To Console    ${response}
    [Return]    ${response}

Get WAP Captcha
    ${ls}=    Set Variable    ls -rth
    ${today}=    Return Date as YYYYMMDD
    ${fpath}=    Catenate    SEPARATOR=    ${wapCaptchaPath}    ${today}
    ${cmd}=    Catenate    ${ls}    ${fpath}    ${wap_captcha_cmd}
    SSH to Server    ${testServer}    ${sshUser}    ${sshPassword}
    ${result}=    Execute shell and return    ${cmd}
    [Return]    ${result}
