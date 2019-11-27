*** Settings ***
Documentation    MO Simulator page object reference document

*** Variables ***

${mo_inject_loc}   //*[@id='menutable']/tbody/tr/td[4]/a
${mo_keyword_loc}   //*[@id='logo']/tbody/tr[3]/td[2]/table/tbody/tr/td/form/table/tbody/tr[2]/td[2]/textarea
${mo_src_addr_loc}  //*[@id='logo']/tbody/tr[3]/td[2]/table/tbody/tr/td/form/table/tbody/tr[4]/td[2]/input
${mo_dest_addr_loc}   //*[@id='logo']/tbody/tr[3]/td[2]/table/tbody/tr/td/form/table/tbody/tr[5]/td[2]/input
${mo_submit_button_loc}     //input[@type='submit']