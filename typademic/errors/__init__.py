from flask import Blueprint

bp = Blueprint('errors', __name__)

from typademic.errors import handlers
