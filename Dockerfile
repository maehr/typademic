FROM python:3

MAINTAINER Moritz Mähr "moritz.maehr@gmail.com"

WORKDIR /usr/src/app

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3-minimal python3-pip texlive-full wget

RUN wget https://github.com/jgm/pandoc/releases/download/2.5/pandoc-2.5-1-amd64.deb
RUN dpkg -i pandoc-2.5-1-amd64.deb

RUN wget https://github.com/google/fonts/archive/master.zip
RUN unzip master.zip -d /usr/share/fonts
RUN rm master.zip
RUN fc-cache -fv

COPY requirements.txt ./
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn

COPY . .

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
