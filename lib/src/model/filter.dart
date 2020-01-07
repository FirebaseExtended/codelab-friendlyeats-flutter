class Filter {
  final String location;
  final int price;
  final String category;
  final String sort;

  bool get isDefault {
    return (location == null &&
        price == null &&
        category == null &&
        sort == null);
  }

  Filter({this.location, this.price, this.category, this.sort});
}
