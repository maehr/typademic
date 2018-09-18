# typademic

Typademic turns distraction freely written markdown files into beautiful PDFs. Built with love, [Google Fonts](https://fonts.google.com/), [Pandoc](http://pandoc.org/), and [LaTeX](https://www.latex-project.org/).

[![Docs](https://readthedocs.org/projects/pip/badge/?version=latest&style=plastic)](https://docs.typademic.ch/)
[![CircleCI](https://circleci.com/gh/maehr/typademic.svg?style=shield&circle-token=f7ea42d593cc8107242a9ebd489b025c4c33328f)](https://circleci.com/gh/maehr/typademic)
[![Build Status](https://travis-ci.org/maehr/typademic.svg?branch=master)](https://travis-ci.org/maehr/typademic)
[![codecov](https://codecov.io/gh/maehr/typademic/branch/master/graph/badge.svg)](https://codecov.io/gh/maehr/typademic)
[![Maintainability](https://api.codeclimate.com/v1/badges/ea819aa50e494e14fd13/maintainability)](https://codeclimate.com/github/maehr/typademic/maintainability)
[![Requirements Status](https://requires.io/github/maehr/typademic/requirements.svg?branch=master)](https://requires.io/github/maehr/typademic/requirements/?branch=master)
[![GitHub issues](https://img.shields.io/github/issues/maehr/typademic.svg)](https://github.com/maehr/typademic/issues)
[![GitHub forks](https://img.shields.io/github/forks/maehr/typademic.svg)](https://github.com/maehr/typademic/network)
[![GitHub stars](https://img.shields.io/github/stars/maehr/typademic.svg)](https://github.com/maehr/typademic/stargazers)
[![GitHub license](https://img.shields.io/github/license/maehr/typademic.svg)](https://github.com/maehr/typademic/blob/master/LICENSE.md)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Install all this to use all functions of typademic.

- [Google Fonts](https://github.com/google/fonts)
- [LaTeX](https://www.latex-project.org/get/)
- [Pandoc 2.2](http://pandoc.org/installing.html)
- [Pandoc Citeproc](https://github.com/jgm/pandoc-citeproc)
- [Python 3.6](https://www.python.org/downloads/release/python-366/)
- [OpenSSL 1.0.2](https://www.openssl.org/source/)


#### Mac with [Homebrew](https://brew.sh/index_de)

```bash
brew install python openssl pandoc pandoc-citeproc mactex wget
wget https://raw.githubusercontent.com/qrpike/Web-Font-Load/master/install.sh | bash
```

#### Ubuntu 18.04

```bash
sudo apt-get update -y
sudo apt-get install -y texlive-full pandoc pandoc-citeproc wget

wget https://raw.githubusercontent.com/qrpike/Web-Font-Load/master/install.sh | bash

pip install --upgrade pip
```

#### Ubuntu 16.04

```bash
sudo add-apt-repository ppa:jonathonf/python-3.6
sudo apt-get update -y
sudo apt-get install -y python3.6 texlive-full pandoc pandoc-citeproc wget

wget https://raw.githubusercontent.com/qrpike/Web-Font-Load/master/install.sh | bash

pip install --upgrade pip
```

### Installing

```bash
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Start the development server

```bash
python app.py
```

## Running the tests

```bash
python pytest
```

## Deployment (BEGINNER)

1. Install [Docker CE](https://www.docker.com/community-edition).

2. Export your secrets and start the latest [typademic docker image](https://hub.docker.com/r/maehr/typademic/).

```bash
export GOOGLE_ANALYTICS=UA-YOURGOOGLECODE
export SECRET_KEY=SOMESECRETKEY
docker run --name typademic \
    -p 443:8000 \
    -e "GOOGLE_ANALYTICS=${GOOGLE_ANALYTICS}" \
    -e "SECRET_KEY=${SECRET_KEY}" \
    -v "/home/web/uploads" \
    -v "/home/web/logs" \
    maehr/typademic:latest
```

3. Go to https://localhost/ (If you did not add valid SSL certificates, ignore the error message.)

## Deployment (ADVANCED)

1. Add your custom SSL certificates (`key.pem` and `crt.pem`) to the root directory. Otherwise private certificates will be issued.

2. Create a `secrets.env` and add your env vars.

```bash
cp secrets.example.env secrets.env
nano secrets.env
```

3. Change `docker-compose.yml` accordingly.

```yaml
# uncomment this line for production use
# env_file: ./secrets.env

# comment this line for production use
environment:
  - GOOGLE_ANALYTICS=${GOOGLE_ANALYTICS}
  - SECRET_KEY=${SECRET_KEY}
```

4. Start typademic and go to https://localhost/

```bash
docker-compose up
```

## Built With

* [Bulma.io](https://bulma.io/)
* [CircleCI](https://circleci.com/)
* [Docker CE](https://www.docker.com/community-edition)
* [Flask](http://flask.pocoo.org/)
* [Flask-Dropzone](https://github.com/greyli/flask-dropzone)
* [Flask-WTF](https://flask-wtf.readthedocs.io/)
* [Google Fonts](https://fonts.google.com/)
* [LaTeX](https://www.latex-project.org/)
* [Pandoc](http://pandoc.org/)
* [Web-Font-Loader](https://github.com/qrpike/Web-Font-Load)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/maehr/typademic/tags).

## Authors

* **Moritz Mähr** - *Initial work* - [maehr](https://github.com/maehr)

See also the list of [contributors](https://github.com/maehr/typademic/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* [John Gruber](https://daringfireball.net/projects/markdown/)
* [John MacFarlane](http://johnmacfarlane.net/)
* [Sarah Simpkin, "Getting Started with Markdown," The Programming Historian 4 (2015)](https://programminghistorian.org/en/lessons/getting-started-with-markdown)
* [Dennis Tenen and Grant Wythoff, "Sustainable Authorship in Plain Text using Pandoc and Markdown," The Programming Historian 3 (2014)](https://programminghistorian.org/en/lessons/sustainable-authorship-in-plain-text-using-pandoc-and-markdown)
