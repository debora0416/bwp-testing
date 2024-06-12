*** Settings ***
Resource    ../resources/common_resources.resource
Library  RequestsLibrary

*** Test Cases ***
BWP tool basic testing
    Open Browser And Navigate To Homepage
    Verify Application Opens
    Click On A Menu Tab    ${CUSTOMERS_MENU_TAB}
    Verify Page Content    ${CUSTOMERS_HEADER}    ${CUSTOMERS_PAGE_GRID}

    ${headers}=  Create Dictionary  Content-Type=application/json
    ${proxies}=  Create Dictionary  http=${PROXY}  https=${PROXY}
    ${response}=  GET  ${RANDOM_DATA_URL}  proxies=${proxies}    params=size=1
    ${body}    Set Variable    ${response.json()}

    ${full_name}    Set Variable    ${body}[0][first_name] ${body}[0][last_name]
    ${email}    Set Variable    ${body}[0][email]
    ${id}    Set Variable    ${body}[0][id]

    Add New Customer    ${full_name}    ${email}    ${EMPTY}    ${id}   
    Save Form
    Verify Added Customer    ${full_name}    ${email}    ${EMPTY}    ${id}

    Click On A Menu Tab    ${LOCATIONS_MENU_TAB}
    Verify Page Content    ${LOCATION_HEADER}    ${LOCATIONS_PAGE_GRID}

    ${city}    Set Variable    ${body}[0][address][city]
    ${zip_code}    Set Variable    ${body}[0][address][zip_code]
    ${street_name}    Set Variable    ${body}[0][address][street_name]

    Add New Location    ${full_name}    ${city}    ${zip_code}    ${street_name}    ${EMPTY}
    Save Form
    Verify Added Location    ${full_name}    ${city}    ${zip_code}    ${street_name}    ${EMPTY}   


    Test Teardown
    