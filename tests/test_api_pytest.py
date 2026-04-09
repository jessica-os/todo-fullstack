import sys
import os

# adiciona a pasta backend ao path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'backend')))

from app import app
import pytest


@pytest.fixture
def client():
    app.config['TESTING'] = True
    return app.test_client()

# comentário
def test_get_tasks(client):
    response = client.get("/tasks")

    assert response.status_code == 200
    assert isinstance(response.json, list)