# -*- coding: utf-8 -*-
"""
    typademic
    ~~~~~
    Academic publishing.
    :copyright: (c) 2018 by Moritz Mähr.
    :license: MIT, see LICENSE.md for more details.
"""
import os
import uuid

from flask import Flask, session, render_template, request, send_file
from flask_dropzone import Dropzone
from flask_wtf.csrf import CSRFProtect, CSRFError
from sh import pandoc

basedir = os.path.abspath(os.path.dirname(__file__))
google_analytics = os.getenv('GOOGLE_ANALYTICS', 'UA-XXXXXXXXX-X')

app = Flask(__name__)

app.config.update(
    SECRET_KEY=os.getenv('SECRET_KEY', uuid.uuid4().hex),
    # the secret key used to generate CSRF token
    UPLOADED_PATH=os.path.join(basedir, 'uploads'),
    # Flask-Dropzone config:
    DROPZONE_ALLOWED_FILE_CUSTOM=True,
    DROPZONE_ALLOWED_FILE_TYPE='.md, image/*, .bib, .bibtex, .biblatex, .csl, .yaml, .yml, .json',
    DROPZONE_MAX_FILE_SIZE=10,
    DROPZONE_MAX_FILES=30,
    DROPZONE_ENABLE_CSRF=True,  # enable CSRF protection
)

dropzone = Dropzone(app)
csrf = CSRFProtect(app)  # initialize CSRFProtect


# Session(app)


@app.route('/', methods=['POST', 'GET'])
def upload():
    if 'uid' not in session:
        uid = uuid.uuid4().hex
        session['uid'] = uid
        session_upload_path = os.path.join(app.config['UPLOADED_PATH'], uid)
        os.mkdir(session_upload_path)
    if request.method == 'POST':
        f = request.files.get('file')
        f.save(os.path.join(app.config['UPLOADED_PATH'], session['uid'], f.filename))
        print(pandoc("-v"))
        # print(pandoc("arg1, "arg2"))
        # https://amoffat.github.io/sh/
    return render_template('index.html', google_analytics=google_analytics)


@app.route('/docx', methods=['GET'])
def docx(args):
    try:
        pandoc(
            '*.md --from markdown+ascii_identifiers+tex_math_single_backslash+raw_tex+table_captions+yaml_metadata_block+autolink_bare_uris --output typademic.docx --pdf-engine xelatex --filter pandoc-citeproc --standalone')
        return send_file(os.path.join(app.config['UPLOADED_PATH'], session['uid'], 'typademic.docx'),
                         attachment_filename='typademic.docx')
    except Exception as e:
        return str(e)


@app.route('/pdf', methods=['GET'])
def pdf(args):
    try:
        pandoc(
            '*.md --from markdown+ascii_identifiers+tex_math_single_backslash+raw_tex+table_captions+yaml_metadata_block+autolink_bare_uris --output typademic.pdf --pdf-engine xelatex --filter pandoc-citeproc --standalone')
        return send_file(os.path.join(app.config['UPLOADED_PATH'], session['uid'], 'typademic.pdf'),
                         attachment_filename='typademic.pdf')
    except Exception as e:
        return str(e)


# handle CSRF error
@app.errorhandler(CSRFError)
def csrf_error(e):
    return e.description, 400


if __name__ == '__main__':
    app.run(debug=True, host=os.getenv('HOST', '0.0.0.0'))
