def calculate_streak(calender):
    streak = 0
    for date in reversed(calender):
        if date["count"] > 0:
            streak += 1
        else:
            break
    return streak

    