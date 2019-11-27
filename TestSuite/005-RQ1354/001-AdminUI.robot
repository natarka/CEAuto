*** Settings ***
Resource    ../../Libraries/configurations.robot
Resource    ../../Libraries/genericLibrary/commonTasks.robot
Resource    ../../Libraries/genericLibrary/dbConnections.robot
Resource    ../../Libraries/genericLibrary/Library.robot
*** Variables ***
${external_username}    amxhubexternal
${external_password}    @demo123
${internal_username}    amxhubinternal
${internal_password}    @demo123
*** Test Cases ***
Test 001-Check Role type Dropdown
    #Display of Role types under User Role Tab in Admin UI
    #Login into Admin UI with MdxAdmin user	MdxAdmin username and password	Login successful
    #Navigate to System->Users->User Role->Roles		User Role Management Page is displayed
    #Click on Add and Click on Role Type drop down option		External-Central role type should not be displayed in the drop down
    #External/Internal role type should be displayed in the drop down
    Connect to oracle database
    ${Expected1}    Query from database    select utm_type from USER_TYPE_MASTER where utm_id=1
    # Log To Console    ${Expected1[0][0]}
    ${Expected2}    Query from database    select utm_type from USER_TYPE_MASTER where utm_id=2
    # Log To Console    ${Expected2[0][0]}
    ${Expected3}    Query from database    select utm_type from USER_TYPE_MASTER where utm_id=3
    # Log To Console    ${Expected3[0][0]}
    Disconnect connection to oracleDB
    Init Browser and login
    Go to Roles
    Click Add
    Click Element    //*[@id='main']/div/form/div[1]/table/tbody/tr[2]/td[1]/div/a
    #Check if Internal role is present under Role Type
    Input Text    //input[@autocomplete='off']    Internal
    ${Actual1}    Get Text    //*[@id='main']/div/form/div[1]/table/tbody/tr[2]/td[1]/div/div/ul/li
    Should Be Equal As Strings    ${Expected1[0][0]}    ${Actual1}    
    #Check if External role is present under Role Type
    Clear Element Text    //input[@autocomplete='off']
    Input Text    //input[@autocomplete='off']    External
    ${Actual2}    Get Text    //*[@id='main']/div/form/div[1]/table/tbody/tr[2]/td[1]/div/div/ul/li
    Should Be Equal As Strings    ${Expected2[0][0]}    ${Actual2}
    #Check if External Central role should not be present under Role Type
    Clear Element Text    //input[@autocomplete='off']    
    Input Text    //input[@autocomplete='off']    External Central
    ${Actual3}    Get Text    //*[@id='main']/div/form/div[1]/table/tbody/tr[2]/td[1]/div/div/ul/li
    ${Expected3_1}    Set Variable    No results match "${Expected3[0][0]}"
    Should Be Equal As Strings    ${Expected3_1}    ${Actual3}
    Logout and close browser
    
Test 002-Check Roles displayed
    #External and External-Central role type should be displayed under User Profile - External Tab in Admin UI
    #Login into Admin UI with MdxAdmin user	MdxAdmin username and password	Login successful
    #Navigate to System->Users->User Profile - External		User Profile - External Page should be displayed with existing users
    #Click on Add button		In the USER PROFILE EXTERNAL - ADD page, under Roles, External and External-Central role type should be displayed as radio button
    Connect to oracle database
    ${Expected2}    Query from database    select utm_type from USER_TYPE_MASTER where utm_id=2
    # Log To Console    ${Expected2[0][0]}
    ${Expected3}    Query from database    select utm_type from USER_TYPE_MASTER where utm_id=3
    # Log To Console    ${Expected3[0][0]}
    Disconnect connection to oracleDB
    Init Browser and login
    Go to User Profile External
    Click Add
    ${actual2}    Get Text    //*[@type='radio']/../../td[1]/label/span
    Should Be Equal As Strings    ${Expected2[0][0].strip()}    ${actual2.strip()}
    ${actual3}    Get Text    //*[@type='radio']/../../td[2]/label/span
    Should Be Equal As Strings    ${Expected3[0][0].strip()}    ${actual3.strip()}
    ${count}    Get Matching Xpath Count    //*[@type='radio']
    Should Be Equal As Numbers    2    ${count.strip()}
    Logout and close browser

