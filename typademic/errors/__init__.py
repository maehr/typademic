from flask import Blueprint

blueprint = Blueprint('errors', __name__, template_folder='templates')

from typademic.errors import handlers
