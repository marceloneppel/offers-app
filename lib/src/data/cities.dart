const cities = [
  City(
    "1058-42-15000",
    "Rio Negrinho - SC",
    false,
  ),
  City(
    "1058-42-15802",
    "São Bento do Sul - SC",
    true,
  ),
];

class City {
  final String code;
  final String name;
  final bool enabled;

  const City(this.code, this.name, this.enabled);
}
