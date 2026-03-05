from app.services.graphql_client import execute_query

PROFILE_QUERY = """
query getProfile($username: String!) {
  matchedUser(username: $username) {
    username
    profile {
      realName
      ranking
    }
  }
}
"""

async def get_profile(username: str):
    data = await execute_query(PROFILE_QUERY, {"username": username})
    return data["data"]["matchedUser"]

BADGES_QUERY = """
query getBadges($username: String!) {
  matchedUser(username: $username) {
    badges {
      displayName
      icon
    }
  }
}
"""

async def get_badges(username: str):
    data = await execute_query(BADGES_QUERY, {"username": username})
    return data["data"]["matchedUser"]["badges"]