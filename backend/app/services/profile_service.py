from app.services.graphql_client import execute_query

PROFILE_QUERY = """
query getUserDashboard($username: String!) {

  matchedUser(username: $username) {
    username

    profile {
      realName
      userAvatar
      ranking
      reputation
    }

    badges {
      displayName
      icon
    }

    activeBadge {
      displayName
      icon
    }

    submitStatsGlobal {
      acSubmissionNum {
        difficulty
        count
        submissions
      }

      totalSubmissionNum {
        difficulty
        count
        submissions
      }
    }

    submissionCalendar
  }

  recentSubmissionList(username: $username, limit: 20) {
    title
    titleSlug
    timestamp
    statusDisplay
    lang
  }

  userContestRanking(username: $username) {
    attendedContestsCount
    rating
    globalRanking
    topPercentage
  }

  allQuestionsCount {
    difficulty
    count
  }

  activeDailyCodingChallengeQuestion {
    date
    link
    question {
      title
      titleSlug
      difficulty
    }
  }
}
"""

async def get_profile(username: str):
    data = await execute_query(PROFILE_QUERY, {"username": username})

    if "data" not in data:
        return {"error": "User not found", "details": data}
    
    print(data)
    

    result = data["data"]
    return{
      "profile":  result["matchedUser"],
      "allQuestionsCount": result["allQuestionsCount"],
      "activeDailyCodingChallengeQuestion": result["activeDailyCodingChallengeQuestion"]
    }

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