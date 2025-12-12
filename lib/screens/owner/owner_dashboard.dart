import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/owner_provider.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/constants.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({Key? key}) : super(key: key);

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  String _search = '';
  bool _grid = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final owner = context.watch<OwnerProvider>();
    final products = owner.products
        .where((p) =>
            p.title.toLowerCase().contains(_search.toLowerCase()) ||
            p.brandName.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner dashboard'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Stats'),
          ],
        ),
      ),
      floatingActionButton: _tabs.index == 0
          ? FloatingActionButton(
              onPressed: () => _openProductEditor(context),
              child: const Icon(Icons.add),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            // الإحصائيات السريعة في الأعلى
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Products',
                    value: '${owner.products.length}',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    title: 'Orders',
                    value: '${owner.orders}',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    title: 'Visitors',
                    value: '${owner.visitors}',
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // شريط البحث + تغيير العرض (قائمة / Grid)
            if (_tabs.index == 0)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Search products',
                      ),
                      onChanged: (v) => setState(() => _search = v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => setState(() => _grid = !_grid),
                    icon: Icon(
                      _grid ? Icons.view_list : Icons.grid_view,
                    ),
                  ),
                ],
              ),
            if (_tabs.index == 0) const SizedBox(height: 12),
            // محتوى التابات
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  // تبويب المنتجات
                  _grid
                      ? _ProductsGrid(
                          products: products,
                          onEdit: _openProductEditor,
                          onDelete: _deleteProduct,
                        )
                      : _ProductsList(
                          products: products,
                          onEdit: _openProductEditor,
                          onDelete: _deleteProduct,
                        ),
                  // تبويب الإحصائيات
                  _StatsView(owner: owner),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteProduct(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete product'),
        content: Text('Are you sure you want to delete "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<OwnerProvider>().deleteProduct(product.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _openProductEditor(BuildContext context,
      [ProductModel? original]) async {
    final isEdit = original != null;

    final idController = TextEditingController(text: original?.id ?? '');
    final titleController = TextEditingController(text: original?.title ?? '');
    final brandController =
        TextEditingController(text: original?.brandName ?? '');
    final imageController =
        TextEditingController(text: original?.image ?? '');
    final priceController = TextEditingController(
        text: original != null ? original.price.toString() : '');
    final stockController = TextEditingController(
        text: original != null ? original.stock.toString() : '10');

    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit product' : 'Add product'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(labelText: 'ID'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: brandController,
                  decoration: const InputDecoration(labelText: 'Brand'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                TextFormField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final p = double.tryParse(v);
                    if (p == null) return 'Invalid number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final n = int.tryParse(v);
                    if (n == null) return 'Invalid number';
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!(formKey.currentState?.validate() ?? false)) return;

              final price = double.parse(priceController.text.trim());
              final stock = int.parse(stockController.text.trim());

              final newProduct = ProductModel(
                id: idController.text.trim(),
                image: imageController.text.trim().isEmpty
                    ? original?.image ??
                        "https://cdn-icons-png.flaticon.com/512/1046/1046784.png"
                    : imageController.text.trim(),
                brandName: brandController.text.trim(),
                title: titleController.text.trim(),
                price: price,
                priceAfetDiscount: null,
                dicountpercent: null,
                stock: stock,
                available: stock > 0,
                ordersCount: original?.ordersCount ?? 0,
              );

              final provider = context.read<OwnerProvider>();

              if (isEdit) {
                provider.updateProduct(original.id, newProduct);
              } else {
                provider.addProduct(newProduct);
              }

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding / 1.3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(defaultBorderRadious),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: blackColor60,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsList extends StatelessWidget {
  final List<ProductModel> products;
  final void Function(BuildContext, ProductModel) onEdit;
  final void Function(BuildContext, ProductModel) onDelete;

  const _ProductsList({
    required this.products,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products yet',
          style: TextStyle(color: blackColor60),
        ),
      );
    }

    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final p = products[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(p.image),
          ),
          title: Text(p.title),
          subtitle: Text('${p.brandName} • ₪${p.price.toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(context, p),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => onDelete(context, p),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  final List<ProductModel> products;
  final void Function(BuildContext, ProductModel) onEdit;
  final void Function(BuildContext, ProductModel) onDelete;

  const _ProductsGrid({
    required this.products,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'No products yet',
          style: TextStyle(color: blackColor60),
        ),
      );
    }

    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: defaultPadding,
        crossAxisSpacing: defaultPadding,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final p = products[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(defaultBorderRadious),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(defaultPadding / 1.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.network(
                    p.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                p.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                p.brandName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: blackColor60,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₪${p.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Orders: ${p.ordersCount}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: blackColor60,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                    onPressed: () => onEdit(context, p),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: Colors.red),
                    onPressed: () => onDelete(context, p),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatsView extends StatelessWidget {
  final OwnerProvider owner;

  const _StatsView({required this.owner});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Orders: ${owner.orders}\nVisitors: ${owner.visitors}\nProducts: ${owner.products.length}',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          height: 1.6,
        ),
      ),
    );
  }
}
