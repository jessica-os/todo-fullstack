document.addEventListener('DOMContentLoaded', () => {
  const input = document.getElementById('nova-tarefa');
  const botaoAdicionar = document.getElementById('adicionar-tarefa');
  const lista = document.getElementById('lista-tarefas');

  // Função para adicionar nova tarefa
  function adicionarTarefa() {
    const textoTarefa = input.value.trim();
    if (textoTarefa === '') {
      // Exibe uma mensagem de alerta se o input estiver vazio
      alert('Por favor, digite uma tarefa antes de adicionar!');
      return; // Impede a adição de uma tarefa vazia
    }

    const li = document.createElement('li');
    li.className = 'bg-white flex justify-between items-center px-4 py-2 rounded shadow';

    const span = document.createElement('span');
    span.textContent = textoTarefa;
    span.className = 'text-gray-800';

    // Botões de editar e excluir
    const divBotoes = document.createElement('div');
    divBotoes.className = 'flex gap-2';

    const btnEditar = document.createElement('button');
    btnEditar.textContent = '✏️';
    btnEditar.className = 'text-blue-500 hover:text-blue-700';

    // Funcionalidade do botão de editar
    btnEditar.addEventListener('click', () => {
      // Substitui o texto da tarefa por um campo de input para edição
      const inputEdit = document.createElement('input');
      inputEdit.value = span.textContent; // Atribui o texto atual da tarefa
      inputEdit.className = 'border border-gray-300 rounded px-2 py-1 focus:outline-none focus:ring-2 focus:ring-purple-400';

      // Substitui o span pelo input de edição
      li.replaceChild(inputEdit, span);

      // Troca o botão de editar pelo de salvar
      const btnSalvar = document.createElement('button');
      btnSalvar.textContent = 'Salvar';
      btnSalvar.className = 'text-green-500 hover:text-green-700';

      // Funcionalidade do botão salvar
      btnSalvar.addEventListener('click', () => {
        const textoNovo = inputEdit.value.trim();
        if (textoNovo !== '') {
          span.textContent = textoNovo; // Atualiza o texto da tarefa
        }

        // Substitui o input de volta pelo span com o novo texto
        li.replaceChild(span, inputEdit);
        
        // Substitui o botão salvar de volta para editar
        divBotoes.replaceChild(btnEditar, btnSalvar);
      });

      // Funcionalidade do Enter para salvar
      inputEdit.addEventListener('keydown', (e) => {
        if (e.key === 'Enter') {
          const textoNovo = inputEdit.value.trim();
          if (textoNovo !== '') {
            span.textContent = textoNovo; // Atualiza o texto da tarefa
          }

          // Substitui o input de volta pelo span com o novo texto
          li.replaceChild(span, inputEdit);

          // Substitui o botão salvar de volta para editar
          divBotoes.replaceChild(btnEditar, btnSalvar);
        }
      });

      divBotoes.replaceChild(btnSalvar, btnEditar);
    });

    const btnExcluir = document.createElement('button');
    btnExcluir.textContent = '🗑️';
    btnExcluir.className = 'text-red-500 hover:text-red-700';
    btnExcluir.addEventListener('click', () => {
      lista.removeChild(li);
    });

    divBotoes.appendChild(btnEditar);
    divBotoes.appendChild(btnExcluir);

    li.appendChild(span);
    li.appendChild(divBotoes);
    lista.appendChild(li);

    input.value = '';
    input.focus();
  }

  botaoAdicionar.addEventListener('click', adicionarTarefa);

  input.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
      adicionarTarefa();
    }
  });
});
