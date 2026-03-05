async def get_stats(username: str):
    data =  await execute_query(STATS_QUERY, {"username": username})
    
    stats = data["data"]["matchedUser"]["submitStatsGlobal"]

    return {
        "easySolved" : extract_easy(stats),
        "mediumSolved" : extract_medium(stats),
        "hardSolved" : extract_hard(stats)
    }