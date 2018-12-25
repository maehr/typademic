FROM ubuntu:18.04

MAINTAINER Moritz Mähr "moritz.maehr@gmail.com"

USER root

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3-minimal python3-pip texlive-full wget

RUN wget https://github.com/jgm/pandoc/releases/download/2.5/pandoc-2.5-1-amd64.deb
RUN dpkg -i pandoc-2.5-1-amd64.deb

RUN wget https://github.com/google/fonts/archive/master.zip
RUN unzip master.zip -d /usr/share/fonts
RUN rm master.zip
RUN fc-cache -fv

COPY requirements.txt /opt/app/requirements.txt
RUN pip3 install --upgrade pip
RUN pip3 install -r /opt/app/requirements.txt
RUN pip3 install gunicorn

WORKDIR /usr/app

COPY . .

COPY generate_ssl.sh /generate_ssl.sh
RUN sh /generate_ssl.sh

ENTRYPOINT ["gunicorn"]
CMD ["app:app", \
    "--bind=:8000", \
    "--workers=5", \
    "--log-level=info", \
    "--access-logfile=/home/web/logs/access.log", \
    "--error-logfile=/home/web/logs/error.log", \
    "--certfile=crt.pem", \
    "--keyfile=key.pem", \
    "--name=typademic"]
