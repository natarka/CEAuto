*** Settings ***
Resource    ../../Libraries/genericLibrary/Library.robot
Resource    ../../Libraries/Resources/wsdl.robot
Resource    ../../Libraries/genericLibrary/dbConnections.robot
Resource    ../../Libraries/genericLibrary/commonTasks.robot
Resource    ../../Libraries/testData/dbQueries.robot
Suite Setup        Connect to sybase database
Suite Teardown     Close SybaseConnection 
*** Test Cases ***
Test 01 doCharge prepaid external central
    # Prepaid Subscriber Test doCharge API with valid External-Central user credentials
    # "1) Fire doCharge API for prepaid subscriber with the required input parameters
    # 2) Pass valid External-Central user credentials"
    # "1) API request is success
    # 2) Configured amount should be charged in PPIN side
    # 3) CDR with correct values should be generated in both PPIN and CE side"
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-49"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">8S6TC7NjO/78/78xxnrIOQ==</wsse:Nonce><wsu:Created>2017-09-20T07:30:45.579Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doCharge><com:providerId>${providerId}</com:providerId><com:applicationId>${applicationId}</com:applicationId><com:serviceId>${serviceId}</com:serviceId><com:originId>${originId}</com:originId><com:operationId>${operationId}</com:operationId><com:msisdn>${prepaid_msisdn}</com:msisdn><com:contentId>${contentId}</com:contentId><com:contentDescription>${contentDescription}</com:contentDescription></com:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}
    #Compare CDR's and validate balance in PPIN
    ${transactionID}    Get DB details    ${getTransactionId}
    # ${CDR}    GetCDR    ${transactionID}    prepaid
    # ${charged_price}    Compute Charging and Validate CDR    ${prepaid_msisdn}    ${keyword}    ${CDR}
    # Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}

Test 02 doRefund prepaid external central
    # Prepaid Subscriber Test doRefund API with valid External-Central user credentials
    # "1) Fire doRefund API for prepaid subscriber with the required input parameters, operation id should be the id that was passed during doCharge in previous testcase
    # 2) Pass valid External-Central user credentials"
    # "1) API request is success
    # 2) Configured amount should be refunded in PPIN side
    # 3) CDR with correct values should be generated in both PPIN and CE side"
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-49"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">8S6TC7NjO/78/78xxnrIOQ==</wsse:Nonce><wsu:Created>2017-09-20T07:30:45.579Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doCharge><com:providerId>${providerId}</com:providerId><com:applicationId>${applicationId}</com:applicationId><com:serviceId>${serviceId}</com:serviceId><com:originId>${originId}</com:originId><com:operationId>${operationId}</com:operationId><com:msisdn>${prepaid_msisdn}</com:msisdn><com:contentId>${contentId}</com:contentId><com:contentDescription>${contentDescription}</com:contentDescription></com:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}
    #Compare CDR's and validate balance in PPIN
    # ${transactionID}    Get DB details    ${getTransactionId}
    # ${CDR}    GetCDR    ${transactionID}    prepaid
    # ${charged_price}    Compute Charging and Validate CDR    ${prepaid_msisdn}    ${keyword}    ${CDR}
    # Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}
    
    Sleep    5s
    
    #create a soap message using input parameters
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-4"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">9hmaeVH3Us4kn0VCoGWXLA==</wsse:Nonce><wsu:Created>2017-09-20T06:29:29.457Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doRefund><com:providerId>${providerId}</com:providerId><com:operationId>${operationId}</com:operationId><com:originId>${originId}</com:originId><com:msisdn>${prepaid_msisdn}</com:msisdn><com:concept>CE-SMS-MT</com:concept><com:subscriptionId/></com:doRefund></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response1}    Call Soap Method    doRefund    ${Message1}
    #validate if response is success
    Should Be Equal As Strings    0    ${response1}
    #Compare CDR's and validate balance in PPIN
    # ${transactionID}    Get DB details    ${getTransactionId}
    # ${CDR}    GetCDR    ${transactionID}    prepaid
    # ${charged_price}    Compute Charging and Validate CDR    ${prepaid_msisdn}    ${keyword}    ${CDR}
    # Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}
    
