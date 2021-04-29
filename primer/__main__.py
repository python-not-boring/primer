from os import environ
from typing import Optional

import uvicorn
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class Item(BaseModel):
    name: str
    description: Optional[str] = None


@app.get("/")
def root():
    return {"message": "Hello World!"}


@app.post("/items/")
def create_item(item: Item):
    if "a" in item.name:
        return 0
    else:
        return 1


def start(host: Optional[str] = None, port: Optional[int] = None) -> None:
    if host is None:
        host = environ.get("HOST", "0.0.0.0")
    if port is None:
        port = int(environ.get("PORT", "8000"))

    uvicorn.run("primer.__main__:app", host=host, port=port)
