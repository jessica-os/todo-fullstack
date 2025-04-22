*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://todo-fullstack-orju.onrender.com

*** Test Cases ***
Listar Tarefas
    [Tags]    GET
    Create Session    todo    ${BASE_URL}
    ${response}=    GET    todo    /tasks
    Status Should Be    200    ${response}
    Should Be True    ${response.json()} is not None