Test 03 directDebitAmountReq prepaid external central
    # Prepaid Subscriber Test directDebitAmountReq API with valid External-Central user credentials
    # Fire createChargingSessionReq for prepaid subscriber with the required input parameters and External-Central user credentials
    # Fire directDebitAmountReq with the session id from above step and valid External-Central user credentials of "AMXHub" 
    # Session id is received when createChargingSessionReq is fired.
    # directDebitAmountReq API request is success
    # Configured amount should be debited in PPIN side
    # CDR with correct values should be generated in both PPIN and CE side
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
Test 04 directCreditAmountReq prepaid external central
    # Prepaid Subscriber Test directCreditAmountReq API with valid External-Central user credentials
    # Fire createChargingSessionReq for prepaid subscriber with the required input parameters and External-Central user credentials
    # Fire directCreditAmountReq with the session id from above step and valid External-Central user credentials of "AMXHub" 
    # Session id is received when createChargingSessionReq is fired.
    # directCreditAmountReq API request is success
    # Configured amount should be credited in PPIN side
    # CDR with correct values should be generated in both PPIN and CE side
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
    #----------------------------
    #create a soap message using input parameters
    ${Message2}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response2}    Call Soap Method    createChargingSessionReq    ${Message2}
    #Fetch the session id from response for later use
    ${sessionId2}    Set Variable    ${response2.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response2.RequestNumberFirstRequest}
    
    #Fire directCreditAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-2"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">Te/+tij9rHoPcnXLkuoc8w==</wsse:Nonce><wsu:Created>2017-09-21T05:54:25.342Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directCreditAmountReq><csap:sessionID>${sessionId2}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><csap:requestNumber>1</csap:requestNumber></csap:directCreditAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    directCreditAmountReq    ${Message3}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId2}    ${response3.sessionID}    
    Should Be Equal As Strings    1    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response3.requestNumberNextRequest}
    
Test 05 directRefundAmountReq prepaid external central
    # Prepaid Subscriber Test directRefundAmountReq API with valid External-Central user credentials
    # Fire createChargingSessionReq for prepaid subscriber with the required input parameters and External-Central user credentials
    # Fire directRefundAmountReq with the session id from above step and valid External-Central user credentials of "AMXHub" 
    # Session id is received when createChargingSessionReq is fired.
    # directRefundAmountReq API request is success
    # Configured amount should be refunded in PPIN side
    # CDR with correct values should be generated in both PPIN and CE side
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
    #----------------------------
    #create a soap message using input parameters
    ${Message2}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response2}    Call Soap Method    createChargingSessionReq    ${Message2}
    #Fetch the session id from response for later use
    ${sessionId2}    Set Variable    ${response2.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response2.RequestNumberFirstRequest}
    
    #Fire directRefundAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-3"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">3iarW2b7YRAtjLe3pDS+Iw==</wsse:Nonce><wsu:Created>2017-09-21T06:12:07.095Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directRefundAmountReq><csap:sessionID>${sessionId2}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:requestNumber>1</csap:requestNumber></csap:directRefundAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    directRefundAmountReq    ${Message3}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId2}    ${response3.sessionID}    
    Should Be Equal As Strings    1    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.refundAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.refundAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.refundAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response3.requestNumberNextRequest}
    
Test 06 debitAmountReq prepaid external central
    # Prepaid Subscriber Test debitAmountReq API with valid External-Central user credentials
    # Fire createChargingSessionReq for prepaid subscriber with the required input parameters and External-Central user credentials
    # Fire reserveAmountReq API with the session id from above step with External-Central user credentials
    # Fire debitAmountReq with the session id from above step and valid External-Central user credentials of "AMXHub" 
    # Fire release API with external central credentials
    # Amount should be reserved in PPIN side
    # debitAmountReq API request is success
    # Configured amount should be debited in PPIN side
    # CDR with correct values should be generated in both PPIN and CE side
    # Session will be released between client and CE
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire reserveAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-4"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">0SFNlquacbBuFYmZ/+QENw==</wsse:Nonce><wsu:Created>2017-09-21T06:30:01.682Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:reserveAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:preferredAmount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>2</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:preferredAmount><csap:minimumAmount><!--Optional:--><csap:Currency>CRC</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:minimumAmount><csap:requestNumber>1</csap:requestNumber></csap:reserveAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    reserveAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    2    ${response1.requestNumberNextRequest}
    
    #Fire debitAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-5"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">R3kzPvDFE4EJohEtsy5r5g==</wsse:Nonce><wsu:Created>2017-09-21T06:44:00.852Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:debitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:reservedAmount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>2</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:reservedAmount><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:closeReservation>0</csap:closeReservation><csap:requestNumber>2</csap:requestNumber></csap:debitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    debitAmountReq    ${Message3}
   
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response3.sessionID}    
    Should Be Equal As Strings    2    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.Amount.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.ShipmentAmount.Exponent}
    Should Be Equal As Strings    2    ${response3.requestNumberNextRequest}
    
Test 07 creditAmountReq prepaid external central
# Prepaid Subscriber Test creditAmountReq API with valid External-Central user credentials
# Fire createChargingSessionReq for prepaid subscriber with the required input parameters and External-Central user credentials
# Fire reserveAmountReq API with the session id from above step with External-Central user credentials
# Fire creditAmountReq with the session id from above step and valid External-Central user credentials of "AMXHub"
# Session id is received when createChargingSessionReq is fired.
# Amount should be reserved in PPIN side
# creditAmountReq API request is success
# Configured amount should be credited in PPIN side
# CDR with correct values should be generated in both PPIN and CE side
# Session will be released between client and CE
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire reserveAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-4"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">0SFNlquacbBuFYmZ/+QENw==</wsse:Nonce><wsu:Created>2017-09-21T06:30:01.682Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:reserveAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:preferredAmount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>2</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:preferredAmount><csap:minimumAmount><!--Optional:--><csap:Currency>CRC</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:minimumAmount><csap:requestNumber>1</csap:requestNumber></csap:reserveAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    reserveAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    2    ${response1.requestNumberNextRequest}
    
    #Fire debitAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-6"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">c4dZXf11NAWc7icACpSLkw==</wsse:Nonce><wsu:Created>2017-09-21T06:57:12.066Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:creditAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>2</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><csap:closeReservation>0</csap:closeReservation><csap:requestNumber>2</csap:requestNumber></csap:creditAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    creditAmountReq    ${Message3}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response3.sessionID}    
    Should Be Equal As Strings    2    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.Amount.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.ShipmentAmount.Exponent}
    Should Be Equal As Strings    2    ${response3.requestNumberNextRequest}
    
