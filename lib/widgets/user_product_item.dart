import 'package:ShopApp/providers/products.dart';
import 'package:ShopApp/screens/edit_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffoldContext = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        child: Row(
          children: [
            IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context).pushNamed(EditProduct.routeName, arguments: id),
            ),
            IconButton(
              color: Theme.of(context).errorColor,
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  Provider.of<Products>(context, listen: false).deleteProduct(id);
                } catch (e) {
                  scaffoldContext.showSnackBar(
                    SnackBar(
                      content: Text(
                        "Deleteing failde",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        width: 100,
      ),
    );
  }
}
