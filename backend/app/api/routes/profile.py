from fastapi import APIRouter
from app.services.profile_service import get_profile

router = APIRouter()

@router.get("/{username}")
async def fetch_profile_data(username: str):
    return await get_profile(username)
