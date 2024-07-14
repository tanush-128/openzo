// import 'package/models/store.dart';

class Category {
  String name;
  StoreType type;
  List<SubCategory> subCategories;
  List<String> metaTags;
  String metaDescription = "";
  Category({
    required this.name,
    required this.subCategories,
    this.metaTags = const [],
    this.metaDescription = "",
    required this.type,
  });
}

class SubCategory {
  String name;
  List<String> metaTags;
  String metaDescription = "";
  SubCategory({
    required this.name,
    this.metaTags = const [],
    this.metaDescription = "",
  });
}

enum StoreType {
  store,
  food,
  service,
}

class GlobalConsts {
  static const backend_url = "https://backend.openzo.in";

  static const String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRob3JpemVkIjp0cnVlLCJwYXNzd29yZCI6InF3ZXJ0eTEyOCIsInVzZXJfZW1haWwiOiJ0YW51ZWR1MTI4QGdtYWlsLmNvbSJ9.j5m62NcdDLO5kTrM3bGW1oI0HU-4XkNOUF2Q5pfJuRg";

  static List<Category> categories = [
    Category(
      name: 'Stores',
      metaDescription: "this is meta des",
      metaTags: [
        "store",
        "shop",
        "buy",
      ],
      type: StoreType.store,
      subCategories: [
        SubCategory(
            name: 'Appliances',
            metaDescription: "this is meta des",
            metaTags: [
              "store",
              "shop",
              "buy",
            ]),
        SubCategory(name: 'Electronics'),
        SubCategory(name: 'Furniture'),
        SubCategory(name: 'Footwear'),
        SubCategory(name: 'Grocery stores'),
        SubCategory(name: 'Jewellery & Accessories'),
        SubCategory(name: 'Sports'),
        SubCategory(name: 'Books & Stationary'),
        SubCategory(name: 'Fashion'),
        SubCategory(name: 'General stores'),
        SubCategory(name: 'Household'),
        SubCategory(name: 'Personal care'),
      ],
    ),
    Category(
        name: 'Home Services',
        subCategories: [
          SubCategory(name: 'AC Repair'),
          SubCategory(name: 'Electrician'),
          SubCategory(name: 'Painter'),
          SubCategory(name: 'TV Repair'),
          SubCategory(name: 'Beautician'),
          SubCategory(name: 'Mechanic'),
          SubCategory(name: 'Plumber'),
          SubCategory(name: 'Washing Machine Repair'),
          SubCategory(name: 'carpenter'),
          SubCategory(name: 'Metal Works'),
          SubCategory(name: 'Refrigator Repair'),
          SubCategory(name: 'Cook'),
          SubCategory(name: 'Transporter'),
          SubCategory(name: 'Others'),
        ],
        type: StoreType.service),
    Category(
      name: 'Services',
      type: StoreType.service,
      subCategories: [
        SubCategory(name: 'Beauty Parlours'),
        SubCategory(name: 'Car wash'),
        SubCategory(name: 'Courier services'),
        SubCategory(name: 'GYMs'),
        SubCategory(name: 'Internet stores'),
        SubCategory(name: 'Laundry store'),
        SubCategory(name: 'Mechanic Stores'),
        SubCategory(name: 'Repair stores'),
        SubCategory(name: 'Saloons'),
      ],
    ),
    Category(
      name: "Food",
      subCategories: [
        SubCategory(name: 'Restaurants'),
        SubCategory(name: 'Bakery'),
        SubCategory(name: 'Cafe'),
        SubCategory(name: 'Fast Food'),
        SubCategory(name: 'Food Truck'),
        SubCategory(name: 'Ice Cream Parlour'),
        SubCategory(name: 'Juice shop'),
        SubCategory(name: 'Street foods'),
        SubCategory(name: 'Sweets'),
      ],
      type: StoreType.food,
    ),
    Category(
      name: 'Rental stores',
      type: StoreType.service,
      subCategories: [
        SubCategory(name: 'Banquet Hall'),
        SubCategory(name: 'Electronics Rentals'),
        SubCategory(name: 'Vehicle Rentals'),
        SubCategory(name: 'Bike Rentals'),
        SubCategory(name: 'Fashion Rentals'),
        SubCategory(name: 'Car rentals'),
        SubCategory(name: 'Furniture Rentals'),
      ],
    ),
    Category(
      name: 'Coachings',
      type: StoreType.service,
      subCategories: [
        SubCategory(name: 'Academic Coaching'),
        SubCategory(name: 'language Coaching'),
        SubCategory(name: 'Technology Coaching'),
        SubCategory(name: 'Arts Coaching'),
        SubCategory(name: 'Music Coaching'),
        SubCategory(name: 'Test Prep Coaching'),
        SubCategory(name: 'Dance Coaching'),
        SubCategory(name: 'Sports Coaching'),
        SubCategory(name: 'Wellness Coaching'),
      ],
    ),
    Category(
      name: 'Agencies',
      type: StoreType.service,
      subCategories: [
        SubCategory(name: 'Advertising Agency'),
        SubCategory(name: 'Event Planning Agency'),
        SubCategory(name: 'Travel Agency'),
        SubCategory(name: 'Desining Agency'),
        SubCategory(name: 'Marketing Agency'),
        SubCategory(name: 'Employement Agency'),
        SubCategory(name: 'Printing Press'),
      ],
    ),
    Category(
      name: 'Showrooms',
      type: StoreType.store,
      subCategories: [
        SubCategory(name: 'Automobile Showrooms'),
        SubCategory(name: 'Electronics Showrooms'),
        SubCategory(name: 'Jewellery Showrooms'),
        SubCategory(name: 'Clothing Showrooms'),
        SubCategory(name: 'Furniture Showrooms'),
      ],
    ),
    Category(
      name: 'Movies & Events',
      type: StoreType.service,
      subCategories: [
        SubCategory(name: 'Amusement parks'),
        SubCategory(name: 'Carnivals'),
        SubCategory(name: 'Events'),
        SubCategory(name: 'Movies'),
        SubCategory(name: 'Video Games'),
      ],
    ),
    Category(name: "Explore", type: StoreType.service, subCategories: [
      SubCategory(name: 'Local Toursims'),
      SubCategory(name: 'Pubs & Bars'),
      SubCategory(name: 'Parks'),
    ]),
    Category(
      name: 'Businesses',
      type: StoreType.service,
      subCategories: [],
    ),
    Category(
      name: 'Hotel',
      type: StoreType.service,
      subCategories: [],
    ),
    Category(
      name: 'Ride hire',
      type: StoreType.service,
      subCategories: [],
    ),
  ];
}
