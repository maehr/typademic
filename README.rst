typademic
=========

Typademic turns distraction freely written markdown files into beautiful
PDFs. Built with love, `Google Fonts <https://fonts.google.com/>`__,
`Pandoc <http://pandoc.org/>`__, and
`LaTeX <https://www.latex-project.org/>`__.

|Docs| |Build Status Docker| |CircleCI| |Build Status Travis| |Coverage|
|Maintainability| |PyUp| |Requirements Status| |GitHub issues|
|GitHub forks| |GitHub stars| |GitHub license|


Getting Started
---------------

These instructions will get you a copy of the project up and running on
your local machine for development and testing purposes. See deployment
for notes on how to deploy the project on a live system.

Prerequisites
~~~~~~~~~~~~~

Install all this to use all functions of typademic.

-  `Google Fonts <https://github.com/google/fonts>`__
-  `LaTeX <https://www.latex-project.org/get/>`__
-  `Pandoc <http://pandoc.org/installing.html>`__
-  `Pandoc Citeproc <https://github.com/jgm/pandoc-citeproc>`__
-  `Python 3 <https://www.python.org/downloads/>`__
-  `OpenSSL <https://www.openssl.org/source/>`__

Mac with `Homebrew <https://brew.sh/index_de>`__
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: bash

   brew install python openssl mactex pandoc pandoc-citeproc wget

   wget https://raw.githubusercontent.com/qrpike/Web-Font-Load/master/install.sh | bash

Ubuntu 18.04
^^^^^^^^^^^^

.. code:: bash

   sudo apt-get update -y
   sudo apt-get install -y texlive-full wget

   wget https://raw.githubusercontent.com/qrpike/Web-Font-Load/master/install.sh | bash

   wget -O pandoc.deb https://github.com/jgm/pandoc/releases/download/2.11.0.4/pandoc-2.11.0.4-1-amd64.deb
   sudo dpkg -i pandoc.deb

   pip install --upgrade pip

Installing
~~~~~~~~~~

.. code:: bash

   virtualenv venv
   source venv/bin/activate
   pip install .

Start the development server
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code:: bash

   python app.py

Running the tests
-----------------

.. code:: bash

   pip install tox
   tox

Deployment (BEGINNER)
---------------------

1. Install `Docker CE <https://www.docker.com/community-edition>`__.

2. Export your secrets and start the latest `typademic docker
   image <https://hub.docker.com/r/maehr/typademic/>`__.

.. code:: bash

   touch logs/error.log
   touch logs/access.log
   export SECRET_KEY=SOMESECRETKEY
   docker run --name typademic \
       -p 443:8000 \
       -e "SECRET_KEY=${SECRET_KEY}" \
       -v "./logs/error.log:/logs/error.log" \
       -v "./logs/access.log:/logs/access.log" \
       -v "./uploads/:/uploads/" \
       maehr/typademic:latest

3. Go to https://localhost/ (If you did not add valid SSL certificates,
   ignore the error message.)

Deployment (ADVANCED)
---------------------

1. Add your custom SSL certificates (``key.pem`` and ``crt.pem``) to the
   root directory. Otherwise private certificates will be issued.

2. Create a ``secrets.env`` and add your env vars.

.. code:: bash

   cp secrets.example.env secrets.env
   nano secrets.env

3. Change ``docker-compose.yml`` accordingly.

.. code:: yaml

   # uncomment this line for production use
   # env_file: ./secrets.env

   # comment this line for production use
   environment:
     - SECRET_KEY=${SECRET_KEY}

4. Start typademic and go to https://localhost/

.. code:: bash

   docker-compose up

Built With
----------

