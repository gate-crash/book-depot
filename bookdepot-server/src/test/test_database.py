def test_database_setup_creates_required_tables(database):
    assert not database.check()

    database.setup()

    assert database.check()
