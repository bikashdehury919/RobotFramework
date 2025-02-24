*** Settings ***
Documentation    API Test Scenarios using Requests
Library          RequestsLibrary
Library          Collections
Library          OperatingSystem
Suite Setup      Create Session For API
Suite Teardown   Delete All Sessions
Resource         ../ReusableKeyword/api_keywords.robot

*** Variables ***
${CONFIG_PATH}    configuration/config.yaml
${API_BASE_URL}    ${EMPTY}
${CAT_FACTS_URL}    ${EMPTY}

*** Test Cases ***

Get Cat Facts
    [Documentation]    Test fetching cat facts from a public API using Requests
    ${config}=    Get Config Data    ${CONFIG_PATH}
    Set Test Variable    ${CAT_FACTS_URL}    ${config['public_apis']['cat_facts']}
    ${response}=    Get Request    /facts
    Status Should Be    200    ${response}
    Should Be List    ${response.json()}
    Length Should Be Greater Than    ${response.json()}    0
    Dictionary Should Contain Key    ${response.json()[0]}    text
    ${sample_fact}=    Set Variable    ${response.json()[0]['text']}
    Log    Sample Cat Fact: ${sample_fact}    INFO

*** Keywords ***
Create Session For API
    Create Session    api    ${API_BASE_URL}
    Create Session    public    ${CAT_FACTS_URL}

Delete All Sessions
    Delete All Sessions

Get Config Data
    [Arguments]    ${path}
    ${content}=    Get File    ${path}
    ${config}=    Evaluate    yaml.safe_load($content)    yaml
    [Return]    ${config}

Post Request
    [Arguments]    ${endpoint}    ${credentials}
    ${data}=    Create Dictionary    username=${credentials['username']}    password=${credentials['password']}
    ${response}=    POST On Session    api    ${endpoint}    json=${data}
    Log    POST ${endpoint} Response: ${response.json()}    INFO
    [Return]    ${response}

Get Request
    [Arguments]    ${endpoint}
    ${response}=    GET On Session    public    ${endpoint}
    Log    GET ${endpoint} Response: ${response.json()}    INFO
    [Return]    ${response}

Get Request With Token
    [Arguments]    ${endpoint}    ${token}
    ${headers}=    Create Dictionary    Authorization=Bearer ${token}
    ${response}=    GET On Session    api    ${endpoint}    headers=${headers}
    Log    GET ${endpoint} Response: ${response.json()}    INFO
    [Return]    ${response}

Get Token From Valid Login
    ${config}=    Get Config Data    ${CONFIG_PATH}
    ${response}=    Post Request    login    ${config['credentials']['valid']}
    ${token}=    Get From Dictionary    ${response.json()}    token
    [Return]    ${token}