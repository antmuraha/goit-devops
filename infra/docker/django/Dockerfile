FROM ghcr.io/astral-sh/uv:python3.13-alpine

# Set environment variables for Python
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
# ENV PYTHONPATH=/usr/src/app/.venv/bin
ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /app

COPY pyproject.toml uv.lock ./

RUN uv sync --frozen --no-dev && \
	python -c "import django; print(django.__version__)"

COPY . .

EXPOSE 8000
CMD ["uv", "run","python", "manage.py", "runserver", "0.0.0.0:8000"]
