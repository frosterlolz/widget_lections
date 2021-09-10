class User{
  final String imagePath;
  final String name;
  final String nickname;
  final String about;

  const User({
    required this.imagePath,
    required this.name,
    required this.nickname,
    required this.about,
  });
}
List <User> users = [];