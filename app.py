# -*- coding: utf-8 -*-
import os

from flask import Flask, render_template, request
from flask_dropzone import Dropzone
from flask_wtf.csrf import CSRFProtect, CSRFError
from sh import pandoc

basedir = os.path.abspath(os.path.dirname(__file__))

app = Flask(__name__)

app.config.update(
    SECRET_KEY=os.getenv('SECRET_KEY', '6*1cu#b!r)0oonlbq(ed-()7kw76d_ent93az*(o313l6es*!c'),
    # the secret key used to generate CSRF token
    UPLOADED_PATH=os.path.join(basedir, 'uploads'),
    # Flask-Dropzone config:
    DROPZONE_ALLOWED_FILE_CUSTOM=True,
    DROPZONE_ALLOWED_FILE_TYPE='image/*, text/*, .bib, .bibtex, .biblatex, .csl, .yaml, .yml, .md, .markdown, .Rmd, .json',
    DROPZONE_MAX_FILE_SIZE=10,
    DROPZONE_MAX_FILES=30,
    DROPZONE_ENABLE_CSRF=True  # enable CSRF protection
)

dropzone = Dropzone(app)
csrf = CSRFProtect(app)  # initialize CSRFProtect


@app.route('/', methods=['POST', 'GET'])
def upload():
    if request.method == 'POST':
        f = request.files.get('file')
        f.save(os.path.join(app.config['UPLOADED_PATH'], f.filename))
        print(pandoc("-v"))
        # print(pandoc("arg1, "arg2"))
        # https://amoffat.github.io/sh/
    return render_template('index.html')


# handle CSRF error
@app.errorhandler(CSRFError)
def csrf_error(e):
    return e.description, 400


if __name__ == '__main__':
    app.run(debug=True, host=os.getenv('HOST', '0.0.0.0'))
