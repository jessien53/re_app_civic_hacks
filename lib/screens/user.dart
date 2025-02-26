class User {
  // Create a static final instance of the class (Singleton instance)
  static final User _instance = User._internal();

  //  Declare instance variables
  int points;
  int level;
  int pointsNeededForNextLevel;

  // Step 3: Use a factory constructor to always return the same instance
  factory User() {
    return _instance; // Ensures that only one instance of User exists
  }

  // Private constructor to prevent external instantiation
  User._internal({
    this.points = 0,
    this.level = 1,
    this.pointsNeededForNextLevel = 10,
  });

  // Method to add points and update the user's level
  void addPoints(int newPoints) {
    points += newPoints;
    // Leveling system: Every `pointsNeededForNextLevel` points = Level up
    level = (points ~/ pointsNeededForNextLevel) + 1;
  }
}
