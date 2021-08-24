# FROM pandoc/core:latest
# FROM dxjoke/tectonic-docker:latest
FROM python:3.9

ENV TINI_VERSION="v0.19.0"
ENV PIP_NO_CACHE_DIR=True
ENV POETRY_VIRTUALENVS_CREATE=False

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

RUN pip install -U \
    pip \
    setuptools \
    wheel \
    poetry


WORKDIR /src

RUN useradd -m -r user && \
    chown user /project

COPY poetry.lock pyproject.toml ./
RUN poetry install --no-dev && \
    rm -rf ~/.cache/pypoetry/{cache,artifacts}

COPY . .

USER user

ARG GIT_HASH
ENV GIT_HASH=${GIT_HASH:-dev}

ENTRYPOINT ["/tini", "--"]

CMD ["run streamlit", "run", "app.py"]