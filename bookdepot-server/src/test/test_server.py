import importlib
import sys

import pytest
from fastapi.testclient import TestClient


@pytest.fixture
def server_client(database):
    """Builds a Server app against the isolated test database and tears it down after."""
    database.setup()

    sys.modules.pop("src.server.server", None)
    import src.server.server as server_module
    importlib.reload(server_module)

    server_module.Server()

    with TestClient(server_module.app) as client:
        yield client

    server_module.database.close()
    sys.modules.pop("src.server.server", None)


class TestServer:
    def test_get_message_endpoint_runs_successfully(self, server_client):
        response = server_client.get("/get-message")

        assert response.status_code == 200
        assert response.json() == {"message": "Book Depot is up and running."}
