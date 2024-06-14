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

    ${response}=  GET  ${RANDOM_USER_DATA_URL}  proxies=${proxies}    params=size=1
    ${body_user}    Set Variable    ${response.json()}

    Click On Add Button To Add New Element
    Add New Customer    ${body_user}   
    Save Form
    Verify Added Customer    ${body_user}

    Click On A Menu Tab    ${LOCATIONS_MENU_TAB}
    Verify Page Content    ${LOCATION_HEADER}    ${LOCATIONS_PAGE_GRID}

    Click On Add Button To Add New Element
    Add New Location    ${body_user}
    Save Form
    Verify Added Location    ${body_user}   

    ${response_device}=  GET  ${RANDOM_DEVICE_DATA_URL}  proxies=${proxies}    params=size=2
    ${body_device}    Set Variable    ${response_device.json()}

    Click On A Menu Tab    ${TOOLS_MENU_TAB}
    Verify Page Content    ${TOOLS_HEADER}    ${TOOLS_PAGE_GRID}
    
    ${device_count}    Get Length    ${body_device}
    FOR    ${items}    IN RANGE    0    ${device_count}    
        Click On Add Button To Add New Element
        Add New Tool    ${body_device}[${items}]    ${body_user}
        Save Form
        Verify Added Tool    ${body_device}[${items}]    ${body_user}
    END

    # Export Excel

    Click On A Menu Tab    ${LOCATIONS_MENU_TAB}
    Verify Page Content    ${LOCATION_HEADER}    ${LOCATIONS_PAGE_GRID}

    Search In Grid With Customer Name    ${body_user}

    Verify Added Location    ${body_user}

    Click Street Link In Table
    Sleep    3
    Check Location Info Page    ${body_user}


    Test Teardown
    