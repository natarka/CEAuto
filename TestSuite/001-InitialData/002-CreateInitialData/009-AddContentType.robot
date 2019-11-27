*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test 001-Add Content Type OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(ctm_content_type_id) from CONTENT_TYPE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Add Content Type OnDemand    ${result[0][0]}    ${content_name_ondemand}
    
Test 002-Add Content Type OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(ctm_content_type_id) from CONTENT_TYPE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Add Content Type OnDemand    ${result[0][0]}    ${content_name_ondemand1}
    
Test 003-Add Content Type OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(ctm_content_type_id) from CONTENT_TYPE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Add Content Type OnDemand    ${result[0][0]}    ${content_name_ondemand2}
    
Test 004-Add Content Type OnDemand
    Connect to oracle database
    ${result}    Query from database    select (select max(ctm_content_type_id) from CONTENT_TYPE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Add Content Type OnDemand    ${result[0][0]}    ${content_name_ondemand3}
    
Test 005-Add Content Type Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(ctm_content_type_id) from CONTENT_TYPE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Add Content Type Subscription    ${result[0][0]}    ${content_name_subs}
    
Test 006-Add Content Type Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(ctm_content_type_id) from CONTENT_TYPE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Add Content Type Subscription    ${result[0][0]}    ${content_name_subs1}
    
Test 007-Add Content Type Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(ctm_content_type_id) from CONTENT_TYPE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Add Content Type Subscription    ${result[0][0]}    ${content_name_subs2}
    
Test 008-Add Content Type Subscription
    Connect to oracle database
    ${result}    Query from database    select (select max(ctm_content_type_id) from CONTENT_TYPE_MASTER)+1 from dual
    Disconnect connection to oracleDB
    Add Content Type Subscription    ${result[0][0]}    ${content_name_subs3}