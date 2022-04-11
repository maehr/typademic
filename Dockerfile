FROM python:3.9

ENV TINI_VERSION="v0.19.0"
ENV TECTONIC_VERSION="0.7.1"
ENV PANDOC_VERSION="2.14.2"
ENV PIP_NO_CACHE_DIR=True
ENV POETRY_VIRTUALENVS_CREATE=False

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

RUN pip install -U \
    pip \
    setuptools \
    wheel \
    poetry

RUN curl -LJO https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%40${TECTONIC_VERSION}/tectonic-${TECTONIC_VERSION}-x86_64-unknown-linux-gnu.tar.gz
RUN tar -xzf tectonic-${TECTONIC_VERSION}-x86_64-unknown-linux-gnu.tar.gz
RUN mv tectonic /usr/local/bin/tectonic
RUN chmod +x /usr/local/bin/tectonic

RUN curl -LJO https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz
RUN tar -xzf pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz
RUN mv pandoc-${PANDOC_VERSION}/bin/pandoc /usr/local/bin/pandoc
RUN chmod +x /usr/local/bin/pandoc

WORKDIR /src

RUN useradd -m -r user && \
    chown user /src

COPY poetry.lock pyproject.toml ./
RUN poetry install --no-dev && \
    rm -rf ~/.cache/pypoetry/{cache,artifacts}

COPY . .

USER user

ARG GIT_HASH
ENV GIT_HASH=${GIT_HASH:-dev}

EXPOSE 8501

ENTRYPOINT ["/tini", "--"]

CMD ["streamlit", "run", "src/app.py"]