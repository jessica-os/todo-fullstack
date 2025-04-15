from flask import Flask
from flask_cors import CORS
from models import db
from routes.tasks import tasks_bp

app = Flask(__name__)

# Libera requisições do Live Server (127.0.0.1:5500)
CORS(app, resources={r"/tasks/*": {"origins": "http://127.0.0.1:5500"}})


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

if __name__ == "__main__":
    app.run(debug=True)
