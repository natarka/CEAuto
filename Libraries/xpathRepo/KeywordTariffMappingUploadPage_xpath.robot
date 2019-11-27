*** Settings ***
Documentation    Bulk Upload page reference document

*** Variables ***

${services_loc}   //div[@id='myslidemenu']/ul/li[4]/a
${shortCodeTariff_loc}   //div[@id='myslidemenu']/ul/li[4]/ul/li[6]/a
${uploadTariff_loc}     //table[@class='task']/tbody/tr/td/input[2]
${attachFile_loc}    id=file1
${uploadButton_loc}    //input[@value='Upload']
${resetButton_loc}    //input[@value='Reset']
${cancelButton_loc}    //input[@value='Cancel']