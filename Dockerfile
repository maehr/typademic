FROM pandoc/latex:2.11.0.4

MAINTAINER Moritz Mähr "moritz.maehr@gmail.com"

RUN apk --no-cache add python3 py3-pip texlive-full wget

RUN wget https://github.com/google/fonts/archive/master.zip
RUN unzip master.zip -d /usr/share/fonts
RUN rm master.zip
RUN fc-cache -fv

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