Test 08 release prepaid external central
# Prepaid Subscriber Test creditAmountReq API with valid External-Central user credentials
# Fire createChargingSessionReq for prepaid subscriber with the required input parameters and External-Central user credentials
# Fire reserveAmountReq API with the session id from above step with External-Central user credentials
# Fire release API with external central credentials
# Session id is received when createChargingSessionReq is fired.
# Amount should be reserved in PPIN side
# Session will be released between client and CE

    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire reserveAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-4"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">0SFNlquacbBuFYmZ/+QENw==</wsse:Nonce><wsu:Created>2017-09-21T06:30:01.682Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:reserveAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:preferredAmount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>2</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:preferredAmount><csap:minimumAmount><!--Optional:--><csap:Currency>CRC</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:minimumAmount><csap:requestNumber>1</csap:requestNumber></csap:reserveAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    reserveAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    2    ${response1.requestNumberNextRequest}
    
    #Fire debitAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-7"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">qiWE83H1vLjgRN3L/Lw6Sw==</wsse:Nonce><wsu:Created>2017-09-21T07:08:01.824Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:release><csap:sessionID>${sessionId}</csap:sessionID><csap:requestNumber>2</csap:requestNumber></csap:release></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    release    ${Message3}
    # Log To Console    ${response3}    
    # validate response 
    Should Be Equal As Strings    None    ${response3}
    
Test 09 doCharge prepaid SRS Charging
# Prepaid Subscriber Test SRSChargingService doCharge API by not passing any credentials
# "1) Fire doCharge API for prepaid subscriber with the required input parameters
# 2) Do not pass any credentials"
# "1) API request is success
# 2) Configured amount should be charged in PPIN side
# 3) CDR with correct values should be generated in both PPIN and CE side"

    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/SRSChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:srs="http://ws.cm.tecnotree.com/SRSChargingService"><soapenv:Header/><soapenv:Body><srs:doCharge soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><providerId xsi:type="xsd:string">${providerId}</providerId><applicationId xsi:type="xsd:string">${applicationId}</applicationId><serviceId xsi:type="xsd:string">${serviceId}</serviceId><originId xsi:type="xsd:string">${originId}</originId><operationId xsi:type="xsd:string">${operationId}</operationId><msisdn xsi:type="xsd:string">${prepaid_msisdn}</msisdn><contentId xsi:type="xsd:string">${contentId}</contentId><contentDescription xsi:type="xsd:string">${contentDescription}</contentDescription></srs:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/SRSChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}

Test 10 doRefund prepaid SRS Charging
# Prepaid Subscriber Test SRSChargingService doRefund API by not passing any credentials
# "1) Fire doRefund API for prepaid subscriber with the required input parameters
# 2) Do not pass any credentials"
# "1) API request is success
# 2) Configured amount should be refunded in PPIN side
# 3) CDR with correct values should be generated in both PPIN and CE side"
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/SRSChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:srs="http://ws.cm.tecnotree.com/SRSChargingService"><soapenv:Header/><soapenv:Body><srs:doCharge soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><providerId xsi:type="xsd:string">${providerId}</providerId><applicationId xsi:type="xsd:string">${applicationId}</applicationId><serviceId xsi:type="xsd:string">${serviceId}</serviceId><originId xsi:type="xsd:string">${originId}</originId><operationId xsi:type="xsd:string">${operationId}</operationId><msisdn xsi:type="xsd:string">${prepaid_msisdn}</msisdn><contentId xsi:type="xsd:string">${contentId}</contentId><contentDescription xsi:type="xsd:string">${contentDescription}</contentDescription></srs:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/SRSChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}
    
    #create a soap message using input parameters
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:srs="http://ws.cm.tecnotree.com/SRSChargingService"><soapenv:Header/><soapenv:Body><srs:doRefund soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><providerId xsi:type="xsd:string">${providerId}</providerId><operationId xsi:type="xsd:string">${operationId}</operationId><msisdn xsi:type="xsd:string">${prepaid_msisdn}</msisdn><concept xsi:type="xsd:string">CE-SMS-MT</concept></srs:doRefund></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/SRSChargingService/
    #Fire soap request
    ${response1}    Call Soap Method    doRefund    ${Message1}
    #validate if response is success
    Should Be Equal As Strings    0    ${response1}
    
