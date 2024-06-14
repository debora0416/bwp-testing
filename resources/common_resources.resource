*** Settings ***
Library    SeleniumLibrary
Library    String
Library    OperatingSystem
# Library  RequestsLibrary

*** Variables ***
# URLs
${HOMEPAGE_URL}    https://bwpool.azurewebsites.net/
${PROXY}  http://idebproxy01.itsh.itsh-internal.hu:3128
${RANDOM_USER_DATA_URL}  https://random-data-api.com/api/users/random_user
${RANDOM_DEVICE_DATA_URL}  https://random-data-api.com/api/device/random_device

# Locators
${CUSTOMERS_MENU_TAB}    //a[@href="Customer"]
${CUSTOMERS_PAGE_GRID}    //h4[text()='Ügyfelek']/following-sibling::div[@id='Grid']
${CUSTOMERS_HEADER}    //h4[.='Ügyfelek']
${CUSTOMER_NAME_INPUT}    //input[@id='name']
${CUSTOMER_EMAIL_INPUT}    //input[@id='email']
${CUSTOMER_PHONE_NUMBER_INPUT}    //input[@placeholder='+36 xxxxxxxxx']
${CUSTOMER_COMMENT_INPUT}    //input[@id='comment']

${GRID_TABLE_FIRST_ROW_FIRST_COLUMN}    //table[@id="Grid_content_table"]//tr[1]/td[2]
${GRID_TABLE_FIRST_ROW_SECOND_COLUMN}    //table[@id="Grid_content_table"]//tr[1]/td[3]
${GRID_TABLE_FIRST_ROW_THIRD_COLUMN}    //table[@id="Grid_content_table"]//tr[1]/td[4]
${GRID_TABLE_FIRST_ROW_FOURTH_COLUMN}    //table[@id="Grid_content_table"]//tr[1]/td[5]
${GRID_TABLE_FIRST_ROW_FIFTH_COLUMN}    //table[@id="Grid_content_table"]//tr[1]/td[6]
${GRID_TABLE_FIRST_ROW_SIXTH_COLUMN}    //table[@id="Grid_content_table"]//tr[1]/td[7]

${ADD_NEW_ELEMENT}    //div[@id='Grid_add']/button
${ADD_NEW_ELEMENT_FORM}    //div[@id="Grid_dialogEdit_wrapper"]//form
${SAVE_BUTTON}    //button[text()='Save']
${SIDE_BAR}    //div[@class='sidebar']
${SEARCH_BOX_INPUT}    //input[@id='Grid_ToolbarSearchBox']
${SEARCH_BUTTON}    //div[@id='Grid_search']//span[@title='Search']

${LOCATIONS_MENU_TAB}    //a[@href="Location"]
${LOCATIONS_PAGE_GRID}    //h4[text()='Telephelyek']/following-sibling::div[@id='Grid']
${LOCATION_HEADER}    //h4[.='Telephelyek']
${LOCATION_AND_TOOL_CUSTOMER_INPUT}    //input[@placeholder='Ügyfél']
${LOCATION_CITY_INPUT}    //input[@id='varos']
${LOCATION_ZIP_CODE_INPUT}    //input[@id='zip']
${LOCATION_STREET_NAME_INPUT}    //input[@id='utca']
${LOCATION_HOUSE_NUMBER_INPUT}    //input[@id='szam']

${TOOLS_MENU_TAB}    //a[@href="Tool"]
${TOOLS_PAGE_GRID}    //h4[text()='Eszközök']/following-sibling::div[@id='Grid']
${TOOLS_HEADER}    //h4[.='Eszközök']
${TOOL_NAME_INPUT}    //input[@id='name']
${TOOL_LOCATION_INPUT}    //input[@placeholder='Telephely']
${TOOL_DESCRIPTION_INPUT}    //textarea[@id='Desc']
${TOOL_COMMENT_INPUT}    //textarea[@id='Comm']

${EXCEL_EXPORT_BUTTON}    //div[@title='Excel Export']//button
${LOCATION_INFO_CUSTOMER_NAME}    //table[@id="infoList_content_table"]//tr[1]/td[2]

${LOCATION_INFO_LOCATION_HEADER}    //h6[.='Telephely adatok']
${LOCATION_INFO_TOOLS_HEADER}    //h6[.='Eszközök']
${LOCATION_INFO_WORKS_HEADER}    //h6[.='Munkák']
${LOCATION_INFO_MAP_HEADER}    //h6[.='Térkép']


# Other Variables
${BROWSER}    Chrome
${HOME_PAGE_TITLE}    BWP Index

${DOWNLOAD_DIR}    ${CURDIR}/downloads
${EXCEL_FILENAME}  example.xlsx

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
    # Wait Until Element Is Enabled    ${menu_tab_locator}
    Sleep    2s
    Click Link    ${menu_tab_locator}

Verify Page Content
    [Arguments]    ${page_title}    ${grid_title_locator}
    Wait Until Page Contains Element    ${page_title}
    Page Should Contain Element    ${grid_title_locator}

