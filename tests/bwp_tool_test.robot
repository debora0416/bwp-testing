*** Settings ***
Resource    ../resources/common_resources.resource

*** Test Cases ***
BWP tool basic testing
    Open Browser And Navigate To Homepage
    Verify Application Opens
    Click On A Specific Menu Tab And Verify Content Grid    ${PARTNERS_MENU_TAB}    ${PARTNERS_PAGE_GRID}

    Test Teardown
    