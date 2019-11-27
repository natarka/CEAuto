*** Settings ***
Documentation     Details related to WebService request
Resource          ../configurations.robot

*** Variables ***
#### SIA related ####

${SIATransactionService_wsdl}    http://172.20.39.82:8080/siaarg/services/SIATransactionService?wsdl
${SIATransactionService_url}    http://172.20.39.82:8080/siaarg/services/SIATransactionService/
${SIAConfCharge_url}    http://172.20.39.82:8080/siaarg/jsp/confcharge.jsp?_transactionId=

${subscriptionService_wsdl}    http://172.20.39.82:8080/cdc-service/services/CESubscriptionService?wsdl
${subscriptionService_url}    http://172.20.39.82:8080/cdc-service/services/CESubscriptionService.SubscriptionServiceSOAP/


${userId}    ${cpUser}
${passwd}    ${cpPass}
${channel}    WAP
${contentName}    AUTOMATION
${urlOk}    http://www.google.com
${urlCancel}    http://www.timesofindia.indiatimes.com
${urlError}    http://www.espncricinfo.com
${urlUnsusc}    ${EMPTY}
${extraParam}    1