Click On Add Button To Add New Element
    Wait Until Element Is Enabled    ${ADD_NEW_ELEMENT}
    Click Button   ${ADD_NEW_ELEMENT}
    Wait Until Element Is Visible    ${ADD_NEW_ELEMENT_FORM}

Add New Customer
    [Arguments]    ${body}

    ${full_name}    Set Variable    ${body}[0][first_name] ${body}[0][last_name]
    ${email}    Set Variable    ${body}[0][email]
    ${phone_number}    Set Variable    ${EMPTY}
    ${comment}    Set Variable    ${body}[0][id]

    Input Text    ${CUSTOMER_NAME_INPUT}    ${full_name}
    ${full_name_value}=    Get Element Attribute    ${CUSTOMER_NAME_INPUT}    value
    Should Be Equal As Strings    ${full_name_value}    ${full_name}

    Input Text    ${CUSTOMER_EMAIL_INPUT}    ${email}
    ${email_value}=    Get Element Attribute    ${CUSTOMER_EMAIL_INPUT}    value
    Should Be Equal As Strings    ${email_value}    ${email}

    Input Text    ${CUSTOMER_PHONE_NUMBER_INPUT}    ${phone_number}
    ${phone_number}=    Get Element Attribute    ${CUSTOMER_PHONE_NUMBER_INPUT}    value
    Should Be Equal As Strings    ${phone_number}    ${EMPTY}

    Input Text    ${CUSTOMER_COMMENT_INPUT}    ${comment}
    ${comment_value}=    Get Element Attribute    ${CUSTOMER_COMMENT_INPUT}    value
    Should Be Equal As Strings    ${comment_value}    ${comment}

    # ${fields}=    Create List    ${CUSTOMER_NAME_INPUT}    ${CUSTOMER_EMAIL_INPUT}    ${CUSTOMER_PHONE_NUMBER_INPUT}    ${CUSTOMER_COMMENT_INPUT}
    # ${values}=    Create List    ${full_name}    ${email}    ${phone_number}    ${id}
    # ${expected_values}=    Create List    ${full_name}    ${email}    ${EMPTY}    ${id}

    # FOR    ${index}    IN RANGE    0    ${len(${fields})}
    #     Input Text    ${fields}[${index}]    ${values}[${index}]
    #     ${actual_value}=    Get Element Attribute    ${fields}[${index}]    value
    #     Should Be Equal As Strings    ${actual_value}    ${expected_values}[${index}]
    # END

Save Form
    Click Button    ${SAVE_BUTTON}
    Wait Until Element Is Not Visible    ${SAVE_BUTTON}
    
Verify Added Customer
    [Arguments]    ${body}

    ${full_name}    Set Variable    ${body}[0][first_name] ${body}[0][last_name]
    ${email}    Set Variable    ${body}[0][email]
    ${phone_number}    Set Variable    ${EMPTY}
    ${comment}    Set Variable    ${body}[0][id]

    Sleep    3s
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FIRST_COLUMN}    ${full_name}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_SECOND_COLUMN}    ${email}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_THIRD_COLUMN}    ${EMPTY}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FOURTH_COLUMN}    ${comment}

Add New Location
    [Arguments]    ${body}

    ${customer}    Set Variable    ${body}[0][first_name] ${body}[0][last_name]
    ${city}    Set Variable    ${body}[0][address][city]
    ${zip_code}    Set Variable    ${body}[0][address][zip_code]
    ${street_name}    Set Variable    ${body}[0][address][street_name]
    ${house_number}    Set Variable    ${EMPTY}

    Input Text    ${LOCATION_AND_TOOL_CUSTOMER_INPUT}    ${customer}
    Wait Until Element Is Visible    //li[contains(text(), '${customer}')]
    Click Element    //li[contains(text(), '${customer}')]
    ${customer_value}=    Get Element Attribute    ${LOCATION_AND_TOOL_CUSTOMER_INPUT}    value
    Should Be Equal As Strings    ${customer_value}    ${customer}

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
    [Arguments]    ${body}

    ${customer}    Set Variable    ${body}[0][first_name] ${body}[0][last_name]
    ${city}    Set Variable    ${body}[0][address][city]
    ${zip_code}    Set Variable    ${body}[0][address][zip_code]
    ${street_name}    Set Variable    ${body}[0][address][street_name]
    ${house_number}    Set Variable    ${EMPTY}

    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FIRST_COLUMN}    ${customer}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_SECOND_COLUMN}    ${city}
    ${zip_code_without_hyphens}=    Replace String    ${zip_code}    -    ${EMPTY}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_THIRD_COLUMN}    ${zip_code_without_hyphens}
    # 0-val kezdődő?
    # itt miért fogadta el a harmadik oszlopként?
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FOURTH_COLUMN}    ${house_number}

