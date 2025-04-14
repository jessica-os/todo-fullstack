from flask import Blueprint, jsonify, request
import json
import os

tasks_bp = Blueprint("tasks", __name__, url_prefix="/tasks")

# Caminho para o arquivo database.json
DATABASE_PATH = os.path.join(os.path.dirname(__file__), "..", "database.json")

# Função para ler as tarefas do arquivo
def ler_tarefas():
    if not os.path.exists(DATABASE_PATH):
        return []
    with open(DATABASE_PATH, "r") as f:
        return json.load(f)

# Função para salvar as tarefas no arquivo
def salvar_tarefas(tarefas):
    with open(DATABASE_PATH, "w") as f:
        json.dump(tarefas, f, indent=4)

# GET /tasks/ - Lista todas as tarefas
@tasks_bp.route("/", methods=["GET"])
def listar_tarefas():
    tarefas = ler_tarefas()
    return jsonify(tarefas)

# POST /tasks/ - Adiciona nova tarefa
@tasks_bp.route("", methods=["POST"])

def adicionar_tarefa():
    nova_tarefa = request.get_json()

    if not nova_tarefa or "nome" not in nova_tarefa:
        return jsonify({"erro": "Campo 'nome' é obrigatório"}), 400

    tarefas = ler_tarefas()
    nova_tarefa["id"] = (tarefas[-1]["id"] + 1) if tarefas else 1
    nova_tarefa["concluida"] = False
    tarefas.append(nova_tarefa)
    salvar_tarefas(tarefas)
    return jsonify(nova_tarefa), 201

# PUT /tasks/<id> - Editar o nome da tarefa
@tasks_bp.route("/<int:id>", methods=["PUT"])
def editar_tarefa(id):
    tarefas = ler_tarefas()
    dados = request.get_json()

    for tarefa in tarefas:
        if tarefa["id"] == id:
            tarefa["nome"] = dados.get("nome", tarefa["nome"])
            salvar_tarefas(tarefas)
            return jsonify(tarefa)

    return jsonify({"erro": "Tarefa não encontrada"}), 404

# PATCH /tasks/<id>/concluir - Alterna a conclusão da tarefa
@tasks_bp.route("/<int:id>/concluir", methods=["PATCH"])
def concluir_tarefa(id):
    tarefas = ler_tarefas()

    for tarefa in tarefas:
        if tarefa["id"] == id:
            tarefa["concluida"] = not tarefa["concluida"]
            salvar_tarefas(tarefas)
            return jsonify(tarefa)

    return jsonify({"erro": "Tarefa não encontrada"}), 404

# DELETE /tasks/<id> - Excluir tarefa
@tasks_bp.route("/<int:id>", methods=["DELETE"])
def excluir_tarefa(id):
    tarefas = ler_tarefas()
    tarefas_novas = [t for t in tarefas if t["id"] != id]

    if len(tarefas) == len(tarefas_novas):
        return jsonify({"erro": "Tarefa não encontrada"}), 404

    salvar_tarefas(tarefas_novas)
    return jsonify({"mensagem": "Tarefa excluída com sucesso"}), 200
