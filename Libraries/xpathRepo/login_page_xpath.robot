*** Settings ***
Documentation    Login page object reference document

*** Variables ***

${login_username_loc}   //input[@class='length-medium'][@name='userId']
${login_password_loc}   //input[@class='length-medium'][@name='password']
${login_submit_loc}     //input[@class='default right']