*** Settings ***
Resource    ../../../Libraries/genericLibrary/dbConnections.robot
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test Delete Robot User
    Connect to oracle database
    Update the database    delete from USER_ROLE_MAP where urm_um_id in (select um_id from user_master where um_login_id = '${UserName}')
    Update the database    delete from user_master where um_login_id = '${UserName}'
    Disconnect connection to oracleDB