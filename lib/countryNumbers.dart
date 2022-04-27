import 'dart:math';

class CountryNumber {
  String displayName;
  String contryCode;
  String phoneCountryCode;
  int size;
  String prefix;

  Random rng = Random();

  CountryNumber(this.displayName, this.contryCode, this.phoneCountryCode,
      this.size, this.prefix);

  static final CountryNumber italy = CountryNumber(
      "Italy", "it", "+39", 10, "3");
  static final CountryNumber india = CountryNumber(
      "India", "in", "+91", 10, "9");
  static final CountryNumber france = CountryNumber(
      "India", "in", "+33", 10, "06");
  static final CountryNumber uk = CountryNumber(
      "United Kingdom", "uk", "+44", 10, "7");
  static final CountryNumber us = CountryNumber("U.S.A.", "us", "+1", 10, "5");

  static final List<CountryNumber> numbers = [italy, india, france, uk, us];


  generate(bool hasPrefix) async {
    var amount = size - prefix.length;
    var amountAsZeros = pow(10, amount) as int;

    var code = rng.nextInt(9 * (amountAsZeros)) + amountAsZeros;

    if (hasPrefix) {
      return phoneCountryCode + prefix + code.toString();
    } else {
      return prefix + code.toString();
    }
  }
}