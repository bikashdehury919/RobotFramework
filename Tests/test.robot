*** Settings ***
Documentation    Test cases for Robot Framework automation

Library    SeleniumLibrary
Library           ../CustomLibraries/CustomLibrary.py
Resource          ../Configuration/Config.robot


*** Test Cases ***
TC01_Verify Points Are Inside Rectangle
    [Documentation]     Validate if points are correctly within the rectangle
    ${rectangle}  ${points}   Parse The Input Text File     ${input_path}
    ${actual_points}          Parse The Output Text File    ${output_path}
    ${results}                Validate Points    ${points}  ${actual_points}  ${rectangle}
    Log    ${results}
    Log Result to Text File   ${results}  ${TEST_NAME}