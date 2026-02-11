*** Settings ***
Library             SeleniumLibrary
Suite Setup         Open Browser    https://reg.up.ac.th/app/main    Chrome
Suite Teardown      Close Browser

*** Variables ***
${EMAIL}            67023031@up.ac.th
${PASSWORD}         รหัสผ่านของคุณ
${grade_value}      B
${sub_id}           2568_2_22269

*** Keywords ***
Handle Cookie
    Run Keyword And Ignore Error    Wait Until Element Is Visible    xpath=//a[contains(text(),'ยอมรับ')]    5s
    Run Keyword And Ignore Error    Click Element                    xpath=//a[contains(text(),'ยอมรับ')]

Login Via Office 365
    Maximize Browser Window
    Wait Until Element Is Visible    class:js-show-header-dropdown    10s
    SapGuiLibrary.Click Element 	 elementid
    Click Element                    class:js-show-header-dropdown
    Wait Until Element Is Visible    xpath://a[contains(@href, 'loginoffice365')]    10s
    Execute Javascript               document.querySelector('a[href*="loginoffice365"]').click()
    
    # 1. หากพบหน้า "ลงชื่อเข้าใช้" ให้กรอกอีเมลก่อน (ตรวจสอบจาก id:i0116 ในหน้า Microsoft)
    ${is_email_page}=    Run Keyword And Return Status    Wait Until Element Is Visible    id:i0116    5s
    IF    ${is_email_page}
        Input Text       id:i0116    ${EMAIL}
        Click Element    id:idSIButton9
        Sleep            2s
    END

    # 2. เลือกบัญชี (ใช้ XPath ที่เจาะจงกับ data-test-id ของอีเมลคุณ)
    Wait Until Element Is Visible    xpath://div[@data-test-id="${EMAIL}"]    15s
    Click Element                    xpath://div[@data-test-id="${EMAIL}"]
    
    # 3. ใส่รหัสผ่าน (ใช้ id:i0118 ตามที่ปรากฏในเครื่องมือตรวจเช็คของคุณ)
    Wait Until Element Is Visible    id:i0118    15s
    Input Password                   id:i0118    ${PASSWORD}
    Click Element                    id:idSIButton9
    
    # รอจนกลับเข้าสู่หน้าหลักของระบบ
    Wait Until Page Contains         ออกจากระบบ    20s

Click ประมวลผลการศึกษา 
    Wait Until Element Is Visible    xpath=//a[contains(@onclick, "menu_click('ประมวลผลการศึกษา')")]    15s
    Click Element                    xpath=//a[contains(@onclick, "menu_click('ประมวลผลการศึกษา')")]

Choose simulate
    Wait Until Element Is Visible    xpath=//a[contains(@onclick, "student/simulate_grade")]    10s
    Click Element                    xpath=//a[contains(@onclick, "student/simulate_grade")]

Select Grade From Dropdown
    [Arguments]      ${sub_id}    ${grade_value}
    Wait Until Element Is Visible    name=${sub_id}    15s
    Select From List By Value        name=${sub_id}    ${grade_value}
    List Selection Should Be         name=${sub_id}    ${grade_value}

Click คำนวณเกรด
    Scroll Element Into View         xpath://span[text()='คำนวณเกรด']
    Wait Until Element Is Visible    xpath://span[text()='คำนวณเกรด']    10s
    Click Element                    xpath://span[text()='คำนวณเกรด']

*** Test Cases ***
Simulate Grade Process
    Login Via Office 365
    Click ประมวลผลการศึกษา
    Choose simulate
    Select Grade From Dropdown    ${sub_id}    ${grade_value}
    Click คำนวณเกรด
    
    Sleep    2s
    Capture Page Screenshot       final_result.png

#python -m robot testRF02.robot