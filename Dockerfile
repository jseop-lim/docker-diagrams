FROM python:3.11.1-alpine

COPY cacert.pem /usr/local/share/ca-certificates/cacert.crt
RUN cat /usr/local/share/ca-certificates/cacert.crt >> /etc/ssl/certs/ca-certificates.crt
RUN apk add --update --no-cache \
    curl \
    graphviz \
    gcc \
    libc-dev \
    libffi-dev \
    ttf-freefont \
    coreutils
RUN curl -sSL https://install.python-poetry.org | python3 -
RUN apk del \
    gcc \
    libc-dev \
    libffi-dev

WORKDIR /tmp
COPY pyproject.toml poetry.lock ./
RUN /root/.local/bin/poetry config virtualenvs.create false && \
    /root/.local/bin/poetry install --no-dev && \
    rm -rf /tmp

WORKDIR /out
ENTRYPOINT ["python"]
