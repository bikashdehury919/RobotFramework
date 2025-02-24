*** Settings ***
Documentation    Reusable keywords for UI login tests
Library          SeleniumLibrary
Resource         ../PageObjects/PageObject.robot
Library         DateTime

*** Keywords ***
Input Username
    [Arguments]    ${username}
    Input Text    ${USERNAME_INPUT}    ${username}
    Log    Entering username: ${username}    INFO

Input Password
    [Arguments]    ${password}
    Input Text    ${PASSWORD_INPUT}    ${password}
    Log    Entering password: ${password}    INFO

Click Login Button
    Click Element    ${LOGIN_BUTTON}
    Log    Clicking login button    INFO

Verify Login Success
    Wait Until Element Is Visible    ${DASHBOARD_LINK}    10s
    Log    Verifying successful login    INFO
    Element Should Be Visible    ${DASHBOARD_LINK}

Verify Login Failure
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    10s
    Log    Verifying login failure    INFO
    Element Should Be Visible    ${ERROR_MESSAGE}

Capture Page Screenshot
    [Documentation]    Reusable keyword which will save the sceenshot as ${TEST_NAME}_Screenshot_{index}.png
    [Arguments]    ${capture_prefix}=${TEST_NAME}
    Capture Page Screenshot    ${capture_prefix}_Screenshot_{index}.png


