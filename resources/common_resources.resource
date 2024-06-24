*** Settings ***
Library    SeleniumLibrary
Library    String
Library    OperatingSystem

*** Variables ***
${HOMEPAGE_URL}    https://bwpool.azurewebsites.net/
${PROXY}  http://idebproxy01.itsh.itsh-internal.hu:3128
${RANDOM_USER_DATA_URL}  https://random-data-api.com/api/users/random_user
${RANDOM_DEVICE_DATA_URL}  https://random-data-api.com/api/device/random_device
${LOCATION_INFO_URL}    https://bwpool.azurewebsites.net/LocationInfo
${CUSTOMERS_URL}    https://bwpool.azurewebsites.net/Customer   
${LOCATIONS_URL}    https://bwpool.azurewebsites.net/Location
${TOOLS_URL}    https://bwpool.azurewebsites.net/Tool

${BROWSER}    Chrome
${HOMEPAGE_TITLE}    BWP Index
${NAVBAR_BRAND}    //a[@class='navbar-brand']
${NAVBAR_BRAND_TEXT}    BWP nyilvántartó
${ADD_NEW_ELEMENT_BUTTON}    //div[@id='Grid_add']/button
${ADD_NEW_ELEMENT_FORM}    //div[@id="Grid_dialogEdit_wrapper"]//form
${SAVE_BUTTON}    //button[text()='Save']
${SEARCH_BOX_INPUT}    //input[@id='Grid_ToolbarSearchBox']
${SEARCH_BUTTON}    //div[@id='Grid_search']//span[@title='Search']
${EXCEL_EXPORT_BUTTON}    //div[@title='Excel Export']//button

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
${GRID_TABLE_ROWS}    //table[@id="Grid_content_table"]//tr

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

${LOCATION_INFO_CUSTOMER_NAME}    //table[@id="infoList_content_table"]//tr[1]/td[2]
${LOCATION_INFO_CUSTOMER_LOCATION}    //table[@id="infoList_content_table"]//tr[2]/td[2]
${LOCATION_INFO_LOCATION_DIV}    //div[@id="infoList"]
${LOCATION_INFO_TOOLS_DIV}    //div[@id="toolsDiv"]
${LOCATION_INFO_WORKS_HEADER}    //h6[.='Munkák']
${LOCATION_INFO_MAP_HEADER}    //h6[.='Térkép']

*** Keywords ***
Open Browser And Navigate To Home Page
    Open Browser    ${HOMEPAGE_URL}    ${BROWSER}
    Maximize Browser Window

Verify Application Opens
    Location Should Be    ${HOMEPAGE_URL}
    Title Should Be    ${HOMEPAGE_TITLE}
    Wait Until Element Is Visible    ${NAVBAR_BRAND}
    ${navbar_brand_text}    Get Text    ${NAVBAR_BRAND}
    Should Be Equal As Strings    ${navbar_brand_text}    ${NAVBAR_BRAND_TEXT}

Click On A Menu Tab
    [Arguments]    ${menu_tab_locator}

    Click Link    ${menu_tab_locator}

Verify Page Content
    [Arguments]    ${page_title}    ${grid_locator}    ${page_url}
    
    Wait Until Element Is Visible    ${page_title}
    Element Should Be Visible    ${grid_locator}
    Location Should Be    ${page_url}

Click On Add Button To Add New Element
    Sleep    3s
    Click Button   ${ADD_NEW_ELEMENT_BUTTON}
    Wait Until Element Is Visible    ${ADD_NEW_ELEMENT_FORM}