# Test 003
    # Init Browser and login
    # Mouse Over    //*[contains(text(),'System')]
    # Wait Until Element Is Visible    //*[contains(text(),'Users')]    5s
    # Mouse Over    //*[contains(text(),'Users')]
    # Wait Until Element Is Visible    //*[contains(text(),'User Profile - External')]    5s
    # Click Element    //*[contains(text(),'User Profile - External')]
    # Click Add
    # Sleep    3s
    # Click Element    //*[@type='radio']/../../td[1]/label
    # Sleep    3s    
    # Page Should Contain    Check All
    # Element Should Be Enabled    //a[@class='chosen-single']/span
    # Click Element    //*[@type='radio']/../../td[2]/label
    # Sleep    3s    
    # Element Should Be Disabled    //a[@class='chosen-single']/span

Test 004-External Central User Creation
    # Create an external user "AMXHub"with role type as External-Central
    # Login into Admin UI with MdxAdmin user	MdxAdmin username and password	Login successful
    # Navigate to System->Users->User Profile - External		User Profile - External Page should be displayed with existing users
    # Click on Add button and select External-Central role type radio button		USER PROFILE EXTERNAL - ADD page is displayed and External-Central radio button is selected
    # Content Partner option should be disabled		Content Partner option is disabled
    # Enter the required details on the page and Save	UserId/FirstName/LastName/Password/ConfirmPassword/EmailId/Mobile/ValidFrom/ValidTill	Required details are entered and Save is successful and User AMXHub is created successfully
    Connect to oracle database
    Update the database    delete from user_master where um_login_id = '${external_central_user}'
    Disconnect connection to oracleDB
    Init Browser and login
    Add External Central User    ${external_central_user}    ${external_central_password}
    Logout and close browser

Test 005-External User Creation
	# Create an external user "Disney-External" with role type as External and role External
	# Login into Admin UI with MdxAdmin user	MdxAdmin username and password	Login successful
	# Navigate to System->Users->User Profile - External		User Profile - External Page should be displayed with existing users
	# Click on Add button and select External role type radio button, select role as External		USER PROFILE EXTERNAL - ADD page is displayed and External radio button is selected and External role is selected
	# Content Partner option should be enabled		Content Partner option is enabled
	# Enter the required details on the page and Save	UserId/FirstName/LastName/Password/ConfirmPassword/EmailId/Mobile/ContentPartner/ValidFrom/ValidTill	Required details are entered and Save is successful and User Disney-External is created successfully
    Connect to oracle database
    Update the database    delete from USER_ROLE_MAP where urm_um_id in (select um_id from user_master where um_login_id = '${external_username}')
    Update the database    delete from user_master where um_login_id = '${external_username}'
    Disconnect connection to oracleDB
    Init Browser and Login
    Add External User    ${external_username}    ${external_password}    ${cpUser}
    Logout and close browser    
    
Test 006-Internal User Creation
    # Create an internal user "Disney-Internal"
    # Login into Admin UI with MdxAdmin user	MdxAdmin username and password	Login successful
    # Navigate to System->Users->User Profile - Internal		User Profile - Internal Page should be displayed with existing users
    # Click on Add button		USER PROFILE INTERNAL - ADD page is displayed
    # Enter the required details on the page and Save	UserId/FirstName/LastName/Password/ConfirmPassword/EmailId/Mobile/ValidFrom/ValidTill	Required details are entered and Save is successful and User Disney-Internal is created successfully
    Connect to oracle database
    Update the database    delete from USER_ROLE_MAP where urm_um_id in (select um_id from user_master where um_login_id = '${internal_username}')
    Update the database    delete from user_master where um_login_id = '${internal_username}'
    Disconnect connection to oracleDB
    #Create Internal User
    Init Browser and login with MdxUser
    Create Internal User    ${internal_username}    ${internal_password}
    Logout and close browser
    #Update the create user with appropriate credentials
    Connect to oracle database
    Update the database    update user_master set um_user_type='S',um_is_first_login='N' where um_login_id='${internal_username}'
    Disconnect connection to oracleDB
    
Test 007-Login with External Central User
    # Login into ADMIN UI with External-Central user should not be allowed
    # Login into Admin UI with External-Central user	AMXHub and password	Login should not be allowed and appropriate error message should be displayed
    Init Browser and login Failure    ${external_central_user}    ${external_central_password}
    Close Browser
    
Test 008-Login with External User
    # Login into ADMIN UI with External user should be allowed
    # Login into Admin UI with External user	Disney-External and password	Login should not be allowed
    Init Browser and login Failure    ${external_username}    ${external_password}
    Close Browser

Test 009-Login with Internal User
    # Login into ADMIN UI with Internal user should be allowed
    # Login into Admin UI with Internal user	Disney-Internal and password	Login should be successful
    Init Browser and login Success    ${internal_username}    ${internal_password}
    Logout and close browser