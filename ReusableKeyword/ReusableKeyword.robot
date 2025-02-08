*** Settings ***
Documentation    Reusable keywords for test automation
Library          Collections
Library          String
Library          OperatingSystem
Library          BuiltIn

*** Keywords ***
Read Input File
    [Arguments]    ${file_path}
    ${data}    Get File    ${file_path}
    [Return]    ${data}

Parse Rectangle And Points
    [Arguments]    ${data}
    ${lines}    Split String    ${data}    \n
    ${rectangle}    Create List
    ${points}    Create List
    ${parsing_points}    Set Variable    ${False}

    FOR    ${line}    IN    @{lines}
        ${line}    Strip String    ${line}
        IF    '${line}' == 'Rectangle'
            CONTINUE
        ELSE IF    '${line}' == 'Points'
            ${parsing_points}    Set Variable    ${True}
            CONTINUE
        END
        ${numbers}    Get Regexp Matches    ${line}    [-+]?\\d*\\.?\\d+
        # Ensure parsing correctly into tuples
        IF    ${numbers}
            ${tuple}    Create List
            ${len_numbers}    Get Length    ${numbers}
            ${i}    Set Variable    0
            WHILE    ${i} < ${len_numbers}
                ${x}    Convert To Number    ${numbers}[${i}]
                ${j}     Evaluate     ${i}+1
                ${y}    Convert To Number    ${numbers}[${j} ]
                Append To List    ${tuple}    (${x}, ${y})
                ${i}    Evaluate    ${i} + 2  # Ensure `i` remains an integer
            END

           IF    ${parsing_points}
                Append To List    ${points}    @{tuple}
           ELSE
                Append To List    ${rectangle}    @{tuple}
           END
        END
    END
    [Return]    ${rectangle}    ${points}



Is Point Inside Rectangle
    [Arguments]    ${point}    ${rectangle}
    ${x_min}    Evaluate    min(${rectangle}[0][0], ${rectangle}[2][0])
    ${x_max}    Evaluate    max(${rectangle}[0][0], ${rectangle}[2][0])
    ${y_min}    Evaluate    min(${rectangle}[0][1], ${rectangle}[1][1])
    ${y_max}    Evaluate    max(${rectangle}[0][1], ${rectangle}[1][1])
    ${inside}    Run Keyword And Return Status    ${x_min} <= ${point}[0] <= ${x_max} and ${y_min} <= ${point}[1] <= ${y_max}
    Run Keyword If    ${inside} == False
    ...    Log    Error: Rectangle data is incomplete. Cannot check point boundaries.
    [Return]    ${inside}

Log To File
    [Arguments]    ${message}
    Append To File    .Reports/test_results_${test_name}.txt    ${message}\n
