import pytest

from src.util.database.database import Database


@pytest.fixture
def database(tmp_path, monkeypatch):
    (tmp_path / "data").mkdir()
    monkeypatch.setenv("BOOKDEPOT_PROJECT_ROOT", str(tmp_path))
    db = Database()
    yield db
    db.close()
