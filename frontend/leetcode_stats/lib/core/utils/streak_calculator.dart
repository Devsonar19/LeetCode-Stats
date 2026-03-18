class StreakData {
  final int maxStreak;
  final int totalSubmissions;
  final int todaySubmissions;
  StreakData({required this.maxStreak, required this.totalSubmissions, required this.todaySubmissions});
}

StreakData calculateStreak(Map<String, dynamic> calendar){
  int maxStreak = 0;
  int currentStreak = 0;
  int totalSubmissions = 0;

  final sortedData = calendar.keys.toList()..sort();

  for(var date in sortedData){
    final count = calendar[date] ?? 0;
    totalSubmissions += count as int;

    if(count > 0){
      currentStreak++;
      if(currentStreak > maxStreak){
        maxStreak = currentStreak;
      }
    }else{
      currentStreak = 0;
    }
  }
  final now = DateTime.now().toUtc();
  final todayStart = DateTime.utc(now.year, now.month, now.day);
  final todayKey = (todayStart.millisecondsSinceEpoch ~/ 1000).toString();

  final todaySubmissions =
      int.tryParse(calendar[todayKey]?.toString() ?? "0") ?? 0;

  return StreakData(
    maxStreak: maxStreak,
    totalSubmissions: totalSubmissions,
    todaySubmissions: todaySubmissions,
  );
}