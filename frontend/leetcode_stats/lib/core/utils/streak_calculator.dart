class StreakData {
  final int maxStreak;
  final int totalSubmissions;
  final int todaySubmissions;
  StreakData({required this.maxStreak, required this.totalSubmissions, required this.todaySubmissions});
}

StreakData calculateStreak(Map<String, dynamic> calendar) {
  int maxStreak = 0;
  int currentStreak = 0;
  int totalSubmissions = 0;

  final sortedDates = calendar.keys
      .map((e) => int.parse(e))
      .toList()
    ..sort();

  int? prevDate;

  for (var timestamp in sortedDates) {
    final count = int.tryParse(calendar[timestamp.toString()].toString()) ?? 0;

    totalSubmissions += count;

    if (count > 0) {
      if (prevDate != null) {
        // difference in seconds
        final diff = timestamp - prevDate;

        if (diff == 86400) {
          // exactly 1 day apart → continue streak
          currentStreak++;
        } else {
          // gap → reset streak
          currentStreak = 1;
        }
      } else {
        currentStreak = 1;
      }

      if (currentStreak > maxStreak) {
        maxStreak = currentStreak;
      }

      prevDate = timestamp;
    }
  }

  // today logic (keep your fixed version)
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