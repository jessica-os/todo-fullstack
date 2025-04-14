document.addEventListener('DOMContentLoaded', () => {
  const input = document.getElementById('nova-tarefa');
  const botaoAdicionar = document.getElementById('adicionar-tarefa');
  const lista = document.getElementById('lista-tarefas');

  // Função que cria o elemento de uma tarefa no DOM
  function criarElementoTarefa(tarefa) {
    const li = document.createElement('li');
    li.className = 'bg-white flex justify-between items-center px-4 py-2 rounded shadow';

    const span = document.createElement('span');
    span.textContent = tarefa.nome;
    span.className = 'text-gray-800';

    const divBotoes = document.createElement('div');
    divBotoes.className = 'flex gap-2';

    const btnEditar = document.createElement('button');
    btnEditar.textContent = '✏️';
    btnEditar.className = 'text-blue-500 hover:text-blue-700';

    // Funcionalidade do botão editar
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
            const resposta = await fetch(`http://localhost:5000/tasks/${tarefa.id}`, {
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

      // Clique no botão salvar
      btnSalvar.addEventListener('click', salvarEdicao);

      // Pressionar Enter para salvar
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
        const resposta = await fetch(`http://localhost:5000/tasks/${tarefa.id}`, {
          method: 'DELETE'
        });

        if (resposta.ok) {
          lista.removeChild(li);
        } else {
          alert('Erro ao excluir tarefa.');
        }
      } catch (erro) {
        console.error('Erro ao excluir tarefa:', erro);
      }
    });

    divBotoes.appendChild(btnEditar);
    divBotoes.appendChild(btnExcluir);

    li.appendChild(span);
    li.appendChild(divBotoes);

    return li;
  }

  // Função para carregar tarefas do backend
  async function carregarTarefas() {
    try {
      const resposta = await fetch('http://localhost:5000/tasks');
      const tarefas = await resposta.json();
      lista.innerHTML = ''; // limpa a lista antes de adicionar novamente

      tarefas.forEach(tarefa => {
        const li = criarElementoTarefa(tarefa);
        lista.appendChild(li);
      });
    } catch (erro) {
      console.error('Erro ao carregar tarefas:', erro);
    }
  }

  // Função para adicionar nova tarefa (envia pro backend e atualiza a lista)
  async function adicionarTarefa() {
    const nomeTarefa = input.value.trim();

    if (!nomeTarefa) {
      alert('Digite uma tarefa antes de adicionar!');
      return;
    }

    try {
      const resposta = await fetch('http://localhost:5000/tasks', {
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

  // Eventos de clique e tecla Enter
  botaoAdicionar.addEventListener('click', adicionarTarefa);

  input.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      adicionarTarefa();
    }
  });

  // Carrega tarefas ao abrir a página
  carregarTarefas();
});
