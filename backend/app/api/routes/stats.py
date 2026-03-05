from fastapi import APIRouter
from app.services.stats_service import get_stats

router = APIRouter()

@router.get("/{username}")
async def fetch_stats_data(username: str):
    return await get_stats(username)    