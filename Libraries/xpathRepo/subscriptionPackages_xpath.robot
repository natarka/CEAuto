*** Settings ***
Documentation    Global Susbcription Optin page object reference document
Resource        ../testData/subscription_Optin.robot

*** Variables ***

${services_header_loc}    //div[@id='myslidemenu']/ul/li[4]/a
${subscription_management_loc}    //div[@id='myslidemenu']/ul/li[4]/ul/li[7]/a
${subscription_packages_loc}    //div[@id='myslidemenu']/ul/li[4]/ul/li[7]/ul/li[3]/a

${searchbox_loc}    //input[@id='searchKey']
${search_button_loc}    //input[@value='Search']
${package_edit_button_loc}    //*[contains(text(),'${pakage_name2}')]/../td[8]/a[1]
${package_duration_loc}    //input[@name='subPackageDuration']
${package_update_button_loc}    //input[@value='Update']

${package_update_succesfully_title_loc}    //div[@id='main']/div/div/h3

${package_update_succesfully_title}    updated successfully