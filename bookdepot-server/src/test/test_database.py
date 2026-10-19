def test_database_setup_creates_required_tables(database):
    assert not database.check()

    database.setup()

    assert database.check()


def test_check_backfills_missing_columns(database):
    database.setup()

    cursor = database.conn.cursor()
    cursor.execute(
        "ALTER TABLE {table} DROP COLUMN thumbnail_filename;".format(table=database.books_table)
    )
    database.conn.commit()

    missing = database.validate_columns()
    assert missing == {database.books_table: ["thumbnail_filename"]}

    assert database.check()

    assert database.validate_columns() == {}
    cursor.execute("PRAGMA table_info({table});".format(table=database.books_table))
    columns = {row[1] for row in cursor.fetchall()}
    assert "thumbnail_filename" in columns
