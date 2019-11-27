*** Settings ***
Documentation    Properties page object reference document

*** Variables ***
${system_header_loc}    //div[@id='myslidemenu']/ul/li[5]/a
${properties_loc}    //div[@id='myslidemenu']/ul/li[5]/ul/li[5]/a

${enable_subscription_optin_loc}    //table[@class='task']/tbody/tr[1]/td[1]/label
${module_type_loc}    //div[@id='progType_chosen']/a/span
${searchbox_xpath}    //div[@class='chosen-search']/input
${module_value}    SIA
${highlighted_value}    //li[@class='active-result highlighted']
${SIA_CONF_CHRG_PAGE_CAPTCHA_ENABLE_loc}    //*[contains(text(),'SIA_CONF_CHRG_PAGE_CAPTCHA_ENABLE')]/../td/input
${update_button_loc}    //input[@value='Update']

${update_successfully_title_loc}    //div[@id='main']/div/div/h3
${update_successfully_title}    PARAMETER VALUES UPDATED SUCCESSFULLY FOR MODULE SIA

# Subscription related
${subscription_module_value}    SUBSCRIPTION
${PERIODICITY_PLACEHOLDER_REPLACEMENTS_loc}    //*[contains(text(),'SUBS_PERIODICITY_PLACEHOLDER_REPLACEMENTS')]/../td/input

#Generic
${generic_module_value}    GENERIC
${FILE_DELIMITER_loc}    //*[contains(text(),'FILE_DELIMITER')]/../td/input
${MAX_FILE_ROWS_loc}    //*[contains(text(),'MAX_FILE_ROWS')]/../td/input