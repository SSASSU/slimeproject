from fastapi import FastAPI
import time
import asyncio

from module.wmgr import wmgr

worker_app=wmgr.Worker()


app = FastAPI()
app.include_router(worker_app.router)


@app.get("/")
async def root():
    return "Welcome!"

#Input Test
@app.post("/worker/{worker_num}")
async def add_worker(worker_num: str):
    a=1+1
    return {"worker number": worker_num, "a": a}

