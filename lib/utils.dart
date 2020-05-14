String twoDigits(int n) {
  if (n >= 10) return "$n";
  return "0$n";
}

String dateTimeToHM(DateTime dateTime) {
  return "${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}" ;
}