*** Settings ***
Documentation     Fetch DB Details from OBS DB
Library           DatabaseLibrary
Library           OperatingSystem
#Suite Setup       Connect to Database         pymysql       ${DBName}        ${DBUser}       ${DBPass}      ${DBHost}      ${Port}
#Suite Teardown    Disconnect From Database


*** Variables ***
${DB_CONNECT_STRING}     ${DBName}        ${DBUser}       ${DBPass}      ${DBHost}      ${Port}
${SQL_Query}    Select * from OBS_OSM
${DBName}          XYZ_TEST
${DBUser}          XYZ_TEST_user
${DBPass}          3BtkZ4hdjhhfNXeVXc5j4G
${DBHost}          12.136.178.154
${Port}            3306



*** Test Cases ***
TC_001 Get Data From XYZ DB
    [Documentation]  Connection established with xyz database and get data from datbase
    [Tags]    Sanity
    Connect To DB
    ${queryResults}=    Run Query and log results    ${SQL_Query}
    log    ${queryResults}
    log to console    ${queryResults}
    Should not Be Equal As Strings  ${queryResults}  None
    Disconnect From DB






*** Keywords ***
Connect To DB
    connect to database      pymysql    ${DBName}        ${DBUser}       ${DBPass}      ${DBHost}      ${Port}

Run Query and log results
    [Arguments]    ${QUERY_TO_EXECUTE}
    Set Global Variable    ${QUERY_TO_EXECUTE}
    ${queryResults}    Query    ${QUERY_TO_EXECUTE}
    [Return]    ${queryResults}

Disconnect From DB
    disconnect from database