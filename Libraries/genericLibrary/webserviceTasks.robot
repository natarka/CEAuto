*** Settings ***
Documentation     Suite description
Library           SudsLibrary
Library           RequestsLibrary
Library           String
Library           Collections
Resource          ../configurations.robot
Resource          ../testData/dbQueries.robot
Resource          ../testData/subscription_Optin.robot
Resource          ../../Libraries/testData/webServiceDetails.robot
Resource          dbConnections.robot
Resource          ../configurations.robot
Resource          ../../Libraries/testData/genericData.robot

*** Keywords ***
InitializeSOAPClient
    [Arguments]    ${wsdl}    ${wsdlUrl}    ${cpUser}    ${cpPass}
    Create SOAP Client    ${wsdl}
    Apply Username token    ${cpUser}    ${cpPass}
    Set Location    ${wsdlUrl}

# FireSOAPMethod
    # [Arguments]    ${method}    ${input}
    # ${output}    Split and make string    ${input}
    # ${response}=    Call Soap Method    ${method}    ${output}
    # [Return]    ${response}

FireSOAPMethod_doCharge
    [Arguments]    ${providerId}    ${applicationId}    ${serviceId}    ${originId}    ${msisdn}    ${contentId}
    ...    ${contentDescription}
    ${OperationId}    Generate Random String    8    [NUMBERS]
    ${response}=    Call Soap Method    doCharge    ${providerId}    ${applicationId}    ${serviceId}    ${originId}
    ...    ${OperationId}    ${msisdn}    ${contentId}    ${contentDescription}
    [Return]    ${response}

Prepare and fire POSTRequest
    [Arguments]    ${requestURL}    ${data}
    Create Session    request    ${requestURL}
    ${resp}=    Post Request    request    /    data=${data}
    [Return]    ${resp}

Prepare and fire GETRequest
    [Arguments]    ${requestURL}
    Create Session    request    ${requestURL}
    ${resp}=    Get Request    request    /
    [Return]    ${resp}

Get moUrl
    [Arguments]    ${sms}    ${srcAddr}    ${destAddr}
    ${string1}=    Catenate    SEPARATOR=    short_message=    ${sms}    &source_addr=    ${srcAddr}
    ...    &destination_addr=    ${destAddr}
    ${url}=    Catenate    SEPARATOR=    ${moGetUrl}    ${string1}    &submit=Submit+Message&service_type=&source_addr_ton=1&source_addr_npi=1&dest_addr_ton=1&dest_addr_npi=1&esm_class=0&protocol_ID=&priority_flag=&registered_delivery_flag=0&data_coding=0&user_message_reference=&source_port=&destination_port=&sar_msg_ref_num=&sar_total_segments=&sar_segment_seqnum=&user_response_code=&privacy_indicator=&payload_type=&message_payload=&callback_num=&source_subaddress=&dest_subaddress=&language_indicator=&tlv1_tag=&tlv1_len=&tlv1_val=&tlv2_tag=&tlv2_len=&tlv2_val=&tlv3_tag=&tlv3_len=&tlv3_val=&tlv4_tag=&tlv4_len=&tlv4_val=&tlv5_tag=&tlv5_len=&tlv5_val=&tlv6_tag=&tlv6_len=&tlv6_val=&tlv7_tag=&tlv7_len=&tlv7_val=
    [Return]    ${url}

FireSOAPMethod_SIA
    [Arguments]    ${srsRatingId}    ${msisdn}    ${contentId}
    Create SOAP Client    ${SIATransactionService_wsdl}
    ${userTransactionId}    Generate Random String    8    [NUMBERS]
    Set Location    ${SIATransactionService_url}
    ${response}    Call Soap Method    requestTransaction    ${userId}    ${password}    ${userTransactionId}    ${srsRatingId}    ${channel}    ${msisdn}    ${contentId}    ${contentName}    ${urlOk}    ${urlCancel}    ${urlError}    ${urlUnsusc}    ${extraParam}
    ${response}=    Fetch From Right    ${response}    |
    Log To Console    ${response}
    [Return]    ${response}

FireSOAPMethod_CancelSubscription
    [Arguments]    ${getSubscriptionId1}
    Connect to oracle database
    ${subscriptionId}    Query from database    ${getSubscriptionId1}
    ${length}=    Get Length    ${subscriptionId}
    Run Keyword If    ${length}==0    LOG    No need to execute cancel subscription API
    ...    ELSE    cancelSubscription    ${subscriptionId[0][0]}
    
cancelSubscription
    [Arguments]    ${subscriptionId}
    Create SOAP Client    ${subscriptionService_wsdl}
    Set Location    ${subscriptionService_url}
    Connect to oracle database
    ${providerId1}    Query from database    ${getProviderId}
    ${response}    Call Soap Method    cancelSubscription    ${providerId1[0][0]}    ${subscriptionId}    ${subscription_msisdn}
    Disconnect connection to oracleDB
    Log To Console    ${response}
    [Return]    ${response}
    
doCharge
    [Arguments]    ${shortcode}    ${isSubscription}    ${msisdn}    ${expected_responseCode}
    Create SOAP Client    ${chargingService_wsdl}
    Set Location    ${chargingService_url}
    Apply Username Token    ${cpUser}    ${cpPass}
    Connect to oracle database
    ${result}    Query from Database    select Provider_id, application_id, service_id, package_id from mv_cp_tariff_map where shortcode_cd = ${shortcode} and is_subscription = '${isSubscription}'
    ${operationId}    Generate Random String    8    [NUMBERS]
    ${response}=    Call Soap Method    doCharge    ${result[0][0]}    ${result[0][1]}    ${result[0][2]}    ${shortcode}    ${operationId}    ${msisdn}    ${result[0][3]}    ${contentDescription1}
    log    ${response}
    Disconnect connection to oracleDB
    Should Be Equal As Integers    ${expected_responseCode}    ${response}
    [Return]    ${operationId}
    
doRefund
    [Arguments]    ${shortcode}    ${operationId}    ${isSubscription}    ${msisdn}    ${subscriptionId}    ${expected_responseCode}
    Create SOAP Client    ${chargingService_wsdl}
    Set Location    ${chargingService_url}
    ${content} =    Set Variable    CE-SMS-MT
    Apply Username Token    ${cpUser}    ${cpPass}
    Connect to oracle database
    ${result}    Query from Database    select Provider_id from mv_cp_tariff_map where shortcode_cd = ${shortcode} and is_subscription = '${isSubscription}'
    ${response}=    Call Soap Method    doRefund    ${result[0][0]}    ${operationId}    ${shortcode}    ${msisdn}    ${content}    ${subscriptionId}
    log    ${response}
    Disconnect connection to oracleDB
    Should Be Equal As Integers    ${expected_responseCode}    ${response}    
    
    
    