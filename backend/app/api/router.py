from fastapi import APIRouter
from app.api.routes import profile, badges

api_router = APIRouter()


api_router.include_router(profile.router, prefix = "/profile")
api_router.include_router(badges.router, prefix = "/badges")


