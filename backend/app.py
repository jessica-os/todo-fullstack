from flask import Flask
from flask_cors import CORS  # Importando o CORS
from routes.tasks import tasks_bp

# Criando a instância do Flask
app = Flask(__name__)

# Habilitando CORS para todas as rotas
CORS(app)

# Registrando o blueprint
app.register_blueprint(tasks_bp)

if __name__ == "__main__":
    app.run(debug=True)
