import 'package:ShopApp/providers/product.dart';
import 'package:ShopApp/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  static const routeName = "/edit-product";

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var _editedProduct = Product(id: null, title: "", description: "", price: 0, imageUrl: "");
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProduct = Provider.of<Products>(context, listen: false).findByID(productId);
        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          "imageUrl": "",
        };
        _imageController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);

    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageController.dispose();

    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      if ((_imageController.text.isEmpty) ||
          (!_imageController.text.startsWith("http")) ||
          (!_imageController.text.endsWith(".png") &&
              !_imageController.text.endsWith(".jpg") &&
              !_imageController.text.endsWith(".jpeg"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();

    if (!isValid) return;

    _formKey.currentState.save();

    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id == null) {
      try {
        await Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      } catch (e) {
        showDialog<Null>(
          context: context,
          builder: (ctx) => showDialogBuilder(ctx),
        );
      }
    } else {
      await Provider.of<Products>(context, listen: false).updateProduct(_editedProduct);
    }

    setState(() {
      _isLoading = true;
    });

    Navigator.of(context).pop();
  }

  AlertDialog showDialogBuilder(BuildContext ctx) {
    return AlertDialog(
      content: Text("Something went wrong !"),
      title: Text("An error occured"),
      actions: [
        FlatButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text("Okay"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: scaffoldAppBar(),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : scaffoldBody(context),
    );
  }

  AppBar scaffoldAppBar() {
    return AppBar(
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _saveForm,
        )
      ],
      title: Text("Edit Product"),
    );
  }

  Padding scaffoldBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            titleTextFormField(context),
            priceTextFormField(context),
            descriptionTextFormField(),
            imageRow(),
          ],
        ),
      ),
    );
  }

  TextFormField descriptionTextFormField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Description"),
      initialValue: _initValues["description"],
      focusNode: _descFocusNode,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      validator: (value) {
        if (value.isEmpty) {
          return "Please, Enter a description";
        }
        if (value.length < 10) {
          return "Description should be at least 10 characters long.";
        }
        return null;
      },
      onSaved: (value) => _editedProduct = Product(
        id: _editedProduct.id,
        title: _editedProduct.title,
        description: value,
        price: _editedProduct.price,
        imageUrl: _editedProduct.imageUrl,
      ),
    );
  }

  TextFormField priceTextFormField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Price"),
      initialValue: _initValues["price"],
      focusNode: _priceFocusNode,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value.isEmpty) {
          return "Please, Enter a price.";
        }
        if (double.tryParse(value) == null) {
          return "Please, Enter a valid price.";
        }
        if (double.parse(value) <= 0) {
          return "Please, Enter a price greater than zero.";
        }
        return null;
      },
      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descFocusNode),
      onSaved: (value) => _editedProduct = Product(
        id: _editedProduct.id,
        title: _editedProduct.title,
        description: _editedProduct.description,
        price: double.parse(value),
        imageUrl: _editedProduct.imageUrl,
      ),
    );
  }

  TextFormField titleTextFormField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Title"),
      initialValue: _initValues["title"],
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value.isEmpty) {
          return "Please, Enter a title.";
        }
        return null;
      },
      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),
      onSaved: (value) => _editedProduct = Product(
        id: _editedProduct.id,
        title: value,
        description: _editedProduct.description,
        price: _editedProduct.price,
        imageUrl: _editedProduct.imageUrl,
        isFavorite: _editedProduct.isFavorite,
      ),
    );
  }

  Row imageRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [imageBox(), imageTextFormField()],
    );
  }

  Expanded imageTextFormField() {
    return Expanded(
      child: TextFormField(
        controller: _imageController,
        decoration: InputDecoration(labelText: "Image URL"),
        focusNode: _imageFocusNode,
        keyboardType: TextInputType.url,
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (value.isEmpty) {
            return "Please, Enter an image URL ";
          }
          if (!value.startsWith("http")) {
            return "Please, Enter a valid image URL ";
          }
          if (!value.endsWith(".png") && !value.endsWith(".jpg") && !value.endsWith(".jpeg")) {
            return "Please, Enter a valid image URL ";
          }
          return null;
        },
        onFieldSubmitted: (_) => _saveForm(),
        onSaved: (value) => _editedProduct = Product(
          id: _editedProduct.id,
          title: _editedProduct.title,
          description: _editedProduct.description,
          price: _editedProduct.price,
          imageUrl: value,
        ),
      ),
    );
  }

  Container imageBox() {
    return Container(
      child: _imageController.text.isEmpty
          ? Text("Enter a URL")
          : FittedBox(
              child: Image.network(
                _imageController.text,
                fit: BoxFit.cover,
              ),
            ),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey),
      ),
      height: 100,
      margin: EdgeInsets.only(top: 8, right: 10),
      width: 100,
    );
  }
}
