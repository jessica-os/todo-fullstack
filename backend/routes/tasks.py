from flask import Blueprint, jsonify, request  # Certifique-se de que jsonify está importado aqui
from models import db, Task

tasks_bp = Blueprint("tasks", __name__, url_prefix="/tasks")

# Preflight para a rota base
@tasks_bp.route("", methods=["OPTIONS"])
def preflight_root():
    return '', 204

# GET /tasks - Lista todas as tarefas
@tasks_bp.route("", methods=["GET"])
def listar_tarefas():
    tarefas = Task.query.all()
    return jsonify([{
        "id": t.id,
        "nome": t.nome,
        "concluida": t.concluida
    } for t in tarefas])

# POST /tasks - Adiciona nova tarefa
@tasks_bp.route("", methods=["POST"])
def adicionar_tarefa():
    dados = request.get_json()
    if not dados or "nome" not in dados:
        return jsonify({"erro": "Campo 'nome' é obrigatório"}), 400

    nova_tarefa = Task(nome=dados["nome"])
    db.session.add(nova_tarefa)
    db.session.commit()

    return jsonify({
        "id": nova_tarefa.id,
        "nome": nova_tarefa.nome,
        "concluida": nova_tarefa.concluida
    }), 201

# Preflight para rotas com ID
@tasks_bp.route("/<int:id>", methods=["OPTIONS"])
def preflight_com_id(id):
    return '', 204

# PUT /tasks/<id> - Edita o nome da tarefa
@tasks_bp.route("/<int:id>", methods=["PUT"])
def editar_tarefa(id):
    tarefa = Task.query.get(id)
    if not tarefa:
        return jsonify({"erro": "Tarefa não encontrada"}), 404

    dados = request.get_json()
    tarefa.nome = dados.get("nome", tarefa.nome)
    db.session.commit()

    return jsonify({
        "id": tarefa.id,
        "nome": tarefa.nome,
        "concluida": tarefa.concluida
    })

# PATCH /tasks/<id>/concluir - Alterna conclusão da tarefa
@tasks_bp.route("/<int:id>/concluir", methods=["PATCH"])
def concluir_tarefa(id):
    tarefa = Task.query.get(id)
    if not tarefa:
        return jsonify({"erro": "Tarefa não encontrada"}), 404

    tarefa.concluida = not tarefa.concluida
    db.session.commit()

    return jsonify({
        "id": tarefa.id,
        "nome": tarefa.nome,
        "concluida": tarefa.concluida
    })

# PATCH /tasks/<id>/voltar - Volta a tarefa para pendente
@tasks_bp.route("/<int:id>/voltar", methods=["PATCH", "OPTIONS"])
def voltar_tarefa(id):
    tarefa = Task.query.get_or_404(id)
    tarefa.concluida = False

    db.session.commit()
    return jsonify({
        'id': tarefa.id,
        'nome': tarefa.nome,
        'concluida': tarefa.concluida
    }), 200


# DELETE /tasks/<id> - Exclui a tarefa
@tasks_bp.route("/<int:id>", methods=["DELETE"])
def excluir_tarefa(id):
    tarefa = Task.query.get(id)
    if not tarefa:
        return jsonify({"erro": "Tarefa não encontrada"}), 404

    db.session.delete(tarefa)
    db.session.commit()

    return jsonify({"mensagem": "Tarefa excluída com sucesso"})
