import 'package:crud/utils/colors.dart';
import 'package:crud/utils/constants.dart';
import 'package:crud/utils/services.dart';
import 'package:crud/utils/strings.dart';
import 'package:crud/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = "";
  TextEditingController otpController = TextEditingController();

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
              Text(Strings.verifyPhone, style: headingStyle),
              const SizedBox(height: 32),
              const Text(
                Strings.enterCode,
                style: TextStyle(
                    color: MyColor.secondaryColor, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              PinCodeTextField(
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                cursorColor: Colors.black,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: Colors.transparent,
                  inactiveFillColor: Colors.transparent,
                  activeColor: Colors.black,
                  selectedFillColor: Colors.transparent,
                  inactiveColor: Colors.grey,
                  selectedColor: Colors.black
                ),
                animationDuration: const Duration(milliseconds: 300),
                backgroundColor: Colors.transparent,
                enableActiveFill: true,
                controller: otpController,
                onCompleted: (v) {
                  setState(() {
                    otp = v;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    otp = value;
                  });
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  return true;
                },
                appContext: context,
              ),
              const SizedBox(height: 40),
              Center(
                child: ButtonWidget(
                  title: Strings.verify,
                  onTap: () {
                    verifyOtp(widget.phone, context, otp);
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
