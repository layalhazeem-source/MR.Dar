import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/my_account_controller.dart';

class MyAccount extends StatelessWidget {
  MyAccount({super.key});

  final MyAccountController controller = Get.put(MyAccountController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final user = controller.user.value;
      if (user == null) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 60, color: Colors.grey),
              SizedBox(height: 20),
              Text(
                "No user data found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => controller.refreshUser(),
                child: Text("Retry"),
              ),
            ],
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الملف الشخصي
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFF274668).withOpacity(0.1),
                backgroundImage:
                    (user.profileImage != null && user.profileImage!.isNotEmpty)
                    ? NetworkImage(user.profileImage!)
                    : null,
                child: (user.profileImage == null || user.profileImage!.isEmpty)
                    ? Icon(Icons.person, size: 60, color: Color(0xFF274668))
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            // صورة الهوية
            Text(
              "ID Image",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            (user.idImage != null && user.idImage!.isNotEmpty)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      user.idImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Text(
                    "No ID image uploaded",
                    style: TextStyle(color: Colors.grey),
                  ),

            const SizedBox(height: 30),
            _buildInfoCard("👤", "Name", "${user.firstName} ${user.lastName}"),
            _buildInfoCard("📱", "Phone", user.phone),
            _buildInfoCard("🎭", "Role", user.role.toString()),
            _buildInfoCard("🎂", "Date of Birth", user.dateOfBirth),
            _buildInfoCard("🆔", "User ID", user.id.toString()),

            const SizedBox(height: 30),
            SizedBox(height: 20),

            // زر التحديث
            Center(
              child: ElevatedButton.icon(
                onPressed: () => controller.refreshUser(),
                icon: Icon(Icons.refresh),
                label: Text("Refresh Data"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF274668),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoCard(String emoji, String label, String value) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Text(emoji, style: TextStyle(fontSize: 24)),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 5),
                  Text(
                    value.isNotEmpty ? value : "Not set",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
