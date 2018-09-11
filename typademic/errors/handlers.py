from flask import render_template
from flask_wtf.csrf import CSRFError

from typademic.errors import blueprint


# handle CSRF error
@blueprint.app_errorhandler(CSRFError)
def csrf_error(e):
    return e.description, 400


@blueprint.app_errorhandler(404)
def not_found_error(error):
    return render_template('errors/404.html'), 404


@blueprint.app_errorhandler(500)
def internal_error(error):
    return render_template('errors/500.html'), 500
