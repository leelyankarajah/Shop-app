// For demo only

class ProductModel {
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;

  ProductModel({
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
  });
}

List<ProductModel> demoPopularProducts = [
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1586201375761-83865001e1a5?auto=format&fit=crop&w=800&q=80",
    title: "Milk 1L",
    brandName: "Farm Fresh",
    price: 2.50,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1542831371-29b0f74f9713?auto=format&fit=crop&w=800&q=80",
    title: "Bread Loaf",
    brandName: "Local Bakery",
    price: 1.20,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=800&q=80",
    title: "Eggs (12 pcs)",
    brandName: "Golden Eggs",
    price: 3.75,
    priceAfetDiscount: 3.00,
    dicountpercent: 20,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1604908177522-6b0f3b8b3995?auto=format&fit=crop&w=800&q=80",
    title: "White Rice 5kg",
    brandName: "GoodGrain",
    price: 12.00,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1588167104856-3a7c8a1a3b6b?auto=format&fit=crop&w=800&q=80",
    title: "Cooking Oil 1L",
    brandName: "PureOil",
    price: 4.50,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1574226516831-e1dff420e43e?auto=format&fit=crop&w=800&q=80",
    title: "Bananas (1kg)",
    brandName: "Fresh Fruits",
    price: 1.80,
  ),
];
List<ProductModel> demoFlashSaleProducts = [
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1604908177733-7f4f6c6d2d3d?auto=format&fit=crop&w=800&q=80",
    title: "Cheddar Cheese 500g",
    brandName: "Cheezy",
    price: 6.00,
    priceAfetDiscount: 4.50,
    dicountpercent: 25,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1506084868230-bb9d95c24759?auto=format&fit=crop&w=800&q=80",
    title: "Green Tea - 100 Bags",
    brandName: "TeaHouse",
    price: 8.50,
    priceAfetDiscount: 6.80,
    dicountpercent: 20,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1588386731770-1b9f5a2b6d6c?auto=format&fit=crop&w=800&q=80",
    title: "Tomato Paste 700g",
    brandName: "TomatoCo",
    price: 2.20,
    priceAfetDiscount: 1.80,
    dicountpercent: 18,
  ),
];
List<ProductModel> demoBestSellersProducts = [
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1585238342023-78f8b8f0d7f7?auto=format&fit=crop&w=800&q=80",
    title: "White Sugar 1kg",
    brandName: "SweetCo",
    price: 1.10,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=800&q=80",
    title: "Ground Coffee 250g",
    brandName: "CoffeeLand",
    price: 5.50,
    priceAfetDiscount: 4.90,
    dicountpercent: 11,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1590086782793-6b4e2f3b1c3c?auto=format&fit=crop&w=800&q=80",
    title: "Biscuit Pack 200g",
    brandName: "BiscuitBest",
    price: 2.00,
  ),
];
List<ProductModel> kidsProducts = [
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1576402187876-1f3b56c9b9f6?auto=format&fit=crop&w=800&q=80",
    title: "Apple Juice 1L",
    brandName: "Juicy",
    price: 2.20,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1582719478179-6c9a0b2d8b2c?auto=format&fit=crop&w=800&q=80",
    title: "Kids Cheese Slices",
    brandName: "HappyKids",
    price: 3.00,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1600718378578-3f9bb8b3f2f2?auto=format&fit=crop&w=800&q=80",
    title: "Kids Candy 150g",
    brandName: "Sweetie",
    price: 1.50,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1542831371-29b0f74f9713?auto=format&fit=crop&w=800&q=80",
    title: "Strawberry Jam 350g",
    brandName: "JamHouse",
    price: 2.80,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80",
    title: "Kids Milk 200ml",
    brandName: "MilkKids",
    price: 0.90,
  ),
  ProductModel(
    image:
        "https://images.unsplash.com/photo-1499636136210-6f4ee915583e?auto=format&fit=crop&w=800&q=80",
    title: "Healthy Snack",
    brandName: "SnackPro",
    price: 1.70,
  ),
];
