import 'package:cosmos_client/Constants.dart';
import 'package:cosmos_client/UserManagement/Screens/LogInPassword.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class Loginotp extends StatefulWidget {
  const Loginotp({super.key});

  @override
  _LoginotpState createState() => _LoginotpState();
}

class _LoginotpState extends State<Loginotp> {
  bool isLoginSelected = true;
  int resendTimer = 60;
  Timer? _timer;
  List<String> otpDigits = List.generate(6, (index) => '');

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startResendTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (resendTimer == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            resendTimer--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Colors.blue,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'images/cosmos.png',
                    height: 250,
                    width: 250,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary:
                                isLoginSelected ? Colors.grey : kPrimaryColor,
                            minimumSize: const Size(160, 50),
                            shadowColor: Colors.black,
                            alignment: Alignment.center,
                            elevation: 10,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isLoginSelected = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: const Text(
                            'PASSWORD',
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary:
                                isLoginSelected ? kPrimaryColor : Colors.grey,
                            minimumSize: const Size(160, 50),
                            shadowColor: Colors.black,
                            alignment: Alignment.center,
                            elevation: 10,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isLoginSelected = true;
                            });
                          },
                          child: const Text(
                            'OTP',
                            style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email, color: Colors.white60),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white60),
                    ),
                    //validations
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Email';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    minimumSize: const Size(150, 50),
                    shadowColor: Colors.black,
                    alignment: Alignment.center,
                    elevation: 10,
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'SEND',
                    style: TextStyle(
                      fontSize: 15,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: OtpTextField(
                    numberOfFields: 5,
                    borderColor: Colors.white60,
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here
                    },
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Verification Code"),
                              content: Text(
                                'Code entered is $verificationCode',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              shape: kAlertBoxBorderStyle,
                            );
                          });
                    }, // end onSubmit
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: resendTimer > 0
                          ? null
                          : () {
                              setState(() {
                                resendTimer = 60;
                                startResendTimer();
                              });
                            },
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: resendTimer > 0 ? Colors.white60 : Colors.red,
                          decoration: resendTimer > 0
                              ? TextDecoration.none
                              : TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      resendTimer > 0 ? ' ($resendTimer)' : '',
                      style: TextStyle(
                        color: resendTimer > 0 ? Colors.white : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
