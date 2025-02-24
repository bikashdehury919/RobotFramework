*** Settings ***
Documentation    Reusable keywords for API tests
Library          RequestsLibrary
Library          Collections

*** Keywords ***
Log Response
    [Arguments]    ${response}    ${endpoint}
    Log    ${endpoint} Response: ${response.json()}    INFO