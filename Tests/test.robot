*** Settings ***

Library           ../CustomLibraries/CustomLibrary.py

*** Variables ***
${inputpath}    ./Resource/system_input_file.1630412935.txt
${outputpath}    ./Resource/system_ouput_file.1630412935.txt

*** Test Cases ***
TC01
    ${rectangle}  ${points}   Parse The Input Text File     ${inputpath}
    ${actual_points}          Parse The Output Text File    ${outputpath}
    ${results}                Validate Points    ${points}  ${actual_points}  ${rectangle}
    Log    ${results}
    Log Result to Text File   ${results}  ${TEST_NAME}
