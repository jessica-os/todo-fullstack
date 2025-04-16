from flask import Flask
from flask_cors import CORS
from models import db
from routes.tasks import tasks_bp
import os

app = Flask(__name__)

# Libera requisições de qualquer origem (temporariamente para testes)
CORS(app)

# Configuração do banco de dados SQLite
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///tasks.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Inicializa o banco
db.init_app(app)

# Registra as rotas
app.register_blueprint(tasks_bp)

# Criação das tabelas
with app.app_context():
    db.create_all()

# Executa a aplicação com configuração compatível com o Render
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
