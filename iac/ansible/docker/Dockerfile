FROM python:3.12-slim

ENV ANSIBLE_STDOUT_CALLBACK=ansible.builtin.default
ENV ANSIBLE_CONFIG=/app/ansible.cfg

RUN apt-get update \
    && apt-get install --no-install-recommends --yes ca-certificates git openssh-client \
    && rm -rf /var/lib/apt/lists/* \
    && python -m pip install --no-cache-dir \
        ansible-core>=2.17,<2.19 \
        ansible-lint>=24.0 \
        kubernetes>=30.0

RUN useradd --create-home --shell /bin/bash ansible

WORKDIR /app
COPY --chown=ansible:ansible . /app
USER ansible
