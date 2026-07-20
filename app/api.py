"""Rotas HTTP da API de estudo."""

from fastapi import APIRouter
from fastapi.responses import PlainTextResponse

router = APIRouter()


@router.get("/", response_class=PlainTextResponse)
def get_hello() -> str:
    """Retorna Hello World em text/plain."""
    return "Hello World"


@router.get("/health")
def get_health() -> dict[str, str]:
    """Health check shallow para o lab."""
    return {"status": "ok", "service": "hello-fargate"}