Add New Customer Data
    [Arguments]    ${full_name}    ${email}    ${phone_number}    ${comment} 

    Input Text    ${CUSTOMER_NAME_INPUT}    ${full_name}
    ${full_name_value}    Get Element Attribute    ${CUSTOMER_NAME_INPUT}    value
    Should Be Equal As Strings    ${full_name_value}    ${full_name}

    Input Text    ${CUSTOMER_EMAIL_INPUT}    ${email}
    ${email_value}    Get Element Attribute    ${CUSTOMER_EMAIL_INPUT}    value
    Should Be Equal As Strings    ${email_value}    ${email}

    Input Text    ${CUSTOMER_PHONE_NUMBER_INPUT}    ${phone_number}
    ${phone_number}    Get Element Attribute    ${CUSTOMER_PHONE_NUMBER_INPUT}    value
    Should Be Equal As Strings    ${phone_number}    ${phone_number}

    Input Text    ${CUSTOMER_COMMENT_INPUT}    ${comment}
    ${comment_value}    Get Element Attribute    ${CUSTOMER_COMMENT_INPUT}    value
    Should Be Equal As Strings    ${comment_value}    ${comment}

Save Form
    Click Button    ${SAVE_BUTTON}
    Wait Until Element Is Not Visible    ${SAVE_BUTTON}
    
Verify Added Customer In Table
    [Arguments]    ${full_name}    ${email}    ${phone_number}    ${comment} 

    Wait Until Element Contains    ${GRID_TABLE_FIRST_ROW_FIRST_COLUMN}    ${full_name}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FIRST_COLUMN}    ${full_name}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_SECOND_COLUMN}    ${email}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_THIRD_COLUMN}    ${phone_number}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FOURTH_COLUMN}    ${comment}

Add New Location Data
    [Arguments]    ${customer_name}    ${city}    ${zip_code_without_hyphens}    ${street_name}    ${house_number}

    Input Text    ${LOCATION_AND_TOOL_CUSTOMER_INPUT}    ${customer_name}
    Wait Until Element Is Visible    //li[contains(text(), '${customer_name}')]
    Click Element    //li[contains(text(), '${customer_name}')]

    ${customer_value}    Get Element Attribute    ${LOCATION_AND_TOOL_CUSTOMER_INPUT}    value
    Should Be Equal As Strings    ${customer_value}    ${customer_name}

    Input Text    ${LOCATION_CITY_INPUT}    ${city}
    ${city_value}    Get Element Attribute    ${LOCATION_CITY_INPUT}    value
    Should Be Equal As Strings    ${city_value}    ${city}

    Input Text    ${LOCATION_ZIP_CODE_INPUT}    ${zip_code_without_hyphens}
    ${zip_code_value}    Get Element Attribute    ${LOCATION_ZIP_CODE_INPUT}    value
    Should Be Equal As Strings    ${zip_code_value}    ${zip_code_without_hyphens}

    Input Text    ${LOCATION_STREET_NAME_INPUT}    ${street_name}
    ${street_name_value}    Get Element Attribute    ${LOCATION_STREET_NAME_INPUT}    value
    Should Be Equal As Strings    ${street_name_value}    ${street_name}

    Input Text    ${LOCATION_HOUSE_NUMBER_INPUT}    ${house_number}
    ${house_number_value}    Get Element Attribute    ${LOCATION_HOUSE_NUMBER_INPUT}    value
    Should Be Equal As Strings    ${house_number_value}    ${house_number}

Verify Added Location In Table
    [Arguments]    ${customer_name}    ${city}    ${zip_code_without_hyphens}    ${street_name}    ${house_number}

    Wait Until Element Contains    ${GRID_TABLE_FIRST_ROW_FIRST_COLUMN}    ${customer_name}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FIRST_COLUMN}    ${customer_name}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_SECOND_COLUMN}    ${city}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_THIRD_COLUMN}    ${zip_code_without_hyphens}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FOURTH_COLUMN}    ${street_name}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FIFTH_COLUMN}    ${house_number}

