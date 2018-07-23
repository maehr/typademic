FROM circleci/python:3.6.6

MAINTAINER Moritz Mähr "moritz.maehr@gmail.com"

USER root

RUN apt-get update -y
RUN apt-get install -y texlive-full pandoc pandoc-citeproc

## Install Google Fonts on Ubuntu
RUN wget https://github.com/google/fonts/archive/master.zip
RUN unzip master.zip -d /usr/share/fonts
RUN rm master.zip
## Register fonts
RUN sudo fc-cache -fv

RUN pip install --upgrade pip

COPY requirements.txt /opt/app/requirements.txt
RUN pip install -r /opt/app/requirements.txt
RUN pip install gunicorn

COPY generate_ssl.sh /opt/app/generate_ssl.sh
RUN sh /opt/app/generate_ssl.sh

USER circleci
COPY . /opt/app
WORKDIR /opt/app
RUN export GUNICORN_CMD_ARGS="--bind :8000 --access-logfile --error-logfile --workers=4 --certfile www.example.com.cert --keyfile www.example.com.key"
ENTRYPOINT ["gunicorn"]
CMD ["app:app"]
