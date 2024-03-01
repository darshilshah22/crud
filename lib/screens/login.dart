import 'package:crud/screens/otp.dart';
import 'package:crud/utils/constants.dart';
import 'package:crud/utils/services.dart';
import 'package:crud/utils/strings.dart';
import 'package:crud/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Strings.withPhone, style: headingStyle),
              const SizedBox(height: 32),
              IntlPhoneField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  print(phone.completeNumber);
                  setState(() {
                    phoneNumber = phone.completeNumber;
                  });
                },
              ),
              const SizedBox(height: 64),
              Center(
                child: ButtonWidget(
                  title: "Continue",
                  onTap: () {
                    if (phoneNumber.isNotEmpty) {
                      sentCode(phoneNumber, context, "");
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OtpScreen(phone: phoneNumber)),
                          (route) => false);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter phone number"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
