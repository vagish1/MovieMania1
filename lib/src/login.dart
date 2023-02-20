import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moviemania/src/database.dart';
import 'package:moviemania/src/home_page.dart';
import 'package:moviemania/src/shared_pref.dart';
import 'package:moviemania/src/signup.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.light) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark));
    } else {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light));
    }

    return Scaffold(
      body: FutureBuilder(
        future: SharedPref.instance.isLogedIn(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return const LogIn();
          }

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 8.0),
                Text(
                  "MovieMania",
                  style: Theme.of(context).textTheme.headline6!.merge(
                        const TextStyle(fontFamily: "Euclid"),
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Image.asset(
            "assets/fonts/netflix.png",
          ),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            "Hi, You need to sing in to continue",
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
            "We need to authenticate you in order to proceed further",
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
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return const SignUp();
                  }));
                },
                child: Text(
                  "I don't have account",
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
                  "Forgot Password?",
                  style: Theme.of(context).textTheme.button!.merge(
                        TextStyle(
                            fontFamily: "Ecuclid", color: Colors.grey.shade700),
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
                    return FutureBuilder<Map<String, Object?>>(
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data?['USER_EMAIL'] == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text("You don't have an account with us."),
                            ));
                          }

                          if (snapshot.data!['USER_PASSWORD'] ==
                              password.text) {
                            SharedPref.instance.completeLogin();
                            return Success(
                              title: "SingIn Completed",
                              desc: "You can now continue to homescreen",
                              email: email.text,
                              onPress: () {
                                Navigator.pop(context);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) {
                                          return const HomePage();
                                        },
                                        fullscreenDialog: true));
                              },
                            );
                          }

                          return const ErrorWidget(
                              errorTitle: "Failed to authenticate",
                              errorDesc:
                                  "Your password don't matched with the original password");
                        }

                        if (snapshot.hasError) {
                          return ErrorWidget(
                              errorTitle: "Unexpected Error Occured",
                              errorDesc: snapshot.error.toString());
                        }
                        return const Progress(
                          title: "SingIn in Progress",
                          desc:
                              "We appreciate your patience...You need to wait until we reach you....Thanks",
                        );
                      },
                      future: MovieManiaDatabase.instance.getUser(email.text),
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
                      fontSize: 16.0,
                    ),
                  ),
            ),
          )
        ],
      ),
    );
  }
}

class Success extends StatelessWidget {
  final String title;
  final String desc;
  final String email;
  final Function() onPress;
  const Success({
    Key? key,
    required this.title,
    required this.desc,
    required this.email,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 28.0,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            title,
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
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Euclid",
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              elevation: 0,
            ),
            onPressed: onPress,
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}

class Progress extends StatelessWidget {
  final String title;
  final String desc;
  const Progress({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            title,
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
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Euclid",
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String errorTitle;
  final String errorDesc;
  const ErrorWidget({
    super.key,
    required this.errorTitle,
    required this.errorDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 28.0,
            backgroundColor: Colors.red,
            child: Icon(Icons.close_rounded, color: Colors.white),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            errorTitle,
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
            errorDesc,
            style: const TextStyle(
              fontFamily: "Euclid",
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 55),
              primary: Colors.red,
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
