*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
Resource    ../../../Libraries/configurations.robot
*** Test Cases ***
Test Add Delivery Channel
    Connect to oracle database
    ${result}    Query from database    select (select max(dcm_channel_id) from DELIVERY_CHANNEL_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Check and Add Delivery Channel    ${result[0][0]}    ${delivery_channel}