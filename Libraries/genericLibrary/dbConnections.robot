*** Settings ***
Library           DatabaseLibrary
Resource          ../configurations.robot
Library           sybaseLibrary

*** Keywords ***
Connect to oracle database
    Connect To Database Using Custom Params    cx_Oracle    '${dbUser}/${dbPassword}@${oracle_service_name}'

Query from database
    [Arguments]    ${query}
    ${queryResults}    Query    ${query}
    [Return]    ${queryResults}

Update the database
    [Arguments]    ${query}
    ${queryResults}    Execute Sql String    ${query}
    [Return]    ${queryResults}

Disconnect connection to oracleDB
    Disconnect From Database

Connect to sybase database
    connect to sybaseDB    ${sybaseServer}    ${sybasePort}    ${sybaseDB}    ${sybaseUser}    ${sybasePassword}

Disconnect connection to sybaseDB
    close sybaseConnection