from pydantic import BaseModel

class Profile(BaseModel):
    username: str
    realName: str
    ranking: int    
