FROM python:3.9-slim-buster as python-base
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    VENV_PATH="/app/.venv"
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        build-essential \
        gcc \
        git \
        g++

ENV POETRY_VERSION=1.1.6
RUN curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python

WORKDIR /app
COPY ./poetry.lock ./pyproject.toml ./
RUN poetry install  --no-root --no-dev
COPY . .
RUN poetry install --no-dev

FROM python:3.9-slim-buster as production
COPY --from=python-base /app /app
ENV PATH="/app/.venv/bin/:$PATH"
EXPOSE 8000
ENV HOST="0.0.0.0"
ENV PORT=8000
ENTRYPOINT ["server"]
