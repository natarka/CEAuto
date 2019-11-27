*** Settings ***
Documentation     Common tasks
#Library           XvfbRobot
Library           SudsLibrary
Library           Collections
Library           DateTime
Library           Selenium2Library
Library           String
Library           genericLibrary
Library           OperatingSystem
Resource          ../../Libraries/configurations.robot
Resource          dbConnections.robot
Resource          ../../Libraries/testData/dbQueries.robot
Resource          ../../Libraries/testData/onDemand_Optin.robot
Resource          ../../Libraries/testData/subscription_Optin.robot
Resource          ../../Libraries/testData/webServiceDetails.robot
Resource          ../../Libraries/xpathRepo/login_page_xpath.robot
Resource          ../../Libraries/xpathRepo/onDemandOptInGlobalPage_xpath.robot
Resource          ../../Libraries/xpathRepo/propertiesPage.robot
Resource          ../../Libraries/xpathRepo/subscriptionOptInGlobalPage_xpath.robot
Resource          ../../Libraries/xpathRepo/subscriptionPackages_xpath.robot
Resource          ../../Libraries/xpathRepo/KeywordTariffMappingUploadPage_xpath.robot
Resource          ../../Libraries/xpathRepo/KeywordTariffUploadReportPage_xpath.robot
Resource          ../testData/genericData.robot
Resource          sshTasks.robot
Library            CreateExcelFile
Library            CreateExcelFile.ExcelUtility

*** Keywords ***
Create Headless Browser
    #Start Virtual Display    1920    1080
    Set Window Size    1920    1080

Create normal browser
    Open Browser    ${URL}    ${browser}
    maximize browser window

Init Browser and login
    #Create Headless Browser
    Create normal browser
    Wait Until Page Contains Element    ${login_username_loc}    30s    Timed out after 30 seconds
    Pass Input to    ${login_username_loc}    ${UserName}
    Pass Input to    ${login_password_loc}    ${Password}
    Submit the form    ${login_submit_loc}
    Sleep    ${micro_sleep}    
    Run Keyword And Ignore Error   Confirm Action

Init Browser and login with MdxUser
    #Create Headless Browser
    Create normal browser
    Wait Until Page Contains Element    ${login_username_loc}    30s    Timed out after 30 seconds
    Pass Input to    ${login_username_loc}    ${MDXUserName}
    Pass Input to    ${login_password_loc}    ${MDXPassword}
    Submit the form    ${login_submit_loc}
    Sleep    3s    
    Run Keyword And Ignore Error   Confirm Action

Init Browser and login Success
    [Arguments]    ${username}    ${password}
    #Create Headless Browser
    Create normal browser
    Wait Until Page Contains Element    ${login_username_loc}    30s    Timed out after 30 seconds
    Pass Input to    ${login_username_loc}    ${username}
    Pass Input to    ${login_password_loc}    ${password}
    Submit the form    ${login_submit_loc}
    Sleep    3s
    Run Keyword And Ignore Error   Confirm Action
    Sleep    3s
    Title Should Be    Commerce Engine - 4.3 - Main Menu

Init Browser and login Failure
    [Arguments]    ${username}    ${password}
    #Create Headless Browser
    Create normal browser
    Wait Until Page Contains Element    ${login_username_loc}    30s    Timed out after 30 seconds
    Pass Input to    ${login_username_loc}    ${username}
    Pass Input to    ${login_password_loc}    ${password}
    Submit the form    ${login_submit_loc}
    Sleep    3s
    Run Keyword And Ignore Error   Confirm Action
    Sleep    3s
    Page Should Contain    Invalid Username/Password    
    Title Should Be    Commerce Engine - 4.3 - LOGIN

Submit the form
    [Arguments]    ${xpath}
    Wait Until Page Contains Element    ${xpath}    30s    Timed out after 30 seconds
    Click Button    ${xpath}

Verify title displayed
    [Arguments]    ${title}
    sleep    ${small_sleep}
    Title Should Be    ${title}

Slide Me
    [Arguments]    ${xpath}
    click element    xpath=${xpath}

Handle Alert
    [Arguments]    ${text}
    Alert Should Be Present    ${text}

Click on
    [Arguments]    ${button}
    Wait Until Page Contains Element    ${button}    ${xlarge_sleep}    Timed out after ${xlarge_sleep}
    click element    ${button}

Pass Input to
    [Arguments]    ${xpath}    ${value}
    input text    ${xpath}    ${value}

Assert if string is equal
    [Arguments]    ${arg1}    ${arg2}
    Run keyword if    ${arg1} == ${arg2}    log to console    PASS

Assert if xpath and value is equal
    [Arguments]    ${xpath}    ${value}
    Element Should Contain    ${xpath}    ${value}

Navigate to
    [Arguments]    ${xpath1}    ${xpath2}
    Wait Until Page Contains Element    ${xpath1}    ${xlarge_sleep}    Timed out after ${xlarge_sleep}
    mouse over    ${xpath1}
    Wait Until Page Contains Element    ${xpath2}    ${xlarge_sleep}    Timed out after ${xlarge_sleep}
    Click on    ${xpath2}
    #Not used anywhere

Return Date as YYYYMMDD
    ${date}    Get Current Date    result_format=%Y%m%d
    [Return]    ${date}

Return TransactionDetails PartitionDate as PRT_TD_DDMMYY
    ${date}     Get Current Date    result_format=%d%m%y
    [Return]    'PRT_TD_'${date}

