# typademic

Typademic turns distraction freely written markdown files into beatiful PDFs. Built with love, [Flask](http://flask.pocoo.org/), [Pandoc](http://pandoc.org/), [LaTeX](https://www.latex-project.org/), [Google Fonts](https://fonts.google.com/) and [Bulma.io](https://bulma.io/).

[![CircleCI](https://circleci.com/gh/maehr/typademic.svg?style=svg&circle-token=f7ea42d593cc8107242a9ebd489b025c4c33328f)](https://circleci.com/gh/maehr/typademic)
[![codecov](https://codecov.io/gh/maehr/typademic/branch/master/graph/badge.svg)](https://codecov.io/gh/maehr/typademic)
[![Requirements Status](https://requires.io/github/maehr/typademic/requirements.svg?branch=master)](https://requires.io/github/maehr/typademic/requirements/?branch=master)
[![GitHub issues](https://img.shields.io/github/issues/maehr/typademic.svg)](https://github.com/maehr/typademic/issues)
[![GitHub forks](https://img.shields.io/github/forks/maehr/typademic.svg)](https://github.com/maehr/typademic/network)
[![GitHub stars](https://img.shields.io/github/stars/maehr/typademic.svg)](https://github.com/maehr/typademic/stargazers)
[![GitHub license](https://img.shields.io/github/license/maehr/typademic.svg)](https://github.com/maehr/typademic/blob/master/LICENSE.md)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

Install all this to use all functions of typademic.

- [Python 3.6.6](https://www.python.org/downloads/release/python-366/)
- [OpenSSL 1.0.2](https://www.openssl.org/source/)
- [Pandoc 2.2](http://pandoc.org/installing.html)
- [Pandoc Citeproc](https://github.com/jgm/pandoc-citeproc)
- [LaTeX](https://www.latex-project.org/get/)
- [Google Fonts](https://github.com/google/fonts)

#### Mac with [Homebrew](https://brew.sh/index_de)

```bash
brew install python openssl pandoc pandoc-citeproc mactex
curl https://raw.githubusercontent.com/qrpike/Web-Font-Load/master/install.sh | bash
```

#### Ubuntu 16.04

```bash
sudo add-apt-repository ppa:jonathonf/python-3.6
sudo apt-get update -y
sudo apt-get install -y python3.6 texlive-full pandoc pandoc-citeproc

https://raw.githubusercontent.com/qrpike/Web-Font-Load/master/install.sh | bash

pip install --upgrade pip
```

### Installing

```bash
virtualenv venv
cd venv
source bin/activate
cd ..
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

## Deployment

Install [Docker CE](https://www.docker.com/community-edition).

```bash
export GOOGLE_ANALYTICS=UA-YOURGOOGLECODE
export SECRET_KEY=SOMESECRETKEY
docker-compose up
```

To further strengthen your deployment process you should:

- copy `key.pem` and `cert.pem` to the root to add a valid ssl certificate
- create a `secrets.env` for your env vars

## Built With

* [Bulma.io](https://bulma.io/)
* [CircleCI](https://circleci.com)
* [Docker CE](https://www.docker.com/community-edition)
* [Flask](http://flask.pocoo.org/)
* [Pandoc](http://pandoc.org/)
* [LaTeX](https://www.latex-project.org/)
* [Google Fonts](https://fonts.google.com/)

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
