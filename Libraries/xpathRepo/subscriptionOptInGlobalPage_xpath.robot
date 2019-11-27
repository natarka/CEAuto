*** Settings ***
Documentation    Global Susbcription Optin page object reference document

*** Variables ***

${services_header_loc}    //div[@id='myslidemenu']/ul/li[4]/a
${subscription_management_loc}    //div[@id='myslidemenu']/ul/li[4]/ul/li[7]/a
${subscription_optin_loc}    //div[@id='myslidemenu']/ul/li[4]/ul/li[7]/ul/li[1]/a

${enable_subscription_optin_loc}    //div[@id='main']/div/form/div[1]/table/tbody/tr[1]/td[1]/label/span
${subscription_optin_based_on_tariff_loc}    //div[@id='main']/div/form/div[1]/table/tbody/tr[1]/td[2]/label/span
${optin_max_active_session_loc}    //input[@id='maxActiveSession']
${subscription_optin_session_expiry_time_loc}    //input[@id='sessionExpMins']
${optin_max_level_loc}    //input[@id='maxLevelConf']
${suffix_generation_policy_loc}    //div[@id='suffixGenPolicy_chosen']/a
${notification_message_loc}    //textarea[@id='listNotifMsgPrePd_PP']
${allowed_keyword_loc}    //div[@id='keywordTemp1_chosen']/a/span
${allowed_keyword_searchbox_loc}    //div[@id='keywordTemp1_chosen']/div/div/input
${allowed_reject_keyword_loc}    //div[@id='keywordTempRej1_chosen']/a/span
${reject_keyword_searchbox_loc}    //div[@id='keywordTempRej1_chosen']/div/div/input
${add_button_loc}    //input[@value='Add'][@name='addAcc']
${delete_optin_notificaiton_loc}    //a[@class='action-delete']
${refuse_notification_loc}    //textarea[@id='editNotifMsgRefuse']
${expiry_notification_loc}    //textarea[@id='editNotifMsgExpiry']
${subscription_update_button_loc}    //input[@class='default'][@value='Update']
${subscription_update_succesfully_title_loc}    //div[@id='main']/div/div/h3

${subscription_update_succesfully_title}    SUBSCRIPTION OPT-IN UPDATE SUCCESSFULLY