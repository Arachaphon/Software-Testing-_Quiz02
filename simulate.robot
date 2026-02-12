*** Settings ***
Library             SeleniumLibrary
Suite Setup         SeleniumLibrary.Open Browser    https://reg.up.ac.th/    Chrome
Suite Teardown      SeleniumLibrary.Close Browser

*** Variables ***
${EMAIL}            67023031@up.ac.th
${PASSWORD}         Focus_1649
${sub_id}           2568_2_22269
${grade_value}      B

*** Keywords ***
Handle Cookie
    # ตรวจสอบและกดปุ่ม 'ยอมรับ' คุกกี้หากปรากฏขึ้น
    Run Keyword And Ignore Error    SeleniumLibrary.Wait Until Element Is Visible    xpath://button[contains(text(),'ยอมรับ')]    5s
    Run Keyword And Ignore Error    SeleniumLibrary.Click Element                    xpath://button[contains(text(),'ยอมรับ')]

Login Via Office 365
    SeleniumLibrary.Maximize Browser Window
    Handle Cookie
    
    # คลิกไอคอน User มุมขวาบน
    SeleniumLibrary.Wait Until Element Is Visible    class:js-show-header-dropdown    10s
    SeleniumLibrary.Click Element                    class:js-show-header-dropdown
    
    # คลิกปุ่ม 'เข้าสู่ระบบด้วย UP Account'
    SeleniumLibrary.Wait Until Element Is Visible    xpath://a[contains(@href, 'loginoffice365')]    10s
    SeleniumLibrary.Execute Javascript               document.querySelector('a[href*="loginoffice365"]').click()
    
    # --- จัดการ Microsoft Login ---
    # หากอยู่หน้า 'ลงชื่อเข้าใช้' ให้กรอกอีเมล
    ${is_signin_page}=    Run Keyword And Return Status    SeleniumLibrary.Wait Until Element Is Visible    id:i0116    5s
    IF    ${is_signin_page}
        SeleniumLibrary.Input Text       id:i0116    ${EMAIL}
        SeleniumLibrary.Click Element    id:idSIButton9
        Sleep    2s
    END

    # เลือกบัญชีของคุณ
    SeleniumLibrary.Wait Until Element Is Visible    xpath://div[contains(text(), '${EMAIL}')]    15s
    SeleniumLibrary.Click Element                    xpath://div[contains(text(), '${EMAIL}')]
    
    # ใส่รหัสผ่านโดยใช้ id:i0118 ตามที่ปรากฏใน Inspector
    SeleniumLibrary.Wait Until Element Is Visible    id:i0118    15s
    SeleniumLibrary.Input Password                   id:i0118    ${PASSWORD}
    SeleniumLibrary.Click Element                    id:idSIButton9
    
    # หน้า 'Stay signed in?' (ลงชื่อเข้าใช้ค้างไว้หรือไม่) ให้กด 'ใช่'
    Run Keyword And Ignore Error    SeleniumLibrary.Wait Until Element Is Visible    id:idSIButton9    5s
    Run Keyword And Ignore Error    SeleniumLibrary.Click Element                    id:idSIButton9

    # ยืนยันว่ากลับมาหน้าหลักสำเร็จ
    SeleniumLibrary.Wait Until Page Contains    ออกจากระบบ    20s

Go to Homepage
    # คลิกปุ่มโปรไฟล์หน้าหลัก
    SeleniumLibrary.Click Element    css:.btn-login.js-show-header-dropdown

Select Grade From Dropdown
    [Arguments]      ${sub_id}    ${grade_value}
    # เลือกเกรดจาก name: 2568_2_22269
    SeleniumLibrary.Wait Until Element Is Visible    name:${sub_id}    15s
    SeleniumLibrary.Select From List By Value        name:${sub_id}    ${grade_value}
    # เช็คเกรดตรงนี้เพื่อให้แน่ใจว่าเลือกสำเร็จ
    SeleniumLibrary.List Selection Should Be         name:${sub_id}    ${grade_value}

Click คำนวณเกรด
    # ค้นหาปุ่มจาก span 'คำนวณเกรด'
    SeleniumLibrary.Scroll Element Into View         xpath://span[text()='คำนวณเกรด']
    SeleniumLibrary.Wait Until Element Is Visible    xpath://span[text()='คำนวณเกรด']    10s
    SeleniumLibrary.Click Element                    xpath://span[text()='คำนวณเกรด']

*** Test Cases ***
Simulate Grade Process
    Login Via Office 365
    Go to Homepage
    Select Grade From Dropdown
    Click คำนวณเกรด
    Sleep    2s
    SeleniumLibrary.Capture Page Screenshot    final_result.png
#python -m robot simulate.robot