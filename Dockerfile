FROM circleci/python:3.6.5

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

RUN adduser --disabled-login app

WORKDIR /home/app

COPY requirements.txt requirements.txt
RUN python -m venv venv
RUN venv/bin/pip install -r requirements.txt
RUN venv/bin/pip install gunicorn

COPY app app
COPY app.py boot.sh ./
RUN chmod a+x boot.sh

ENV FLASK_APP app.py

RUN chown -R app:app ./
USER app

EXPOSE 5000
ENTRYPOINT ["./boot.sh"]

#USER circleci
#
#COPY requirements.txt requirements.txt
#RUN python -m venv venv
#RUN venv/bin/pip install -r requirements.txt
#RUN venv/bin/pip install gunicorn

## We copy just the requirements.txt first to leverage Docker cache
#COPY requirements.txt /app/requirements.txt
#WORKDIR /app
#RUN pip install -r requirements.txt
#COPY . /app
#ENTRYPOINT [ "python" ]
#CMD [ "app.py" ]
