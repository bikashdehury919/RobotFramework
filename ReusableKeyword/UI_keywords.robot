*** Settings ***
Documentation     Reusable and advanced UI keywords for login and browser handling.
Library           SeleniumLibrary
Library           OperatingSystem
Library           DateTime
Library           Collections
Library           BuiltIn
Library           String
Resource          ../PageObjects/PageObject.robot

*** Variables ***
${DEFAULT_TIMEOUT}     10s
${RETRY_INTERVAL}      2s
${CAPTURE_DIR}         ./Screenshots

*** Keywords ***

Open Browser To Login Page
    [Arguments]    ${url}    ${browser}=chrome    ${headless}=False    ${incognito}=False
    [Documentation]    Opens browser with options like headless or incognito and navigates to login page.
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].${browser}.options.Options()    sys, selenium.webdriver
    Run Keyword If    '${headless}' == 'True'    Call Method    ${options}    add_argument    --headless
    Run Keyword If    '${incognito}' == 'True'   Call Method    ${options}    add_argument    --incognito
    Create Webdriver    ${browser}    options=${options}
    Go To    ${url}
    Maximize Browser Window
    Set Selenium Speed    0.3s
    Log    Browser opened at ${url} with browser: ${browser}    INFO

Input Username
    [Arguments]    ${username}    ${timeout}=${DEFAULT_TIMEOUT}
    [Documentation]    Inputs the given username into the username field.
    Wait Until Element Is Visible    ${USERNAME_INPUT}    ${timeout}
    Input Text    ${USERNAME_INPUT}    ${username}
    Log    Entered username: ${username}

Input Password
    [Arguments]    ${password}    ${timeout}=${DEFAULT_TIMEOUT}
    [Documentation]    Inputs the given password into the password field.
    Wait Until Element Is Visible    ${PASSWORD_INPUT}    ${timeout}
    Input Text    ${PASSWORD_INPUT}    ${password}
    Log    Entered password: *********

Click Login Button
    [Arguments]    ${timeout}=${DEFAULT_TIMEOUT}
    [Documentation]    Waits until login button is enabled and clicks it.
    Wait Until Element Is Enabled    ${LOGIN_BUTTON}    ${timeout}
    Click Button    ${LOGIN_BUTTON}
    Log    Clicked on Login Button.

Verify Login Success
    [Arguments]    ${timeout}=${DEFAULT_TIMEOUT}
    [Documentation]    Verifies that user is redirected to dashboard after successful login.
    Wait Until Page Contains Element    ${DASHBOARD_LINK}    ${timeout}
    Element Should Be Visible    ${DASHBOARD_LINK}
    Log    Successfully navigated to Dashboard page.

Verify Login Failure
    [Arguments]    ${timeout}=${DEFAULT_TIMEOUT}
    [Documentation]    Verifies that error message is shown on login failure.
    Wait Until Page Contains Element    ${ERROR_MESSAGE}    ${timeout}
    Element Should Be Visible    ${ERROR_MESSAGE}
    Log    Login failed as expected. Error message is visible.

Close Browser On Failure
    [Documentation]    If test fails, this keyword captures a screenshot and closes the browser.
    Run Keyword If Test Failed
    ...    Capture Screenshot With Timestamp
    Close Browser

Capture Screenshot With Timestamp
    [Documentation]    Captures a screenshot with timestamp and test name, stored in Screenshots folder.
    ${timestamp}=    Get Time    format=%Y%m%d_%H%M%S
    ${name}=    Replace String    ${TEST NAME}    ${SPACE}    _
    ${filename}=    Set Variable    ${CAPTURE_DIR}/${name}_${timestamp}.png
    Create Directory    ${CAPTURE_DIR}
    Capture Page Screenshot    ${filename}
    Log    Screenshot saved: ${filename}

Login With Credentials
    [Arguments]    ${username}    ${password}
    [Documentation]    Wrapper keyword to perform login steps using given credentials.
    Input Username    ${username}
    Input Password    ${password}
    Click Login Button