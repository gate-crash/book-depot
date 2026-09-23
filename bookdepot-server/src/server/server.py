import uvicorn
from fastapi import FastAPI, Body
from configparser import ConfigParser
import os

import src.util.database.repo as repo
from src.util.database import database
from src.util.dataModels import DataModels


# TODO: in progress
database = database.Database()
repo = repo.DatabaseRepo(database.conn)

config = ConfigParser()

config_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../util/config.ini')
config.read(config_path)
server_config = config["server"]


host = server_config["address"]
port = int(server_config["port"])

app = FastAPI()

@app.get("/get-message")
async def read_root():
    return {"message": "Hello World"}

@app.get("/get-bookcases")
async def get_bookcases():
    bookcases = list(repo.fetch_all_bookcases())
    return {"bookcases": bookcases}

@app.get("/get-shelves")
async def get_shelves(data: dict = Body(...)):

    print(data)
    bookcase = data["bookcase"]

    shelves = list(repo.get_shelves(bookcase))
    return {"shelves": shelves}

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
async def add_shelf(data: dict = Body(...)):

    try:
        data = DataModels.Shelf(**data).clean_dict()

        try:
            repo.insert_data(table_name='shelves', data=data)
            return {"message": "Shelf added successfully", "data": data}
        except Exception as e:
            return {"message": "Something went wrong.", "error": str(e)}

    except Exception as e:
        return {"message": "Data error.", "error": str(e)}

def __main__():
    uvicorn.run(app, host=host, port=port)

if __name__ == "__main__":
    __main__()