*** Settings ***
Documentation    Global onDemand Optin page object reference document

*** Variables ***
${services_header_loc}    //div[@id='myslidemenu']/ul/li[4]/a
${onDemand_optin_loc}    //div[@id='myslidemenu']/ul/li[4]/ul/li[9]/a

${enable_subscription_optin_loc}    //table[@class='task']/tbody/tr[1]/td[1]/label
${onDemand_optin_based_on_tariff_loc}    //div[@id='main']/div/form/div[1]/table/tbody/tr[1]/td[2]/label
${optin_max_active_session_loc}    //input[@id='maxActiveSession']
${onDemand_optin_session_expiry_time_loc}    //input[@id='sessionExpMins']
${optin_max_level_loc}    //input[@id='maxLevelConf']
${suffix_generation_policy_loc}    //div[@id='suffixGenPolicy_chosen']/a
${onDemand_notification_message_loc}    //textarea[@id='notifMsgOnDemand']
${onDemand_allowed_keyword_loc}    //div[@id='keywordTemp_chosen']/a/span
${onDemand_allowed_keyword_searchbox_loc}   //div[@id='keywordTemp_chosen']/div/div/input 
${onDemand_reject_keyword_searchbox_loc}    //div[@id='keywordTempRej_chosen']/div/div/input
${onDemand_accpeptKeyword_highlighted_value_xpath}    //div[@id='keywordTemp_chosen']/div/ul/li
${onDemand_rejectKeyword_highlighted_value_xpath}    //div[@id='keywordTempRej_chosen']/div/ul/li
${onDemand_allowed_reject_keyword_loc}    //div[@id='keywordTempRej_chosen']/a/span
${add_button_loc}    //input[@name='addAcc']
${onDemand_refuse_notification_loc}    //textarea[@id='editNotifMsgRefuse']
${onDemand_expiry_notification_loc}    //textarea[@id='editNotifMsgExpiry']
${onDemand_update_button_loc}    //input[@value='Update']
${onDemand_update_succesfully_title_loc}    //div[@id='main']/div/div/h3

${onDemand_update_succesfully_title}    ONDEMAND OPT-IN UPDATE SUCCESSFULLY