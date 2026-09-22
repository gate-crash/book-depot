import uvicorn
from fastapi import FastAPI
import src.util.database.repo as repo
from src.util.database import database


# TODO: in progress
database = database.Database()
repo = repo.DatabaseRepo(database.conn)

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

if __name__ == "__main__":
    uvicorn.run(app, host="localhost", port=8000)