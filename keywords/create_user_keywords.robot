*** Settings ***
Resource  ../../resources/imports.robot
Resource  ./database_keywords.robot

*** Variables ***
${url}    http://localhost:3000

*** Keywords ***
Call API Create User
    [Arguments]   ${body}  ${expected_status}=201
    Create Session    restapi    ${url}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    Post On Session    restapi    /posts    json=${body}    headers=${headers}  expected_status=${expected_status}
    Set Test Variable  ${response}  ${response}
    
Verify User In Database
    [Arguments]  ${userId}  ${expected_data}
    ${query_response}=  Query data from posts table by userId  userId=${userId}
    log   ${query_response}
    Should Be Equal As Numbers   ${expected_data['userId']}   ${query_response[0][1]}
    Should Be Equal As Strings   ${expected_data['title']}   ${query_response[0][2]}
    Should Be Equal As Strings   ${expected_data['body']}   ${query_response[0][3]}
    
Verify User Database is Empty
    [Arguments]  ${userId}
    ${query_response}=  Query data from posts table by userId  userId=${userId}
    Log   ${query_response}

Template call api and verify json file valid case
    [Arguments]   ${request_body}
    Call API Create User   body=${request_body}
    Then Should Be Equal As Integers    ${response.status_code}    201
    Verify User In Database   userId=${response.json()['userId']}  expected_data=${request_body}
    [Teardown]  Delete all data

Template call api and verify json file invalid case
    [Arguments]   ${request_body}
    [Setup]    Delete all data
    Call API Create User   body=${request_body}  expected_status=400
    Should Be Equal As Integers    ${response.status_code}    400