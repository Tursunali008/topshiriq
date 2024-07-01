import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:topshiriq/model/product.dart';
import 'package:topshiriq/servis/product_httpservis.dart';
import 'package:topshiriq/views/widgets/custom_drawer.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final ProductServices productServices = ProductServices();
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      products = await productServices.fetchProducts();
      setState(() {});
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void _addProduct(Product product) async {
    setState(() {
      products.add(product);
    });
    await productServices.addProduct(product);
    fetchProducts();
  }

  void _editProduct(Product product) async {
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      setState(() {
        products[index] = product;
      });
      await productServices.updateProduct(product.id, product);
      fetchProducts();
    }
  }

  void _deleteProduct(String id) async {
    setState(() {
      products.removeWhere((product) => product.id == id);
    });
    await productServices.deleteProduct(id);
  }

  void _toggleFavorite(Product product) async {
    setState(() {
      product.isFavorite = !product.isFavorite;
    });
    await productServices.updateProduct(product.id, product);
    fetchProducts();
  }

  void _showAddEditDialog([Product? product]) {
    showDialog(
      context: context,
      builder: (ctx) => ProductDialog(
        product: product,
        onSave: product == null ? _addProduct : _editProduct,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('admin_panel')),
        backgroundColor: Colors.amber,
      ),
      drawer: const CustomDrawer(),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (ctx, index) {
          final product = products[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(product.imageUrl),
            ),
            title: Text(product.title),
            subtitle: Text(
                '${tr('amount')}: ${product.amount} - ${tr('price')}: \$${product.price}'),
            trailing: IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: product.isFavorite ? Colors.red : null,
              ),
              onPressed: () => _toggleFavorite(product),
            ),
            onTap: () => _showAddEditDialog(product),
            onLongPress: () => _deleteProduct(product.id),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductDialog extends StatefulWidget {
  final Product? product;
  final Function(Product) onSave;

  const ProductDialog({super.key, this.product, required this.onSave});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDialogState createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _imageUrl;
  late double _price;
  late int _amount;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _title = widget.product!.title;
      _imageUrl = widget.product!.imageUrl;
      _price = widget.product!.price;
      _amount = widget.product!.amount;
      _isFavorite = widget.product!.isFavorite;
    } else {
      _title = '';
      _imageUrl = '';
      _price = 0.0;
      _amount = 0;
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newProduct = Product(
        id: widget.product?.id ?? DateTime.now().toString(),
        title: _title,
        imageUrl: _imageUrl,
        price: _price,
        amount: _amount,
        isFavorite: _isFavorite,
      );
      widget.onSave(newProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.product == null ? tr('add_product') : tr('edit_product')),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: tr('title')),
                validator: (value) {
                  if (value!.isEmpty) {
                    return tr('enter_name');
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                initialValue: _imageUrl,
                decoration: InputDecoration(labelText: tr('image_url')),
                validator: (value) {
                  if (value!.isEmpty) {
                    return tr('enter_profile_picture_url');
                  }
                  return null;
                },
                onSaved: (value) {
                  _imageUrl = value!;
                },
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: tr('price')),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty || double.tryParse(value) == null) {
                    return tr('enter_valid_price');
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _amount.toString(),
                decoration: InputDecoration(labelText: tr('amount')),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty || int.tryParse(value) == null) {
                    return tr('enter_valid_amount');
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = int.parse(value!);
                },
              ),
              SwitchListTile(
                title: Text(tr('favorite')),
                value: _isFavorite,
                onChanged: (value) {
                  setState(() {
                    _isFavorite = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(tr('cancel')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text(tr('save')),
        ),
      ],
    );
  }
}
