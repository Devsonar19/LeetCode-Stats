from datetime import datetime

def parse_calender(calender):
    res = []
    
    for timestamp, count in calender.items():
        date = datetime.fromtimestamp(timestamp).strftime("%Y-%m-%d")
        res.append({"date": date, "count": count})
    
    res.append({
        "date": date,
        "count": count
    })

    return res

    