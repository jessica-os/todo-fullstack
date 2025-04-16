document.addEventListener('DOMContentLoaded', () => {
  const API_URL = 'http://127.0.0.1:5000';

  const input = document.getElementById('nova-tarefa');
  const botaoAdicionar = document.getElementById('adicionar-tarefa');
  const listaPendentes = document.getElementById('lista-tarefas-pendentes');
  const listaConcluidas = document.getElementById('lista-tarefas-concluidas');

  function criarElementoTarefa(tarefa) {
    const li = document.createElement('li');
    li.className = 'flex justify-between items-center px-4 py-2 shadow';
    li.style.backgroundColor = tarefa.concluida ? 'GreenYellow' : 'white';

    const span = document.createElement('span');
    span.textContent = tarefa.nome;
    span.className = 'text-gray-800';

    const divBotoes = document.createElement('div');
    divBotoes.className = 'flex gap-2';

    const btnConcluir = document.createElement('button');
    btnConcluir.textContent = '✅';
    btnConcluir.className = 'text-green-500 hover:text-green-700';
    btnConcluir.addEventListener('click', async () => {
      try {
        const resposta = await fetch(`${API_URL}/tasks/${tarefa.id}/concluir`, {
          method: 'PATCH',
        });

        if (resposta.ok) {
          carregarTarefas();
        } else {
          alert('Erro ao concluir tarefa.');
        }
      } catch (erro) {
        console.error('Erro ao concluir tarefa:', erro);
      }
    });

    const btnVoltar = document.createElement('button');
    btnVoltar.textContent = '🔙';
    btnVoltar.className = 'text-yellow-500 hover:text-yellow-700';
    btnVoltar.addEventListener('click', async () => {
      try {
        const resposta = await fetch(`${API_URL}/tasks/${tarefa.id}/voltar`, {
          method: 'PATCH',
        });

        if (resposta.ok) {
          carregarTarefas();
        } else {
          alert('Erro ao voltar tarefa.');
        }
      } catch (erro) {
        console.error('Erro ao voltar tarefa:', erro);
      }
    });

    const btnEditar = document.createElement('button');
    btnEditar.textContent = '✏️';
    btnEditar.className = 'text-blue-500 hover:text-blue-700';
    btnEditar.addEventListener('click', () => {
      const inputEdit = document.createElement('input');
      inputEdit.value = span.textContent;
      inputEdit.className = 'border border-gray-300 rounded px-2 py-1 focus:outline-none focus:ring-2 focus:ring-purple-400';
      li.replaceChild(inputEdit, span);

      const btnSalvar = document.createElement('button');
      btnSalvar.textContent = 'Salvar';
      btnSalvar.className = 'text-green-500 hover:text-green-700';

      const salvarEdicao = async () => {
        const textoNovo = inputEdit.value.trim();
        if (textoNovo !== '') {
          try {
            const resposta = await fetch(`${API_URL}/tasks/${tarefa.id}`, {
              method: 'PUT',
              headers: {
                'Content-Type': 'application/json'
              },
              body: JSON.stringify({ nome: textoNovo })
            });

            if (resposta.ok) {
              const tarefaAtualizada = await resposta.json();
              span.textContent = tarefaAtualizada.nome;
              li.replaceChild(span, inputEdit);
              divBotoes.replaceChild(btnEditar, btnSalvar);
            } else {
              alert('Erro ao editar tarefa.');
            }
          } catch (erro) {
            console.error('Erro ao editar tarefa:', erro);
          }
        }
      };

      btnSalvar.addEventListener('click', salvarEdicao);
      inputEdit.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
          salvarEdicao();
        }
      });

      divBotoes.replaceChild(btnSalvar, btnEditar);
    });

    const btnExcluir = document.createElement('button');
    btnExcluir.textContent = '🗑️';
    btnExcluir.className = 'text-red-500 hover:text-red-700';
    btnExcluir.addEventListener('click', async () => {
      try {
        const resposta = await fetch(`${API_URL}/tasks/${tarefa.id}`, {
          method: 'DELETE'
        });

        if (resposta.ok) {
          li.remove();
        } else {
          alert('Erro ao excluir tarefa.');
        }
      } catch (erro) {
        console.error('Erro ao excluir tarefa:', erro);
      }
    });

    // Mostrar o botão correto conforme status da tarefa
    if (tarefa.concluida) {
      divBotoes.appendChild(btnVoltar);
    } else {
      divBotoes.appendChild(btnConcluir);
    }

    divBotoes.appendChild(btnEditar);
    divBotoes.appendChild(btnExcluir);

    li.appendChild(span);
    li.appendChild(divBotoes);

    return li;
  }

  async function carregarTarefas() {
    try {
      const resposta = await fetch(`${API_URL}/tasks`);
      const tarefas = await resposta.json();

      listaPendentes.innerHTML = '';
      listaConcluidas.innerHTML = '';

      tarefas.forEach(tarefa => {
        const li = criarElementoTarefa(tarefa);
        if (tarefa.concluida) {
          listaConcluidas.appendChild(li);
        } else {
          listaPendentes.appendChild(li);
        }
      });
    } catch (erro) {
      console.error('Erro ao carregar tarefas:', erro);
    }
  }

  async function adicionarTarefa() {
    const nomeTarefa = input.value.trim();

    if (!nomeTarefa) {
      alert('Digite uma tarefa antes de adicionar!');
      return;
    }

    try {
      const resposta = await fetch(`${API_URL}/tasks`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ nome: nomeTarefa })
      });

      if (resposta.ok) {
        input.value = '';
        carregarTarefas();
      } else {
        alert('Erro ao adicionar tarefa.');
      }
    } catch (erro) {
      console.error('Erro ao adicionar tarefa:', erro);
    }
  }

  botaoAdicionar.addEventListener('click', adicionarTarefa);
  input.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      adicionarTarefa();
    }
  });

  carregarTarefas();
});
