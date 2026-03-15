from fastapi import FastAPI
from app.api.router import api_router

app = FastAPI(
    title = 'LeetCode Stats App',
    version = '1.0.0'
)

app.include_router(api_router)

@app.get("/")
async def root():
    return {"message": "Welcome to the LeetCode Stats API"}

