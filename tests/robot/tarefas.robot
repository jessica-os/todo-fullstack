*** Settings ***
Resource    resources/tarefas.resource
Library    Collections
Library    BuiltIn
Library    OperatingSystem
Library    String
Library    Browser


*** Test Cases ***

*** Test Cases ***
Fluxo Completo da Tarefa
    Abrir o navegador
    Abrir a página todo-list
    Criar tarefa única
    Validar tarefa pendente
    Editar tarefa
    Concluir tarefa
    Validar tarefa concluida
    Excluir tarefa
    Fechar o navegador