Test 11 doCharge prepaid external
# Prepaid Subscriber Test doCharge API with valid External user credentials
# "1) Fire doCharge API for prepaid subscriber with the required input parameters
# 2) Pass valid External-Central user credentials"
# "1) API request is success
# 2) Configured amount should be charged in PPIN side
# 3) CDR with correct values should be generated in both PPIN and CE side"

    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-49"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">8S6TC7NjO/78/78xxnrIOQ==</wsse:Nonce><wsu:Created>2017-09-20T07:30:45.579Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doCharge><com:providerId>${providerId}</com:providerId><com:applicationId>${applicationId}</com:applicationId><com:serviceId>${serviceId}</com:serviceId><com:originId>${originId}</com:originId><com:operationId>${operationId}</com:operationId><com:msisdn>${prepaid_msisdn}</com:msisdn><com:contentId>${contentId}</com:contentId><com:contentDescription>${contentDescription}</com:contentDescription></com:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}
    # ${transactionID}    Get DB details    ${getTransactionId}
    # ${CDR}    GetCDR    ${transactionID}    prepaid
    # ${charged_price}    Compute Charging and Validate CDR    ${prepaid_msisdn}    ${keyword}    ${CDR}
    # Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}

Test 12 doRefund prepaid external
# Prepaid Subscriber Test doRefund API with valid External user credentials
# "1) Fire doRefund API for prepaid subscriber with the required input parameters, operation id should be the id that was passed during doCharge in previous testcase
# 2) Pass valid External-Central user credentials"
# "1) API request is success
# 2) Configured amount should be refunded in PPIN side
# 3) CDR with correct values should be generated in both PPIN and CE side"
 
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-49"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">8S6TC7NjO/78/78xxnrIOQ==</wsse:Nonce><wsu:Created>2017-09-20T07:30:45.579Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doCharge><com:providerId>${providerId}</com:providerId><com:applicationId>${applicationId}</com:applicationId><com:serviceId>${serviceId}</com:serviceId><com:originId>${originId}</com:originId><com:operationId>${operationId}</com:operationId><com:msisdn>${prepaid_msisdn}</com:msisdn><com:contentId>${contentId}</com:contentId><com:contentDescription>${contentDescription}</com:contentDescription></com:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}
    
    #create a soap message using input parameters
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-4"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">9hmaeVH3Us4kn0VCoGWXLA==</wsse:Nonce><wsu:Created>2017-09-20T06:29:29.457Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doRefund><com:providerId>${providerId}</com:providerId><com:operationId>${operationId}</com:operationId><com:originId>${originId}</com:originId><com:msisdn>${prepaid_msisdn}</com:msisdn><com:concept>CE-SMS-MT</com:concept><com:subscriptionId/></com:doRefund></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response1}    Call Soap Method    doRefund    ${Message1}
    #validate if response is success
    Should Be Equal As Strings    0    ${response1}
    
Test 13 directDebitAmountReq prepaid external
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
Test 14 directCreditAmountReq prepaid external
    # 1) Fire createChargingSessionReq first
    # 2) Use the session id from above request and then fire directDebitAmountReq
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
    #----------------------------
    #create a soap message using input parameters
    ${Message2}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response2}    Call Soap Method    createChargingSessionReq    ${Message2}
    #Fetch the session id from response for later use
    ${sessionId2}    Set Variable    ${response2.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response2.RequestNumberFirstRequest}
    
    #Fire directCreditAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-2"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">Te/+tij9rHoPcnXLkuoc8w==</wsse:Nonce><wsu:Created>2017-09-21T05:54:25.342Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directCreditAmountReq><csap:sessionID>${sessionId2}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><csap:requestNumber>1</csap:requestNumber></csap:directCreditAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    directCreditAmountReq    ${Message3}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId2}    ${response3.sessionID}    
    Should Be Equal As Strings    1    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response3.requestNumberNextRequest}
    
Test 15 directRefundAmountReq prepaid external
    # 1) Fire createChargingSessionReq first
    # 2) Use the session id from above request and then fire directDebitAmountReq
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
    #----------------------------
    #create a soap message using input parameters
    ${Message2}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response2}    Call Soap Method    createChargingSessionReq    ${Message2}
    #Fetch the session id from response for later use
    ${sessionId2}    Set Variable    ${response2.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response2.RequestNumberFirstRequest}
    
    #Fire directRefundAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-3"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">3iarW2b7YRAtjLe3pDS+Iw==</wsse:Nonce><wsu:Created>2017-09-21T06:12:07.095Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directRefundAmountReq><csap:sessionID>${sessionId2}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:requestNumber>1</csap:requestNumber></csap:directRefundAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    directRefundAmountReq    ${Message3}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId2}    ${response3.sessionID}    
    Should Be Equal As Strings    1    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.refundAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.refundAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.refundAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response3.requestNumberNextRequest}
    
