*** Settings ***
Library    JSONLibrary
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem

*** Variables ***
${BASE_URL}    http://localhost:3000
${JSON_FILE}   ../../resources/fuzzed-specs.json

*** Test Cases ***
Fuzzed API Test Runner
    [Documentation]    Dynamically runs all tests from fuzzed-specs.json

    # Step 1: Load the JSON file
    ${json}=    Load JSON From File    ${JSON_FILE}

    # Step 2: Create API session
    Create Session    api    ${BASE_URL}

    # Step 3: Loop through each test case in the JSON
    FOR    ${test}    IN    @{json}
        ${title}=       Get From Dictionary    ${test}    title
        ${method}=      Get From Dictionary    ${test}    method
        ${url}=         Get From Dictionary    ${test}    url
        ${headers}=     Get From Dictionary    ${test}    headers
        ${body}=        Get From Dictionary    ${test}    body
        ${expected}=    Get From Dictionary    ${test}    expected

        Log To Console    \n🚀 Running test: ${title}

        ${resp}=    Post On Session    api    ${url}    json=${body}    headers=${headers}

        ${expected_status}=    Get From Dictionary    ${expected}    status
        Should Be Equal As Integers    ${resp.status_code}    ${expected_status}

        IF    ${expected_status} == 400
            Should Be Equal    ${resp.text}    Bad Request
        ELSE
            Log To Console    ✅ Valid request: ${resp.status_code}
        END
    END