Add New Tool Data
    [Arguments]    ${device_name}    ${description}    ${note}    ${customer_name}    ${customer_location}

    Input Text    ${TOOL_NAME_INPUT}    ${device_name}
    ${device_value}    Get Element Attribute    ${TOOL_NAME_INPUT}    value
    Should Be Equal As Strings    ${device_value}    ${device_name}
    
    Input Text    ${LOCATION_AND_TOOL_CUSTOMER_INPUT}    ${customer_name}
    Wait Until Element Is Visible    //li[contains(text(), '${customer_name}')]
    Click Element    //li[contains(text(), '${customer_name}')]

    ${customer_value}    Get Element Attribute    ${LOCATION_AND_TOOL_CUSTOMER_INPUT}    value
    Should Be Equal As Strings    ${customer_value}    ${customer_name}

    Sleep    3s
    ${customer_location_value}    Get Element Attribute    ${TOOL_LOCATION_INPUT}    value
    ${trimmed_location_value}    Strip String    ${customer_location_value}
    Should Be Equal As Strings    ${trimmed_location_value}    ${customer_location}
    
    Input Text    ${TOOL_DESCRIPTION_INPUT}    ${description}
    ${description_value}    Get Element Attribute    ${TOOL_DESCRIPTION_INPUT}    value
    Should Be Equal As Strings    ${description_value}    ${description}

    Input Text    ${TOOL_COMMENT_INPUT}    ${note}
    ${note_value}    Get Element Attribute    ${TOOL_COMMENT_INPUT}    value
    Should Be Equal As Strings    ${note_value}    ${note}

Verify Added Tool In Table
    [Arguments]    ${device_name}    ${description}    ${note}    ${customer_name}    ${customer_location}

    Wait Until Element Contains    ${GRID_TABLE_FIRST_ROW_SECOND_COLUMN}    ${device_name}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_SECOND_COLUMN}    ${device_name}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_THIRD_COLUMN}    ${customer_name}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FOURTH_COLUMN}    ${customer_location}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_FIFTH_COLUMN}    ${description}
    Element Should Contain    ${GRID_TABLE_FIRST_ROW_SIXTH_COLUMN}    ${note}

Export Excel And Verify
    ${downloads_path}    Evaluate    os.path.join(os.environ['USERPROFILE'], 'Downloads') if os.name == 'nt' else os.path.join(os.path.expanduser('~'), 'Downloads')    os
    ${before_files}    List Directory    ${downloads_path}
    Click Button    ${EXCEL_EXPORT_BUTTON}
    Sleep    5s
    ${after_files}    List Directory    ${downloads_path}
    ${new_files_set}    Evaluate    set(${after_files}) - set(${before_files})
    ${new_files_list}    Evaluate    list(${new_files_set})
    ${new_file}    Set Variable    ${new_files_list}[0]
    File Should Exist    ${downloads_path}/${new_file}

Search In Grid With Param
    [Arguments]    ${param}

    Input Text    ${SEARCH_BOX_INPUT}    ${param}
    ${param_value}    Get Element Attribute    ${SEARCH_BOX_INPUT}    value
    Should Be Equal As Strings    ${param_value}    ${param}
    Click Element    ${SEARCH_BUTTON}

Check Table Row Number
    [Arguments]    ${row_number}

    ${rows_in_table}    Get WebElements    ${GRID_TABLE_ROWS}
    ${rows_in_table_length}    Get Length    ${rows_in_table}
    Should Be Equal As Integers    ${rows_in_table_length}    ${row_number}

Click Street Link In Table
    Click Link    ${GRID_TABLE_FIRST_ROW_FOURTH_COLUMN}//a
    Sleep    3s

Check Location Info Page
    [Arguments]    ${customer_name}    ${customer_location}

    Wait Until Element Is Visible    ${LOCATION_INFO_LOCATION_DIV}
    ${current_url}    Get Location
    Should Contain    ${current_url}    ${LOCATION_INFO_URL}
    Element Should Be Visible    ${LOCATION_INFO_LOCATION_DIV}
    Element Should Contain    ${LOCATION_INFO_CUSTOMER_NAME}    ${customer_name}
    Element Should Contain    ${LOCATION_INFO_CUSTOMER_LOCATION}    ${customer_location}
    Element Should Be Visible    ${LOCATION_INFO_TOOLS_DIV}
    Element Should Be Visible    ${LOCATION_INFO_WORKS_HEADER}
    Element Should Be Visible    ${LOCATION_INFO_MAP_HEADER}
   
Test Teardown
    Close All Browsers