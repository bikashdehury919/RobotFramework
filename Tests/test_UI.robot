*** Settings ***
Documentation    UI Login Test Scenarios using Selenium
Library          SeleniumLibrary
Library          Collections
Library          OperatingSystem
Library          DateTime
Library          BuiltIn
Test Setup       Setup Browser For Login
Test Teardown    Teardown Browser
Resource         ../ReusableKeyword/UI_keywords.robot
Resource         ../ReusableKeyword/ReusableKeyword.robot

*** Variables ***
${CONFIG_PATH}     configuration/config.yaml
${LOGIN_URL}       ${EMPTY}
${BROWSER}         ${EMPTY}
${HEADLESS}        ${EMPTY}
${INCOGNITO}       ${EMPTY}

*** Test Cases ***
Valid Login
    [Documentation]    Login using valid credentials and verify dashboard is visible
    ${config}=    Get Config Data    ${CONFIG_PATH}
    Input Username    ${config['credentials']['valid']['username']}
    Input Password    ${config['credentials']['valid']['password']}
    Click Login Button
    Verify Login Success

Invalid Login
    [Documentation]    Attempt login with invalid credentials and verify error message
    ${config}=    Get Config Data    ${CONFIG_PATH}
    Input Username    ${config['credentials']['invalid']['username']}
    Input Password    ${config['credentials']['invalid']['password']}
    Click Login Button
    Verify Login Failure

Empty Credentials Login
    [Documentation]    Attempt login with empty credentials and expect failure
    ${config}=    Get Config Data    ${CONFIG_PATH}
    Input Username    ${config['credentials']['empty']['username']}
    Input Password    ${config['credentials']['empty']['password']}
    Click Login Button
    Verify Login Failure

*** Keywords ***
Setup Browser For Login
    [Documentation]    Loads config, opens browser with headless/incognito if set
    ${config}=    Get Config Data    ${CONFIG_PATH}
    Set Global Variable    ${LOGIN_URL}     ${config['urls']['login_url']}
    Set Global Variable    ${BROWSER}       ${config['browser']['name']}
    Set Global Variable    ${HEADLESS}      ${config['browser']['headless']}
    Set Global Variable    ${INCOGNITO}     ${config['browser']['incognito']}
    Open Browser To Login Page   ${LOGIN_URL}    ${BROWSER}    ${HEADLESS}    ${INCOGNITO}

Teardown Browser
    Run Keyword And Ignore Error    Capture Page Screenshot On Failure
    Close All Browsers

Capture Page Screenshot On Failure
    [Documentation]    Captures screenshot if test fails
    Run Keyword If    '${TEST STATUS}' == 'FAIL'    Capture Page Screenshot    ${TEST NAME}_Failure.png
