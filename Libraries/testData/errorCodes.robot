*** Settings ***
Resource          genericData.robot
Resource        ../configurations.robot

*** Variables ***
# CE Error codes #

${SUBSCRIBER_NOT_FOUND}    288
${INSUFFICIENT_BALANCE}    205
${DUPLICATE_REFUND_REQUEST}    488