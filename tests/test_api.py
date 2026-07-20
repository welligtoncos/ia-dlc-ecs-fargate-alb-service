"""Testes example-based da API (TestClient)."""

from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_get_hello_plain_text() -> None:
    response = client.get("/")
    assert response.status_code == 200
    assert response.text == "Hello World"
    assert "text/plain" in response.headers.get("content-type", "")


def test_get_health_json() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok", "service": "hello-fargate"}
