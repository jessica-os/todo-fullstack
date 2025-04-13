from flask import Blueprint, jsonify, request
import json
import os

tasks_bp = Blueprint("tasks", __name__, url_prefix="/tasks")

DATABASE_PATH = os.path.join(os.path.dirname(__file__), "..", "database.json")

def ler_tarefas():
    with open(DATABASE_PATH, "r") as f:
        return json.load(f)

def salvar_tarefas(tarefas):
    with open(DATABASE_PATH, "w") as f:
        json.dump(tarefas, f, indent=4)

# Listar todas as tarefas
@tasks_bp.route("/", methods=["GET"])
def listar_tarefas():
    tarefas = ler_tarefas()
    return jsonify(tarefas)

# Adicionar nova tarefa
@tasks_bp.route("/", methods=["POST"])
def adicionar_tarefa():
    nova_tarefa = request.get_json()

    if not nova_tarefa or "titulo" not in nova_tarefa:
        return jsonify({"erro": "Campo 'titulo' é obrigatório"}), 400

    tarefas = ler_tarefas()
    nova_tarefa["id"] = len(tarefas) + 1
    nova_tarefa["concluida"] = False
    tarefas.append(nova_tarefa)
    salvar_tarefas(tarefas)
    return jsonify(nova_tarefa), 201

@tasks_bp.route("/<int:id>", methods=["PUT"])
def editar_tarefa(id):
    tarefas = ler_tarefas()
    dados = request.get_json()

    for tarefa in tarefas:
        if tarefa["id"] == id:
            tarefa["titulo"] = dados.get("titulo", tarefa["titulo"])
            salvar_tarefas(tarefas)
            return jsonify(tarefa)

    return jsonify({"erro": "Tarefa não encontrada"}), 404

@tasks_bp.route("/<int:id>/concluir", methods=["PATCH"])
def concluir_tarefa(id):
    tarefas = ler_tarefas()

    for tarefa in tarefas:
        if tarefa["id"] == id:
            tarefa["concluida"] = not tarefa["concluida"]
            salvar_tarefas(tarefas)
            return jsonify(tarefa)

    return jsonify({"erro": "Tarefa não encontrada"}), 404

@tasks_bp.route("/<int:id>", methods=["DELETE"])
def excluir_tarefa(id):
    tarefas = ler_tarefas()
    tarefas_novas = [t for t in tarefas if t["id"] != id]

    if len(tarefas) == len(tarefas_novas):
        return jsonify({"erro": "Tarefa não encontrada"}), 404

    salvar_tarefas(tarefas_novas)
    return jsonify({"mensagem": "Tarefa excluída com sucesso"}), 200


