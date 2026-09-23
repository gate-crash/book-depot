Server Data Models:

Book: 
```aiignore
{
    'id': String (default=UUID cast to string), 
    'title': String, 
    'isbn': String, 
    'issn': String, 
    'shelf': UUID, 
    'author': UUID, # Note: there are plans to change this to a json object to support multi-author 
    'genre': String, 
    'language': String (default='English'), 
    'publish_date': Date, 
    'printing_date': Date, 
    'series': String, 
    'volume_number': Integer, 
    'format': String (default='Paperback Book'), 
    'possession': UUID, 
    'edition': Integer, 
    'description': String, 
    'notes': String, 
    'thumbnail_filename': String, 
    'sequence_ordinal': Float, 
    'fiction': Boolean (default=True), 
    'read': Boolean (default=True), 
    'shelved': Boolean (default=True)
}
```