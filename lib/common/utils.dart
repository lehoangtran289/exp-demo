
bool isPhoneNoValid(String? phoneNo) {
  if (phoneNo == null) return false;
  final regExp = RegExp(r'^(84[3|5|7|8|9]|0[3|5|7|8|9])+([0-9]{8})\b');
  return regExp.hasMatch(phoneNo);
}