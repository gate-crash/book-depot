from pathlib import Path

import pytest
from PIL import Image

BOOKCASE_IMAGE_PATH = (
    Path(__file__).parents[3] / "bookdepot-client" / "assets" / "images" / "bookcase.png"
)


def test_save_image_accepts_file_path_and_persists_a_valid_image(image_store):
    saved_path = image_store.save_image(str(BOOKCASE_IMAGE_PATH), "authors")

    assert Path(saved_path).exists()
    with Image.open(BOOKCASE_IMAGE_PATH) as original, Image.open(saved_path) as saved:
        assert saved.format == "PNG"
        assert saved.size == original.size


def test_save_image_accepts_file_object(image_store):
    with open(BOOKCASE_IMAGE_PATH, "rb") as fh:
        saved_path = image_store.save_image(fh, "authors")

    assert Path(saved_path).exists()
    with Image.open(saved_path) as saved:
        assert saved.format == "PNG"


def test_save_image_accepts_raw_bytes(image_store):
    image_bytes = BOOKCASE_IMAGE_PATH.read_bytes()

    saved_path = image_store.save_image(image_bytes, "authors")

    assert Path(saved_path).exists()
    with Image.open(saved_path) as saved:
        assert saved.format == "PNG"


def test_save_image_accepts_pil_image_instance(image_store):
    with Image.open(BOOKCASE_IMAGE_PATH) as original:
        saved_path = image_store.save_image(original, "authors")

    assert Path(saved_path).exists()
    with Image.open(saved_path) as saved:
        assert saved.format == "PNG"


def test_save_image_rejects_non_image_input(image_store):
    with pytest.raises(ValueError):
        image_store.save_image("not an image", "authors")
