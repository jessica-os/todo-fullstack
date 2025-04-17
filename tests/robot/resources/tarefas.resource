*** Settings ***
Library    Browser
Library    BuiltIn

*** Variables ***
${URL}     https://jessica-os.github.io/todo-fullstack/
${RANDOM}  Evaluate    __import__('random')

*** Keywords ***
Abrir o navegador
    New Browser    headless=${False}
    New Context

Abrir a página todo-list
    New Page    ${URL}
    Wait For Elements State    h1    visible    timeout=5s

Inserir nova tarefa
    [Arguments]    ${tarefa}
    ${rand}    Evaluate    random.randint(1000, 9999)    modules=random
    ${tarefa_unica}    Set Variable    ${tarefa} ${rand}
    Fill Text    xpath=//input[@id="nova-tarefa"]    ${tarefa_unica}
    Click        xpath=//button[@id="adicionar-tarefa"]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${tarefa_unica}")]    visible    timeout=5s
    Set Suite Variable    ${TAREFA_ADICIONADA}    ${tarefa_unica}

Validar tarefa pendente
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA_ADICIONADA}")]    visible    timeout=5s

Concluir tarefa
    Click    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA_ADICIONADA}")]//button[1]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-concluidas"]//li[contains(., "${TAREFA_ADICIONADA}")]    visible    timeout=5s

Editar tarefa
    Click    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA_ADICIONADA}")]//button[contains(text(),"✏️")]
    ${id_input}    Set Variable    editar-${TAREFA_ADICIONADA.replace(" ", "_")}
    Wait For Elements State    xpath=//input[@id="${id_input}"]    visible    timeout=5s
    Fill Text    xpath=//input[@id="${id_input}"]    ${TAREFA_ADICIONADA} editada
    Click    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA_ADICIONADA}")]//button[contains(text(),"Salvar")]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA_ADICIONADA} editada")]    visible    timeout=5s
    Set Suite Variable    ${TAREFA_ADICIONADA}    ${TAREFA_ADICIONADA} editada



Excluir tarefa
    Click    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA_ADICIONADA}")]//button[contains(text(),"🗑️")]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA_ADICIONADA}")]    hidden    timeout=5s

Fechar o navegador
    Close Browser
