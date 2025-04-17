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

Criar tarefa única
    ${rand}    Evaluate    random.randint(1000, 9999)    modules=random
    ${tarefa}    Set Variable    Tarefa teste ${rand}
    Fill Text    xpath=//input[@id="nova-tarefa"]    ${tarefa}
    Click        xpath=//button[@id="adicionar-tarefa"]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${tarefa}")]    visible    timeout=5s
    Set Suite Variable    ${TAREFA}    ${tarefa}

Validar tarefa pendente
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA}")]    visible    timeout=5s

Editar tarefa
    ${element}    Get Element    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA}")]
    ${id}         Get Attribute    ${element}    data-id
    Click         xpath=//ul[@id="lista-tarefas-pendentes"]//li[@data-id="${id}"]//button[contains(text(),"✏️")]

    ${tarefa_formatada}    Evaluate    "${TAREFA}".replace(" ", "_")
    ${input_id}            Set Variable    editar-${id}-${tarefa_formatada}

    Wait For Elements State    id=${input_id}    visible    timeout=5s

    ${nova_tarefa}    Set Variable    ${TAREFA} editada
    Fill Text         id=${input_id}    ${nova_tarefa}

    Click             xpath=//ul[@id="lista-tarefas-pendentes"]//li[@data-id="${id}"]//button[contains(text(),"Salvar")]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${nova_tarefa}")]    visible    timeout=5s

    Set Suite Variable    ${TAREFA}    ${nova_tarefa}




Concluir tarefa
    Click    xpath=//ul[@id="lista-tarefas-pendentes"]//li[contains(., "${TAREFA}")]//button[1]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-concluidas"]//li[contains(., "${TAREFA}")]    visible    timeout=5s

Validar tarefa concluida
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-concluidas"]//li[contains(., "${TAREFA}")]    visible    timeout=5s

Excluir tarefa
    Click    xpath=//ul[@id="lista-tarefas-concluidas"]//li[contains(., "${TAREFA}")]//button[contains(text(),"🗑️")]
    Wait For Elements State    xpath=//ul[@id="lista-tarefas-concluidas"]//li[contains(., "${TAREFA}")]    hidden    timeout=5s

Fechar o navegador
    Close Browser