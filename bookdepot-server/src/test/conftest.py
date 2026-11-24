import pytest

from src.util.database.database import Database
from src.util.system.image_store import ImageStore


@pytest.fixture
def database(tmp_path, monkeypatch):
    (tmp_path / "data").mkdir()
    monkeypatch.setenv("BOOKDEPOT_PROJECT_ROOT", str(tmp_path))
    db = Database()
    yield db
    db.close()


@pytest.fixture
def image_store(tmp_path, monkeypatch):
    monkeypatch.setenv("BOOKDEPOT_PROJECT_ROOT", str(tmp_path))
    return ImageStore()
