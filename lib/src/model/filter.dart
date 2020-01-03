class Filter {
  final String location;
  final int price;
  final String cuisine;
  final String sort;

  bool get isDefault {
    return (location == null &&
        price == null &&
        cuisine == null &&
        sort == null);
  }

  Filter({this.location, this.price, this.cuisine, this.sort});
}
