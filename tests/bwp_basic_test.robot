*** Settings ***
Resource    ../resources/common_resources.resource
Library    RequestsLibrary

Test Setup    Open Browser And Navigate To Home Page
Test Teardown    Test Teardown

*** Test Cases ***
BWP Basic Test
    Verify Application Opens

    Sleep    3s
    Click On A Menu Tab    ${CUSTOMERS_MENU_TAB}
    Verify Page Content    ${CUSTOMERS_HEADER}    ${CUSTOMERS_PAGE_GRID}

    ${headers}  Create Dictionary  Content-Type=application/json
    ${proxies}  Create Dictionary  http=${PROXY}  https=${PROXY}

    ${response_user}    GET    ${RANDOM_USER_DATA_URL}    proxies=${proxies}    params=size=1
    ${body_user}    Set Variable    ${response_user.json()}

    ${full_name}    Set Variable    ${body_user}[0][first_name] ${body_user}[0][last_name]
    ${email}    Set Variable    ${body_user}[0][email]
    ${phone_number}    Set Variable    ${EMPTY}
    ${comment}    Set Variable    ${body_user}[0][id]
    
    ${city}    Set Variable    ${body_user}[0][address][city]
    ${zip_code}    Set Variable    ${body_user}[0][address][zip_code]
    ${zip_code_without_leading_zeros}    Strip String    ${zip_code}    characters=0
    ${zip_code_without_hyphens}    Replace String    ${zip_code_without_leading_zeros}    -    ${EMPTY}
    ${street_name}    Set Variable    ${body_user}[0][address][street_name]
    ${house_number}    Set Variable    ${EMPTY}
    ${customer_location}    Set Variable    ${zip_code_without_hyphens} ${city}, ${street_name}

    Click On Add Button To Add New Element
    Add New Customer    ${full_name}    ${email}    ${phone_number}    ${comment}
    Save Form
    Verify Customer In Table    ${full_name}    ${email}    ${phone_number}    ${comment}

    Click On A Menu Tab    ${LOCATIONS_MENU_TAB}
    Verify Page Content    ${LOCATION_HEADER}    ${LOCATIONS_PAGE_GRID}

    Click On Add Button To Add New Element
    Add New Location    ${full_name}    ${city}    ${zip_code_without_hyphens}    ${street_name}    ${house_number}
    Save Form
    Verify Location In Table    ${full_name}    ${city}    ${zip_code_without_hyphens}    ${street_name}    ${house_number}   

    ${response_device}    GET    ${RANDOM_DEVICE_DATA_URL}    proxies=${proxies}    params=size=2
    ${body_device}    Set Variable    ${response_device.json()}

    Click On A Menu Tab    ${TOOLS_MENU_TAB}
    Verify Page Content    ${TOOLS_HEADER}    ${TOOLS_PAGE_GRID}
    
    ${device_count}    Get Length    ${body_device}

    FOR    ${items}    IN RANGE    0    ${device_count}    
        Click On Add Button To Add New Element

        ${device_name}    Set Variable    ${body_device}[${items}][manufacturer] ${body_device}[${items}][model]
        ${description}    Set Variable    ${body_device}[${items}][platform]
        ${note}    Set Variable    ${body_device}[${items}][serial_number]   

        Add New Tool    ${device_name}    ${description}    ${note}    ${full_name}    ${customer_location}
        Save Form
        Verify Tool In Table    ${device_name}    ${description}    ${note}    ${full_name}    ${customer_location}
    END

    Sleep    3s
    Export Excel And Verify

    Click On A Menu Tab    ${LOCATIONS_MENU_TAB}
    Verify Page Content    ${LOCATION_HEADER}    ${LOCATIONS_PAGE_GRID}

    Sleep    3s
    Search In Grid With Param    ${full_name}
    Check Table Row Number    1
    Verify Location In Table    ${full_name}    ${city}    ${zip_code_without_hyphens}    ${street_name}    ${house_number}

    Click Street Link In Table
    Check Location Info Page    ${full_name}    ${customer_location}
    