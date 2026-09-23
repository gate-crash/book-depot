import os

__author__  = "Emily Thomas <thomas.ech@gmail.com>"
__status__  = "alpha"
__version__ = "0.0.1"
__date__    = "23 September 2026"

def __init__():
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
