class RestaurantModel {
  final double rating;
  final String name;
  final String link;
  final String menu;

  RestaurantModel({
    required this.rating,
    required this.name,
    required this.link,
    required this.menu,
  }) : assert(0.0 <= rating && rating <= 5.0);
}
