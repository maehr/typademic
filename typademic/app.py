import os
import uuid

from flask import Flask
from flask_dropzone import Dropzone
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_wtf.csrf import CSRFProtect

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
        aDROPZONE_UPLOAD_MULTIPLE=True,  # enable parallel upload
        DROPZONE_PARALLEL_UPLOADS=1,  # handle 3 file per request
        DROPZONE_MAX_FILE_SIZE=10,
        DROPZONE_MAX_FILES=30,
        DROPZONE_ENABLE_CSRF=True,
        DROPZONE_DEFAULT_MESSAGE='<i class="fas fa-file-upload fa-2x"></i> Upload your files (Text, Images, Bibliography, Style etc.)',
        DROPZONE_REDIRECT_VIEW='uploads.upload',
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
        os.makedirs(app.config['UPLOADED_PATH'])
    except OSError:
        pass

    dropzone.init_app(app)
    csrf.init_app(app)
    limiter.init_app(app)

    from typademic.errors import blueprint as errors_bp
    app.register_blueprint(errors_bp)

    from typademic.uploads import blueprint as uploads_bp
    app.register_blueprint(uploads_bp)

    return app
