"""
    typademic
    ~~~~~
    Academic publishing.
    :copyright: (c) 2018 by Moritz Mähr.
    :license: MIT, see LICENSE.md for more details.
"""
from typademic.app import create_app

app = create_app()
if __name__ == '__main__':
    app.run()
