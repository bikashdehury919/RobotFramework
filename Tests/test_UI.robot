*** Settings ***
Documentation    UI Login Test Scenarios using Selenium
Library          SeleniumLibrary
Library          Collections
Library          OperatingSystem
Library          DateTime
Test Setup      Open Browser And Navigate To Login
Test Teardown   Close All Browsers
Resource         ../ReusableKeyword/login_keywords.robot

*** Variables ***
${CONFIG_PATH}    configuration/config.yaml
${BROWSER}        Chrome    # Default to Chrome; can be changed to Firefox, Edge, etc.
${HEADLESS}       ${FALSE}
${LOGIN_URL}      ${EMPTY}

*** Test Cases ***
Valid Login
    [Documentation]    Test login with valid credentials
    ${config}=    Get Config Data    ${CONFIG_PATH}
    Set Test Variable    ${LOGIN_URL}    ${config['urls']['login_url']}
    Input Username    ${config['credentials']['valid']['username']}
    Input Password    ${config['credentials']['valid']['password']}
    Click Login Button
    Verify Login Success

Invalid Login
    [Documentation]    Test login with invalid credentials
    ${config}=    Get Config Data    ${CONFIG_PATH}
    Set Test Variable    ${LOGIN_URL}    ${config['urls']['login_url']}
    Input Username    ${config['credentials']['invalid']['username']}
    Input Password    ${config['credentials']['invalid']['password']}
    Click Login Button
    Verify Login Failure

Empty Credentials Login
    [Documentation]    Test login with empty credentials
    ${config}=    Get Config Data    ${CONFIG_PATH}
    Set Test Variable    ${LOGIN_URL}    ${config['urls']['login_url']}
    Input Username    ${config['credentials']['empty']['username']}
    Input Password    ${config['credentials']['empty']['password']}
    Click Login Button
    Verify Login Failure

*** Keywords ***
Open Browser And Navigate To Login
    ${config}=    Get Config Data    ${CONFIG_PATH}
    ${options}=    Run Keyword If    ${HEADLESS}    Set Variable    headless=True    ELSE    Set Variable    headless=False
    Open Browser    ${config['urls']['login_url']}    ${BROWSER}    options=${options}
    Log    Browser opened successfully at ${config['urls']['login_url']}    INFO
    Maximize Browser Window

Close All Browsers
    Close Browser

Capture Page Screenshot On Failure
    Run Keyword If Test Failed    Capture Page Screenshot

Get Config Data
    [Arguments]    ${path}
    ${content}=    Get File    ${path}
    ${config}=    Evaluate    yaml.safe_load($content)    yaml
    [Return]    ${config}