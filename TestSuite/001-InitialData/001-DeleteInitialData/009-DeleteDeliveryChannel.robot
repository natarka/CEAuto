*** Settings ***
Resource    ../../../Libraries/genericLibrary/commonTasks.robot
*** Test Cases ***
Test Delete Delivery Channel
    Check and Delete Delivery Channel    ${delivery_channel}