Test 16 debitAmountReq prepaid external
    # 1) Fire createChargingSessionReq first
    # 2) Use the session id from above request and then fire directDebitAmountReq
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire reserveAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-4"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">0SFNlquacbBuFYmZ/+QENw==</wsse:Nonce><wsu:Created>2017-09-21T06:30:01.682Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:reserveAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:preferredAmount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>2</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:preferredAmount><csap:minimumAmount><!--Optional:--><csap:Currency>CRC</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:minimumAmount><csap:requestNumber>1</csap:requestNumber></csap:reserveAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    reserveAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    2    ${response1.requestNumberNextRequest}
    
    #Fire debitAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-5"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">R3kzPvDFE4EJohEtsy5r5g==</wsse:Nonce><wsu:Created>2017-09-21T06:44:00.852Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:debitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:reservedAmount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>2</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:reservedAmount><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:closeReservation>0</csap:closeReservation><csap:requestNumber>2</csap:requestNumber></csap:debitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    debitAmountReq    ${Message3}
   
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response3.sessionID}    
    Should Be Equal As Strings    2    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.Amount.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.ShipmentAmount.Exponent}
    Should Be Equal As Strings    2    ${response3.requestNumberNextRequest}
    
Test 17 creditAmountReq prepaid external
    # 1) Fire createChargingSessionReq first
    # 2) Use the session id from above request and then fire directDebitAmountReq
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire reserveAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-4"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">0SFNlquacbBuFYmZ/+QENw==</wsse:Nonce><wsu:Created>2017-09-21T06:30:01.682Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:reserveAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:preferredAmount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>2</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:preferredAmount><csap:minimumAmount><!--Optional:--><csap:Currency>CRC</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:minimumAmount><csap:requestNumber>1</csap:requestNumber></csap:reserveAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    reserveAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    2    ${response1.requestNumberNextRequest}
    
    #Fire debitAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-6"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">c4dZXf11NAWc7icACpSLkw==</wsse:Nonce><wsu:Created>2017-09-21T06:57:12.066Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:creditAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>2</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><csap:closeReservation>0</csap:closeReservation><csap:requestNumber>2</csap:requestNumber></csap:creditAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    creditAmountReq    ${Message3}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response3.sessionID}    
    Should Be Equal As Strings    2    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.Amount.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.reservedAmountLeft.ShipmentAmount.Exponent}
    Should Be Equal As Strings    2    ${response3.requestNumberNextRequest}
    
Test 18 release prepaid external
    # 1) Fire createChargingSessionReq first
    # 2) Use the session id from above request and then fire directDebitAmountReq
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${prepaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${prepaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire reserveAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-4"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">0SFNlquacbBuFYmZ/+QENw==</wsse:Nonce><wsu:Created>2017-09-21T06:30:01.682Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:reserveAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${prepaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:preferredAmount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>2</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:preferredAmount><csap:minimumAmount><!--Optional:--><csap:Currency>CRC</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:minimumAmount><csap:requestNumber>1</csap:requestNumber></csap:reserveAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    reserveAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.reservedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    2    ${response1.requestNumberNextRequest}
    
    #Fire debitAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-7"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">qiWE83H1vLjgRN3L/Lw6Sw==</wsse:Nonce><wsu:Created>2017-09-21T07:08:01.824Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:release><csap:sessionID>${sessionId}</csap:sessionID><csap:requestNumber>2</csap:requestNumber></csap:release></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    release    ${Message3}
    # Log To Console    ${response3}    
    # validate response 
    Should Be Equal As Strings    None    ${response3}
    
Test 19 doCharge postpaid external central
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-49"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">8S6TC7NjO/78/78xxnrIOQ==</wsse:Nonce><wsu:Created>2017-09-20T07:30:45.579Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doCharge><com:providerId>${providerId}</com:providerId><com:applicationId>${applicationId}</com:applicationId><com:serviceId>${serviceId}</com:serviceId><com:originId>${originId}</com:originId><com:operationId>${operationId}</com:operationId><com:msisdn>${postpaid_msisdn}</com:msisdn><com:contentId>${contentId}</com:contentId><com:contentDescription>${contentDescription}</com:contentDescription></com:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}
    # ${transactionID}    Get DB details    ${getTransactionId}
    # ${CDR}    GetCDR    ${transactionID}    prepaid
    # ${charged_price}    Compute Charging and Validate CDR    ${postpaid_msisdn}    ${keyword}    ${CDR}
    # Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}

Test 20 doRefund postpaid external central
    # 1) First fire doCharge
    # 2) Using the operation id from doCharge, fire doRefund 
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-49"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">8S6TC7NjO/78/78xxnrIOQ==</wsse:Nonce><wsu:Created>2017-09-20T07:30:45.579Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doCharge><com:providerId>${providerId}</com:providerId><com:applicationId>${applicationId}</com:applicationId><com:serviceId>${serviceId}</com:serviceId><com:originId>${originId}</com:originId><com:operationId>${operationId}</com:operationId><com:msisdn>${postpaid_msisdn}</com:msisdn><com:contentId>${contentId}</com:contentId><com:contentDescription>${contentDescription}</com:contentDescription></com:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}
    
    #create a soap message using input parameters
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-4"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">9hmaeVH3Us4kn0VCoGWXLA==</wsse:Nonce><wsu:Created>2017-09-20T06:29:29.457Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doRefund><com:providerId>${providerId}</com:providerId><com:operationId>${operationId}</com:operationId><com:originId>${originId}</com:originId><com:msisdn>${postpaid_msisdn}</com:msisdn><com:concept>CE-SMS-MT</com:concept><com:subscriptionId/></com:doRefund></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response1}    Call Soap Method    doRefund    ${Message1}
    #validate if response is success
    Should Be Equal As Strings    0    ${response1}
    
