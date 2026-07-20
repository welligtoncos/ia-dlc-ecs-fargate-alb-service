"""Aplicação FastAPI do lab hello-fargate."""

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

from api import router

app = FastAPI(title="hello-fargate", version="0.1.0")
app.include_router(router)


@app.exception_handler(Exception)
async def unhandled_exception_handler(_request: Request, _exc: Exception) -> JSONResponse:
    """Erro genérico 500 sem vazar detalhes internos ao cliente."""
    return JSONResponse(status_code=500, content={"detail": "internal_error"})
