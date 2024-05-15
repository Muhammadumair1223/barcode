import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/upload_controller.dart';
import '../utils/color_resources.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_drawer.dart';

class UploadImageScreen extends StatelessWidget {
  const UploadImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<UploadController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          padding: const EdgeInsets.all(8.0),
          children: [
            TextFormField(
              controller: controller.productController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                hintText: "Now Press Image and scan Product",
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                labelText: 'Scan Product',
                prefixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: () async {},
                  icon: const Icon(Icons.clear),
                ),
                suffixIcon: IconButton(
                  color: Colors.teal,
                  onPressed: () async {},
                  icon: const Icon(Icons.search),
                ),
              ),
              onFieldSubmitted: controller.searchProduct,
            ),
            const SizedBox(height: 12.0),
            CustomButtonWidget(
              isLoading: controller.isLoadingGallery,
              buttonText: "Select image from gallery",
              onPressed: controller.pickImageFromGallery,
            ),
            const SizedBox(height: 10),
            CustomButtonWidget(
              isLoading: controller.isLoadingCamera,
              buttonText: "Take photo",
              onPressed: controller.pickImageFromCamera,
              buttonColor: ColorResources.colorPrint,
            ),
            controller.imageBytes != null
                ? Image.memory(
                    controller.imageBytes!,
                    height: 200,
                  )
                : const Text('Select an image'),
          ],
        ),
      ),
    );
  }
}
