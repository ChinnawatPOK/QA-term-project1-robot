*** Settings ***
Resource    ../resources/imports.robot
Resource    ../keywords/create_user_keywords.robot
Resource    ../keywords/database_keywords.robot
Variables    ../resources/testdata/create_user_data.yml

Suite Setup    Connect database connection
Suite Teardown    Disconnect From Database

*** Test Cases ***
TC_001 Test call single create user and validate should success
    When Call API Create User   body=${create_user.TC_001.request_body}
    Then Should Be Equal As Integers    ${response.status_code}    201
    And Verify User In Database   userId=${response.json()['userId']}  expected_data=${create_user.TC_001.expected_data}
    [Teardown]  Delete all data

TC_002 Test call single create user and validate should bad request
    [Setup]    Delete all data
    When Call API Create User   body=${create_user.TC_002.request_body}  expected_status=400
    Then Should Be Equal As Integers    ${response.status_code}    400
    And Verify User Database is Empty  userId=${create_user.TC_002.request_body.userId}

# Help qa focus on business cases
TC_003 Test all data in json file valid cases
    [Documentation]   Test read file from json file and verify should be correct
    ${json_obj}=    Load JSON From File    resources/testdata/posts-post-fuzzed-data.json
    ${valid_list}=    Get Value From Json    ${json_obj}    $.valid
    ${valid}=    Set Variable    ${valid_list[0]}
    FOR    ${item}    IN    @{valid}
        Template call api and verify json file valid case  request_body=${item}
    END

TC_004 Test all data in json file invalid cases
    [Documentation]   Test read file from json file and verify should be failed
    ${json_obj}=    Load JSON From File    resources/testdata/posts-post-fuzzed-data.json
    ${valid_list}=    Get Value From Json    ${json_obj}    $.invalid
    ${valid}=    Set Variable    ${valid_list[0]}
    FOR    ${item}    IN    @{valid}
        Template call api and verify json file invalid case  request_body=${item}
    END
