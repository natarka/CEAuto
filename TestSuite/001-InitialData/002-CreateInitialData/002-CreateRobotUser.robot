*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
Resource    ../../../Libraries/genericLibrary/dbConnections.robot
*** Test Cases ***
Test Create Robots User
    #Create Internal User
    Init Browser and login with MdxUser
    Create Internal User    ${UserName}    ${Password}
    Logout and close browser
    #Update the create user with appropriate credentials
    Connect to oracle database
    Update the database    update user_master set um_user_type='S',um_is_first_login='N' where um_login_id='${UserName}'
    Disconnect connection to oracleDB