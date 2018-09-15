import pytest

from typademic.app import create_app


@pytest.fixture
def app():
    app = create_app({
        'TESTING': True,
        'SECRECT_KEY': 'REALLY_SECRET',
    })

    yield app


@pytest.fixture
def client(app):
    return app.test_client()

@pytest.fixture
def client_with_uid(app):
    # TODO impement get session
    return app.test_client()


@pytest.fixture
def runner(app):
    return app.test_cli_runner()




# class UploadAction(object):
#     def __init__(self, client):
#         self._client = client
#
#     def upload(self, md='test'):
#         return self._client.post(
#             '/upload',
#             data={'md': md}
#         )
#
#     def logout(self):
#         return self._client.get('/auth/logout')
#
#
# @pytest.fixture
# def upload(client):
#     return UploadAction(client)
