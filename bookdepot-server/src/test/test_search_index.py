from src.util.database.repo import DatabaseRepo


def test_search_index_tracks_book_and_author_changes(database):
    database.setup()
    repo = DatabaseRepo(database.conn)
    cursor = database.conn.cursor()

    cursor.execute(
        "INSERT INTO authors (id, first_name, last_name) VALUES (?, ?, ?)",
        ("author-1", "Ursula", "Le Guin"),
    )
    cursor.execute(
        "INSERT INTO books (id, title, shelf, author) VALUES (?, ?, ?, ?)",
        ("book-1", "The Left Hand of Darkness", "shelf-1", "author-1"),
    )
    database.conn.commit()

    assert [book["id"] for book in repo.broad_book_search("dark")] == ["book-1"]
    assert [book["id"] for book in repo.broad_book_search("ursula")] == ["book-1"]

    cursor.execute("UPDATE books SET title = ? WHERE id = ?", ("The Dispossessed", "book-1"))
    database.conn.commit()
    assert repo.broad_book_search("dark") == []
    assert [book["id"] for book in repo.broad_book_search("disposs")] == ["book-1"]

    cursor.execute("UPDATE authors SET first_name = ? WHERE id = ?", ("Octavia", "author-1"))
    database.conn.commit()
    assert repo.broad_book_search("ursula") == []
    assert [book["id"] for book in repo.broad_book_search("octavia")] == ["book-1"]

    cursor.execute("UPDATE books SET deleted = 1 WHERE id = ?", ("book-1",))
    database.conn.commit()
    assert repo.broad_book_search("disposs") == []
