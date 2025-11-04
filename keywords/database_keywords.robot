*** Settings ***
Resource    ../../resources/imports.robot

*** Variables ***
${DBNAME}     myappdb
${DBUSER}     root
${DBPASS}     rootpassword
${DBHOST}     localhost
${DBPORT}     3306

*** Keywords ***
Query data from posts table by userId
    [Arguments]   ${userId}
    Connect To Database   pymysql  ${DBNAME}  ${DBUSER}  ${DBPASS}  ${DBHOST}  ${DBPORT}
    ${query}=  Set Variable  SELECT * FROM posts where user_id=${userId};
    ${result}=  Query   ${query}
    [return]   ${result}

Connect database connection
    Connect To Database   pymysql  ${DBNAME}  ${DBUSER}  ${DBPASS}  ${DBHOST}  ${DBPORT}

Delete all data
     Execute Sql String    TRUNCATE TABLE posts;
     ${rows}=    Query    SELECT COUNT(*) FROM posts;
     ${count}=    Set Variable    ${rows[0][0]}
     Should Be Equal As Integers    ${count}    0
    
    



