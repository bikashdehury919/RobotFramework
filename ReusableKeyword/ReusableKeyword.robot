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

Open Browser and maximize window
    [Documentation]    Reusable keyword which will open the browser and maximize the window
    [Arguments]    ${URL}    ${Browser}
    open browser     ${URL}    ${Browser}
    maximize browser window


Capture Page Screenshot With Test Name
    [Documentation]    Reusable keyword which will save the sceenshot as ${TEST_NAME}_Screenshot_{index}.png
    [Arguments]    ${capture_prefix}=${TEST_NAME}
    Capture Page Screenshot    ${capture_prefix}_Screenshot_{index}.png

Wait untill locator Element is Visible
    [Arguments]    ${path}    ${timeout}=20s    ${retry_time}=40s    ${retry_interval}=5s
    [Documentation]    Keyword searches and click xpath element. Retry time and interval can be set also.
    Wait Until Element Is Visible    ${path}    ${timeout}

Check if element is present then input text
    [Arguments]    ${element}     ${value}
    [Documentation]    Keyword searches and input the text as ${value} identified by   ${element}
    ${IsElementVisible}=  Run Keyword And Return Status    Wait untill locator Element is Visible   ${element}
    Run Keyword If    ${IsElementVisible}    input text    ${element}    ${value}
...    ELSE
...    Fail    the screen has changed

Clear Text Field
  [Arguments]  ${inputField}
  press keys  ${inputField}  CTRL+a+BACKSPACE

Check if element is present then clear text
    [Arguments]    ${element}
    [Documentation]    Keyword searches and clear the element text identified by   ${element}
    ${IsElementVisible}=  Run Keyword And Return Status    Wait untill locator Element is Visible   ${element}
    Run Keyword If    ${IsElementVisible}    Clear Text Field    ${element}

Check if element is present then click element
    [Arguments]    ${element}
    ${IsElementVisible}=  Run Keyword And Return Status    Wait untill locator Element is Visible   ${element}
    Run Keyword If    ${IsElementVisible}    click element    ${element}

Get text and verify with input value
    [Arguments]    ${locator}    ${textvalue}
    ${value}=    get text    ${locator}
    should be equal as strings    ${value}     ${textvalue}


Clear text from Input filed and put new input
    [Arguments]    ${locator}    ${textvalue}
    Check if element is present then clear text    ${locator}
    check if element is present then input text    ${locator}    ${textvalue}

Closes the Current Browser
    close browser
