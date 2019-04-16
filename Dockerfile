FROM python:3.7

MAINTAINER Moritz Mähr "moritz.maehr@gmail.com"

RUN apt-get update -y
RUN apt-get install -y texlive-full wget

RUN wget https://github.com/jgm/pandoc/releases/download/2.7.2/pandoc-2.7.2-1-amd64.deb
RUN dpkg -i pandoc-2.7.2-1-amd64.deb

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
