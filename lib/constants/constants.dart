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

  static List<StoreCategory> StoreCategories = [
    StoreCategory(
      imageName: 'General stores.png',
      categoryName: 'General Stores',
      productCategories: [
        ProductCategory(categoryName: 'Cleaning supplies', image: 'Pantry'),
        ProductCategory(
            categoryName: 'Household essentials', image: 'House essentials'),
        ProductCategory(
            categoryName: 'Snacks and beverages', image: 'Snacks and drinks'),
        ProductCategory(
            categoryName: 'Personal care products', image: 'Self care'),
        ProductCategory(categoryName: 'Pet care items', image: 'Pet care'),
        ProductCategory(
            categoryName: 'Office supplies', image: 'Office essentials'),
        ProductCategory(categoryName: 'Toys and games', image: 'Toys'),
        ProductCategory(categoryName: 'Kitchenware', image: 'Kitchen'),
        ProductCategory(
            categoryName: 'Seasonal items', image: 'Spices and powders'),
        ProductCategory(
            categoryName: 'Health and wellness', image: 'Health and wellness'),
      ],
    ),
    StoreCategory(
      imageName: 'Stationary stores.png',
      categoryName: 'Stationary Stores',
      productCategories: [
        ProductCategory(
            categoryName: 'Writing instruments', image: 'writing_instruments'),
        ProductCategory(
            categoryName: 'Notebooks and pads', image: 'notebooks_and_pads'),
        ProductCategory(categoryName: 'Art supplies', image: 'art_supplies'),
        ProductCategory(
            categoryName: 'Desk accessories', image: 'desk_accessories'),
        ProductCategory(
            categoryName: 'Calendars and planners',
            image: 'calendars_and_planners'),
        ProductCategory(
            categoryName: 'Filing and organization',
            image: 'filing_and_organization'),
        ProductCategory(
            categoryName: 'Crafting materials', image: 'crafting_materials'),
        ProductCategory(
            categoryName: 'School supplies', image: 'school_supplies'),
        ProductCategory(
            categoryName: 'Classroom essentialss',
            image: 'Classroom essentials'),
// ProductCategory(
// categoryName: 'Office furniture', image: 'office_furniture'),
      ],
    ),
    StoreCategory(
      imageName: 'Electronic stores.png',
      categoryName: 'Electronic Stores',
      productCategories: [
        ProductCategory(
            categoryName: 'Smartphones and accessories', image: 'Smartphones'),
        ProductCategory(
            categoryName: 'Laptops and computers', image: 'Laptop accessories'),
        ProductCategory(categoryName: 'Audio devices', image: 'Speakers'),
        ProductCategory(
            categoryName: 'Cameras and photography equipment',
            image: 'Cameras and equipment'),
        ProductCategory(
            categoryName: 'Home appliances', image: 'Home appliances'),
        ProductCategory(
            categoryName: 'Gaming consoles and accessories',
            image: 'Gaming Accessories'),
        ProductCategory(
            categoryName: 'Wearable technology', image: 'Wearables'),
        ProductCategory(
            categoryName: 'Batteries and chargers',
            image: 'Chargers and batteries'),
      ],
    ),
    StoreCategory(
      imageName: 'Fashion stores.png',
      categoryName: 'Fashion Stores',
      productCategories: [
        ProductCategory(categoryName: 'Men’s clothing', image: 'mens_clothing'),
        ProductCategory(
            categoryName: 'Women’s clothing', image: 'womens_clothing'),
        ProductCategory(categoryName: 'Kids’ clothing', image: 'kids_clothing'),
// ProductCategory(
// categoryName: 'Shoes and footwear',
// image: 'shoes_and_footwear'),
        ProductCategory(
            categoryName: 'Accessories (hats, scarves, etc.)',
            image: 'accessories'),
        ProductCategory(categoryName: 'Jewelery', image: 'jewelery'),
        ProductCategory(
            categoryName: 'Handbags and purses', image: 'handbags_and_purses'),
        ProductCategory(categoryName: 'Sunglasses', image: 'sunglasses'),
// ProductCategory(categoryName: 'Watches', image: 'watches'),
// ProductCategory(categoryName: 'Formal wear', image: 'formal_wear'),
      ],
    ),
    StoreCategory(
      imageName: 'Footwear stores.png',
      categoryName: 'Footwear Stores',
      productCategories: [
        ProductCategory(categoryName: 'Men’s shoes', image: 'mens_shoes'),
        ProductCategory(categoryName: 'Women’s shoes', image: 'womens_shoes'),
        ProductCategory(
            categoryName: 'Boots and booties', image: 'boots_and_booties'),
        ProductCategory(categoryName: 'Slippers', image: 'slippers'),
        ProductCategory(categoryName: 'Kids’ shoes', image: 'kids_shoes'),
      ],
    ),
    StoreCategory(
      imageName: 'Accessory stores.png',
      categoryName: 'Accessory Stores',
      productCategories: [
        ProductCategory(
            categoryName: 'Handbags and clutches',
            image: 'handbags_and_clutches.png'),
        ProductCategory(categoryName: 'Jewelry', image: 'jewelry.png'),
        ProductCategory(
            categoryName: 'Hats and caps', image: 'hats_and_caps.png'),
        ProductCategory(
            categoryName: 'Scarves and wraps', image: 'scarves_and_wraps.png'),
        ProductCategory(categoryName: 'Sunglasses', image: 'sunglasses.png'),
        ProductCategory(categoryName: 'Watches', image: 'watches.png'),
        ProductCategory(categoryName: 'Belts', image: 'belts.png'),
        ProductCategory(
            categoryName: 'Gloves and mittens',
            image: 'gloves_and_mittens.png'),
        ProductCategory(
            categoryName: 'Hair accessories', image: 'hair_accessories.png'),
        ProductCategory(
            categoryName: 'Tech accessories', image: 'tech_accessories.png'),
      ],
    ),
    StoreCategory(
      imageName: 'Rental stores.png',
      categoryName: 'Rental Stores',
      productCategories: [
        ProductCategory(
            categoryName: 'Event equipment', image: 'event_equipment.png'),
        ProductCategory(
            categoryName: 'Tools and machinery',
            image: 'tools_and_machinery.png'),
        ProductCategory(
            categoryName: 'Party supplies', image: 'party_supplies.png'),
        ProductCategory(
            categoryName: 'Formal attire rentals',
            image: 'formal_attire_rentals.png'),
        ProductCategory(
            categoryName: 'Outdoor gear', image: 'outdoor_gear.png'),
        ProductCategory(
            categoryName: 'Furniture rentals', image: 'furniture_rentals.png'),
        ProductCategory(
            categoryName: 'Home appliance rentals',
            image: 'home_appliance_rentals.png'),
        ProductCategory(
            categoryName: 'Vehicle rentals', image: 'vehicle_rentals.png'),
        ProductCategory(
            categoryName: 'Audio-visual equipment',
            image: 'audio_visual_equipment.png'),
        ProductCategory(
            categoryName: 'Recreational equipment',
            image: 'recreational_equipment.png'),
      ],
    ),
    StoreCategory(
      imageName: 'Grocery stores.png',
      categoryName: 'Grocery Stores',
      productCategories: [
        ProductCategory(
            categoryName: 'Fresh produce', image: 'fresh_produce.png'),
        ProductCategory(
            categoryName: 'Dairy and eggs', image: 'dairy_and_eggs.png'),
        ProductCategory(
            categoryName: 'Meat and seafood', image: 'meat_and_seafood.png'),
        ProductCategory(
            categoryName: 'Canned and packaged goods',
            image: 'canned_and_packaged_goods.png'),
        ProductCategory(
            categoryName: 'Bakery items', image: 'bakery_items.png'),
        ProductCategory(
            categoryName: 'Frozen foods', image: 'frozen_foods.png'),
        ProductCategory(categoryName: 'Beverages', image: 'beverages.png'),
        ProductCategory(
            categoryName: 'Snacks and sweets', image: 'snacks_and_sweets.png'),
        ProductCategory(
            categoryName: 'Organic and natural products',
            image: 'organic_and_natural_products.png'),
        ProductCategory(
            categoryName: 'International foods',
            image: 'international_foods.png'),
      ],
    ),
    StoreCategory(
      imageName: 'Beauty and products store.png',
      categoryName: 'Beauty and Products',
      productCategories: [
        ProductCategory(categoryName: 'Skincare', image: 'skincare.png'),
        ProductCategory(categoryName: 'Makeup', image: 'makeup.png'),
        ProductCategory(categoryName: 'Haircare', image: 'haircare.png'),
        ProductCategory(categoryName: 'Fragrances', image: 'fragrances.png'),
        ProductCategory(
            categoryName: 'Bath and body products',
            image: 'bath_and_body_products.png'),
        ProductCategory(categoryName: 'Nail care', image: 'nail_care.png'),
        ProductCategory(
            categoryName: 'Men’s grooming products',
            image: 'mens_grooming_products.png'),
        ProductCategory(
            categoryName: 'Beauty tools and accessories',
            image: 'beauty_tools_and_accessories.png'),
        ProductCategory(
            categoryName: 'Wellness products', image: 'wellness_products.png'),
        ProductCategory(
            categoryName: 'Specialty beauty items',
            image: 'specialty_beauty_items.png'),
      ],
    ),
    StoreCategory(
      imageName: 'Internet and technology stores.png',
      categoryName: 'Sports Stores',
      productCategories: [
        ProductCategory(
            categoryName: 'Athletic apparel', image: 'athletic_apparel.png'),
        ProductCategory(
            categoryName: 'Footwear for sports',
            image: 'footwear_for_sports.png'),
        ProductCategory(
            categoryName: 'Exercise equipment',
            image: 'exercise_equipment.png'),
        ProductCategory(
            categoryName: 'Team sports gear', image: 'team_sports_gear.png'),
        ProductCategory(
            categoryName: 'Outdoor and adventure gear',
            image: 'outdoor_and_adventure_gear.png'),
        ProductCategory(
            categoryName: 'Yoga and fitness accessories',
            image: 'yoga_and_fitness_accessories.png'),
        ProductCategory(categoryName: 'Swimwear', image: 'swimwear.png'),
        ProductCategory(
            categoryName: 'Sports nutrition', image: 'sports_nutrition.png'),
        ProductCategory(
            categoryName: 'Recovery and injury prevention',
            image: 'recovery_and_injury_prevention.png'),
        ProductCategory(
            categoryName: 'Camping and hiking equipment',
            image: 'camping_and_hiking_equipment.png'),
      ],
    ),
  ];
}

class StoreCategory {
  String imageName;
  String categoryName;
  List<ProductCategory> productCategories = [];
// StoreType storeType;
  StoreCategory({
    required this.imageName,
    required this.categoryName,
    required this.productCategories,
// required this.storeType,
  });
}

class ProductCategory {
  String categoryName;
  String image;
  ProductCategory({required this.categoryName, required this.image});
}
