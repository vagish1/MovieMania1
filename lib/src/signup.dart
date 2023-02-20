import 'package:flutter/material.dart';
import 'package:moviemania/src/shared_pref.dart';
import 'login.dart';
import 'login.dart' as Err;
import 'database.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset(
              "assets/fonts/movi.png",
            ),
            const SizedBox(
              height: 24.0,
            ),
            Text(
              "Hi, You need to create an account with us.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5!.merge(
                    const TextStyle(
                      fontFamily: "Euclid",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              "We need you in our database, in order to access our content.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle1!.merge(
                    const TextStyle(
                      fontFamily: "Euclid",
                    ),
                  ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            TextField(
                controller: name,
                style: Theme.of(context).textTheme.subtitle1!.merge(
                      const TextStyle(
                        fontFamily: "Eculid",
                      ),
                    ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  labelStyle: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .merge(const TextStyle(fontFamily: "Euclid")),
                  label: const Text(
                    "Your Good Name",
                  ),
                )),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
                controller: email,
                style: Theme.of(context).textTheme.subtitle1!.merge(
                      const TextStyle(
                        fontFamily: "Eculid",
                      ),
                    ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  labelStyle: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .merge(const TextStyle(fontFamily: "Euclid")),
                  label: const Text(
                    "@example.com",
                  ),
                )),
            const SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: password,
              style: Theme.of(context).textTheme.subtitle1!.merge(
                    const TextStyle(
                      fontFamily: "Eculid",
                    ),
                  ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                labelStyle: Theme.of(context).textTheme.subtitle1!.merge(
                      const TextStyle(
                        fontFamily: "Eculid",
                      ),
                    ),
                label: const Text(
                  "Password",
                ),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "I already have an account",
                    style: Theme.of(context).textTheme.button!.merge(
                          TextStyle(
                            fontFamily: "Ecuclid",
                            color: Colors.grey.shade700,
                          ),
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Privacy Policy",
                    style: Theme.of(context).textTheme.button!.merge(
                          TextStyle(
                              fontFamily: "Ecuclid",
                              color: Colors.grey.shade700),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  )),
              onPressed: () {
                if (email.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please provide a valid email")));
                  return;
                }

                if (password.text.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text("Password must be greater than 8 characters")));
                  return;
                }

                showModalBottomSheet(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36.0),
                        topRight: Radius.circular(36.0),
                      ),
                    ),
                    context: context,
                    builder: (_) {
                      return FutureBuilder<bool>(
                        builder: (_, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!) {
                              SharedPref.instance.completeLogin();
                              return Success(
                                title: "Account Created Successfully",
                                desc:
                                    "We Successfully Created Your Account, You can now Login",
                                email: email.text,
                                onPress: () {
                                  Navigator.pop(context);
                                },
                              );
                            }

                            return const Err.ErrorWidget(
                                errorTitle: "Failed to create an accunt",
                                errorDesc:
                                    "We are unable to create your account right now.");
                          }

                          if (snapshot.hasError) {
                            return Err.ErrorWidget(
                                errorTitle: "Unexpected Error Occured",
                                errorDesc: snapshot.error.toString());
                          }
                          return const Progress(
                            title: "We are creating your account",
                            desc:
                                "We appreciate your patience...You need to wait until we reach you....Thanks",
                          );
                        },
                        future: MovieManiaDatabase.instance
                            .insertUser(name.text, email.text, password.text),
                      );
                    },
                    isDismissible: true);
              },
              child: Text(
                "Continue",
                style: Theme.of(context).textTheme.button!.merge(
                      const TextStyle(
                          fontFamily: "Euclid",
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16.0),
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
