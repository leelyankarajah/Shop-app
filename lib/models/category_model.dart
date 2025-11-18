class CategoryModel {
  final String title;
  final String? image, svgSrc;
  final List<CategoryModel>? subCategories;

  CategoryModel({
    required this.title,
    this.image,
    this.svgSrc,
    this.subCategories,
  });
}

final List<CategoryModel> demoCategoriesWithImage = [
  CategoryModel(title: "Fruits & Vegetables", image: "https://images.unsplash.com/photo-1547516508-4b646d0f0b6c?auto=format&fit=crop&w=800&q=80"),
  CategoryModel(title: "Dairy", image: "https://images.unsplash.com/photo-1585238342023-78f8b8f0d7f7?auto=format&fit=crop&w=800&q=80"),
  CategoryModel(title: "Bakery", image: "https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80"),
  CategoryModel(title: "Pantry", image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=800&q=80"),
];

final List<CategoryModel> demoCategories = [
  CategoryModel(
    title: "On Sale",
    svgSrc: "assets/icons/Sale.svg",
    subCategories: [
      CategoryModel(title: "All Products"),
      CategoryModel(title: "Fresh Deals"),
      CategoryModel(title: "Limited Offers"),
    ],
  ),
  CategoryModel(
    title: "Grocery",
    svgSrc: "assets/icons/Man&Woman.svg",
    subCategories: [
      CategoryModel(title: "Pantry"),
      CategoryModel(title: "Canned Goods"),
      CategoryModel(title: "Staples"),
    ],
  ),
  CategoryModel(
    title: "Fresh",
    svgSrc: "assets/icons/Child.svg",
    subCategories: [
      CategoryModel(title: "Fruits & Vegetables"),
      CategoryModel(title: "Meat & Fish"),
      CategoryModel(title: "Dairy"),
    ],
  ),
  CategoryModel(
    title: "Household",
    svgSrc: "assets/icons/Accessories.svg",
    subCategories: [
      CategoryModel(title: "Cleaning"),
      CategoryModel(title: "Kitchen"),
    ],
  ),
];
