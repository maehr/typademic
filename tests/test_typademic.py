def test_404(client):
    response = client.get('/404')
    assert client.get('/404').status_code == 404
    assert b'Sowwy, there is nothing here' in response.data


def test_clear(client):
    response = client.get('/clear')
    assert response.status_code == 200
    assert b'Nothing to remove.' in response.data
    # TODO upload some stuff

def test_clear_all(client):
    # TODO upload some stuff
    response = client.get('/clear_all/REALLY_SECRET')
    assert response.status_code == 200
    assert b'All files are successfully removed.' in response.data
    assert client.get('/clear_all/WRONG_KEY').status_code == 302
    assert client.get('/clear_all/REALLY_SECRET').status_code == 429


def test_docx(client):
    assert client.get('/docx').status_code == 302


def test_index(client):
    assert client.get('/').status_code == 200


def test_pdf(client):
    assert client.get('/pdf').status_code == 302

# def test_index(client):
#     response = client.get('/')
#     assert b"Log In" in response.data
#     assert b"Register" in response.data
#
#     # auth.login()
#     response = client.get('/')
#     assert b'Log Out' in response.data
#     assert b'test title' in response.data
#     assert b'by test on 2018-01-01' in response.data
#     assert b'test\nbody' in response.data
#     assert b'href="/1/update"' in response.data
