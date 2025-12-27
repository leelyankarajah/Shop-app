import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/constants.dart';
import 'package:shop/providers/owner_provider.dart';
import 'package:shop/models/product_model.dart';

import 'owner_product_form.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final owner = context.watch<OwnerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Owner Dashboard'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: defaultPadding),

            // إحصائيات بسيطة
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: Row(
                children: [
                  _StatCard(
                    title: 'Visitors',
                    value: owner.visitors.toString(),
                    icon: Icons.people_outline,
                  ),
                  const SizedBox(width: defaultPadding),
                  _StatCard(
                    title: 'Orders',
                    value: owner.orders.toString(),
                    icon: Icons.shopping_bag_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(height: defaultPadding),

            // عنوان + زر إضافة منتج
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding,
              ),
              child: Row(
                children: [
                  const Text(
                    'Products',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const OwnerProductForm(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add product'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: defaultPadding / 2),

            // لودينغ / خطأ / ليست المنتجات
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                ),
                child: Builder(
                  builder: (context) {
                    if (owner.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (owner.errorMessage != null) {
                      return Center(
                        child: Text(
                          owner.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      );
                    }

                    final products = owner.products;

                    if (products.isEmpty) {
                      return const Center(
                        child: Text(
                          'No products yet. Add your first product.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: blackColor60),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: products.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: defaultPadding / 2),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _ProductRow(product: product);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(defaultBorderRadious),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: primaryColor),
            const SizedBox(width: defaultPadding / 2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: blackColor60,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final ProductModel product;

  const _ProductRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final owner = context.read<OwnerProvider>();

    return Container(
      padding: const EdgeInsets.all(defaultPadding / 1.2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة صغيرة
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: blackColor5,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_outlined,
                    size: 24,
                    color: blackColor40,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: defaultPadding / 1.2),

          // المعلومات الأساسية
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.brandName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: blackColor60,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₪${product.price.toStringAsFixed(2)}'
                  '${product.priceAfetDiscount != null ? '  (after: ₪${product.priceAfetDiscount!.toStringAsFixed(2)})' : ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Stock: ${product.stock} | Orders: ${product.ordersCount}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: blackColor60,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: defaultPadding / 2),

          // متاح / غير متاح
          Column(
            children: [
              Switch(
                value: product.available,
                activeColor: primaryColor,
                onChanged: (value) async {
                  final updated = product.copyWith(available: value);
                  await owner.updateProduct(product.id, updated);
                },
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              OwnerProductForm(existingProduct: product),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Delete product'),
                          content: Text(
                            'Are you sure you want to delete "${product.title}"?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await owner.deleteProduct(product.id);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
