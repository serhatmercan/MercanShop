import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product")),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_priceFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Price"),
                focusNode: _priceFocusNode,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descFocusNode),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                focusNode: _descFocusNode,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
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
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _imageController,
                      decoration: InputDecoration(labelText: "Image URL"),
                      focusNode: _imageFocusNode,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
