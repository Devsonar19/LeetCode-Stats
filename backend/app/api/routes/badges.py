from fastapi import APIRouter
from app.services.profile_service import get_badges

router = APIRouter()

@router.get("/{username}")
async def fetch_badges_data(username: str):
    return await get_badges(username)
