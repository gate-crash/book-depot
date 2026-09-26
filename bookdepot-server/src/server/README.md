Server Data Models:

Book: 
```aiignore
{
    "id": String (default=UUID cast to string), 
    "title": String, 
    "isbn": String, 
    "issn": String, 
    "shelf": UUID, 
    "author": UUID, # Note: there are plans to change this to a json object to support multi-author 
    "genre": String, 
    "language": String (default="English"), 
    "publish_date": Date, 
    "printing_date": Date, 
    "series": String, 
    "volume_number": Integer, 
    "format": String (default="Paperback Book"), 
    "possession": UUID, 
    "edition": Integer, 
    "description": String, 
    "notes": String, 
    "thumbnail_filename": String, 
    "sequence_ordinal": Float, 
    "fiction": Boolean (default=True), 
    "read": Boolean (default=True), 
    "shelved": Boolean (default=True)
}
```

e.g.

Adds a single book
```POST http://localhost:8000/add-book
Content-Type: application/json

{
  "title": "The Great Gatsby",
  "language": "English",
  "author": "dd48f60b-bfef-4881-9c07-1fd91bd94701",
  "shelf": "dd48f60b-bfef-4881-9c07-1fd91bd94701",
  "isbn": "123456789"
}
```

Gets all books
```GET http://localhost:8000/get-books
```

Gets shelves in a bookcase
```GET http://localhost:8000/get-shelves
Content-Type: application/json

{"bookcase":"7f7a8832-9ba9-4a9f-9e42-60c466bd06f1"}
```