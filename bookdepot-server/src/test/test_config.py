from configparser import ConfigParser
from pathlib import Path


def test_config_file_contains_required_sections_and_values():
    config_path = Path(__file__).parents[1] / "util" / "config.ini"
    config = ConfigParser()

    assert config.read(config_path) == [str(config_path)]
    assert set(config.sections()) >= {"database", "tables", "logging", "server"}
    assert set(config["database"]) >= {"name", "path"}
    assert set(config["tables"]) >= {
        "bookcases",
        "shelves",
        "authors",
        "possessions",
        "books",
        "book_search",
    }
    assert set(config["server"]) >= {"address", "port"}


def test_database_loads_configured_database_path_and_table_names(database):
    config_path = Path(__file__).parents[1] / "util" / "config.ini"
    config = ConfigParser()
    config.read(config_path)

    assert database.database_path.endswith(
        str(Path(config["database"]["path"]) / config["database"]["name"])
    )
    assert database.bookcases_table == config["tables"]["bookcases"]
    assert database.shelves_table == config["tables"]["shelves"]
    assert database.authors_table == config["tables"]["authors"]
    assert database.possessions_table == config["tables"]["possessions"]
    assert database.books_table == config["tables"]["books"]
    assert database.book_search_table == config["tables"]["book_search"]
