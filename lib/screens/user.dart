class User {
  static final User _instance = User._internal();

  int points;
  int level;
  int pointsNeededForNextLevel=10;

  factory User() {
    return _instance;
  }

  User._internal({this.points = 0, this.level = 0});

  void addPoints(int newPoints) {
    points += newPoints;
    level = (points ~/ pointsNeededForNextLevel) + 1; // Example leveling system: every 10 points = level up
  }
}