Test 21 directDebitAmountReq postpaid external central
    # 1) Fire createChargingSessionReq first
    # 2) Use the session id from above request and then fire directDebitAmountReq
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${postpaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${postpaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
Test 22 directCreditAmountReq postpaid external central
    # 1) Fire createChargingSessionReq first
    # 2) Use the session id from above request and then fire directDebitAmountReq
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${postpaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${postpaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
    #----------------------------
    #create a soap message using input parameters
    ${Message2}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${postpaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response2}    Call Soap Method    createChargingSessionReq    ${Message2}
    #Fetch the session id from response for later use
    ${sessionId2}    Set Variable    ${response2.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response2.RequestNumberFirstRequest}
    
    #Fire directCreditAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-2"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">Te/+tij9rHoPcnXLkuoc8w==</wsse:Nonce><wsu:Created>2017-09-21T05:54:25.342Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directCreditAmountReq><csap:sessionID>${sessionId2}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${postpaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><csap:requestNumber>1</csap:requestNumber></csap:directCreditAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    directCreditAmountReq    ${Message3}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId2}    ${response3.sessionID}    
    Should Be Equal As Strings    1    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response3.requestNumberNextRequest}
    
Test 23 directRefundAmountReq postpaid external central
    # 1) Fire createChargingSessionReq first
    # 2) Use the session id from above request and then fire directDebitAmountReq
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${postpaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${postpaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
    #----------------------------
    #create a soap message using input parameters
    ${Message2}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${postpaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response2}    Call Soap Method    createChargingSessionReq    ${Message2}
    #Fetch the session id from response for later use
    ${sessionId2}    Set Variable    ${response2.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response2.RequestNumberFirstRequest}
    
    #Fire directRefundAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-3"><wsse:Username>${external_central_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_central_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">3iarW2b7YRAtjLe3pDS+Iw==</wsse:Nonce><wsu:Created>2017-09-21T06:12:07.095Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directRefundAmountReq><csap:sessionID>${sessionId2}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${postpaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:requestNumber>1</csap:requestNumber></csap:directRefundAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    directRefundAmountReq    ${Message3}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId2}    ${response3.sessionID}    
    Should Be Equal As Strings    1    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.refundAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.refundAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.refundAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response3.requestNumberNextRequest}
    
Test 24 doCharge postpaid SRS Charging
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/SRSChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:srs="http://ws.cm.tecnotree.com/SRSChargingService"><soapenv:Header/><soapenv:Body><srs:doCharge soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><providerId xsi:type="xsd:string">${providerId}</providerId><applicationId xsi:type="xsd:string">${applicationId}</applicationId><serviceId xsi:type="xsd:string">${serviceId}</serviceId><originId xsi:type="xsd:string">${originId}</originId><operationId xsi:type="xsd:string">${operationId}</operationId><msisdn xsi:type="xsd:string">${postpaid_msisdn}</msisdn><contentId xsi:type="xsd:string">${contentId}</contentId><contentDescription xsi:type="xsd:string">${contentDescription}</contentDescription></srs:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/SRSChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}

Test 25 doRefund postpaid SRS Charging
    # 1) First fire doCharge
    # 2) Using the operation id from doCharge, fire doRefund 
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/SRSChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:srs="http://ws.cm.tecnotree.com/SRSChargingService"><soapenv:Header/><soapenv:Body><srs:doCharge soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><providerId xsi:type="xsd:string">${providerId}</providerId><applicationId xsi:type="xsd:string">${applicationId}</applicationId><serviceId xsi:type="xsd:string">${serviceId}</serviceId><originId xsi:type="xsd:string">${originId}</originId><operationId xsi:type="xsd:string">${operationId}</operationId><msisdn xsi:type="xsd:string">${postpaid_msisdn}</msisdn><contentId xsi:type="xsd:string">${contentId}</contentId><contentDescription xsi:type="xsd:string">${contentDescription}</contentDescription></srs:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/SRSChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}
    
    #create a soap message using input parameters
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:srs="http://ws.cm.tecnotree.com/SRSChargingService"><soapenv:Header/><soapenv:Body><srs:doRefund soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><providerId xsi:type="xsd:string">${providerId}</providerId><operationId xsi:type="xsd:string">${operationId}</operationId><msisdn xsi:type="xsd:string">${postpaid_msisdn}</msisdn><concept xsi:type="xsd:string">CE-SMS-MT</concept></srs:doRefund></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/SRSChargingService/
    #Fire soap request
    ${response1}    Call Soap Method    doRefund    ${Message1}
    #validate if response is success
    Should Be Equal As Strings    0    ${response1}
    
Test 26 doCharge postpaid external
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-49"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">8S6TC7NjO/78/78xxnrIOQ==</wsse:Nonce><wsu:Created>2017-09-20T07:30:45.579Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doCharge><com:providerId>${providerId}</com:providerId><com:applicationId>${applicationId}</com:applicationId><com:serviceId>${serviceId}</com:serviceId><com:originId>${originId}</com:originId><com:operationId>${operationId}</com:operationId><com:msisdn>${postpaid_msisdn}</com:msisdn><com:contentId>${contentId}</com:contentId><com:contentDescription>${contentDescription}</com:contentDescription></com:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}
    # ${transactionID}    Get DB details    ${getTransactionId}
    # ${CDR}    GetCDR    ${transactionID}    prepaid
    # ${charged_price}    Compute Charging and Validate CDR    ${postpaid_msisdn}    ${keyword}    ${CDR}
    # Compare Account_balance in PPIN    ${onDemand_msisdn}    ${charged_price}

Test 27 doRefund postpaid external
    # 1) First fire doCharge
    # 2) Using the operation id from doCharge, fire doRefund 
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-49"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">8S6TC7NjO/78/78xxnrIOQ==</wsse:Nonce><wsu:Created>2017-09-20T07:30:45.579Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doCharge><com:providerId>${providerId}</com:providerId><com:applicationId>${applicationId}</com:applicationId><com:serviceId>${serviceId}</com:serviceId><com:originId>${originId}</com:originId><com:operationId>${operationId}</com:operationId><com:msisdn>${postpaid_msisdn}</com:msisdn><com:contentId>${contentId}</com:contentId><com:contentDescription>${contentDescription}</com:contentDescription></com:doCharge></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response}    Call Soap Method    doCharge    ${Message}
    #validate if response is success
    Should Be Equal As Strings    0    ${response}
    
    #create a soap message using input parameters
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:com="http://ws.cm.tecnotree.com/CommonType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-4"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">9hmaeVH3Us4kn0VCoGWXLA==</wsse:Nonce><wsu:Created>2017-09-20T06:29:29.457Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><com:doRefund><com:providerId>${providerId}</com:providerId><com:operationId>${operationId}</com:operationId><com:originId>${originId}</com:originId><com:msisdn>${postpaid_msisdn}</com:msisdn><com:concept>CE-SMS-MT</com:concept><com:subscriptionId/></com:doRefund></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingService/
    #Fire soap request
    ${response1}    Call Soap Method    doRefund    ${Message1}
    #validate if response is success
    Should Be Equal As Strings    0    ${response1}
    
