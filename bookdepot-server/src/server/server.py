import json
import uvicorn
from fastapi import FastAPI, Body
import src.util.database.repo as repo
from src.util.database import database
from src.util.dataModels import DataModels


# TODO: in progress
database = database.Database()
repo = repo.DatabaseRepo(database.conn)

host = "localhost"
port = 8000

app = FastAPI()

@app.get("/get-message")
async def read_root():
    return {"message": "Hello World"}

@app.get("/get-bookcases")
async def get_bookcases():
    bookcases = list(repo.fetch_all_bookcases())
    return {"bookcases": bookcases}

@app.get("/get-books")
async def get_books():
    books = list(repo.fetch_all_books())
    return {"books": books}

@app.post("/add-book")
async def add_book(data: dict = Body(...)):

    try:
        data = DataModels.Book(**data).clean_dict()

        try:
            repo.insert_data(table_name='books', data=data)
            return {"message": "Book added successfully", "data": data}
        except Exception as e:
            return {"message": "Something went wrong.", "error": str(e)}

    except Exception as e:
        return {"message": "Data error.", "error": str(e)}

@app.post("/add-bookcase")
async def add_book(data: dict = Body(...)):

    try:
        data = DataModels.Bookcase(**data).clean_dict()

        try:
            repo.insert_data(table_name='bookcases', data=data)
            return {"message": "Bookcase added successfully", "data": data}
        except Exception as e:
            return {"message": "Something went wrong.", "error": str(e)}

    except Exception as e:
        return {"message": "Data error.", "error": str(e)}

@app.post("/add-shelf")
async def add_book(data: dict = Body(...)):

    try:
        data = DataModels.Shelf(**data).clean_dict()

        try:
            repo.insert_data(table_name='shelves', data=data)
            return {"message": "Shelf added successfully", "data": data}
        except Exception as e:
            return {"message": "Something went wrong.", "error": str(e)}

    except Exception as e:
        return {"message": "Data error.", "error": str(e)}

if __name__ == "__main__":
    uvicorn.run(app, host=host, port=port)