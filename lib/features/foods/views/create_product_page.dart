import 'package:flutter/material.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final TextEditingController productNameCont = TextEditingController();
  final TextEditingController caloriesCont = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    productNameCont.dispose();
    caloriesCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Product Page")),
      body: SafeArea(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: productNameCont,
                    decoration: InputDecoration(hintText: "eg;, Apple", labelText: "Product Name"),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the product name";
                      }
                      return null;
                    }
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: caloriesCont,
                    decoration: InputDecoration(hintText: "eg;, 300", labelText: "Calories"),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter the calories";
                        }
                        return null;
                      }
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [ElevatedButton(onPressed: () {}, child: Text("Create Product"))],
        ),
      ),
    );
  }
}