-  `Bulma.io <https://bulma.io/>`__
-  `CircleCI <https://circleci.com/>`__
-  `Cookiecutter <https://github.com/audreyr/cookiecutter>`__
-  `Docker CE <https://www.docker.com/community-edition>`__
-  `Flask <http://flask.pocoo.org/>`__
-  `Flask-Dropzone <https://github.com/greyli/flask-dropzone>`__
-  `Flask-WTF <https://flask-wtf.readthedocs.io/>`__
-  `Google Fonts <https://fonts.google.com/>`__
-  `LaTeX <https://www.latex-project.org/>`__
-  `Pandoc <http://pandoc.org/>`__
-  `Web-Font-Loader <https://github.com/qrpike/Web-Font-Load>`__


Contributing
------------

Please read `CONTRIBUTING.rst <CONTRIBUTING.rst>`__ for details on our
code of conduct, and the process for submitting pull requests to us.

Versioning
----------

We use `SemVer <http://semver.org/>`__ for versioning. For the versions
available, see the `tags on this
repository <https://github.com/maehr/typademic/tags>`__.

Authors
-------

Please read `AUTHORS.rst <AUTHORS.rst>`__ for details on the authors.
See also the list of `contributors <https://github.com/maehr/typademic/contributors>`__ who
participated in this project.

License
-------

This project is licensed under the MIT License - see the
`LICENSE.rst <LICENSE.rst>`__ file for details

Acknowledgments
---------------

-  `John Gruber <https://daringfireball.net/projects/markdown/>`__
-  `John MacFarlane <http://johnmacfarlane.net/>`__
-  `Sarah Simpkin, “Getting Started with Markdown,” The Programming
   Historian 4
   (2015) <https://programminghistorian.org/en/lessons/getting-started-with-markdown>`__
-  `Dennis Tenen and Grant Wythoff, “Sustainable Authorship in Plain
   Text using Pandoc and Markdown,” The Programming Historian 3
   (2014) <https://programminghistorian.org/en/lessons/sustainable-authorship-in-plain-text-using-pandoc-and-markdown>`__

.. |Docs| image:: https://readthedocs.org/projects/pip/badge/?version=latest&style=flat
   :target: https://docs.typademic.ch/
.. |CircleCI| image:: https://circleci.com/gh/maehr/typademic.svg?style=shield&circle-token=f7ea42d593cc8107242a9ebd489b025c4c33328f
   :target: https://circleci.com/gh/maehr/typademic
.. |Build Status Travis| image:: https://travis-ci.org/maehr/typademic.svg?branch=master
   :target: https://travis-ci.org/maehr/typademic
.. |Build Status Docker| image:: https://img.shields.io/docker/cloud/automated/maehr/typademic.svg
   :target: https://hub.docker.com/r/maehr/typademic/
   :alt: Docker Cloud Automated build
.. |Coverage| image:: https://api.codeclimate.com/v1/badges/ea819aa50e494e14fd13/test_coverage
   :target: https://codeclimate.com/github/maehr/typademic/test_coverage
   :alt: Test Coverage
.. |Maintainability| image:: https://api.codeclimate.com/v1/badges/ea819aa50e494e14fd13/maintainability
   :target: https://codeclimate.com/github/maehr/typademic/maintainability
.. |Requirements Status| image:: https://requires.io/github/maehr/typademic/requirements.svg?branch=master
   :target: https://requires.io/github/maehr/typademic/requirements/?branch=master
.. |PyUp| image:: https://pyup.io/repos/github/maehr/typademic/shield.svg
   :target: https://pyup.io/repos/github/maehr/typademic/
.. |GitHub issues| image:: https://img.shields.io/github/issues/maehr/typademic.svg
   :target: https://github.com/maehr/typademic/issues
.. |GitHub forks| image:: https://img.shields.io/github/forks/maehr/typademic.svg
   :target: https://github.com/maehr/typademic/network
.. |GitHub stars| image:: https://img.shields.io/github/stars/maehr/typademic.svg
   :target: https://github.com/maehr/typademic/stargazers
.. |GitHub license| image:: https://img.shields.io/github/license/maehr/typademic.svg
   :target: https://github.com/maehr/typademic/blob/master/LICENSE.rst
