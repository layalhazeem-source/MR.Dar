import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/my_account_controller.dart';

class MyAccount extends StatelessWidget {
  MyAccount({super.key});

  // استدعاء الـ Controller
  final MyAccountController controller = Get.put(MyAccountController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.user.value;
      if (user == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/avatar.png"),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "First Name: ${user.firstName}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Last Name: ${user.lastName}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text("Phone: ${user.phone}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Role: ${user.role}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              "Date of Birth: ${user.dateOfBirth}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // ممكن تضيفي وظيفة لتعديل الحساب أو تسجيل الخروج
                  Get.snackbar("Edit", "Edit profile tapped!");
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF274668),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