GetCDR
    [Arguments]    ${tid}    ${subtype}
    ${cat}=    Set Variable    cat
    ${cmd}=    Set Variable    | grep -v CallReference | grep
    ${cdrpath}=    Catenate    SEPARATOR=    ${cdrPath}    ${subtype}    /*
    ${fcmd}=    Catenate    ${cat}    ${cdrpath}    ${cmd}    ${tid}
    SSH to Server    ${testServer}    ${sshUser}    ${sshPassword}
    ${result}=    Execute shell and return    ${fcmd}
    
    ${length}=    Get Length    ${result}
    Run Keyword If    ${length}!=0    LOG    CDR is present with mentioned transactionId    
    ...    ELSE    ${result[0]}    GetCDR    ${tid}    ${subtype}
    [Return]    ${result[0]}

Get WAP Captcha
    ${ls}=    Set Variable    ls -rth
    ${today}=    Return Date as YYYYMMDD
    ${fpath}=    Catenate    SEPARATOR=    ${wapCaptchaPath}    ${today}
    ${cmd}=    Catenate    ${ls}    ${fpath}    ${wap_captcha_cmd}
    SSH to Server    ${testServer}    ${sshUser}    ${sshPassword}
    ${result}=    Execute shell and return    ${cmd}
    [Return]    ${result}

Navigate to second level
    [Arguments]    ${xpath1}    ${xpath2}
    Wait Until Element Is Visible    ${xpath1}    ${xlarge_sleep}    Timed out after ${xlarge_sleep}
    mouse over    ${xpath1}
    Wait Until Element Is Visible    ${xpath2}    ${xlarge_sleep}    Timed out after ${xlarge_sleep}
    Click on    ${xpath2}

Navigate to third level
    [Arguments]    ${xpath1}    ${xpath2}    ${xpath3}
    Wait Until Element Is Visible    ${xpath1}    ${xlarge_sleep}    Timed out after ${xlarge_sleep}
    mouse over    ${xpath1}
    Wait Until Element Is Visible    ${xpath2}    ${xlarge_sleep}    Timed out after ${xlarge_sleep}
    mouse over    ${xpath2}
    Wait Until Element Is Visible    ${xpath3}    ${xlarge_sleep}    Timed out after ${xlarge_sleep}
    Click on    ${xpath3}

Fail if two values dont match
    [Arguments]    ${expected_value}    ${actual_value}
    Should Be Equal    ${expected_value}    ${actual_value}

Oracle DB query
    [Arguments]    ${query}    ${expected}    ${datatype}
    ${int}    Set Variable    int
    ${str}    Set Variable    str
    
    Connect to oracle database
    ${result}    Query from database    ${query}
    Log To Console    ${result[0][0]}
    Run Keyword If    ${datatype}==${int} and '${result[0][0]}'!='${expected}'    Assert_int    ${expected}    ${query}
    ...    ELSE IF    ${datatype}==${int} and '${result[0][0]}'=='${expected}'    Should Be Equal As Integers    ${expected}    ${result[0][0]}
    ...    ELSE IF    ${datatype}==${str} and '${result[0][0]}'!='${expected}'    Assert_string    ${expected}    ${query}
    ...    ELSE IF    ${datatype}==${str} and '${result[0][0]}'=='${expected}'    Should Be Equal As Strings    ${expected}    ${result[0][0]}
    ...    ELSE    Log To Console    Invalid Datatype    
    Disconnect connection to oracleDB

Assert_int
    [Arguments]    ${expected}    ${query}
    Sleep    ${large_sleep}
    ${result}    Query from database    ${query}
    Log To Console    ${result[0][0]}
    Should Be Equal As Integers    ${expected}    ${result[0][0]}

Assert_string
    [Arguments]    ${expected}    ${query}
    Sleep    ${large_sleep}
    ${result}    Query from database    ${query}
    Log To Console    ${result[0][0]}
    Should Be Equal As Strings    ${expected}    ${result[0][0]}

OnDemand Optin
    [Arguments]    ${global_optin}    ${optin_at_tariff_level}
    Connect to oracle database
    ${result}    Query from database    ${isOnDemandOptinEnabled}
    Run Keyword If    ${result[0][0]}==${global_optin}    LOG    Expected and actual global optin is same
    ...    ELSE    GUI Enable On-Demand Global Opt-IN

    ${result}    Query from database    ${isOnDemandOptinBasedOnTariffEnabled}
    Run Keyword If    ${result[0][0]}==${optin_at_tariff_level}    LOG    Expected and actual tariff level optin is same
    ...    ELSE    GUI Enable On-Demand Opt-IN at Tariff Level
    Disconnect connection to oracleDB

GUI Enable On-Demand Global Opt-IN
    Init Browser and login
    Navigate to second level    ${services_header_loc}    ${onDemand_optin_loc}
    Click Element    ${enable_subscription_optin_loc}
    Click Element    ${onDemand_update_button_loc}
    Assert if xpath and value is equal    ${onDemand_update_succesfully_title_loc}    ${onDemand_update_succesfully_title}
    Close Browser

GUI Enable On-Demand Opt-IN at Tariff Level
    Init Browser and login
    Navigate to second level    ${services_header_loc}    ${onDemand_optin_loc}
    Click Element    ${onDemand_optin_based_on_tariff_loc}
    Click Element    ${onDemand_update_button_loc}
    Assert if xpath and value is equal    ${onDemand_update_succesfully_title_loc}    ${onDemand_update_succesfully_title}
    Close Browser

Configure OnDemand Notifications and session expiry
    Init Browser and login
    Navigate to second level    ${services_header_loc}    ${onDemand_optin_loc}
    Pass Input to    ${onDemand_notification_message_loc}    ${onDemand_global_accept_notification}
    Select value from dropdown    ${onDemand_allowed_keyword_loc}    ${onDemand_allowed_keyword_searchbox_loc}    ${onDemand_accept keyword}    ${onDemand_accpeptKeyword_highlighted_value_xpath}
    Select value from dropdown    ${onDemand_allowed_reject_keyword_loc}    ${onDemand_reject_keyword_searchbox_loc}    ${onDemand_reject keyword}    ${onDemand_rejectKeyword_highlighted_value_xpath}
    Pass Input to    ${onDemand_refuse_notification_loc}    ${onDemand_refuse notification}
    Pass Input to    ${onDemand_expiry_notification_loc}    ${onDemand_expiry notification}
    Pass Input to    ${onDemand_optin_session_expiry_time_loc}    1
    Click Element    ${onDemand_update_button_loc}
    Assert if xpath and value is equal    ${onDemand_update_succesfully_title_loc}    ${onDemand_update_succesfully_title}
    Close Browser

Select value from dropdown
    [Arguments]    ${xpath}    ${searchbox_xpath}    ${value}    ${highlighted_value_xpath}
    Click Element    ${xpath}
    Pass Input to    ${searchbox_xpath}    ${value}
    Sleep    1s    
    # Click Element    ${highlighted_value}
    Click Element    ${highlighted_value_xpath}

Update Global Captcha Flag
    [Arguments]    ${global_captcha_flag}
    #${somevlaue}    Set Variable    ${global_captcha_flag}
    #${n}    Set Variable    N
    Connect to oracle database
    ${result}    Query from database    ${isCaptchaEnabled}
    Run Keyword If    '${result[0][0]}'=='${global_captcha_flag}'    LOG    Expected and actual captcha are same
    ...    ELSE    GUI Update WAP Captcha flag    ${global_captcha_flag}

GUI Update WAP Captcha flag
    [Arguments]    ${global_captcha_flag}
    Init Browser and login
    Navigate to second level    ${system_header_loc}    ${properties_loc}
    Select value from dropdown    ${module_type_loc}    ${searchbox_xpath}    ${module_value}    ${highlighted_value}
    Wait Until Element Is Visible    ${SIA_CONF_CHRG_PAGE_CAPTCHA_ENABLE_loc}    5s
    Pass Input to    ${SIA_CONF_CHRG_PAGE_CAPTCHA_ENABLE_loc}    ${global_captcha_flag}
    Click Element    ${update_button_loc}
    Assert if xpath and value is equal    ${update_successfully_title_loc}    ${update_successfully_title}
    Close Browser

Initiate SIA browser transaction
    [Arguments]    ${transaction_id}
    Open Browser    ${SIAConfCharge_url}${transaction_id}    ${browser}
    maximize browser window

Compare CDRs
    [Arguments]    ${expected_cdr}    ${actual_cdr}
    Log To Console    Expected CDR=${expected_cdr}    
    Log To Console    Actual CDR=${actual_cdr}
    ${res}=    Match Cdrs    ${expected_cdr}    ${actual_cdr}
    Fail if two values dont match    ${res}    TRUE 

Change Account_balance in PPIN
    [Arguments]    ${msisdn}
    # Connect to sybase database
    EXECUTE SYBASE QUERY     update Subscriber set Account_balance = 9999999 where Sub_id='${msisdn}'
    # Disconnect connection to sybaseDB

Change Account_balance to zero
    [Arguments]    ${msisdn}
    # Connect to sybase database
    EXECUTE SYBASE QUERY     update Subscriber set Account_balance = 0 where Sub_id='${msisdn}'
    # Disconnect connection to sybaseDB
    
Compare Account_balance in PPIN
    [Arguments]    ${msisdn}    ${charged_price}
    # Connect to sybase database
    ${result}    EXECUTE SYBASE QUERY    select Account_balance from Subscriber where Sub_id='${msisdn}'
    Run Keyword If    ${result[0][0]}==9999999-${charged_price}    LOG    Balance is as expected
    ...    ELSE    LOG    Wrong balance in PPIN
    # close_sybaseConnection
    

Subscription Optin
    [Arguments]    ${global_optin}    ${optin_at_tariff_level}
    Connect to oracle database
    ${result}    Query from database    ${isSubscriptionOptinEnabled}
    Run Keyword If    ${result[0][0]}==${global_optin}    LOG    Expected and actual global optin is same
    ...    ELSE     GUI Enable Subscription Global Opt-IN

    ${result}    Query from database    ${isSubscriptionBasedOnTariffEnabled}
    Run Keyword If    ${result[0][0]}==${optin_at_tariff_level}    LOG    Expected and actual tariff level optin is same
    ...    ELSE    GUI Enable Subscription Opt-IN at Tariff Level
    Disconnect connection to oracleDB

GUI Enable Subscription Global Opt-IN
    Init Browser and login
    Navigate to third level    ${services_header_loc}    ${subscription_management_loc}    ${subscription_optin_loc}
    Click Element    ${enable_subscription_optin_loc}
    Sleep    ${micro_sleep}    
    Click Element    ${subscription_update_button_loc}
    # Assert if xpath and value is equal    ${subscription_update_succesfully_title_loc}    ${subscription_update_succesfully_title}
    Close Browser

GUI Enable Subscription Opt-IN at Tariff Level
    Init Browser and login
    Navigate to third level    ${services_header_loc}    ${subscription_management_loc}    ${subscription_optin_loc}
    Click Element    ${subscription_optin_based_on_tariff_loc}
    Sleep    ${micro_sleep}    
    Click Element    ${subscription_update_button_loc}
    # Assert if xpath and value is equal    ${subscription_update_succesfully_title_loc}    ${subscription_update_succesfully_title}
    Close Browser

Configure Subscription Notifications and session expiry
    Connect to oracle database
    ${result}    Query from database    ${maxConfiguredOptinLevel}
    Run Keyword If    ${result[0][0]}==1    Configure 1 level global Subcription notification
    ...    ELSE    Configure 2 level global Subcription notification
    Pass Input to    ${refuse_notification_loc}    ${subscription_refuse notification}
    Pass Input to    ${expiry_notification_loc}    ${subscription_expiry notification}
    Click Element    ${subscription_update_button_loc}
    # Assert if xpath and value is equal    ${subscription_update_succesfully_title_loc}    ${subscription_update_succesfully_title}
    Disconnect connection to oracleDB
    Close Browser

Configure 1 level global Subcription notification
    Init Browser and login
    Navigate to third level    ${services_header_loc}    ${subscription_management_loc}    ${subscription_optin_loc}
    Wait Until Page Contains Element    ${delete_optin_notificaiton_loc}    5s
    Click Element    ${delete_optin_notificaiton_loc}
    Pass Input to    ${optin_max_active_session_loc}    1
    Pass Input to    ${subscription_optin_session_expiry_time_loc}    1
    Sleep    ${micro_sleep}

    Pass Input to    ${notification_message_loc}    ${subscription_global_1st_level_optin_notification}
    Select value from dropdown    ${allowed_keyword_loc}    ${allowed_keyword_searchbox_loc}    ${subscription_1st_level_accept keyword}    ${highlighted_value}
    Select value from dropdown    ${allowed_reject_keyword_loc}    ${reject_keyword_searchbox_loc}    ${subscription_1st_level_reject keyword}    ${highlighted_value}
    Click Element    ${add_button_loc}
    Sleep    ${micro_sleep}
    Pass Input to    ${notification_message_loc}    ${subscription_global_2nd_level_optin_notification}
    Select value from dropdown    ${allowed_keyword_loc}    ${allowed_keyword_searchbox_loc}    ${subscription_2nd_level_accept keyword}    ${highlighted_value}
    Select value from dropdown    ${allowed_reject_keyword_loc}    ${reject_keyword_searchbox_loc}    ${subscription_2nd_level_reject keyword}    ${highlighted_value}
    Click Element    ${add_button_loc}

Configure 2 level global Subcription notification
    Init Browser and login
    Navigate to third level    ${services_header_loc}    ${subscription_management_loc}    ${subscription_optin_loc}
    Wait Until Page Contains Element    ${delete_optin_notificaiton_loc}    5s
    Click Element    ${delete_optin_notificaiton_loc}
    Sleep    ${micro_sleep}
    Wait Until Page Contains Element    ${delete_optin_notificaiton_loc}    5s
    Click Element    ${delete_optin_notificaiton_loc}
    Pass Input to    ${optin_max_active_session_loc}    1
    Pass Input to    ${subscription_optin_session_expiry_time_loc}    1

    Pass Input to    ${notification_message_loc}    ${subscription_global_1st_level_optin_notification}
    Select value from dropdown    ${allowed_keyword_loc}    ${allowed_keyword_searchbox_loc}    ${subscription_1st_level_accept keyword}    ${highlighted_value}
    Select value from dropdown    ${allowed_reject_keyword_loc}    ${reject_keyword_searchbox_loc}    ${subscription_1st_level_reject keyword}    ${highlighted_value}
    Click Element    ${add_button_loc}
    Sleep    ${micro_sleep}
    Pass Input to    ${notification_message_loc}    ${subscription_global_2nd_level_optin_notification}
    Select value from dropdown    ${allowed_keyword_loc}    ${allowed_keyword_searchbox_loc}    ${subscription_2nd_level_accept keyword}    ${highlighted_value}
    Select value from dropdown    ${allowed_reject_keyword_loc}    ${reject_keyword_searchbox_loc}    ${subscription_2nd_level_reject keyword}    ${highlighted_value}
    Click Element    ${add_button_loc}

Get DB details
    [Arguments]    ${query}
    Sleep    ${small_sleep}    
    Connect to oracle database
    ${result}    Query from database    ${query}
    [Return]    ${result[0][0]}

Create Internal User
    [Arguments]    ${username}    ${password}
    Mouse Over    //*[@id='myslidemenu']/ul/li[5]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[5]/ul/li[7]/a    5s    
    Mouse Over    //*[@id='myslidemenu']/ul/li[5]/ul/li[7]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[5]/ul/li[7]/ul/li[1]/a    5s    
    Click Element    //*[@id='myslidemenu']/ul/li[5]/ul/li[7]/ul/li[1]/a
    Click Element    //input[@value='Add']
    Input Text    //input[@name='userId']    ${username}
    Input Text    //input[@name='firstName']    ${username}
    Input Text    //input[@name='lastName']    ${username}
    Input Text    //input[@name='password']    ${password}
    Input Text    //input[@name='con_pass']    ${password}
    Input Text    //input[@name='emailId']    ${email}
    Input Text    //input[@name='msisdn']    ${contact_number}
    Click Element    //input[@name='validFromStringTemp']
    Click Element    //a[@class='ui-state-default ui-state-highlight ui-state-hover']
    Click Element    //input[@name='validTillStringTemp']
    Click Element    //span[@class='ui-icon ui-icon-circle-triangle-e']
    Click Element    //span[@class='ui-icon ui-icon-circle-triangle-e']
    Click Element    //span[@class='ui-icon ui-icon-circle-triangle-e']
    Click Element    //*[@id='ui-datepicker-div']/table/tbody/tr[3]/td[4]/a
    Click Element    //label[@for='roleAll']
    Click Element    //input[@value='Save']
    Page Should Contain    Added Successfully

Add Content Provider
    Mouse Over    //*[@id='myslidemenu']/ul/li[2]/a
    Click Element    //*[@id='myslidemenu']/ul/li[2]/ul/li[1]/a
    Click Element    //input[@value='Add']
    Input Text    //input[@name='contentPartnerCode']    ${cpUser}
    Input Text    //input[@name='contentPartnerName']    ${cpUser}
    Input Text    //input[@name='contentPartnerContentNumber']    ${contact_number}
    Input Text    //input[@name='contentPartnerEmail']    ${email}
    Click Element    //label[@for='serviceTypeCp0']
    Click Element    //a[@class='chosen-single']
    Click Element    //*[@id='cpTypeId']/td[1]/div/div/ul/li[2]
    Click Button    //input[@value='Save']
    Page Should Contain    saved successfully

Logout and close browser
    Click Element    //a[@class='logout']
    Close Browser

Add External User
    [Arguments]    ${username}    ${password}    ${providername}
    Mouse Over    //*[@id='myslidemenu']/ul/li[5]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[5]/ul/li[7]/a    5s
    Mouse Over    //*[@id='myslidemenu']/ul/li[5]/ul/li[7]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[5]/ul/li[7]/ul/li[2]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[5]/ul/li[7]/ul/li[2]/a    
    Click Element    //input[@value='Add']
    Input Text    //input[@name='userId']    ${username}
    Input Text    //input[@name='firstName']    ${username}
    Input Text    //input[@name='lastName']    ${username}
    Input Text    //input[@name='password']    ${password}
    Input Text    //input[@name='con_pass']    ${password}
    Input Text    //input[@name='emailId']    ${email}
    Input Text    //input[@name='msisdn']    ${contact_number}
    Click Element    //*[@id='contentProviderId_chosen']/a/div/b
    Input Text    //*[@id='contentProviderId_chosen']/div/div/input    ${providername}
    Click Element    //*[@id='contentProviderId_chosen']/div/ul/li/em
    Click Element    //input[@name='validFromStringTemp']
    Click Element    //a[@class='ui-state-default ui-state-highlight ui-state-hover']
    Click Element    //input[@name='validTillStringTemp']
    Click Element    //span[@class='ui-icon ui-icon-circle-triangle-e']
    Click Element    //span[@class='ui-icon ui-icon-circle-triangle-e']
    Click Element    //span[@class='ui-icon ui-icon-circle-triangle-e']
    Click Element    //*[@id='ui-datepicker-div']/table/tbody/tr[3]/td[4]/a
    Click Element    //label[@for='roleAll']
    Click Element    //input[@value='Save']
    Page Should Contain    Added Successfully

Add External Central User
    [Arguments]    ${username}    ${password}
    Mouse Over    //*[contains(text(),'System')]
    Wait Until Element Is Visible    //*[contains(text(),'Users')]    5s
    Mouse Over    //*[contains(text(),'Users')]
    Wait Until Element Is Visible    //*[contains(text(),'User Profile - External')]    5s
    Click Element    //*[contains(text(),'User Profile - External')]
    Click Add
    Sleep    2s
    Click Element    //*[@type='radio']/../../td[2]/label
    Sleep    2s
    Input Text    //input[@name='userId']    ${username}
    Input Text    //input[@name='firstName']    ${username}
    Input Text    //input[@name='lastName']    ${username}
    Input Text    //input[@id='password']    ${password}
    Input Text    //input[@id='con_pass']    ${password}
    Input Text    //input[@name='emailId']    ${email}
    Input Text    //input[@id='msisdn']    ${contact_number}
    Click Element    //input[@name='validFromStringTemp']
    Click Element    //a[@class='ui-state-default ui-state-highlight ui-state-hover']
    Click Element    //input[@name='validTillStringTemp']
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/table/tbody/tr[3]/td[4]/a
    Click Element    //input[@value='Save']
    Sleep    2s    
    Page Should Contain    Added Successfully
    
Add SMSC Master
    Mouse Over    //*[@id='myslidemenu']/ul/li[2]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/a    5s
    Mouse Over    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/a    5s
    Mouse Over    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/ul/li[1]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/ul/li[1]/a
    Click Element    //input[@value='Add']
    Input Text    //input[@name='ssdSmscIdentity']    ${smscName}
    Input Text    //input[@name='ssdSmscIp']    ${smscIP}
    Input Text    //input[@name='ssdSmscRxPort']    ${smscRxPort}
    Input Text    //input[@name='ssdSmscTxPort']    ${smscTxPort}
    Input Text    //input[@name='ssdSmscTrxPort']    ${smscTRxPort}
    Input Text    //input[@name='ssdSmscDesc']    ${smscName}
    Click Element    //input[@value='Save']
    Page Should Contain    saved successfully

Check and delete SMSC Master
    Connect to oracle database
    ${result}    Query from database    select count(1) from SMSG_SMSC_DETAILS where ssd_smsc_identity='${smscName}'
    Run Keyword If    ${result[0][0]}==0    Log    No SMSC configuration present
    ...    ELSE    Delete SMSC Master
    
Delete SMSC Master
    Init Browser and login with MdxUser
    Mouse Over    //*[@id='myslidemenu']/ul/li[2]/a
	Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/a    5s    
	Mouse Over    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/a
	Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/a    5s    
	Mouse Over    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/a
	Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/ul/li[1]/a    5s    
	Click Element    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/ul/li[1]/a
	Input Text    //input[@id='searchKey']    ${smscName}
	Click Element    //input[@value='Search']
	Click Element    //a[@class='action-delete']
	Run Keyword And Ignore Error   Confirm Action
	Page Should Contain    deleted successfully
	Logout and close browser
	
Add SMSG Configuration
    Mouse Over    //*[@id='myslidemenu']/ul/li[2]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/a    5s
    Mouse Over    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/a    5s
    Mouse Over    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/ul/li[2]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/ul/li[2]/a
    Click Element    //input[@value='Add']
    Input Text    //input[@name='accountDescription']    ${smsgName}
    Click Element    //*[contains(text(),'${smscName} (${smscIP})')]
    Click Element    //*[contains(text(),'Receiver')]
    Click Element    //*[@id='TX']/a
    Input Text    //*[@id='tab1']/table/tbody/tr[1]/td[1]/input[1]    ${TxSystemId}
    Input Text    //*[@id='tab1']/table/tbody/tr[1]/td[2]/input    ${TxPassword}
    Click Element    //*[@id='RX']/a
    Input Text    //*[@id='tab2']/table/tbody/tr[1]/td[1]/input[1]    ${RxSystemId}
    Input Text    //*[@id='tab2']/table/tbody/tr[1]/td[2]/input    ${RxPassword}
    Click Element    //input[@value='Save']
    Page Should Contain    saved successfully

Check and delete SMSG configuration
    Connect to oracle database
    ${result}    Query from database    select count(1) from SMSG_ACCOUNT_MASTER where sam_account_description = '${smsgName}'
    Run Keyword If    ${result[0][0]}==0    Log    No SMSG configuration present
    ...    ELSE    Delete SMSG Configuration
	
Delete SMSG Configuration
    Init Browser and login with MdxUser
    Mouse Over    //*[@id='myslidemenu']/ul/li[2]/a
	Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/a    5s    
	Mouse Over    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/a
	Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/a    5s    
	Mouse Over    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/a
	Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/ul/li[2]/a    5s
	Click Element    //*[@id='myslidemenu']/ul/li[2]/ul/li[2]/ul/li[1]/ul/li[2]/a
	Input Text    //input[@name='searchKey']    ${TxSystemId}
	Click Element    //input[@value='Search']
	Page Should Contain    ${smsgName}
	Click Element    //a[@class='action-delete']
	Run Keyword And Ignore Error   Confirm Action
	Page Should Contain    deleted successfully
	Logout and close browser

Check and update PRICING_AUTO_GEN_ID_FLAG
    [Arguments]    ${flag_value}
    Connect to oracle database
    ${result}    Query from database    select acm_keyvalue from APPLICATION_CONFIG_MASTER where acm_keyname='PRICING_AUTO_GEN_ID_FLAG'
    Run Keyword If    '${result[0][0]}'=='${flag_value}'    Log    Flag value same in DB, no need to update
    ...    ELSE    Update PRICING_AUTO_GEN_ID_FLAG    ${flag_value}
	
Update PRICING_AUTO_GEN_ID_FLAG
    [Arguments]    ${flag_value}
    Init Browser and login with MdxUser
    Mouse Over    //*[@id='myslidemenu']/ul/li[5]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[5]/ul/li[5]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[5]/ul/li[5]/a
    Click Element    //*[@id='progType_chosen']/a/span
    Click Element    //*[@id='progType_chosen']/div/ul/li[3]
    Wait Until Element Is Visible    //*[@id='PARAMS']/div[2]/table/tbody/tr[37]/td[3]/input    5s
    Input Text    //*[@id='PARAMS']/div[2]/table/tbody/tr[37]/td[3]/input    ${flag_value}
    Wait Until Element Is Visible    //input[@value='Update']
    Click Element    //input[@value='Update']
    Page Should Contain    Parameter Values updated successfully for Module ADMIN-UI
    Logout and close browser

Add Application
    [Arguments]    ${app_id}    ${app_name}
    Init Browser and login
    Mouse Over    //*[@id='myslidemenu']/ul/li[3]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[3]/ul/li[1]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[3]/ul/li[1]/a
    Click Element    //input[@value='Add']
    Wait Until Element Is Visible    //input[@id='appsId']    5s
    Input Text    //input[@id='appsId']    ${app_id}
    Wait Until Element Is Visible    //input[@name='appsName']    5s
    Input Text    //input[@name='appsName']    ${app_name}
    Wait Until Element Is Visible    //input[@value='Save']    5s
    Click Element    //input[@value='Save']
    Page Should Contain    saved successfully
    Logout and close browser

Check and delete application
    [Arguments]    ${app_name}
    Connect to oracle database
    ${result}    Query from database    select count(1) from CONTENT_PARTNER_APPLICATION where cpa_application_name = '${app_name}'
    Run Keyword If    ${result[0][0]}==0    Log    No application present
    ...    ELSE    Delete Application    ${app_name}

Delete Application
    [Arguments]    ${app_name}
    Init Browser and login with MdxUser
    Mouse Over    //*[@id='myslidemenu']/ul/li[3]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[3]/ul/li[1]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[3]/ul/li[1]/a
    Input Text    //input[@name='searchKey']    ${app_name}
    Click Element    //a[@class='action-delete']
    Run Keyword And Ignore Error   Confirm Action
    Page Should Contain    deleted successfully
    Logout and close browser

Check and Add Delivery Channel
    [Arguments]    ${channel_id}    ${channel_name}
    Connect to oracle database
    ${result}    Query from database    select count(1) from delivery_channel_master where dcm_channel_name = '${channel_name}'
    Run Keyword If    ${result[0][0]}==1    Log    Delivery Channel ${channel_name} already exists
    ...    ELSE    Add Delivery Channel    ${channel_id}    ${channel_name}

Add Delivery Channel
    [Arguments]    ${channel_id}    ${channel_name}
    Log    Creating new Delivery channel ${channel_name}
    Init Browser and login
    Mouse Over    //*[@id='myslidemenu']/ul/li[3]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[3]/ul/li[2]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[3]/ul/li[2]/a
    Click Element    //input[@value='Add']
    Input Text    //input[@id='delivId']    ${channel_id}
    Input Text    //input[@name='channelName']    ${channel_name}
    Click Element    //input[@value='Save']
    Page Should Contain    saved successfully
    Logout and close browser

Check and Delete Delivery Channel
    [Arguments]    ${channel_name}
    Connect to oracle database
    ${result}    Query from database    select count(1) from delivery_channel_master where dcm_channel_name = '${channel_name}'
    Run Keyword If    ${result[0][0]}==0    Log        Delivery Channnel ${channel_name} does not exist
    ...    ELSE    Delete Delivery Channel    ${channel_name}

Delete Delivery Channel
    [Arguments]    ${channel_name}
    Log    Deleting Delivery Channel ${channel_name}
    Init Browser and login with MdxUser
    Mouse Over    //*[@id='myslidemenu']/ul/li[3]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[3]/ul/li[2]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[3]/ul/li[2]/a
    Input Text    //input[@name='searchKey']    ${channel_name}
    Click Element    //input[@value='Search']
    Click Element    //a[@class='action-delete']
    Run Keyword And Ignore Error   Confirm Action
    Logout and close browser

Add Content Type OnDemand
    [Arguments]    ${content_id}    ${content_name}
    Init Browser and login
    Mouse Over    //*[@id='myslidemenu']/ul/li[3]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[3]/ul/li[3]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[3]/ul/li[3]/a
    Click Element    //input[@value='Add']
    Input Text    //input[@id='cTypeId']    ${content_id}
    Input Text    //input[@name='contentTypeName']    ${content_name}
    Click Element    //input[@value='Save']
    Page Should Contain    saved successfully
    Logout and close browser

Check and Delete Content
    [Arguments]    ${content_name}
    Connect to oracle database
    ${result}    Query from database    select count(1) from content_type_master where ctm_content_type='${content_name}'
    Run Keyword If    ${result[0][0]}==0    Log    ${content_name} does not exist
    ...    ELSE  Delete Content    ${content_name}
    
Delete Content
    [Arguments]    ${content_name}
    Init Browser and login with MdxUser
    Mouse Over    //*[@id='myslidemenu']/ul/li[3]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[3]/ul/li[3]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[3]/ul/li[3]/a
    Input Text    //input[@name='searchKey']    ${content_name}
    Click Element    //input[@value='Search']
    Click Element    //a[@class='action-delete']
    Run Keyword And Ignore Error   Confirm Action
    Page Should Contain    deleted successfully
    Logout and close browser    
    
Add Content Type Subscription
    [Arguments]    ${content_id}    ${content_name}
    Init Browser and login
    Mouse Over    //*[@id='myslidemenu']/ul/li[3]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[3]/ul/li[3]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[3]/ul/li[3]/a
    Click Element    //input[@value='Add']
    Input Text    //input[@id='cTypeId']    ${content_id}
    Input Text    //input[@name='contentTypeName']    ${content_name}
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[3]/td/label/span
    Click Element    //input[@value='Save']
    Page Should Contain    saved successfully
    Logout and close browser

Add Short Code
    [Arguments]    ${shortcode}
    Mouse Over    //*[@id='myslidemenu']/ul/li[4]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[4]/ul/li[2]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[4]/ul/li[2]/a
    Click Element    //input[@value='Add']
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[1]/td[1]/div/a
    Input Text    //*[@id='main']/div/form/div[1]/table/tbody/tr[1]/td[1]/div/div/div/input    ${category}
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[1]/td[1]/div/div/ul/li
    Input Text    //input[@name='shortCode']    ${shortcode}
    Input Text    //input[@name='description']    auto_shortcode
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[2]/td[2]/div/a
    Input Text    //*[@id='main']/div/form/div[1]/table/tbody/tr[2]/td[2]/div/div/div/input    ${delivery_channel}
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[2]/td[2]/div/div/ul/li[1]
    Click Element    //*[@id='TABSMS']/table/tbody/tr[1]/td/div/a
    Input Text    //*[@id='TABSMS']/table/tbody/tr[1]/td/div/div/div/input    ${smsgName}
    Click Element    //*[@id='TABSMS']/table/tbody/tr[1]/td/div/div/ul/li
    Click Element    //input[@value='Save']

Check and Delete Short Code
    [Arguments]    ${shortcode}
    Connect to oracle database
    ${result}    Query from database    select count(1) from CGW_SHORTCODE_MASTER where scm_short_code=${shortcode}
    Run Keyword If    ${result[0][0]}==0    Log    ${shortcode} does not exist
    ...    ELSE  Delete Short Code    ${shortcode}  

Delete Short Code
    [Arguments]    ${shortcode}
    Init Browser and login with MdxUser
    Mouse Over    //*[@id='myslidemenu']/ul/li[4]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[4]/ul/li[2]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[4]/ul/li[2]/a
    Input Text    //input[@name='searchKey']    ${shortcode}
    Click Element    //input[@value='Search']
    Click Element    //a[@class='action-delete']
    Run Keyword And Ignore Error   Confirm Action
    Page Should Contain    deleted successfully
    Logout and close browser

Add Tariff
    [Arguments]    ${content_id}    ${content_name}    ${app_name}    ${shortcode}
    Mouse Over    //*[@id='myslidemenu']/ul/li[3]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[3]/ul/li[4]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[3]/ul/li[4]/a
    Click Element    //input[@value='Add']
    Wait Until Element Is Visible    //input[@id='ccId']    5s
    Input Text    //input[@id='ccId']    ${content_id}
    Click Element    //*[@id='providerComboList0_chosen']/a/span
    Input Text    //*[@id='providerComboList0_chosen']/div/div/input    ${cpUser}
    Click Element    //*[@id='providerComboList0_chosen']/div/ul/li
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[2]/td[2]/div/a/span
    Input Text    //*[@id='main']/div/form/div[1]/table/tbody/tr[2]/td[2]/div/div/div/input    ${content_name}
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[2]/td[2]/div/div/ul/li
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[4]/td[1]/div/a/span
    Input Text    //*[@id='main']/div/form/div[1]/table/tbody/tr[4]/td[1]/div/div/div/input    ${app_name}
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[4]/td[1]/div/div/ul/li
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[4]/td[2]/div/a/span
    Input Text    //*[@id='main']/div/form/div[1]/table/tbody/tr[4]/td[2]/div/div/div/input    ${shortcode}
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[4]/td[2]/div/div/ul/li
    Input Text    //input[@name='ETT']    ${app_name}
    Click Element    //*[@id='tax_chosen']/a/span
    Input Text    //*[@id='tax_chosen']/div/div/input    ${tax}
    Click Element    //*[@id='tax_chosen']/div/ul/li
    Click Element    //h2[@id='priceInfoH2']
    Click Element    //input[@name='fromDate']
    Click Element    //a[@class='ui-state-default ui-state-highlight ui-state-hover']
    Click Element    //input[@name='toDate']
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/table/tbody/tr[3]/td[4]/a
    Input Text    //input[@name='price']    ${price}
    Input Text    //input[@name='minPrice']    ${minPrice}
    Input Text    //input[@name='shipmentPrice']    ${shipmentPrice}
    Click Element    //input[@value='Add']
    Click Element    //*[@id='commissionHeader_0']
    Click Element    //input[@name='fromDateMainComm0']
    Click Element    //a[@class='ui-state-default ui-state-highlight ui-state-hover']
    Click Element    //input[@name='toDateMainComm0']
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/table/tbody/tr[3]/td[4]/a
    Input Text    //input[@name='mainCommissionFlat0']    ${commission}
    Click Element    //*[@id='mainCommissionRule0_chosen']/a/span
    Click Element    //*[@id='mainCommissionRule0_chosen']/div/ul/li[2]
    Click Element    //*[@id='mainCommissionType0_chosen']/a/span
    Click Element    //*[@id='mainCommissionType0_chosen']/div/ul/li[2]
    Click Element    //*[@id='commissionInfoTASKS_0']/tbody/tr[3]/td[5]/input
    Click Element    //input[@value='Save']
    Page Should Contain    Tariff successfully saved

Check and delete tariff
    [Arguments]    ${shortcode}
    Connect to oracle database
    ${result}    Query from database    select count(1) from charge_code_master where ccm_scm_short_code=${shortcode}
    Run Keyword If    '${result[0][0]}'=='0'    Log    No Tariff Present
    ...    ELSE    Delete tariff    ${shortcode}
    
Delete tariff
    [Arguments]    ${shortcode}
    Init Browser and login with MdxUser
    Mouse Over    //*[@id='myslidemenu']/ul/li[3]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[3]/ul/li[4]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[3]/ul/li[4]/a
    Click Element    //*[@id='searchParamId_chosen']/a/span
    Click Element    //*[@id='searchParamId_chosen']/div/ul/li[5]
    Input Text    //*[@id='searchKey']    ${shortcode}
    Click Element    //input[@value='Search']
    Click Element    //a[@class='action-delete']
    Run Keyword And Ignore Error   Confirm Action
    Page Should Contain    deleted successfully
    Logout and close browser

Add Keyword
    [Arguments]     ${keyword_category}     ${keyword}
    mouse over  //*[@id='myslidemenu']/ul/li[4]/a
   wait until element is visible  //*[@id='myslidemenu']/ul/li[4]/ul/li[1]/a	5s
   click element  //*[@id='myslidemenu']/ul/li[4]/ul/li[1]/a
   click element  //input[@value='Add']
   click element  //*[@id='main']/div/form/div[1]/table/tbody/tr[1]/td/div/a/span
   input text  //*[@id='main']/div/form/div[1]/table/tbody/tr[1]/td/div/div/div/input  ${keyword_category}
   click element  //*[@id='main']/div/form/div[1]/table/tbody/tr[1]/td/div/div/ul/li
   input text  //input[@name='keyword']  ${keyword}
   click element  //input[@value='Save']
   page should contain  saved successfully

Add Keyword with Alias
    [Arguments]     ${keyword_category}     ${keyword}    ${keyword_alias}
    mouse over  //*[@id='myslidemenu']/ul/li[4]/a
   wait until element is visible  //*[@id='myslidemenu']/ul/li[4]/ul/li[1]/a	5s
   click element  //*[@id='myslidemenu']/ul/li[4]/ul/li[1]/a
   click element  //input[@value='Add']
   click element  //*[@id='main']/div/form/div[1]/table/tbody/tr[1]/td/div/a/span
   input text  //*[@id='main']/div/form/div[1]/table/tbody/tr[1]/td/div/div/div/input  ${keyword_category}
   click element  //*[@id='main']/div/form/div[1]/table/tbody/tr[1]/td/div/div/ul/li
   input text  //input[@name='keyword']  ${keyword}
   Input Text    //input[@name='aliasName']    ${keyword_alias}
   Click Element    //input[@value='Add']
   click element  //input[@value='Save']
   page should contain  saved successfully

Check and delete keyword
    [Arguments]		${keyword}
    Connect to oracle database
    ${result}    Query from database    select count(1) from CGW_KEYWORD where ck_name_s='${keyword}'
    Run Keyword If    '${result[0][0]}'=='0'    Log    No keyword Present
    ...    ELSE    Delete Keyword    ${keyword}

Delete Keyword
    [Arguments]		${keyword}
    Init Browser and login with MdxUser
    mouse over  //*[@id='myslidemenu']/ul/li[4]/a
	wait until element is visible  //*[@id='myslidemenu']/ul/li[4]/ul/li[1]/a	5s
	click element  //*[@id='myslidemenu']/ul/li[4]/ul/li[1]/a
	input text  //*[@id='keywordSearch']	${keyword}
	click element  //input[@value='Search']
	Click Element    //a[@class='action-delete']
	Run Keyword And Ignore Error   Confirm Action
	Page Should Contain    deleted successfully
	logout and close browser

Add Provider Configuration
    [Arguments]    ${ContentProvider}    ${ShortCode}    ${isSubscription}
    Run Keyword If    '${isSubscription}'=='N'    Add Provider Configuration OnDemand    ${ContentProvider}    ${ShortCode}
    ...    ELSE    Add Provider Configuration Subscription    ${ContentProvider}    ${ShortCode}    

Add Provider Configuration OnDemand
    [Arguments]    ${ContentProvider}    ${ShortCode}
    mouse over    //*[@id='myslidemenu']/ul/li[4]/a
    wait until element is visible    //*[@id='myslidemenu']/ul/li[4]/ul/li[4]/a    ${small_sleep}
    click element    //*[@id='myslidemenu']/ul/li[4]/ul/li[4]/a
    click element    //input[@value='Add']
    click element    //*[@id='contentPatnerIdStr_chosen']/a/span
    input text    //*[@id='contentPatnerIdStr_chosen']/div/div/input    ${ContentProvider}
    click element    //*[@id='contentPatnerIdStr_chosen']/div/ul/li
    Click Element    //*[@id='serviceTypesList_chosen']/a/span
    input text    //*[@id='serviceTypesList_chosen']/div/div/input    ${delivery_channel}
    click element    //*[@id='serviceTypesList_chosen']/div/ul/li
    click element    //*[@id='shortCodeId_chosen']/a/span
    input text    //*[@id='shortCodeId_chosen']/div/div/input    ${ShortCode}
    click element    //*[@id='shortCodeId_chosen']/div/ul/li
    input text    //*[@id='shortRowId']/td[2]/input    ${ContentProvider}
    click element    //*[contains(text(),'SMPP')]
    click element    //*[@id='moApplayRowId']/td/label/span
    click element    //*[@id='mtApplayRowId']/td[1]/label/span
    click element    //input[@value='Save']
    Page Should Contain    added successfully

Add Provider Configuration Subscription
    [Arguments]    ${ContentProvider}    ${ShortCode}
    mouse over  //*[@id='myslidemenu']/ul/li[4]/a
	wait until element is visible  //*[@id='myslidemenu']/ul/li[4]/ul/li[4]/a	${small_sleep}
	click element  //*[@id='myslidemenu']/ul/li[4]/ul/li[4]/a
	click element  //input[@value='Add']
	click element  //*[@id='contentPatnerIdStr_chosen']/a/span
	input text  //*[@id='contentPatnerIdStr_chosen']/div/div/input		${ContentProvider}
	click element  //*[@id='contentPatnerIdStr_chosen']/div/ul/li
	Click Element    //*[@id='serviceTypesList_chosen']/a/span
	input text  //*[@id='serviceTypesList_chosen']/div/div/input	${delivery_channel}
	click element  //*[@id='serviceTypesList_chosen']/div/ul/li
	click element  //*[@id='shortCodeId_chosen']/a/span
	input text  //*[@id='shortCodeId_chosen']/div/div/input		${ShortCode}
	click element  //*[@id='shortCodeId_chosen']/div/ul/li
	input text  //*[@id='shortRowId']/td[2]/input		${ContentProvider}
	click element  	//*[contains(text(),'SMPP')]
	click element  //*[@id='moApplayRowId']/td/label/span
	# click element  //*[@id='mtApplayRowId']/td[1]/label/span
	click element  //input[@value='Save']
	Page Should Contain    added successfully

Check and delete provider configuration
    [Arguments]    ${ShortCode}
    Connect to oracle database
    ${result}    Query from database    select count(1) from cgw_cp_config_master where ccm_scm_id in (select scm_id from cgw_shortcode_master where scm_short_code=${ShortCode})
    Run Keyword If    '${result[0][0]}'=='0'    Log    No provider configuration Present
    ...    ELSE    Delete Provider Configuration    ${ShortCode}

Delete Provider Configuration
    [Arguments]    ${ShortCode}
    Init Browser and login with MdxUser
    mouse over  //*[@id='myslidemenu']/ul/li[4]/a
	wait until element is visible  //*[@id='myslidemenu']/ul/li[4]/ul/li[4]/a	${small_sleep}
	click element  //*[@id='myslidemenu']/ul/li[4]/ul/li[4]/a
	Input Text    //input[@id='shortCodeSearch']    ${ShortCode}
	Click Element    //input[@value='Search']
	Click Element    //a[@class='action-delete']
	Run Keyword And Ignore Error   Confirm Action
	Page Should Contain    deleted successfully
	Logout and close browser

Add Access Channel
    [Arguments]    ${ShortCode}
    Connect to oracle database
    ${result}    Query from database    select sgm_server_desc from SMPPSERVER_GATEWAY_MASTER where sgm_server_ip='${smscIP}'
    Init Browser and login
    Mouse Over    //*[@id='myslidemenu']/ul/li[4]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[4]/ul/li[5]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[4]/ul/li[5]/a
    Click Element    //input[@value='Add']
    Click Element    //*[@id='serviceTypesList_chosen']/a/span
    Input Text    //*[@id='serviceTypesList_chosen']/div/div/input    ${delivery_channel}
    Click Element    //*[@id='serviceTypesList_chosen']/div/ul/li
    Sleep    2s
    Click Element    //*[@id='shortCodeId_chosen']/a/span
    Input Text    //*[@id='shortCodeId_chosen']/div/div/input    ${ShortCode}
    Click Element    //*[@id='shortCodeId_chosen']/div/ul/li
    Click Element    //*[@id='servNumber']/td/div/a/span
    Input Text    //*[@id='servNumber']/td/div/div/div/input    ${result[0][0]}
    Click Element    //*[@id='servNumber']/td/div/div/ul/li
    Click Element    //*[@id='BINDTYPES']/td/label[2]/span
    Click Element    //*[@id='LI_TX']/a
    Input Text    //input[@name='systemIdTx']    ${TxSystemId}
    Input Text    //input[@name='systemPasswordTx']    ${TxPassword}
    Click Element    //*[@id='LI_RX']/a
    Input Text    //input[@name='systemIdRx']    ${RxSystemId}
    Input Text    //input[@name='systemPasswordRx']    ${RxPassword}
    Click Element    //*[@id='LI_SMPPNOT']/a
    Input Text    //input[@name='smppWebEPR']    ${cp_notif_url}
    Click Element    //input[@value='Save']
    Page Should Contain    saved successfully
    Logout and close browser

Check and delete access channel
    [Arguments]    ${ShortCode}
    Connect to oracle database
    ${result}    Query from database    select count(1) from mv_cpconfig_access_channel where cacm_schortcode=${ShortCode}
    Run Keyword If    '${result[0][0]}'=='0'    Log    No Access channel mapping Present
    ...    ELSE    Delete Access Channel    ${ShortCode}
    
Delete Access Channel
    [Arguments]    ${ShortCode}
    Init Browser and login with MdxUser
    Mouse Over    //*[@id='myslidemenu']/ul/li[4]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[4]/ul/li[5]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[4]/ul/li[5]/a
    Input Text    //*[@id='shortCodeSearch']    ${ShortCode}
    Click Element    //input[@value='Search']
    Click Element    //a[@class='action-delete']
    Run Keyword And Ignore Error   Confirm Action
	Page Should Contain    deleted successfully
	Logout and close browser
	
Add Short Code Tariff OnDemand
    #OnDemand Optin    1    1
    [Arguments]    ${tariff}    ${shortcode}    ${keyword}    ${enable_captcha}    ${disable_optin_flag}    ${notification}
    Mouse Over    //*[@id='myslidemenu']/ul/li[4]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[4]/ul/li[6]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[4]/ul/li[6]/a
    Click Element    //input[@value='Update']
    Click Element    //*[@id='contentPatnerId_chosen']/a/span
    Input Text    //*[@id='contentPatnerId_chosen']/div/div/input    ${cpUser}
    Click Element    //*[@id='contentPatnerId_chosen']/div/ul/li
    Click Element    //*[@id='serviceTypesList_chosen']/a/span
    Input Text    //*[@id='serviceTypesList_chosen']/div/div/input    ${delivery_channel}
    Click Element    //*[@id='serviceTypesList_chosen']/div/ul/li
    Click Element    //*[@id='shortCodeId_chosen']/a/span
    Input Text    //*[@id='shortCodeId_chosen']/div/div/input    ${shortcode}
    Click Element    //*[@id='shortCodeId_chosen']/div/ul/li
    Sleep    2s
    Click Element    //*[@id='SMSConfig']/h2[1]
    Click Element    //*[@id='trafficType1_chosen']/a/span
    Input Text    //*[@id='trafficType1_chosen']/div/div/input    MO
    Click Element    //*[@id='trafficType1_chosen']/div/ul/li
    Click Element    //*[@id='keyword1_chosen']/a/span
    Input Text    //*[@id='keyword1_chosen']/div/div/input    ${keyword}
    Click Element    //*[@id='keyword1_chosen']/div/ul/li
    Click Element    //*[@id='multiTariffRow1']/td[5]/label
    Click Element    //*[@id='tariff1_chosen']/a/span
    Input Text    //*[@id='tariff1_chosen']/div/div/input    ${tariff}
    Click Element    //*[@id='tariff1_chosen']/div/ul/li
    # Run Keyword If    '${enable_captcha}'=='Y'    Click Element    //*[@id='multiTariffRow1']/td[9]/label
    # Run Keyword If    '${disable_optin_flag}'=='Y'    Click Element    //*[@id='multiTariffRow1']/td[10]/label
    Run Keyword If    '${disable_optin_flag}'=='Y'    Click Element    //*[@id='multiTariffRow1']/td[9]/label
    Run Keyword If    '${disable_optin_flag}'=='N'    Input Text    //*[@id='optinConf']    ${notification}    
    Click Element    //input[@id='addTariff1']
    Click Element    //*[@id='trafficType1_chosen']/a/span
    Input Text    //*[@id='trafficType1_chosen']/div/div/input    MT
    Click Element    //*[@id='trafficType1_chosen']/div/ul/li
    Click Element    //*[@id='keyword1_chosen']/a/span
    Input Text    //*[@id='keyword1_chosen']/div/div/input    ${keyword}
    Click Element    //*[@id='keyword1_chosen']/div/ul/li
    Click Element    //*[@id='tariff1_chosen']/a/span
    Input Text    //*[@id='tariff1_chosen']/div/div/input    ${tariff}
    Click Element    //*[@id='tariff1_chosen']/div/ul/li
    Click Element    //input[@id='addTariff1']
    Click Element    //*[@id='main']/div/form/div[4]/table/tbody/tr/td/input[1]
    Page Should Contain    added successfully

Check and delete short code tariff
    [Arguments]    ${ContentProviderName}    ${ShortCode}
    Connect to oracle database
    ${result}    Query from database    select count(1) from CGW_CP_TARIFF_MASTER where ctm_short_code='${ShortCode}'
    Run Keyword If    '${result[0][0]}'=='0'    Log    No Mapping Present
    ...    ELSE    Delete Short Code Tariff    ${ContentProviderName}    ${ShortCode}
    
Delete Short Code Tariff
    [Arguments]    ${ContentProviderName}    ${ShortCode}
    Init Browser and login with MdxUser
    Mouse Over    //*[@id='myslidemenu']/ul/li[4]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[4]/ul/li[6]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[4]/ul/li[6]/a
    Click Element    //input[@value='Update']
    Click Element    //*[@id='contentPatnerId_chosen']/a/span
    Input Text    //*[@id='contentPatnerId_chosen']/div/div/input    ${ContentProviderName}
    Click Element    //*[@id='contentPatnerId_chosen']/div/ul/li
    Click Element    //*[@id='serviceTypesList_chosen']/a/span
    Input Text    //*[@id='serviceTypesList_chosen']/div/div/input    ${delivery_channel}
    Click Element    //*[@id='serviceTypesList_chosen']/div/ul/li
    Click Element    //*[@id='shortCodeId_chosen']/a/span
    Input Text    //*[@id='shortCodeId_chosen']/div/div/input    ${ShortCode}
    Click Element    //*[@id='shortCodeId_chosen']/div/ul/li
    Click Element    //a[@class='action-delete']
    Run Keyword And Ignore Error    Confirm Action
    Wait Until Element Is Visible    //*[@id='main']/div/form/div[4]/table/tbody/tr/td/input[1]    5s    
    Mouse Over    //*[@id='main']/div/form/div[4]/table/tbody/tr/td/input[1]
    Click Element    //*[@id='main']/div/form/div[4]/table/tbody/tr/td/input[1]
    Page Should Contain    added successfully
    Logout and close browser
    
Add Subscription Package
    [Arguments]    ${PackageName}    ${PackageId}    ${PackageDuration}    ${tariff}
    Click Element    //*[contains(text(),'Services')]
    Wait Until Element Is Visible    //*[contains(text(),'Subscription Management')]    5s
    Mouse Over    //*[contains(text(),'Subscription Management')]
    Wait Until Element Is Visible    //*[contains(text(),'Subscription Packages')]    5s
    Click Element    //*[contains(text(),'Subscription Packages')]
    Click Element    //input[@value='Add']
    Input Text    //input[@name='subPackageName']    ${PackageName}
    Input Text    //input[@name='subPackageCode']    ${PackageId}
    Input Text    //input[@name='subPackageDescription']    ${PackageName}
    Click Element    //input[@name='subPackageValidToString']
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/div/a[2]/span
    Click Element    //*[@id='ui-datepicker-div']/table/tbody/tr[3]/td[4]/a
    Input Text    //input[@name='subPackageDuration']    ${PackageDuration}
    Input Text    //input[@name='maxMTCounter']    1
    Input Text    //input[@name='maxMTDuration']    1
    Input Text    //input[@name='minMTCounter']    1
    Input Text    //input[@name='minMTDuration']    1
    Input Text    //input[@name='subPackageMTAmount']    1
    Input Text    //input[@name='maxSubPackageMTCounter']    1
    Click Element    //*[contains(text(),'Charge On Delivery')]/../td[1]/label/span
    Click Element    //*[@id='subChargeCodeVal_chosen']/a/span
    Click Element    //*[@id='subChargeCodeVal_chosen']/a/span
    Input Text    //*[@id='subChargeCodeVal_chosen']/div/div/input    ${tariff}
    Click Element    //*[@id='subChargeCodeVal_chosen']/div/ul/li
    Input Text    //textarea[@name='pkgCpNotifMsgActv']    You have sent [REQUESTED_KWD] to [SHORT_CODE], you have been charged [PRICE] and your subscription [PKG_CODE] has been activated and is valid for [PERIODICITY], [PKG_DURATION]
    Input Text    //textarea [@name='pkgCpNotifMsgCancel']    Bye from ${PackageName}
    Click Element    //input[@value='Save']
    Page Should Contain    Added Successfully

Check and delete subscription package
    [Arguments]    ${PackageName}    ${shortcode}
    Connect to oracle database
    ${result}    Query from database    select count(1) from SUB_PACKAGE_MASTER where spm_pkg_name='${PackageName}'
    Run Keyword If    '${result[0][0]}'=='0'    Log    No Subscription Present
    ...    ELSE    Delete Subscription Package    ${shortcode}
    
Delete Subscription Package
    [Arguments]    ${shortcode}
    Init Browser and login with MdxUser
    Click Element    //*[contains(text(),'Services')]
    Wait Until Element Is Visible    //*[contains(text(),'Subscription Management')]    5s
    Mouse Over    //*[contains(text(),'Subscription Management')]    
    Wait Until Element Is Visible    //*[contains(text(),'Subscription Packages')]    5s
    Click Element    //*[contains(text(),'Subscription Packages')]
    Click Element    //*[@id='searchParamId_chosen']/a
    Input Text    //*[@id='searchParamId_chosen']/div/div/input    Short Code
    Click Element    //*[@id='searchParamId_chosen']/div/ul/li
    Input Text    //input[@name='searchKey']    ${shortcode}
    Click Element    //input[@value='Search']
    Click Element    //a[@class='action-delete']
    Run Keyword And Ignore Error    Confirm Action
    Page Should Contain    Successfully Deleted
    Logout and close browser

Add Short Code Tariff Subscription
    [Arguments]    ${PackageID}    ${shortcode}    ${keyword}    ${enable_captcha}    ${disable_optin_flag}    ${notification}
    #Subscription Optin    1    1
    Mouse Over    //*[@id='myslidemenu']/ul/li[4]/a
    Wait Until Element Is Visible    //*[@id='myslidemenu']/ul/li[4]/ul/li[6]/a    5s
    Click Element    //*[@id='myslidemenu']/ul/li[4]/ul/li[6]/a
    Click Element    //input[@value='Update']
    Click Element    //*[@id='contentPatnerId_chosen']/a/span
    Input Text    //*[@id='contentPatnerId_chosen']/div/div/input    ${cpUser}
    Click Element    //*[@id='contentPatnerId_chosen']/div/ul/li
    Click Element    //*[@id='serviceTypesList_chosen']/a/span
    Input Text    //*[@id='serviceTypesList_chosen']/div/div/input    ${delivery_channel}
    Click Element    //*[@id='serviceTypesList_chosen']/div/ul/li
    Click Element    //*[@id='shortCodeId_chosen']/a/span
    Input Text    //*[@id='shortCodeId_chosen']/div/div/input    ${shortcode}
    Click Element    //*[@id='shortCodeId_chosen']/div/ul/li
    Sleep    2s
    Click Element    //*[@id='SMSConfig']/h2[1]
    Click Element    //*[@id='trafficType1_chosen']/a/span
    Input Text    //*[@id='trafficType1_chosen']/div/div/input    MO
    Click Element    //*[@id='trafficType1_chosen']/div/ul/li
    Click Element    //*[@id='keyword1_chosen']/a/span
    Input Text    //*[@id='keyword1_chosen']/div/div/input    ${keyword}
    Click Element    //*[@id='keyword1_chosen']/div/ul/li
    Click Element    //*[@id='multiTariffRow1']/td[5]/label
    Click Element    //*[@id='multiTariffRow1']/td[6]/label
    Click Element    //*[@id='tariff1_chosen']/a/span
    Input Text    //*[@id='tariff1_chosen']/div/div/input    ${PackageID}
    Click Element    //*[@id='tariff1_chosen']/div/ul/li
    # Run Keyword If    '${enable_captcha}'=='Y'    Click Element     //*[@id='multiTariffRow1']/td[9]/label
    # Run Keyword If    '${disable_optin_flag}'=='Y'    Click Element    //*[@id='multiTariffRow1']/td[10]/label
    Run Keyword If    '${disable_optin_flag}'=='Y'    Click Element    //*[@id='multiTariffRow1']/td[9]/label
    Run Keyword If    '${disable_optin_flag}'=='N'    Input Text    //*[@id='optinConf']    ${notification}
    Click Element    //input[@id='addTariff1']
    Click Element    //*[@id='main']/div/form/div[4]/table/tbody/tr/td/input[1]
    Page Should Contain    added successfully

Go to Roles
    Mouse Over    //*[contains(text(),'System')]
    Wait Until Element Is Visible    //*[contains(text(),'Users')]    5s
    Mouse Over    //*[contains(text(),'Users')]
    Wait Until Element Is Visible    //*[contains(text(),'User Role')]    5s
    Mouse Over    //*[contains(text(),'User Role')]
    Wait Until Element Is Visible    //*[contains(text(),'Roles')]    5s
    Click Element    //*[contains(text(),'Roles')]

Go to User Profile External
    Mouse Over    //*[contains(text(),'System')]
    Wait Until Element Is Visible    //*[contains(text(),'Users')]    5s
    Mouse Over    //*[contains(text(),'Users')]
    Wait Until Element Is Visible    //*[contains(text(),'User Profile - External')]    5s
    Click Element    //*[contains(text(),'User Profile - External')]

Click Add
    Wait Until Element Is Visible    //input[@value='Add']    5s
    Click Element    //input[@value='Add']
    Sleep    2s

Configure periodicity
    [Arguments]    ${period}    ${packageName}
    Connect to oracle database
    Update the database    update sub_package_master set spm_pkg_duration=${period} where spm_pkg_name='${packageName}'
    Init Browser and login
    Navigate to third level    ${services_header_loc}    ${subscription_management_loc}    ${subscription_optin_loc}
    Wait Until Page Contains Element    ${delete_optin_notificaiton_loc}    5s
    Click Element    ${delete_optin_notificaiton_loc}
    Sleep    ${micro_sleep}
    Wait Until Page Contains Element    ${delete_optin_notificaiton_loc}    5s
    Click Element    ${delete_optin_notificaiton_loc}
    Pass Input to    ${optin_max_active_session_loc}    1
    Pass Input to    ${subscription_optin_session_expiry_time_loc}    1
    
    Pass Input to    ${notification_message_loc}    ${subscription_periodicity_notification}
    Select value from dropdown    ${allowed_keyword_loc}    ${allowed_keyword_searchbox_loc}    ${subscription_1st_level_accept keyword}    ${highlighted_value}
    Select value from dropdown    ${allowed_reject_keyword_loc}    ${reject_keyword_searchbox_loc}    ${subscription_1st_level_reject keyword}    ${highlighted_value}
    Click Element    ${add_button_loc}    
    Sleep    ${small_sleep}
    Pass Input to    ${notification_message_loc}    ${subscription_global_2nd_level_optin_notification}
    Select value from dropdown    ${allowed_keyword_loc}    ${allowed_keyword_searchbox_loc}    ${subscription_2nd_level_accept keyword}    ${highlighted_value}
    Select value from dropdown    ${allowed_reject_keyword_loc}    ${reject_keyword_searchbox_loc}    ${subscription_2nd_level_reject keyword}    ${highlighted_value}
    Click Element    ${add_button_loc}
    Pass Input to    ${refuse_notification_loc}    ${subscription_refuse notification}
    Pass Input to    ${expiry_notification_loc}    ${subscription_expiry notification}
    Click Element    ${subscription_update_button_loc}
    # Assert if xpath and value is equal    ${subscription_update_succesfully_title_loc}    ${subscription_update_succesfully_title}
    Disconnect connection to oracleDB
    Close Browser

GUI Update Periodicity
    Init Browser and login
    Navigate to second level    ${system_header_loc}    ${properties_loc}
    Select value from dropdown    ${module_type_loc}    ${searchbox_xpath}    ${subscription_module_value}    ${highlighted_value}
    Wait Until Element Is Visible    ${PERIODICITY_PLACEHOLDER_REPLACEMENTS_loc}    5s
    Pass Input to    ${PERIODICITY_PLACEHOLDER_REPLACEMENTS_loc}    ${periodicity_replacement}
    Click Element    ${update_button_loc}
    Page Should Contain    Parameter Values updated successfully for Module SUBSCRIPTION
    Close Browser

Compute Charging and Validate CDR
    [Arguments]    ${msisdn}    ${keyword}    ${actual_cdr}
    Connect to oracle database
    ${result}    Query    select Provider_id, Provider_name, application_id, service_id, shortcode_cd, content_id, tariff_id from mv_cp_tariff_map where keyword = '${keyword}'
    ${application_name}    Query    select cpa_application_name from content_partner_application where cpa_application_id = ${result[0][2]}
    ${service_name}    Query    select ctm_content_type from content_type_master where ctm_content_type_id = ${result[0][3]}
    ${price}    Query    select ccpd_ccm_price, ccpd_ccm_shipment_price from CHARGE_CODE_PRICE_DETAIL where ccpd_ccm_charge_code_id = ${result[0][6]}
    ${tax}    Query    select ccm_tax, ccm_ett from charge_code_master where ccm_charge_code_id = ${result[0][6]}
    
    ${charged_tax}=    Evaluate    (${price[0][0]}+${price[0][1]})*${tax[0][0]}/100
    ${totalAmt}=    Evaluate    ${price[0][0]}+${price[0][1]}+${charged_tax}
    ${AmountToBeDebitedFromPPIN}=    Evaluate    ${totalAmt}*100000
    
    ${msisdnWithoutCountryCode}=    Get Substring    ${msisdn}    4  
    ${expected_cdr}=    Set Expected Cdr    ${result[0][0]}    ${result[0][1]}    ${result[0][2]}    ${application_name[0][0]}    ${result[0][3]}    ${service_name[0][0]}    ${result[0][4]}    ${result[0][5]}    ${msisdnWithoutCountryCode}    ${result[0][6]}    ${tax[0][1]}    ${tax[0][0]}    ${charged_tax}    ${price[0][1]}    ${price[0][1]}    0.0    ${price[0][0]}    ${totalAmt}
    Compare CDRs    ${expected_cdr}    ${actual_cdr}
    Disconnect connection to oracleDB
    [Return]    ${AmountToBeDebitedFromPPIN}

Compute Charging and Validate Refund CDR
    [Arguments]    ${msisdn}    ${keyword}    ${actual_cdr}    ${subscriber}
    Connect to oracle database
    ${result}    Query    select Provider_id, Provider_name, application_id, service_id, shortcode_cd, content_id, tariff_id from mv_cp_tariff_map where keyword = '${keyword}'
    ${application_name}    Query    select cpa_application_name from content_partner_application where cpa_application_id = ${result[0][2]}
    ${service_name}    Query    select ctm_content_type from content_type_master where ctm_content_type_id = ${result[0][3]}
    ${price}    Query    select ccpd_ccm_price, ccpd_ccm_shipment_price from CHARGE_CODE_PRICE_DETAIL where ccpd_ccm_charge_code_id = ${result[0][6]}
    ${tax}    Query    select ccm_tax, ccm_ett from charge_code_master where ccm_charge_code_id = ${result[0][6]}
    
    ${charged_tax}=    Evaluate    (${price[0][0]}+${price[0][1]})*${tax[0][0]}/100
    ${totalAmt}=    Evaluate    ${price[0][0]}+${price[0][1]}+${charged_tax}
    ${AmountToBeDebitedFromPPIN}=    Evaluate    ${totalAmt}*100000
    
    ${msisdnWithoutCountryCode}=    Get Substring    ${msisdn}    4
    ${subscriberType} =    Convert To String    ${subscriber}
    ${expected_cdr}=    Set Expected Refund Cdr    ${subscriberType}    ${result[0][0]}    ${result[0][1]}    ${result[0][2]}    ${application_name[0][0]}    ${result[0][3]}    ${service_name[0][0]}    ${result[0][4]}    ${result[0][5]}    ${msisdnWithoutCountryCode}    ${result[0][6]}    ${tax[0][1]}    ${tax[0][0]}    ${charged_tax}    ${price[0][1]}    ${price[0][1]}    0.0    ${price[0][0]}    ${totalAmt}
    Compare CDRs    ${expected_cdr}    ${actual_cdr}
    Disconnect connection to oracleDB
    [Return]    ${AmountToBeDebitedFromPPIN}

Compute Charging and Validate CDR Postpaid
    [Arguments]    ${msisdn}    ${keyword}    ${actual_cdr}
    Connect to oracle database
    ${result}    Query    select Provider_id, Provider_name, application_id, service_id, shortcode_cd, content_id, tariff_id from mv_cp_tariff_map where keyword = '${keyword}'
    ${application_name}    Query    select cpa_application_name from content_partner_application where cpa_application_id = ${result[0][2]}
    ${service_name}    Query    select ctm_content_type from content_type_master where ctm_content_type_id = ${result[0][3]}
    ${price}    Query    select ccpd_ccm_price, ccpd_ccm_shipment_price from CHARGE_CODE_PRICE_DETAIL where ccpd_ccm_charge_code_id = ${result[0][6]}
    ${tax}    Query    select ccm_tax, ccm_ett from charge_code_master where ccm_charge_code_id = ${result[0][6]}
    
    ${charged_tax}=    Evaluate    (${price[0][0]}+${price[0][1]})*${tax[0][0]}/100
    ${totalAmt}=    Evaluate    ${price[0][0]}+${price[0][1]}+${charged_tax}
    ${AmountToBeDebitedFromPPIN}=    Evaluate    ${totalAmt}*100000
    
    ${msisdnWithoutCountryCode}=    Get Substring    ${msisdn}    4  
    ${expected_cdr}=    Set Expected Cdr Postpaid    ${result[0][0]}    ${result[0][1]}    ${result[0][2]}    ${application_name[0][0]}    ${result[0][3]}    ${service_name[0][0]}    ${result[0][4]}    ${result[0][5]}    ${msisdnWithoutCountryCode}    ${result[0][6]}    ${tax[0][1]}    ${tax[0][0]}    ${charged_tax}    ${price[0][1]}    ${price[0][1]}    0.0    ${price[0][0]}    ${totalAmt}
    Compare CDRs    ${expected_cdr}    ${actual_cdr}
    Disconnect connection to oracleDB
    [Return]    ${AmountToBeDebitedFromPPIN}
    
Compute Charging
    [Arguments]    ${keyword}
    Connect to oracle database
    ${result}    Query    select Provider_id, Provider_name, application_id, service_id, shortcode_cd, content_id, tariff_id from mv_cp_tariff_map where keyword = '${keyword}'
    ${application_name}    Query    select cpa_application_name from content_partner_application where cpa_application_id = ${result[0][2]}
    ${service_name}    Query    select ctm_content_type from content_type_master where ctm_content_type_id = ${result[0][3]}
    ${price}    Query    select ccpd_ccm_price, ccpd_ccm_shipment_price from CHARGE_CODE_PRICE_DETAIL where ccpd_ccm_charge_code_id = ${result[0][6]}
    ${tax}    Query    select ccm_tax, ccm_ett from charge_code_master where ccm_charge_code_id = ${result[0][6]}
    
    ${charged_tax}=    Evaluate    (${price[0][0]}+${price[0][1]})*${tax[0][0]}/100
    ${totalAmt}=    Evaluate    ${price[0][0]}+${price[0][1]}+${charged_tax}
    ${AmountToBeDebitedFromPPIN}=    Evaluate    ${totalAmt}*100000
    Disconnect connection to oracleDB
    [Return]    ${AmountToBeDebitedFromPPIN}

Change JB_KTM_UPLOAD frequency to 1 minute
    ${update_job} =    Set Variable    BEGIN DBMS_SCHEDULER.SET_ATTRIBUTE (name => 'JB_KTM_DEQUEUE', attribute => 'REPEAT_INTERVAL', value => 'FREQ=MINUTELY ; INTERVAL=1');END;
    Connect to oracle database
    Update the database    ${update_job}
    Disconnect connection to oracleDB
Bulk Upload file
    [Arguments]    ${file_location}
    Init Browser and login
    Navigate to second level    ${services_loc}    ${shortCodeTariff_loc}
    Click Element    ${uploadTariff_loc}
    # Wait Until Element Is Visible    ${attachFile_loc}    5s
    Choose File    ${attachFile_loc}    ${file_location}
    Click Element    ${uploadButton_loc}
    
Prepare Text file
    [Arguments]    ${test_name}    ${provider_Id}    ${tarffic_type}    ${service_type}    ${shortcode}    ${tariff_id}    ${keyword}    ${allow_param}    ${allow_optin}    ${notification}    ${file_delimiter}
    ${file_input} =    Set Variable    ${provider_Id}${file_delimiter}${tarffic_type}${file_delimiter}${service_type}${file_delimiter}${shortcode}${file_delimiter}${tariff_id}${file_delimiter}${keyword}${file_delimiter}${allow_param}${file_delimiter}${allow_optin}${file_delimiter}${notification}
    Create File    ${ktm_base_directory}/${test_name}.txt    ${file_input}
    
    Bulk Upload file    ${ktm_base_directory}/${test_name}.txt
        
Prepare Excel file
    [Arguments]    ${test_name}    ${provider_Id}    ${tarffic_type}    ${service_type}    ${shortcode}    ${tariff_id}    ${keyword}    ${allow_param}    ${allow_optin}    ${notification}
    @{content}    Create List
    Append To List    ${content}    1    0    ${provider_Id}
    Append To List    ${content}    1    1    ${tarffic_type}
    Append To List    ${content}    1    2    ${service_type}
    Append To List    ${content}    1    3    ${shortcode}
    Append To List    ${content}    1    4    ${tariff_id}
    Append To List    ${content}    1    5    ${keyword}
    Append To List    ${content}    1    6    ${allow_param}
    Append To List    ${content}    1    7    ${allow_optin}
    Append To List    ${content}    1    8    ${notification}
    Write To Excel File    ${ktm_base_directory}/${test_name}.xlsx    ${content}
    
    Bulk Upload file    ${ktm_base_directory}/${test_name}.xlsx 
    
GUI Update Bulk Upload parameters
    [Arguments]    ${delimiter}    ${max_rows}
    Init Browser and login
    Navigate to second level    ${system_header_loc}    ${properties_loc}
    Select value from dropdown    ${module_type_loc}    ${searchbox_xpath}    ${generic_module_value}    ${highlighted_value}
    Sleep    3s
    Wait Until Element Is Visible    ${FILE_DELIMITER_loc}    5s
    Pass Input to    ${FILE_DELIMITER_loc}    ${delimiter}
    Wait Until Element Is Visible    ${MAX_FILE_ROWS_loc}    5s
    Pass Input to    ${MAX_FILE_ROWS_loc}    ${max_rows}
    Wait Until Element Is Visible    ${update_button_loc}    5s
    Click Element    ${update_button_loc}
    Page Should Contain    Parameter Values updated successfully for Module GENERIC
    Close Browser
    # Mouse Over    //*[contains(text(),'System')]
    # Wait Until Element Is Visible    //*[contains(text(),'Properties')]    5s
    # Click Element    //*[contains(text(),'Properties')]
    # Click Element    //*[@id='progType_chosen']/a
    # Click Element    //*[@id='progType_chosen']/div/ul/li[2]
    # Sleep    2s
    # Input Text    //*[contains(text(),'FILE_DELIMITER')]/../td[3]/input    ,
    # Input Text    //*[contains(text(),'MAX_FILE_ROWS')]/../td[3]/input    5
    # Wait Until Element Is Visible    //input[@value='Update']    5s
    # Click Element    //input[@value='Update']
    
Check count in GUI
    [Arguments]    ${totalRowCount}    ${rowsInserted}    ${rowsWithError}
    ${count1}    Get Text    ${totalRowsCount_loc}
    ${count2}    Get Text    ${rowsInserted_loc}
    ${count3}    Get Text    ${rowsWithError_loc}
    Should Be Equal As Integers    ${totalRowCount}    ${count1}
    Should Be Equal As Integers    ${rowsInserted}    ${count2}
    Should Be Equal As Integers    ${rowsWithError}    ${count3}
    
Check Upload status Positive
    [Arguments]    ${isSubscription}    ${provider_Id}    ${traffic_type}    ${service_type}    ${shortcode}    ${tariff_id}    ${keyword}    ${allow_param}    ${allow_optin}    ${notification}    ${notificationCount}
    Connect to oracle database
    ${key_id}    Query    select ck_id_n from cgw_keyword where ck_name_s = '${keyword}'
    ${keyword_length} =    Get Length    ${key_id}
    ${result}    Query    select ctm_id, ctm_tariff_type, ctm_keyword_id, ctm_charge_code, ctm_service_type, ctm_is_param_allowed, ctm_apply_optin from CGW_CP_TARIFF_MASTER where ctm_short_code = '${shortcode}' and ctm_is_subscription = '${isSubscription}' and ctm_keyword_id = ${key_id[0][0]} 
    ${db_notification}    Query    select con_opt_in_message from cgw_opt_in_notification where con_ctm_id = ${result[0][0]}
    ${db_keyword}    Query    select ck_name_s from CGW_KEYWORD where ck_id_n = ${result[0][2]}
    
    ${tariff_type} =    Run Keyword If    '${traffic_type}'=='MO'    Set Variable    1
    ...    ELSE IF    '${traffic_type}'=='MT'    Set Variable    2
        
    ${length} =    Get Length    ${db_notification}
    Should Be Equal As Integers    ${notificationCount}    ${length}
    
    Should Be Equal As Strings    ${keyword}    ${db_keyword[0][0]}
    Should Be Equal As Integers    ${tariff_type}    ${result[0][1]}
    Should Be Equal As Strings    ${service_type}    ${result[0][4]}
    Should Be Equal As Strings    ${allow_param}    ${result[0][5]}
    Should Be Equal As Strings    ${allow_optin}    ${result[0][6]}
    Run Keyword If    ${length}!=0    Should Be Equal As Strings    ${notification}    ${db_notification[0][0]}
    ...    ELSE    Log To Console    Notification is not added into database in this test case. Please verify    
    
    Disconnect connection to oracleDB

Check Upload status Negative
    [Arguments]    ${isSubscription}    ${shortcode}    ${keyword}
    Connect to oracle database
    ${key_id}    Query    select ck_id_n from cgw_keyword where ck_name_s = '${keyword}'
    ${keyword_length} =    Get Length    ${key_id}
    ${result}    Query    select count(*) from CGW_CP_TARIFF_MASTER where ctm_short_code = '${shortcode}' and ctm_is_subscription = '${isSubscription}' and ctm_keyword_id = ${key_id[0][0]}
    Should Be Equal As Integers    0    ${result[0][0]}
    
    Disconnect connection to oracleDB
    
Check Report Count Positive
    [Arguments]    ${isSubscription}    ${shortcode}    ${keyword}    ${Test Name}    ${total_count}    ${success_count}    ${failure_count}    ${invalidShortCode}    ${invalidChargeCode}    ${InvalidServiceType}    ${invalidProveriderId}    ${InvalidKeyword}    ${tariffAlreadyMapped}    ${MOFlagNotEnabled}    ${MTFlagNotEnabled}    ${MTNotFound}
    # Sleep    100s
    Connect to oracle database
    ${key_id}    Query    select ck_id_n from cgw_keyword where ck_name_s = '${keyword}'
    ${keyword_length} =    Get Length    ${key_id}
    ${result}    Query    select count(*) from CGW_CP_TARIFF_MASTER where ctm_short_code = '${shortcode}' and ctm_is_subscription = '${isSubscription}' and ctm_keyword_id = ${key_id[0][0]}
    Should Be Equal As Integers    1    ${result[0][0]}
    
    ${res}    Query    select * from (select ckus_filename, ckus_file_cnt, ckus_success_cnt, ckus_failure_cnt, ckus_failure_detail from CGW_KTM_UPLOAD_STATUS where ckus_status = 'Processed' order by ckus_upload_date desc) where rownum =1
    
    Should Be Equal As Strings    ${Test Name}    ${res[0][0]}
    Should Be Equal As Integers    ${total_count}    ${res[0][1]}
    Should Be Equal As Integers    ${success_count}    ${res[0][2]}
    Should Be Equal As Integers    ${failure_count}    ${res[0][3]}
    
    ${error_details} =    Set Variable    ${res[0][4]}
    @{error_details} =    Split String    ${error_details}    ,
    
    Should Be Equal As Strings    Invalid Short Code:${invalidShortCode}    @{error_details}[0]
    Should Be Equal As Strings    Invalid Charge Code:${invalidChargeCode}    @{error_details}[1]
    Should Be Equal As Strings    Invalid Service Type:${InvalidServiceType}    @{error_details}[2]
    Should Be Equal As Strings    Invalid Cp Id:${invalidProveriderId}    @{error_details}[3]
    Should Be Equal As Strings    Invalid Keyword:${InvalidKeyword}    @{error_details}[4]
    Should Be Equal As Strings    Tariff already mapped:${tariffAlreadyMapped}    @{error_details}[5]
    Should Be Equal As Strings    MO Flag not enable:${MOFlagNotEnabled}    @{error_details}[6]
    Should Be Equal As Strings    MT flag not enable:${MTFlagNotEnabled}    @{error_details}[7]
    Should Be Equal As Strings    MT not found:${MTNotFound}    @{error_details}[8]
    
    Disconnect connection to oracleDB

Check Report Count Negative
    [Arguments]    ${isSubscription}    ${shortcode}    ${Test Name}    ${total_count}    ${success_count}    ${failure_count}    ${invalidShortCode}    ${invalidChargeCode}    ${InvalidServiceType}    ${invalidProveriderId}    ${InvalidKeyword}    ${tariffAlreadyMapped}    ${MOFlagNotEnabled}    ${MTFlagNotEnabled}    ${MTNotFound}
    # Sleep    100s
    Connect to oracle database
    ${key_id}    Query    select ck_id_n from cgw_keyword where ck_name_s = '${InvalidKeyword}'
    ${keyword_length} =    Get Length    ${key_id}
    ${result}    Run Keyword If    '${keyword_length}'!='0'    Query    select count(*) from CGW_CP_TARIFF_MASTER where ctm_short_code = '${shortcode}' and ctm_is_subscription = '${isSubscription}' and ctm_keyword_id = ${key_id[0][0]}
    Run Keyword If    '${keyword_length}'!='0'    Should Be Equal As Integers    0    ${result[0][0]}
    
    ${res}    Query    select * from (select ckus_filename, ckus_file_cnt, ckus_success_cnt, ckus_failure_cnt, ckus_failure_detail from CGW_KTM_UPLOAD_STATUS where ckus_status = 'Processed' order by ckus_upload_date desc) where rownum =1
    
    Should Be Equal As Strings    ${Test Name}    ${res[0][0]}
    Should Be Equal As Integers    ${total_count}    ${res[0][1]}
    Should Be Equal As Integers    ${success_count}    ${res[0][2]}
    Should Be Equal As Integers    ${failure_count}    ${res[0][3]}
    
    ${error_details} =    Set Variable    ${res[0][4]}
    @{error_details} =    Split String    ${error_details}    ,
    
    Should Be Equal As Strings    Invalid Short Code:${invalidShortCode}    @{error_details}[0]
    Should Be Equal As Strings    Invalid Charge Code:${invalidChargeCode}    @{error_details}[1]
    Should Be Equal As Strings    Invalid Service Type:${InvalidServiceType}    @{error_details}[2]
    Should Be Equal As Strings    Invalid Cp Id:${invalidProveriderId}    @{error_details}[3]
    Should Be Equal As Strings    Invalid Keyword:${InvalidKeyword}    @{error_details}[4]
    Should Be Equal As Strings    Tariff already mapped:${tariffAlreadyMapped}    @{error_details}[5]
    Should Be Equal As Strings    MO Flag not enable:${MOFlagNotEnabled}    @{error_details}[6]
    Should Be Equal As Strings    MT flag not enable:${MTFlagNotEnabled}    @{error_details}[7]
    Should Be Equal As Strings    MT not found:${MTNotFound}    @{error_details}[8]
    
    Disconnect connection to oracleDB

Delete existing mapping
    [Arguments]    ${shortcode}    ${keyword}    ${deleteKeyword}
    Connect to oracle database
    ${key_id}    Query    select ck_id_n from cgw_keyword where ck_name_s = '${keyword}'
    ${keyword_length} =    Get Length    ${key_id}
    ${result}    Run Keyword If    '${keyword_length}'!='0'    Query    select * from (select ctm_id, ctm_keyword_id from cgw_cp_tariff_master where ctm_short_code = '${shortcode}' and ctm_keyword_id = ${key_id[0][0]}) where ROWNUM=1
    ${length}    Run Keyword If    '${keyword_length}'!='0'    Get Length    ${result}
    ...    ELSE    Set Variable    0
    Run Keyword If    '${length}'!='0'    Update the database    delete from cgw_opt_in_notification where con_ctm_id = '${result[0][0]}'
    Run Keyword If    '${keyword_length}'!='0'    Update the database    delete from cgw_cp_tariff_master where ctm_short_code = '${shortcode}' and ctm_keyword_id = ${key_id[0][0]}
    Run Keyword If    '${deleteKeyword}'=='1' and '${length}'!='0' and '${keyword_length}'!='0'    Update the database    delete from cgw_keyword where ck_id_n = '${result[0][1]}'
    ...    ELSE    LOG    No need to delete the keyword
    
Check Bulk Upload report
    Sleep    ${minute_sleep}
    Navigate to second level    ${reports_loc}    ${keywordTariffMapUpload_loc}
    Click Element    ${generateButton_loc}
    Click Element    ${details1stRow}
    
Check Details Upload report
    [Arguments]    ${total_records}    ${success_count}    ${failure_count}    ${keywordLimitExceeded}    ${InvalidChargeCode}    ${InvalidServiceType}    ${TariffAlreadyMapped}    ${InvalidShortCode}    ${InvalidKeyword}    ${KeywordSeqPresent}    ${MTNotFound}    ${MTFlagNotEnabled}    ${MOFlagNotEnabled}    ${InvalidProviderID}    ${NewKeywordCount}
    ${count1}    Get Text    ${total_records_loc}
    ${count2}    Get Text    ${success_count_loc}
    ${count3}    Get Text    ${failure_count_loc}
    ${count4}    Get Text    ${keywordLimitExceeds_loc}
    ${count6}    Get Text    ${invalidChargeCode_loc}
    ${count7}    Get Text    ${invalidServiceType_loc}
    ${count8}    Get Text    ${tariffAlreadyMapped_loc}
    ${count9}    Get Text    ${invalidShortCode_loc}
    ${count10}    Get Text    ${invalidKeyword_loc}
    ${count11}    Get Text    ${keywordSequencePresent_loc}
    ${count12}    Get Text    ${mtNotFound_loc}
    ${count13}    Get Text    ${mtFlagNotEnable_loc}
    ${count14}    Get Text    ${moFlagNotEnable_loc}
    ${count15}    Get Text    ${invalidCpId_loc}
    ${count16}    Get Text    ${newKeywordCount_loc}