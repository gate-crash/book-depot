import uvicorn
from fastapi import FastAPI, Body, APIRouter
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


class Server:

    def __init__(self):
        self.router = APIRouter()

        # Register bound methods so FastAPI doesn't see "self" as a param.
        self.router.add_api_route("/get-message", self.read_root, methods=["GET"])
        self.router.add_api_route("/get-bookcases", self.get_bookcases, methods=["GET"])
        self.router.add_api_route("/get-shelves", self.get_shelves, methods=["GET"])
        self.router.add_api_route("/get-books", self.get_all_books, methods=["GET"])
        self.router.add_api_route("/add-book", self.add_book, methods=["POST"])
        self.router.add_api_route("/add-bookcase", self.add_bookcase, methods=["POST"])
        self.router.add_api_route("/add-shelf", self.add_shelf, methods=["POST"])
        self.router.add_api_route("/get-books-by-shelf", self.get_books_by_shelf, methods=["GET"])
        app.include_router(self.router)

    def run(self):
        uvicorn.run(app, host=host, port=port)

    async def read_root(self):
        return {"message": "Hello World"}

    async def get_bookcases(self):
        bookcases = repo.fetch_all_bookcases()
        return {"bookcases": bookcases}

    async def get_shelves(self, data: dict = Body(...)):

        print(data)
        bookcase = data["bookcase"]

        shelves = repo.get_shelves(bookcase)
        return {"shelves": shelves}

    async def get_all_books(self):
        books = repo.fetch_all_books()
        return {"books": books}

    async def get_books_by_shelf(self, data: dict = Body(...)):
        shelf = data["shelf"]

        books = repo.fetch_books_by_shelf(shelf)

        return {"books": books}

    async def add_book(self, data: dict = Body(...)):

        try:
            data = DataModels.Book(**data).clean_dict()

            try:
                repo.insert_data(table_name='books', data=data)
                return {"message": "Book added successfully", "data": data}
            except Exception as e:
                return {"message": "Something went wrong.", "error": str(e)}

        except Exception as e:
            return {"message": "Data error.", "error": str(e)}

    async def add_bookcase(self, data: dict = Body(...)):

        try:
            data = DataModels.Bookcase(**data).clean_dict()

            try:
                repo.insert_data(table_name='bookcases', data=data)
                return {"message": "Bookcase added successfully", "data": data}
            except Exception as e:
                return {"message": "Something went wrong.", "error": str(e)}

        except Exception as e:
            return {"message": "Data error.", "error": str(e)}

    async def add_shelf(self, data: dict = Body(...)):

        try:
            data = DataModels.Shelf(**data).clean_dict()

            try:
                repo.insert_data(table_name='shelves', data=data)
                return {"message": "Shelf added successfully", "data": data}
            except Exception as e:
                return {"message": "Something went wrong.", "error": str(e)}

        except Exception as e:
            return {"message": "Data error.", "error": str(e)}
