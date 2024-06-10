*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# URLs
${HOMEPAGE_URL}    https://bwpool.azurewebsites.net/

# Locators
${HOME_PAGE_CONTENT_HEADER}    //h4[.='Munka naptár']
${PARTNERS_MENU_TAB}    //a[contains(.,'Partnerek')]
${PARTNERS_PAGE_GRID}    //h4[text()='Ügyfelek']/following-sibling::div[@id='Grid']

# Other Variables
${BROWSER}    Chrome
${HOME_PAGE_TITLE}    BWP Index

*** Keywords ***
Open Browser And Navigate To Home Page
    Open Browser    ${HOMEPAGE_URL}    ${BROWSER}
    Maximize Browser Window

Verify Application Opens
    ${current_url}    Get Location
    Should Be Equal As Strings    ${current_url}    ${HOME_PAGE_URL}
    Title Should Be    ${HOME_PAGE_TITLE}
    Page Should Contain Element   ${HOME_PAGE_CONTENT_HEADER}

Click On A Specific Menu Tab And Verify Content Grid
    [Arguments]    ${menu_tab_locator}    ${grid_title_locator}
    Click Element    ${menu_tab_locator}
    Wait Until Element Is Visible    ${grid_title_locator}

Test Teardown
    Close All Browsers