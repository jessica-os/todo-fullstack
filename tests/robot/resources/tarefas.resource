*** Settings ***
Library    BuiltIn
Library    Browser

*** Variables ***
${URL}     https://jessica-os.github.io/todo-fullstack/
${RANDOM}  Evaluate    __import__('random')

*** Keywords ***
Abrir o navegador
    New Browser    headless=${False}
    New Context
    Log To Console    Abrindo o navegador...

Abrir a página todo-list
    New Page    ${URL}
    Wait For Elements State    h1    visible    timeout=5s
    Log To Console    Página carregada com sucesso!

Criar tarefa única
     [Tags]  Criando a tarefa   
    ${rand}    Evaluate    random.randint(1000, 9999)    modules=random
    ${tarefa}    Set Variable    Tarefa teste ${rand}
    Fill Text    xpath=//input[@id="nova-tarefa"]    ${tarefa}
    Click        xpath=//button[@id="adicionar-tarefa"]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${tarefa}")]    visible    timeout=5s
    Set Suite Variable    ${TAREFA}    ${tarefa}
    Log    Tarefa "${tarefa}" criada com sucesso!

Validar tarefa pendente
    [Tags]  Validando a criação da tarefa  
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA}")]    visible    timeout=5s
    Log    Validando tarefa pendente "${TAREFA}"...

Editar tarefa
    [Tags]    Editando a tarefa
    Log    Editando a tarefa "${TAREFA}"...
    ${element}    Get Element    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA}")]
    ${id}         Get Attribute    ${element}    data-id
    Click    xpath=//ul[@id="lista-tarefas-pendentes"]//li[@data-id="${id}"]//button[contains(text(),"✏️")]
    ${input_id}   Set Variable    editar-${id}-${TAREFA.replace(" ", "_")}
    Wait For Elements State    id=${input_id}    visible    timeout=5s
    ${nova_tarefa}    Set Variable    ${TAREFA} editada
    Fill Text    id=${input_id}    ${nova_tarefa}
    Click    xpath=//ul[@id="lista-tarefas-pendentes"]//li[@data-id="${id}"]//button[contains(text(),"Salvar")]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${nova_tarefa}")]    visible    timeout=5s
    Set Suite Variable    ${TAREFA}    ${nova_tarefa}
    Log    Tarefa "${TAREFA}" editada com sucesso!

Validar tarefa editada
     [Tags]   Validando a edição da tarefa
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA}")]    visible    timeout=5s
    Log    Validando se a tarefa "${TAREFA}" foi editada...

Concluir tarefa
     [Tags]    Concluindo a tarefa
    Log    Concluindo a tarefa "${TAREFA}"...
    Click    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA}")]//button[1]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-concluidas"]//li[contains(., "${TAREFA}")]    visible    timeout=5s
    Log    Tarefa "${TAREFA}" concluída com sucesso!

Validar tarefa concluída
     [Tags]    Validando a conclusão da tarefa
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-concluidas"]//li[contains(., "${TAREFA}")]    visible    timeout=5s
    Log    Validando se a tarefa "${TAREFA}" foi concluída...

Excluir tarefa
     [Tags]    Excluindo a tarefa
    Log    Excluindo a tarefa "${TAREFA}"...
    Click    xpath=//ul[@id="lista-tarefas-concluidas"]//li[contains(., "${TAREFA}")]//button[contains(text(),"🗑️")]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-concluidas"]//li[contains(., "${TAREFA}")]    hidden    timeout=5s
    Log    Tarefa "${TAREFA}" excluída com sucesso!

Fechar o navegador
    Close Browser
    Log To Console    Navegador fechado com sucesso!