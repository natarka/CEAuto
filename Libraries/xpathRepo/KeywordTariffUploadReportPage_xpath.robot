*** Settings ***
Documentation     Bulk upload reports page reference document

*** Variables ***

${reports_loc}   //div[@id=']myslidemenu']/ul/li[6]/a
${keywordTariffMapUpload_loc}    //div[@id='myslidemenu']/ul/li[6]/ul/li[5]/a
${generateButton_loc}    //input[@value='Generate']
${downloadReportButton_loc}    //input[@value='Download Report']
${resetButton_loc}    //input[@value='Reset']

${fileName1stRow}    //table[@class='tasks']/tbody[2]/tr/td[2]
${uploadDate1stRow}    //table[@class='tasks']/tbody[2]/tr/td[3]
${totalRecord1stRow}    //table[@class='tasks']/tbody[2]/tr/td[4]
${successCount1stRow}    //table[@class='tasks']/tbody[2]/tr/td[5]
${failureCount1stRow}    //table[@class='tasks']/tbody[2]/tr/td[6]
${status1stRow}    //table[@class='tasks']/tbody[2]/tr/td[7]
${details1stRow}    //table[@class='tasks']/tbody[2]/tr/td[8]/a[1]
${summary1stRow}    //table[@class='tasks']/tbody[2]/tr/td[8]/a[2]

${totalRowsCount_loc}    //*[contains(text(),'Total Rows Count:')]/../td[1]
${rowsInserted_loc}    //*[contains(text(),'Rows Inserted:')]/../td[1]
${rowsWithError_loc}    //*[contains(text(),'Rows with error:')]/../td[1]

${total_records_loc}    //*[contains(text(),'Total Records')]/../td[2]
${success_count_loc}    //*[contains(text(),'Success Count')]/../td[2]
${failure_count_loc}    //*[contains(text(),'Failure Count')]/../td[2]

${keywordLimitExceeds_loc}    //*[contains(text(),'KW limit exeeds')]/../td[2]
${invalidChargeCode_loc}    //*[contains(text(),'Invalid Charge Code')]/../td[2]
${invalidServiceType_loc}    //*[contains(text(),'Invalid Service Type')]/../td[2]
${tariffAlreadyMapped_loc}    //*[contains(text(),'Tariff already mapped')]/../td[2]
${invalidShortCode_loc}    //*[contains(text(),'Invalid Short Code')]/../td[2]
${invalidKeyword_loc}    //*[contains(text(),'Invalid Keyword')]/../td[2]
${keywordSequencePresent_loc}    //*[contains(text(),'KW SEQ present')]/../td[2]
${mtNotFound_loc}    //*[contains(text(),'MT not found')]/../td[2]
${mtFlagNotEnable_loc}    //*[contains(text(),'MT flag not enable')]/../td[2]
${moFlagNotEnable_loc}    //*[contains(text(),'MO Flag not enable')]/../td[2]
${invalidCpId_loc}    //*[contains(text(),'Invalid Cp Id')]/../td[2]

${newKeywordCount_loc}    //*[contains(text(),'New Keyword Count')]/../td[2]
${newKeywordList_loc}    //*[contains(text(),'New Keyword List')]/../../tr[21]/td

${backButtonFromDetailsScreen_loc}    //input[@value='Back']
