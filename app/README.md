# Local Development Setup (Django)

## Prerequisites

- Python 3.9+
- PostgreSQL running locally

---

## Setup

### 1. Activate virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

---

## Environment Variables

Export required variables before running the app:

```bash
export POSTGRES_NAME=postgres
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres
# POSTGRES_HOST run Django with venv
export POSTGRES_HOST=localhost
# POSTGRES_HOST run Django with compose
export POSTGRES_HOST=db
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
