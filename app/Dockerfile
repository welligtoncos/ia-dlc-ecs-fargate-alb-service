# Imagem da API Hello World para o lab Fargate.
# Build: docker build -t <ecr>/hello-fargate:latest ./app

ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-slim

WORKDIR /app

# Dependências de runtime (pytest/httpx também listados no requirements — leves para o lab).
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY __init__.py api.py main.py ./

# Usuário não-root (boa prática mínima do lab).
RUN useradd --create-home --shell /bin/bash appuser \
    && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
