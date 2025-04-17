*** Settings ***
Resource    resources/tarefas.resource
Library    Collections
Library    BuiltIn
Library    OperatingSystem
Library    String
Library    Browser


*** Test Cases ***

Inserir e validar tarefa
    Abrir o navegador
    Abrir a página todo-list
    Inserir nova tarefa    Estudar Cypress
    Validar tarefa pendente
    Fechar o navegador

Concluir tarefa
    Abrir o navegador
    Abrir a página todo-list
    Inserir nova tarefa    Concluir tarefa de teste
    Validar tarefa pendente
    Concluir tarefa
    Fechar o navegador

Editar tarefa
    Abrir o navegador
    Abrir a página todo-list
    Inserir nova tarefa    Editar tarefa de teste
    Validar tarefa pendente
    Editar tarefa
    Fechar o navegador

Excluir tarefa
    Abrir o navegador
    Abrir a página todo-list
    Inserir nova tarefa    Excluir tarefa de teste
    Validar tarefa pendente
    Excluir tarefa
    Fechar o navegador