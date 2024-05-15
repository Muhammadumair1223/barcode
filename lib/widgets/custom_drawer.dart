import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AuthController>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Barcode Inventory',
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            titleTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Icon(Icons.book),
            title: const Text('Check Price'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/checkprice");
            },
          ),
          ListTile(
            titleTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Icon(Icons.abc_outlined),
            title: const Text('Show Inventory'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/showinventory");
            },
          ),
          ListTile(
            titleTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Icon(Icons.list),
            title: const Text('Entry Inventory'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/entryinventory");
            },
          ),
          ListTile(
            titleTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Icon(Icons.qr_code),
            title: const Text('Barcode Generator'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/barcodegenerator");
            },
          ),
          ListTile(
            titleTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Icon(Icons.add_a_photo),
            title: const Text('Add Product'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/addproduct");
            },
          ),
          ListTile(
            titleTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Icon(Icons.doorbell_sharp),
            title: const Text('Transfer Products'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/transferinventory");
            },
          ),
          ListTile(
            titleTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Icon(Icons.swap_calls),
            title: const Text('AI Image'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/uploadImage");
            },
          ),
          ListTile(
            titleTextStyle: Theme.of(context).textTheme.bodyLarge,
            leading: const Icon(Icons.swap_calls),
            title: const Text('Count Inventory'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/countinventory");
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log Out',
                style: TextStyle(color: Colors.redAccent)),
            onTap: () => controller.logout(context),
          ),
        ],
      ),
    );
  }
}
