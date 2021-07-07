class AppUser {
  final String uid;
  final String userName;
  final String userEmail;
  final int level;
  final int points;
  final int lightBulbs;
  final int lightBulbRefillsAt;
  final bool hint;
  final bool solution;

  AppUser({
    this.uid,
    this.userName,
    this.userEmail,
    this.level,
    this.points,
    this.lightBulbs,
    this.lightBulbRefillsAt,
    this.hint,
    this.solution,
  });
}
