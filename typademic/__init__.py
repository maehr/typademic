import os
import uuid

from flask import Flask, session, render_template, request, send_file, redirect, url_for
from flask_dropzone import Dropzone
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_wtf.csrf import CSRFProtect, CSRFError
from sh import pandoc

dropzone = Dropzone()
csrf = CSRFProtect()
limiter = Limiter(
    key_func=get_remote_address,
    default_limits=["500 per day", "50 per hour"]
)


def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        # Secret key used to generate CSRF token should not be set at random in production. It breaks sessions.
        SECRET_KEY=os.getenv('SECRET_KEY', uuid.uuid4().hex),
        UPLOADED_PATH=os.path.join(app.instance_path, 'uploads'),
        # Flask-Dropzone config:
        DROPZONE_ALLOWED_FILE_CUSTOM=True,
        DROPZONE_ALLOWED_FILE_TYPE='.md, .png, .jpg, .jpeg, .bib, .bibtex, .biblatex, .csl, .yaml, .yml, .json, .tex',
        DROPZONE_MAX_FILE_SIZE=10,
        DROPZONE_MAX_FILES=30,
        DROPZONE_ENABLE_CSRF=True,
        DROPZONE_DEFAULT_MESSAGE='<i class="fas fa-file-upload fa-2x"></i> Upload your files (Text, Images, Bibliography, Style etc.)',
        GOOGLE_ANALYTICS=os.getenv('GOOGLE_ANALYTICS', 'UA-XXXXXXXXX-X')
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    dropzone.init_app(app)
    csrf.init_app(app)
    limiter.init_app(app)

    # handle CSRF error
    @app.errorhandler(CSRFError)
    def csrf_error(e):
        return e.description, 400

    @app.errorhandler(404)
    def error_404(error):
        return render_template("errors/404.html"), 404

    @app.errorhandler(500)
    def error_404(error):
        return render_template("errors/500.html"), 500

    def uploaded_files():
        try:
            return os.listdir(os.path.join(app.config['UPLOADED_PATH'], session['uid']))
        except Exception:
            return []

    @app.route('/', methods=['POST', 'GET'])
    def upload():
        if 'uid' not in session:
            try:
                uid = uuid.uuid4().hex
                session['uid'] = uid
                session_upload_path = os.path.join(app.config['UPLOADED_PATH'], uid)
                # ensure the upload folder exists
                os.mkdir(session_upload_path)
            except Exception as e:
                return render_template('index.html', files=uploaded_files(), error=str(e))

        if request.method == 'POST':
            try:
                f = request.files.get('file')
                f.save(os.path.join(app.config['UPLOADED_PATH'], session['uid'], f.filename))
            except Exception as e:
                return render_template('index.html', files=uploaded_files(), error=str(e))

        return render_template('index.html', files=uploaded_files(), error='')

    @app.route('/clear', methods=['GET'])
    def clear():
        try:
            for root, dirs, files in os.walk(os.path.join(app.config['UPLOADED_PATH'], session['uid']), topdown=False):
                for name in files:
                    os.remove(os.path.join(root, name))
                for name in dirs:
                    os.remove(os.path.join(root, name))
            return redirect(url_for('upload'))
        except Exception as e:
            return render_template('index.html', files=uploaded_files(), error=str(e))

    @app.route('/clear_all/<key>', methods=['GET'])
    @limiter.limit("1 per day")
    def clear_all(key):
        if key is app.config['SECRET_KEY']:
            try:
                for root, dirs, files in os.walk(os.path.abspath(app.config['UPLOADED_PATH']), topdown=False):
                    for name in files:
                        os.remove(os.path.join(root, name))
                    for name in dirs:
                        os.remove(os.path.join(root, name))
                return render_template('index.html', files=uploaded_files(),
                                       error='All files are successfully removed.')
            except Exception as e:
                return render_template('index.html', files=uploaded_files(), error=str(e))
        else:
            return redirect(url_for('upload'))

    @app.route('/render/<output_format>', methods=['GET'])
    def render(output_format):
        if output_format not in ['docx', 'pdf']:
            return redirect(url_for('upload'))
        output_filename = 'typademic.' + output_format
        files = uploaded_files()
        try:
            md_files = ''
            for file in files:
                # Serve from cache
                if file.endswith(output_filename):
                    return send_file(os.path.join(app.config['UPLOADED_PATH'], session['uid'], output_filename),
                                     attachment_filename=output_filename)
                # Extract md file(s)
                if file.endswith('.md'):
                    md_files = md_files + ' ' + file
            if md_files is '':
                return render_template('index.html', files=files,
                                       error='No Markdown file was uploaded. Please reset and try again.')
            cwd = os.path.join(app.config['UPLOADED_PATH'], session['uid'])
            pandoc(md_files.strip(),
                   '--output',
                   output_filename,
                   '--from',
                   'markdown+ascii_identifiers+tex_math_single_backslash+raw_tex+table_captions+yaml_metadata_block+autolink_bare_uris',
                   '--latex-engine=xelatex',
                   # Pandoc 2.2.3 fix
                   # '--pdf-engine=xelatex',
                   '--filter',
                   'pandoc-citeproc',
                   '--standalone',
                   _cwd=cwd)
            return send_file(os.path.join(app.config['UPLOADED_PATH'], session['uid'], output_filename),
                             attachment_filename=output_filename)
        except Exception as e:
            return render_template('index.html', files=files, error=str(e))

    return app
