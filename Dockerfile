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

# TODO generate private ssl certificates
# COPY generate_ssl.sh /opt/app/generate_ssl.sh
# RUN sh /opt/app/generate_ssl.sh

# TODO use deployment server with ssl
# RUN export GUNICORN_CMD_ARGS="--bind :8000 --access-logfile --error-logfile --workers=4 --certfile crt.pem --keyfile key.pem"
# ENTRYPOINT ["gunicorn"]
# CMD ["app:app"]

ENTRYPOINT [ "python" ]
CMD [ "app.py" ]
