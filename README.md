# 📝 To-do List Fullstack

![badge](https://img.shields.io/badge/Status-Completed-brightgreen) 
![badge](https://img.shields.io/badge/License-MIT-blue)

Uma aplicação simples de lista de tarefas (To-do List), desenvolvida com **frontend em HTML, CSS (Tailwind)** e **JavaScript**, e **backend em Flask (Python)** com banco de dados **SQLite**, tudo integrado e hospedado gratuitamente.

---

## 🔗 Acesse o Projeto

- 🌐 **Frontend (GitHub Pages):** [https://jessica-os.github.io/todo-fullstack/](https://jessica-os.github.io/todo-fullstack/)
- 🛠️ **Backend (Render):** [https://todo-fullstack-orju.onrender.com](https://todo-fullstack-orju.onrender.com)

---

## 🚀 Demonstração

Aqui está um gif demonstrando como a aplicação funciona:

  <img src="../assets/todo-list.gif" alt="">
  <img src="../assets/todo-list-responsive.gif" alt="">

---

## ⚙️ Funcionalidades

- **Adicionar novas tarefas**
- **Marcar tarefas como concluídas**
- **Voltar tarefas para pendentes**
- **Excluir tarefas**
- **Interface dividida entre "Tarefas Pendentes" e "Tarefas Concluídas"**
- **Layout moderno com animação de título**

---

## 🧰 Tecnologias Utilizadas

### Frontend

![HTML5](https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind%20CSS-06B6D4?logo=tailwind-css&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?logo=javascript&logoColor=black)
![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-22272E?logo=github&logoColor=white)

### Backend

![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?logo=flask&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B57?logo=sqlite&logoColor=white)
![Render](https://img.shields.io/badge/Render-4C4D6C?logo=render&logoColor=white)

---

## 🧪 Testes

### Testes de Frontend

Os testes do frontend foram realizados utilizando **Robot Framework** com **Playwright** para garantir a qualidade das funcionalidades E2E. Os arquivos de teste estão localizados na pasta `robot`.

- **login.robot**: Testes de login (se aplicável)
- **tarefas.robot**: Testes de interação com a lista de tarefas (adicionar, marcar como concluída, excluir)
  
### Testes da API

A API foi testada utilizando **Robot Framework** com a **RequestsLibrary**, onde os endpoints principais foram verificados:

- `GET /tasks`: Testa a listagem das tarefas
- `POST /tasks`: Testa a criação de uma nova tarefa
- `PUT /tasks/{id}`: Testa a atualização de uma tarefa (ex.: marcar como concluída)
- `DELETE /tasks/{id}`: Testa a exclusão de uma tarefa

---

## 🛠️ Como Rodar o Projeto Localmente

### 1. Clone o repositório

```bash
git clone https://github.com/jessica-os/todo-fullstack.git
cd todo-fullstack
```

