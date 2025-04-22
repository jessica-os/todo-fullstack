*** Settings ***
Library           RequestsLibrary
Library           Collections
Library           BuiltIn
Library           OperatingSystem

Suite Setup       Disable SSL Warnings
Resource          resources/variables.resource

*** Variables ***
${BASE_URL}       https://todo-fullstack-orju.onrender.com

*** Keywords ***
Disable SSL Warnings
    Set Environment Variable    PYTHONWARNINGS    ignore::InsecureRequestWarning

*** Test Cases ***

Criar Tarefa
    [Tags]    POST
    Create Session    todo    ${BASE_URL}
    ${dados}=    Create Dictionary    nome=Estudar Robot
    ${response}=    POST On Session    todo    /tasks    json=${dados}
    ${task}=    Convert To Dictionary    ${response.json()}
    ${task_id}=    Get From Dictionary    ${task}    id
    Set Suite Variable    ${task_id}    ${task_id}

Concluir Tarefa
    [Tags]    PATCH
    Create Session    todo    ${BASE_URL}
    ${response}=    PATCH On Session      todo    /tasks/${task_id}/concluir
    Log    ${response.json()}
    Status Should Be    200    ${response}
    ${task}=    Convert To Dictionary    ${response.json()}
    Should Be Equal As Strings    ${task['concluida']}    True

Atualizar Tarefa
    [Tags]    PUT
    Create Session    todo    ${BASE_URL}
    ${novos_dados}=    Create Dictionary    nome=Estudar Playwright
    ${response}=    PUT On Session     todo    /tasks/${task_id}    json=${novos_dados}
    Log    ${response.json()}
    Status Should Be    200    ${response}
    ${task}=    Convert To Dictionary    ${response.json()}
    Should Be Equal As Strings    ${task['nome']}    Estudar Playwright

Deletar Tarefa
    [Tags]    DELETE
    Create Session    todo    ${BASE_URL}
    ${response}=    DELETE On Session     todo    /tasks/${task_id}
    Log    ${response.json()}
    Status Should Be    200    ${response}
    Should Be Equal As Strings    ${response.json()}[mensagem]    Tarefa excluída com sucesso