Add New Tool
    [Arguments]    ${body_device}    ${body_user}

    ${device_name}    Set Variable    ${body_device}[manufacturer] ${body_device}[model]
    ${description}    Set Variable    ${body_device}[platform]
    ${note}    Set Variable    ${body_device}[serial_number]

    ${zip_code}    Set Variable    ${body_user}[0][address][zip_code]
    ${city}    Set Variable    ${body_user}[0][address][city]
    ${customer}    Set Variable    ${body_user}[0][first_name] ${body_user}[0][last_name]
    ${street_name}    Set Variable    ${body_user}[0][address][street_name]
    ${zip_code_without_hyphens}=    Replace String    ${zip_code}    -    ${EMPTY}
    ${customer_location}    Set Variable    ${zip_code_without_hyphens} ${city}, ${street_name} 

    Input Text    ${TOOL_NAME_INPUT}    ${device_name}
    ${device_value}=    Get Element Attribute    ${TOOL_NAME_INPUT}    value
    Should Be Equal As Strings    ${device_value}    ${device_name}
    
    Input Text    ${LOCATION_AND_TOOL_CUSTOMER_INPUT}    ${customer}
    Wait Until Element Is Visible    //li[contains(text(), '${customer}')]
    Click Element    //li[contains(text(), '${customer}')]
    ${customer_value}=    Get Element Attribute    ${LOCATION_AND_TOOL_CUSTOMER_INPUT}    value
    Should Be Equal As Strings    ${customer_value}    ${customer}

    # a telephely automatikusan kitöltődik, ha az ügyfélhez csak egy telephely tartozik (és mi tudjuk hogy csak egyet adtunk hozzá a teszt során)
    # itt várni kéne addig amíg kitöltődik a dropdown, még nem ellenőriztem
    # Sleep    3s
    # Wait Until Element Contains    ${TOOL_LOCATION_INPUT}    ${customer_location}
    Sleep    3s
    ${customer_location_value}    Get Element Attribute    ${TOOL_LOCATION_INPUT}    value
    ${trimmed_location_value}    Strip String    ${customer_location_value}
    Should Be Equal As Strings    ${trimmed_location_value}    ${customer_location}
    
    Input Text    ${TOOL_DESCRIPTION_INPUT}    ${description}
    ${description_value}=    Get Element Attribute    ${TOOL_DESCRIPTION_INPUT}    value
    Should Be Equal As Strings    ${description_value}    ${description}

    Input Text    ${TOOL_COMMENT_INPUT}    ${note}
    ${note_value}=    Get Element Attribute    ${TOOL_COMMENT_INPUT}    value
    Should Be Equal As Strings    ${note_value}    ${note}

Verify Added Tool
    [Arguments]    ${body_device}    ${body_user}

    ${device_name}    Set Variable    ${body_device}[manufacturer] ${body_device}[model]
    ${description}    Set Variable    ${body_device}[platform]
    ${note}    Set Variable    ${body_device}[serial_number]

    ${zip_code}    Set Variable    ${body_user}[0][address][zip_code]
    ${city}    Set Variable    ${body_user}[0][address][city]
    ${customer}    Set Variable    ${body_user}[0][first_name] ${body_user}[0][last_name]
    ${street_name}    Set Variable    ${body_user}[0][address][street_name]
    ${zip_code_without_hyphens}=    Replace String    ${zip_code}    -    ${EMPTY}
    ${customer_location}    Set Variable    ${zip_code_without_hyphens} ${city}, ${street_name} 

    Element Should Contain    ${GRID_TABLE_FIRST_ROW_SECOND_COLUMN}    ${device_name}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_THIRD_COLUMN}    ${customer}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FOURTH_COLUMN}    ${customer_location}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FIFTH_COLUMN}    ${description}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_SIXTH_COLUMN}    ${note}

Export Excel
    Click Button    ${EXCEL_EXPORT_BUTTON}
    Log    ${DOWNLOAD_DIR}/${EXCEL_FILENAME}
    ${files}  List Files In Directory  ${DOWNLOAD_DIR}
    Log    ${files}
    Wait Until Created    ${DOWNLOAD_DIR}/Export.xlsx
    File Should Exist    ${DOWNLOAD_DIR}/Export.xlsx
    Sleep    10s

Search In Grid With Customer Name
    [Arguments]    ${body_user}
    ${customer}    Set Variable    ${body_user}[0][first_name] ${body_user}[0][last_name]

    Input Text    ${SEARCH_BOX_INPUT}    ${customer}
    ${search_value}=    Get Element Attribute    ${SEARCH_BOX_INPUT}    value
    Should Be Equal As Strings    ${search_value}    ${customer}
    Click Element    ${SEARCH_BUTTON}
    Sleep    5s

Check Location Info Page
    [Arguments]    ${body_user}
    ${customer}    Set Variable    ${body_user}[0][first_name] ${body_user}[0][last_name]
    
    Element Should Contain    ${LOCATION_INFO_CUSTOMER_NAME}    ${customer}
    Element Should Be Visible    ${LOCATION_INFO_LOCATION_HEADER}
    Element Should Be Visible    ${LOCATION_INFO_TOOLS_HEADER}
    Element Should Be Visible    ${LOCATION_INFO_WORKS_HEADER}
    Element Should Be Visible    ${LOCATION_INFO_MAP_HEADER}
    
Click Street Link In Table
    Click Link    ${GRID_TABLE_FIRST_ROW_FOURTH_COLUMN}//a
Test Teardown
    Close All Browsers