FROM circleci/python:3.6.6

MAINTAINER Moritz Mähr "moritz.maehr@gmail.com"

USER root

RUN apt-get update -y
RUN apt-get install -y texlive-full pandoc pandoc-citeproc

RUN wget https://github.com/google/fonts/archive/master.zip
RUN unzip master.zip -d /usr/share/fonts
RUN rm master.zip
RUN sudo fc-cache -fv

COPY requirements.txt /opt/app/requirements.txt
RUN pip install --upgrade pip
RUN pip install -r /opt/app/requirements.txt
RUN pip install gunicorn

RUN useradd -ms /bin/bash web

COPY . /home/web
RUN chown -R web:web /home/web

USER web

WORKDIR /home/web

COPY generate_ssl.sh /generate_ssl.sh
RUN sh /generate_ssl.sh

ENTRYPOINT ["gunicorn"]
CMD ["app:app", "--bind=127.0.0.1:8000", "--name=typademic", "--workers=4", "--log-level=info", "--certfile=crt.pem", "--keyfile=key.pem"]
