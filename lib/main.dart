import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/auth_controller.dart';
import 'controllers/barcode_controller.dart';
import 'controllers/check_price_controller.dart';
import 'controllers/count_inventory_controller.dart';
import 'controllers/inventory_entry_controller.dart';
import 'controllers/out_stock_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/show_inventory_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/transfer_inventory_controller.dart';
import 'controllers/upload_controller.dart';
import 'repository/auth_repository.dart';
import 'repository/inventory_repository.dart';
import 'screens/add_product_screen.dart';
import 'screens/barcode_generate_screen.dart';
import 'screens/check_price_screen.dart';
import 'screens/count_inventory_screen.dart';
import 'screens/entry_inventory_screen.dart';
import 'screens/login_screen.dart';
import 'screens/out_stock_screen.dart';
import 'screens/show_inventory_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/transfer_inventory_screen.dart';
import 'screens/upload_image_screen.dart';
import 'theme/theme.dart';
import 'utils/global_context_key.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.bluetooth.request();
  await Permission.bluetoothConnect.request();
  await Permission.bluetoothScan.request();

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      Provider.value(value: sharedPreferences),

      // Repositories
      Provider<InventoryRepository>(
        create: (context) => InventoryRepository(
          sharedPreferences: sharedPreferences,
        ),
      ),
      Provider<AuthRepository>(
        create: (context) => AuthRepository(
          sharedPreferences: sharedPreferences,
        ),
      ),

      // Controllers
      ChangeNotifierProvider(
        create: (context) =>
            ThemeController(sharedPreferences: sharedPreferences),
      ),
      ChangeNotifierProvider(
        create: (context) => AuthController(
          context.read<AuthRepository>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => BarcodeController(
            context.read<InventoryRepository>(), sharedPreferences),
      ),
      ChangeNotifierProvider(
        create: (context) => TransferInventoryController(
          context.read<InventoryRepository>(),
          sharedPreferences,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => UploadController(
          context.read<InventoryRepository>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => ProductController(
            context.read<InventoryRepository>(), sharedPreferences),
      ),
      ChangeNotifierProvider(
        create: (context) => CheckPriceController(
            context.read<InventoryRepository>(), sharedPreferences),
      ),
      ChangeNotifierProvider(
        create: (context) => CountInventoryController(
            context.read<InventoryRepository>(), sharedPreferences),
      ),
      ChangeNotifierProvider(
        create: (context) => InventoryEntryController(
            context.read<InventoryRepository>(), sharedPreferences),
      ),
      ChangeNotifierProvider(
        create: (context) => OutStockController(
            context.read<InventoryRepository>(), sharedPreferences),
      ),
      ChangeNotifierProvider(
        create: (context) => ShowInventoryController(
            context.read<InventoryRepository>(), sharedPreferences),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcode Inventory',
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/showinventory': (context) => const ShowInventoryScreen(),
        '/entryinventory': (context) => const EntryInventory(),
        '/countinventory': (context) => const CountInventoryScreen(),
        '/checkprice': (context) => const CheckPriceScreen(),
        '/addproduct': (context) => const AddProductScreen(),
        '/transferinventory': (context) => const TransferInventoryScreen(),
        '/outinventory': (context) => const OutStockScreen(),
        '/barcodegenerator': (context) => const BarCodeGenerateScreen(),
        '/uploadImage': (context) => const UploadImageScreen(),
      },
    );
  }
}
