*** Settings ***
Library    SeleniumLibrary
Library    String
# Library  RequestsLibrary

*** Variables ***
# URLs
${HOMEPAGE_URL}    https://bwpool.azurewebsites.net/

# Locators
${HOME_PAGE_CONTENT_HEADER}    //h4[.='Munka naptár']

${CUSTOMERS_MENU_TAB}    //a[@href="Customer"]
${CUSTOMERS_PAGE_GRID}    //h4[text()='Ügyfelek']/following-sibling::div[@id='Grid']
${CUSTOMERS_HEADER}    //h4[.='Ügyfelek']
${CUSTOMER_NAME_INPUT}    //input[@id='name']
${CUSTOMER_EMAIL_INPUT}    //input[@id='email']
${CUSTOMER_PHONE_NUMBER_INPUT}    //input[@placeholder='+36 xxxxxxxxx']
${CUSTOMER_NOTE_INPUT}    //input[@id='comment']

${GRID_TABLE_FIRST_ROW_FIRST_COLUMN}    //table[@id="Grid_content_table"]//tr[1]/td[2]
${GRID_TABLE_FIRST_ROW_SECOND_COLUMN}    //table[@id="Grid_content_table"]//tr[1]/td[3]
${GRID_TABLE_FIRST_ROW_THIRD_COLUMN}    //table[@id="Grid_content_table"]//tr[1]/td[4]
${GRID_TABLE_FIRST_ROW_FOURTH_COLUMN}    //table[@id="Grid_content_table"]//tr[1]/td[5]

${ADD_NEW_ELEMENT}    //div[@id='Grid_add']/button
${SAVE_BUTTON}    //button[text()='Save']
${SIDE_BAR}    //div[@class='sidebar']

${LOCATIONS_MENU_TAB}    //a[@href="Location"]
${LOCATIONS_PAGE_GRID}    //h4[text()='Telephelyek']/following-sibling::div[@id='Grid']
${LOCATION_HEADER}    //h4[.='Telephelyek']

${LOCATION_CUSTOMER_INPUT}    //input[@placeholder='Ügyfél']
${LOCATION_CITY_INPUT}    //input[@id='varos']
${LOCATION_ZIP_CODE_INPUT}    //input[@id='zip']
${LOCATION_STREET_NAME_INPUT}    //input[@id='utca']
${LOCATION_HOUSE_NUMBER_INPUT}    //input[@id='szam']


# Other Variables
${BROWSER}    Chrome
${HOME_PAGE_TITLE}    BWP Index

${PROXY}  http://idebproxy01.itsh.itsh-internal.hu:3128
${RANDOM_DATA_URL}  https://random-data-api.com/api/users/random_user

*** Keywords ***
Open Browser And Navigate To Home Page
    Open Browser    ${HOMEPAGE_URL}    ${BROWSER}
    Maximize Browser Window

Verify Application Opens
    ${current_url}    Get Location
    Should Be Equal As Strings    ${current_url}    ${HOME_PAGE_URL}
    Title Should Be    ${HOME_PAGE_TITLE}

Click On A Menu Tab
    [Arguments]    ${menu_tab_locator}
    Wait Until Element Is Enabled    ${menu_tab_locator}
    Click Link    ${menu_tab_locator}

Verify Page Content
    [Arguments]    ${page_title}    ${grid_title_locator}
    Wait Until Page Contains Element    ${page_title}
    Page Should Contain Element    ${grid_title_locator}

Add New Customer
    [Arguments]    ${full_name}    ${email}    ${phone_number}    ${id}

    Wait Until Element Is Enabled    ${ADD_NEW_ELEMENT}
    Click Button   ${ADD_NEW_ELEMENT}
    Wait Until Element Is Visible    ${CUSTOMER_EMAIL_INPUT}

    Input Text    ${CUSTOMER_NAME_INPUT}    ${full_name}
    ${full_name_value}=    Get Element Attribute    ${CUSTOMER_NAME_INPUT}    value
    Should Be Equal As Strings    ${full_name_value}    ${full_name}

    Input Text    ${CUSTOMER_EMAIL_INPUT}    ${email}
    ${email_value}=    Get Element Attribute    ${CUSTOMER_EMAIL_INPUT}    value
    Should Be Equal As Strings    ${email_value}    ${email}

    Input Text    ${CUSTOMER_PHONE_NUMBER_INPUT}    ${phone_number}
    ${phone_number}=    Get Element Attribute    ${CUSTOMER_PHONE_NUMBER_INPUT}    value
    Should Be Equal As Strings    ${phone_number}    ${EMPTY}

    Input Text    ${CUSTOMER_NOTE_INPUT}    ${id}
    ${note_value}=    Get Element Attribute    ${CUSTOMER_NOTE_INPUT}    value
    Should Be Equal As Strings    ${note_value}    ${id}

Save Form
    Click Button    ${SAVE_BUTTON}
    
Verify Added Customer
    [Arguments]    ${full_name}    ${email}    ${phone_number}    ${id}

    Wait Until Element Is Not Visible    ${SAVE_BUTTON}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FIRST_COLUMN}    ${full_name}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_SECOND_COLUMN}    ${email}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_THIRD_COLUMN}    ${EMPTY}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FOURTH_COLUMN}    ${id}

Add New Location
    [Arguments]    ${customer}    ${city}    ${zip_code}    ${street_name}    ${house_number} 

    Wait Until Element Is Enabled    ${ADD_NEW_ELEMENT}
    Click Button   ${ADD_NEW_ELEMENT}
    Wait Until Element Is Visible    ${LOCATION_CUSTOMER_INPUT}

    Input Text    ${LOCATION_CUSTOMER_INPUT}    ${customer}
    Wait Until Element Is Visible    //li[contains(text(), '${customer}')]
    Click Element    //li[contains(text(), '${customer}')]

    Input Text    ${LOCATION_CITY_INPUT}    ${city}
    ${city_value}=    Get Element Attribute    ${LOCATION_CITY_INPUT}    value
    Should Be Equal As Strings    ${city_value}    ${city}

    Input Text    ${LOCATION_ZIP_CODE_INPUT}    ${zip_code}
    ${zip_code_value}=    Get Element Attribute    ${LOCATION_ZIP_CODE_INPUT}    value
    ${zip_code_without_hyphens}=    Replace String    ${zip_code}    -    ${EMPTY}
    Should Be Equal As Strings    ${zip_code_value}    ${zip_code_without_hyphens}

    Input Text    ${LOCATION_STREET_NAME_INPUT}    ${street_name}
    ${street_name_value}=    Get Element Attribute    ${LOCATION_STREET_NAME_INPUT}    value
    Should Be Equal As Strings    ${street_name_value}    ${street_name}

    Input Text    ${LOCATION_HOUSE_NUMBER_INPUT}    ${house_number}
    ${house_number_value}=    Get Element Attribute    ${LOCATION_HOUSE_NUMBER_INPUT}    value
    Should Be Equal As Strings    ${house_number_value}    ${house_number}

Verify Added Location
    [Arguments]    ${customer}    ${city}    ${zip_code}    ${street_name}    ${house_number}

    Wait Until Element Is Not Visible    ${SAVE_BUTTON}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FIRST_COLUMN}    ${customer}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_SECOND_COLUMN}    ${city}
    ${zip_code_without_hyphens}=    Replace String    ${zip_code}    -    ${EMPTY}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_THIRD_COLUMN}    ${zip_code_without_hyphens}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_THIRD_COLUMN}    ${house_number}

Test Teardown
    Close All Browsers