# Local Development Setup (Django)

## Prerequisites

- Python 3.13+
- PostgreSQL running locally
- `uv` installed (https://github.com/astral-sh/uv)

---

## Setup

### 1. Activate virtual environment

```bash
uv venv
source .venv/bin/activate
```

### 2. Install dependencies

```bash
uv sync
```

---

## Environment Variables

Export required variables before running the app:

```bash
export POSTGRES_NAME=postgres
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432
```

---

## Database Setup

Run migrations:

```bash
python manage.py migrate
```

---

## Run Development Server

```bash
python manage.py runserver localhost:8000
```
