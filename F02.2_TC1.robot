*** Settings ***
Library             SeleniumLibrary
Suite Setup         SeleniumLibrary.Open Browser    https://reg.up.ac.th/app/main    Chrome
Suite Teardown      SeleniumLibrary.Close Browser

*** Variables ***
${EMAIL}            67023031@up.ac.th
${PASSWORD}         Focus_1649
${sub_id}           2568_2_18420
${grade_value}      B

*** Keywords ***
Check Open REG   #pass
    Wait Until Page Contains          ระบบบริการการศึกษา      timeout=10s
Accept Cookies   #pass
    ${btn_accept}=    Set Variable    xpath://button[contains(text(), 'ยอมรับ')]
    Wait Until Element Is Visible     ${btn_accept}    timeout=5s
    Click Element                     ${btn_accept}
    Sleep    1s
Click Avatar
    Wait Until Element Is Visible    css:.header-wrapicon2 .js-show-header-dropdown img    timeout=10s
    Click Element 	                 css:.header-wrapicon2 .js-show-header-dropdown img
Go to Login     
    Click Avatar
    Wait Until Page Contains         หากพบปัญหาการเข้าสู่ระบบ                                 timeout=10s
    Execute Javascript               document.querySelector('a.btn-grad').click()
Input Username
    Wait Until Element Is Visible    id:i0116                                   timeout=10s
    input text                       id:i0116               ${EMAIL}            
    Click Element                    id:idSIButton9
Input Password
    Wait Until Element Is Visible    id:i0118                                   timeout=10s
    input text                       id:i0118               ${PASSWORD}         
    Click Element                    id:idSIButton9
    Wait Until Page Contains         อนุมัติคำขอลงชื่อเข้าใช้                         timeout=10s 
Office 365 Login
    Input Username
    Input Password
    Wait Until Page Contains         ลงชื่อเข้าใช้ค้างไว้หรือไม่                        timeout=10s
    Click Element                    id:idSIButton9
    Wait Until Page Contains         ระบบบริการการศึกษา                           timeout=10s

Reg Login
    Maximize Browser Window
    Check Open REG
    Accept Cookies
    Go to Login
    Office 365 Login

Go to main
    Click Avatar
    Wait Until Page Contains         เลือกแอปพลิเคชัน                             timeout=10s
    Execute Javascript    document.evaluate('//div[contains(@class, "list-app-link") and contains(text(), "ระบบทะเบียนออนไลน์")]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    Wait Until Element Is Visible    id:ui-id-1
Go to simulate
    Execute Javascript    document.querySelector("a.sf-with-ul[onclick*='ประมวลผลการศึกษา']").click()
    Execute Javascript    document.querySelector("a[onclick*='simulate_grade']").click()
    Wait Until Element Is Visible    id:ui-id-2
Choose Grade
    Wait Until Element Is Visible    name:${sub_id}    timeout=15s
    Select From List By Value        name:${sub_id}    ${grade_value}
    List Selection Should Be         name:${sub_id}    ${grade_value}
*** Test Cases ***
Test Choose Grade
    Reg Login
    Go to main
    Go to simulate
    Choose Grade
    Capture Page Screenshot         Choose_grade.png 
#python -m robot F02.2_TC1.robot  