Test 28 directDebitAmountReq postpaid external
    # 1) Fire createChargingSessionReq first
    # 2) Use the session id from above request and then fire directDebitAmountReq
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${postpaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${postpaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
Test 29 directCreditAmountReq postpaid external
    # 1) Fire createChargingSessionReq first
    # 2) Use the session id from above request and then fire directDebitAmountReq
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${postpaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${postpaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
    #----------------------------
    #create a soap message using input parameters
    ${Message2}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${postpaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response2}    Call Soap Method    createChargingSessionReq    ${Message2}
    #Fetch the session id from response for later use
    ${sessionId2}    Set Variable    ${response2.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response2.RequestNumberFirstRequest}
    
    #Fire directCreditAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-2"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">Te/+tij9rHoPcnXLkuoc8w==</wsse:Nonce><wsu:Created>2017-09-21T05:54:25.342Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directCreditAmountReq><csap:sessionID>${sessionId2}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${postpaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><csap:requestNumber>1</csap:requestNumber></csap:directCreditAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    directCreditAmountReq    ${Message3}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId2}    ${response3.sessionID}    
    Should Be Equal As Strings    1    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.creditedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response3.requestNumberNextRequest}
    
Test 30 directRefundAmountReq postpaid external
    # 1) Fire createChargingSessionReq first
    # 2) Use the session id from above request and then fire directDebitAmountReq
    
    #set subscriber balance to 9999999
    Change Account_balance in PPIN    ${postpaid_msisdn}
    #generate a random number for operation id
    ${operationId}=    Generate Random String  10  [NUMBERS]
    #create a soap client
    Create SOAP Client    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService?wsdl
    #create a soap message using input parameters
    ${Message}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${postpaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response}    Call Soap Method    createChargingSessionReq    ${Message}
    #Fetch the session id from response for later use
    ${sessionId}    Set Variable    ${response.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response.RequestNumberFirstRequest}
    
    #Fire directDebitAmountReq
    ${Message1}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-1"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">rAfDQWw9k07he3XPB70eJg==</wsse:Nonce><wsu:Created>2017-09-21T05:16:14.763Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directDebitAmountReq><csap:sessionID>${sessionId}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${postpaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:amount><!--Optional:--><csap:Currency>${currency}</csap:Currency><!--Optional:--><csap:IvaTax><csap:Number>0</csap:Number><csap:Exponent/></csap:IvaTax><csap:Amount><csap:Number>1</csap:Number><csap:Exponent>1</csap:Exponent></csap:Amount><!--Optional:--><csap:ShipmentAmount><csap:Number>0</csap:Number><csap:Exponent/></csap:ShipmentAmount><!--Optional:--><csap:CalculatedPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:CalculatedPromo><!--Optional:--><csap:PercentPromo><csap:Number>0</csap:Number><csap:Exponent/></csap:PercentPromo></csap:amount><!--Optional:--><csap:commission><csap:Number>0</csap:Number><csap:Exponent/></csap:commission><csap:requestNumber>1</csap:requestNumber></csap:directDebitAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response1}    Call Soap Method    directDebitAmountReq    ${Message1}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId}    ${response1.sessionID}    
    Should Be Equal As Strings    1    ${response1.requestNumber}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response1.debitedAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response1.requestNumberNextRequest}
    
    #----------------------------
    #create a soap message using input parameters
    ${Message2}    Create Raw Soap Message    <soapenv:Envelope xmlns:add="http://www.w3.org/2005/08/addressing" xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-52"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">kp2zSgDkwuacCttHNQF0+w==</wsse:Nonce><wsu:Created>2017-09-20T07:33:58.811Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:createChargingSessionReq><csap:appChargingSession><add:Address>${applicationId1}</add:Address><!--Optional:--><add:ReferenceParameters><!--You may enter ANY elements at this point--></add:ReferenceParameters><!--Optional:--><add:Metadata><!--You may enter ANY elements at this point--></add:Metadata><!--You may enter ANY elements at this point--></csap:appChargingSession><csap:sessionDescription>Testing</csap:sessionDescription><csap:merchantAccount><csap:MerchantID>${providerId}</csap:MerchantID><csap:AccountID>${originId1}</csap:AccountID></csap:merchantAccount><csap:users><!--Zero or more repetitions:--><csap:Item><csap:Plan/><csap:AddrString>${postpaid_msisdn}</csap:AddrString><csap:Name/><csap:Presentation/><csap:Screening/><csap:SubAddressString>?</csap:SubAddressString></csap:Item></csap:users><csap:correlationID><csap:CorrelationID>${operationId}</csap:CorrelationID><csap:CorrelationType/></csap:correlationID></csap:createChargingSessionReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response2}    Call Soap Method    createChargingSessionReq    ${Message2}
    #Fetch the session id from response for later use
    ${sessionId2}    Set Variable    ${response2.ChargingSessionID}
    #Verify if request number is 1
    Should Be Equal As Strings    1    ${response2.RequestNumberFirstRequest}
    
    #Fire directRefundAmountReq
    ${Message3}    Create Raw Soap Message    <soapenv:Envelope xmlns:csap="http://ws.cm.tecnotree.com/CSAPIType" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Header><wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"><wsse:UsernameToken wsu:Id="UsernameToken-3"><wsse:Username>${external_user}</wsse:Username><wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">${external_password}</wsse:Password><wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">3iarW2b7YRAtjLe3pDS+Iw==</wsse:Nonce><wsu:Created>2017-09-21T06:12:07.095Z</wsu:Created></wsse:UsernameToken></wsse:Security></soapenv:Header><soapenv:Body><csap:directRefundAmountReq><csap:sessionID>${sessionId2}</csap:sessionID><csap:chargingParameters><!--Zero or more repetitions:--><csap:Item><csap:ParameterID>1</csap:ParameterID><csap:ParameterValue><csap:IntValue>${packageId}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>2</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>3</csap:ParameterID><csap:ParameterValue><csap:IntValue>${serviceId1}</csap:IntValue><csap:FloatValue/><csap:StringValue/><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>4</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${contentName1}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>5</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${date}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item><csap:Item><csap:ParameterID>6</csap:ParameterID><csap:ParameterValue><csap:IntValue/><csap:FloatValue/><csap:StringValue>${postpaid_msisdn}</csap:StringValue><csap:BooleanValue/><csap:OctetValue/></csap:ParameterValue></csap:Item></csap:chargingParameters><csap:requestNumber>1</csap:requestNumber></csap:directRefundAmountReq></soapenv:Body></soapenv:Envelope>
    #set destination URL
    Set Location    http://${testServer}:${adminUIPort}/chargingManager/services/ChargingSessionService/
    #Fire soap request
    ${response3}    Call Soap Method    directRefundAmountReq    ${Message3}
    
    # validate response 
    Should Be Equal As Strings    ${sessionId2}    ${response3.sessionID}    
    Should Be Equal As Strings    1    ${response3.requestNumber}
    Should Be Equal As Strings    0    ${response3.refundAmount.IvaTax.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.IvaTax.Exponent}
    Should Be Equal As Strings    0    ${response3.refundAmount.Amount.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.Amount.Exponent}
    Should Be Equal As Strings    0    ${response3.refundAmount.ShipmentAmount.Number}
    Should Be Equal As Strings    0    ${response3.refundAmount.ShipmentAmount.Exponent}
    Should Be Equal As Strings    1    ${response3.requestNumberNextRequest}