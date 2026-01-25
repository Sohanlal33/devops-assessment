# __________________________________
#         Build stage
# _________________________________
FROM python:3.12-slim AS builder

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

#__________________________________
#       Runtime stage
#__________________________________
FROM python:3.12-slim

WORKDIR /app

# Non-root user
RUN groupadd -r django && useradd -r -g django django

COPY --from=builder /usr/local /usr/local
COPY . .

RUN chown -R django:django /app

USER django

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "config.wsgi:application"]


