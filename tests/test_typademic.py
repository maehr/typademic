def test_routes_no_session(client):
    assert client.get('/404').status_code == 404
    assert client.get('/').status_code == 200
    assert client.get('/clear').status_code == 302
    assert client.get('/docx').status_code == 302
    assert client.get('/pdf').status_code == 302

def test_index(client):
    response = client.get('/')
    assert b"Log In" in response.data
    assert b"Register" in response.data

    # auth.login()
    response = client.get('/')
    assert b'Log Out' in response.data
    assert b'test title' in response.data
    assert b'by test on 2018-01-01' in response.data
    assert b'test\nbody' in response.data
    assert b'href="/1/update"' in response.data