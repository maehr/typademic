FROM pandoc/latex:2.18.0.0

MAINTAINER Moritz Mähr "moritz.maehr@gmail.com"

RUN apk --no-cache add make openssl python3 py3-pip texlive-full wget

RUN wget https://github.com/google/fonts/archive/main.tar.gz -O gf.tar.gz
RUN tar -xf gf.tar.gz
RUN mkdir -p /usr/share/fonts/truetype/google-fonts
RUN find $PWD/fonts-main/ -name "*.ttf" -exec install -m644 {} /usr/share/fonts/truetype/google-fonts/ \; || return 1
RUN rm -f gf.tar.gz
RUN fc-cache -f && rm -rf /var/cache/*
RUN tlmgr update --self
RUN tlmgr install float


ADD . /src
WORKDIR /src
RUN pip install --upgrade pip
RUN make install
RUN pip3 install gunicorn

RUN sh generate_ssl.sh

ENTRYPOINT ["gunicorn"]
CMD ["app:app", \
    "--bind=:8000", \
    "--workers=5", \
    "--log-level=info", \
    "--access-logfile=/logs/access.log", \
    "--error-logfile=/logs/error.log", \
    "--certfile=crt.pem", \
    "--keyfile=key.pem", \
    "--name=typademic"]
