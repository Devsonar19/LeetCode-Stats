import httpx
from app.core.config import LEETCODE_GRAPHQL_URL

async def execute_query(query: str, variables: dict):

    async with httpx.AsyncClient() as client:
        response = await client.post(
            LEETCODE_GRAPHQL_URL,
            json={
                "query": query,
                "variables": variables
            }
        )
    return response.json()