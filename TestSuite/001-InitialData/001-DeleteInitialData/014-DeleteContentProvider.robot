*** Settings ***
Resource    ../../../Libraries/genericLibrary/dbConnections.robot
Resource    ../../../Libraries/configurations.robot
*** Test Cases ***
Delete Content Provider
    Connect to oracle database
    Update the database    delete from CONTENT_PARTNER_SERVICE_MAP where cpsm_cpm_id in (select cpm_id from CONTENT_PARTNER_MASTER where cpm_code='${cpUser}')
    Update the database    delete from CONTENT_PARTNER_MASTER where cpm_code='${cpUser}'
    Disconnect connection to oracleDB