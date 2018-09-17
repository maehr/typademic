from flask import Blueprint

blueprint = Blueprint('uploads', __name__, template_folder='templates')

from typademic.uploads import routes
