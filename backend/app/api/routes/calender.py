from fastapi import APIRouter
from app.services.profile_service import get_calender

router = APIRouter()

@router.get("/{username}")
async def fetch_calender_data(username: str):
    return await get_calender(username) 