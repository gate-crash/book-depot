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

        self.router.add_api_route("/bookcases", self.fetch_bookcases, methods=["GET"])
        self.router.add_api_route("/bookcase/add", self.add_bookcase, methods=["POST"])
        self.router.add_api_route('/bookcase/delete', self.delete_bookcase, methods=["POST"])

        self.router.add_api_route("/shelves", self.fetch_shelves, methods=["GET"])
        self.router.add_api_route("/shelf/add", self.add_shelf, methods=["POST"])
        self.router.add_api_route("/shelf/get-books", self.get_books_by_shelf, methods=["GET"])
        self.router.add_api_route("/shelf/delete", self.delete_shelf, methods=["POST"])

        self.router.add_api_route("/books", self.fetch_all_books, methods=["GET"])
        self.router.add_api_route("/book/add", self.add_book, methods=["POST"])
        self.router.add_api_route("/book/delete", self.delete_book, methods=["POST"])

        self.router.add_api_route("/loan/add", self.create_possession, methods=["POST"])
        self.router.add_api_route("/loans", self.fetch_possessions, methods=["GET"])
        self.router.add_api_route("/loan/delete", self.delete_possession, methods=["POST"])

        self.router.add_api_route("/author/add", self.add_author, methods=["POST"])
        self.router.add_api_route("/authors", self.fetch_authors, methods=["GET"])
        self.router.add_api_route("/author/delete", self.delete_author, methods=["POST"])

        app.include_router(self.router)

    def run(self):
        uvicorn.run(app, host=host, port=port)

    async def read_root(self):
        return {"message": "Book Depot is up and running."}

    async def fetch_bookcases(self):
        bookcases = repo.fetch_all_bookcases()
        return {"bookcases": bookcases}

    async def fetch_shelves(self, data: dict = Body(...)):

        print(data)
        bookcase = data["bookcase"]

        shelves = repo.get_shelves(bookcase)
        return {"shelves": shelves}

    async def fetch_all_books(self):
        books = repo.fetch_all_books()
        return {"books": books}

    async def get_books_by_shelf(self, data: dict = Body(...)):
        shelf = data["shelf"]

        books = repo.fetch_books_by_shelf(shelf)

        return {"books": books}

    async def add_book(self, data: dict = Body(...)):

        try:
            data = DataModels.Book(**data)
            data = data.clean_dict()
            print(data)

            try:
                repo.insert_data(table_name='books', data=data)
                return {"message": "Book added successfully", "data": data}
            except Exception as e:
                return {"message": "Something went wrong.", "error": str(e)}

        except Exception as e:
            return {"message": "Data error.", "error": str(e), "data": data}

    async def add_bookcase(self, data: dict = Body(...)):

        try:
            data = DataModels.Bookcase(**data).clean_dict()

            try:
                repo.insert_data(table_name='bookcases', data=data)
                return {"message": "Bookcase added successfully", "data": data}
            except Exception as e:
                return {"message": "Something went wrong.", "error": str(e)}

        except Exception as e:
            return {"message": "Data error.", "error": str(e), "data": data}

    async def add_shelf(self, data: dict = Body(...)):

        try:
            data = DataModels.Shelf(**data).clean_dict()
            print(data)

            try:
                repo.insert_data(table_name='shelves', data=data)
                return {"message": "Shelf added successfully", "data": data}
            except Exception as e:
                return {"message": "Something went wrong.", "error": str(e)}

        except Exception as e:
            return {"message": "Data error.", "error": str(e), "data": data}

    async def create_possession(self, data: dict = Body(...)):

        try:
            data = DataModels.Possession(**data).clean_dict()

            try:
                repo.insert_data(table_name='possessions', data=data)
                return {"message": "Possession added successfully", "data": data}
            except Exception as e:
                return {"message": "Something went wrong.", "error": str(e)}

        except Exception as e:
            return {"message": "Data error.", "error": str(e), "data": data}

    async def fetch_possessions(self, data: dict = Body(...)):
        loans = repo.fetch_all_possessions()
        return {"loans": loans}

    async def delete_bookcase(self, data: dict = Body(...)):
        bookcase = data["id"]

        data = repo.set_data_to_deleted(table='bookcases', id=bookcase)

        return {"bookcase": data}

    async def delete_shelf(self, data: dict = Body(...)):
        shelf = data["id"]

        data = repo.set_data_to_deleted(table='shelves', id=shelf)

        return {"shelf": data}

    async def delete_book(self, data: dict = Body(...)):
        book = data["id"]

        data = repo.set_data_to_deleted(table='books', id=book)

        return {"book": data}

    async def delete_possession(self, data: dict = Body(...)):
        possession = data["id"]

        data = repo.set_data_to_deleted(table='possessions', id=possession)

        return {"bookcase": data}

    async def fetch_authors(self):
        authors = repo.fetch_all_authors()
        return {"authors": authors}

    async def add_author(self, data: dict = Body(...)):
        try:
            data = DataModels.Author(**data).clean_dict()

            try:
                repo.insert_data(table_name='authors', data=data)
                return {"message": "Author added successfully", "data": data}
            except Exception as e:
                return {"message": "Something went wrong.", "error": str(e)}

        except Exception as e:
            return {"message": "Data error.", "error": str(e), "data": data}

    async def delete_author(self, data: dict = Body(...)):
        author = data["id"]

        data = repo.set_data_to_deleted(table='authors', id=author)

        return {"author": data}
