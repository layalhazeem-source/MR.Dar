import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:new_project/view/home.dart';
import 'package:new_project/view/signup.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controller/signupcontroller.dart';

class Signup extends StatelessWidget {
  Signup({super.key});
  final signupController controller = Get.put(signupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        color: Color(0xFFE8E8E8),
        child: Column(
          children: [
            Container(
              height: 275,
              child: Image.asset("images/photo_2025-11-27_11-23-04.jpg"),
            ),

            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    maxLength: 20,

                    style: const TextStyle(color: Colors.black87, fontSize: 22),
                    decoration: InputDecoration(
                      labelText: "First name",
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black45,
                        fontSize: 16,
                      ),

                      fillColor: Color(0xFFCFFDFA),
                      filled: true,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF34F6F2),
                          width: 2.w,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black26,
                          width: 2.w,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10), // مسافة صغيرة بين الحقلين

                Expanded(
                  child: GetBuilder<signupController>(
                    builder: (controller) {
                      return TextFormField(
                        maxLength: 15,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 22,
                        ),
                        decoration: InputDecoration(
                          labelText: "Last name",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                            fontSize: 16,
                          ),

                          fillColor: Color(0xFFCFFDFA),
                          filled: true,
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF34F6F2),
                              width: 2.w,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black26,
                              width: 2.w,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),

            GetBuilder<signupController>(
              builder: (controller) {
                return TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: controller.birthDate.value,
                  ),
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 16,
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                    fillColor: Color(0xFFCFFDFA),
                    filled: true,
                    border: OutlineInputBorder(),

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF34F6F2),
                        width: 2.w,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black26, width: 2.w),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      controller.setBirthDate(formattedDate);
                      controller.update(); // لتحديث الواجهة
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
