*** Settings ***
Resource    ../configurations.robot
*** Variables ***
${InformationServiceWSDL}       http://${testServer}:${admin_ui_port}/cdc-service/services/CEInformationService?wsdl
${CRMInformationServiceWSDL}    http://${testServer}:${admin_ui_port}/cdc-service/services/CRMInformationService?wsdl
${CRMServiceWSDL}    http://${testServer}:${admin_ui_port}/cdc-service/services/CRMService?wsdl
${ChargingServiceWSDL}    http://${testServer}:${admin_ui_port}/chargingManager/services/ChargingService?wsdl