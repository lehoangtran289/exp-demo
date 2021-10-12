

class User {
  late String msisdn;
  late String name;
  late num balance;
  late String email;
  late List<Map<String, dynamic>> configs;

  User({required this.name, required this.balance, required this.email});
}
