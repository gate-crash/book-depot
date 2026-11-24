import os
import uuid
from configparser import ConfigParser
from io import BytesIO

from PIL import Image, UnidentifiedImageError


_PROJECT_ROOT_MARKER = "requirements.txt"

def _find_project_root(start_path, marker=_PROJECT_ROOT_MARKER):
    current = os.path.abspath(start_path)
    while True:
        if os.path.exists(os.path.join(current, marker)):
            return current
        parent = os.path.dirname(current)
        if parent == current:
            raise FileNotFoundError(
                "Could not locate project root (missing marker file '{marker}') "
                "starting from '{start_path}'.".format(marker=marker, start_path=start_path)
            )
        current = parent


class ImageStore:
    def __init__(self):
        config = ConfigParser()

        config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../config.ini')

        config.read(config_path)

        thumbnails_config = config["thumbnails"]

        project_root = os.environ.get("BOOKDEPOT_PROJECT_ROOT") or _find_project_root(
            os.path.dirname(os.path.abspath(__file__))
        )
        self.images_path = os.path.normpath(
            os.path.join(project_root, thumbnails_config["path"])
        )

    def save_image(self, image: Image.Image, target):
        if not isinstance(image, Image.Image):
            try:
                if isinstance(image, (bytes, bytearray)):
                    image = Image.open(BytesIO(image))
                else:
                    image = Image.open(image)
                image.load()
            except (UnidentifiedImageError, OSError) as exc:
                raise ValueError("'image' must be a valid image (PIL.Image, path, file-like, or bytes)") from exc

        target_dir = os.path.join(self.images_path, target)
        os.makedirs(target_dir, exist_ok=True)

        extension = (image.format or "PNG").lower()
        image_path = os.path.join(target_dir, "{}.{}".format(uuid.uuid4().hex, extension))
        image.save(image_path)
        return image_path

    def delete_image(self, target):
        # TODO: add ability to remove images for when books are fully deleted
        pass