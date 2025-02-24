*** Settings ***
Documentation    Locators for the Login Page
Library          SeleniumLibrary

*** Variables ***
${USERNAME_INPUT}    //input[@id='j_username']    # Using XPath for consistency
${PASSWORD_INPUT}    //input[@id='j_password']    # Using XPath for consistency
${LOGIN_BUTTON}      //button[@name='Submit']     # Using XPath
${DASHBOARD_LINK}    //a[normalize-space()='Dashboard']
${ERROR_MESSAGE}     .error-message              # CSS selector