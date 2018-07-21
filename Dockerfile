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

USER circleci

# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install -r requirements.txt
COPY . /app
ENTRYPOINT [ "python" ]
CMD [ "app.py" ]
