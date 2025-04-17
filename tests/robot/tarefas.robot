*** Settings ***
Resource    resources/tarefas.resource
Library    Collections
Library    BuiltIn
Library    OperatingSystem
Library    String
Library    Browser

*** Test Cases ***
Fluxo Completo da Tarefa
    Abrir o navegador
    Abrir a página todo-list
    Criar tarefa única
    Validar tarefa pendente
    Editar tarefa
    Validar tarefa editada
    Concluir tarefa
    Validar tarefa concluída
    Excluir tarefa
    Fechar o navegador