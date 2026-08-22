# Multi-stage build: wheels are compiled in the builder stage and only the
# runtime dependencies are copied into the slim final image.
FROM python:3.12-slim AS builder

WORKDIR /build
COPY app/requirements.txt .
RUN pip wheel --no-cache-dir --wheel-dir /build/wheels -r requirements.txt

FROM python:3.12-slim

ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

RUN groupadd --gid 1000 appuser && useradd --uid 1000 --gid appuser --shell /usr/sbin/nologin appuser

WORKDIR /main
COPY --from=builder /build/wheels /wheels
COPY app/requirements.txt .
RUN pip install --no-cache-dir --no-index --find-links=/wheels -r requirements.txt && rm -rf /wheels

COPY ./app ./app

USER 1000:1000

EXPOSE 80

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80"]
