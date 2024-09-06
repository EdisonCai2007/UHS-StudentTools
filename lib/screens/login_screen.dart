import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/models_services/teachassist_model.dart';
import 'package:wolfpackapp/screens/home_screen/home_screen.dart';
import 'package:wolfpackapp/shared_prefs.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../page_navigator.dart';

/*
#########################
#=-=-= LoginScreen =-=-=#
#########################
*/
class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool buttonClickable = true;

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Form(
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            extendBody: true,
            body: Column(
              children: [

                /*
                ####################
                #=-=-= Header =-=-=#
                ####################
                */
                Flexible(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 90, left: 60, right: 60, bottom: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(500), // Image radius
                          child: const Image(
                            image: AssetImage('assets/TemporaryLogo.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /*
                ##################
                #=-=-= Form =-=-=#
                ##################
                */

                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),//EdgeInsets.all(50),
                    child: Column(
                      children: [
                        // Username
                        UsernameField(controller: _usernameController),

                        const SizedBox(height: 15),

                        // Password
                        PasswordField(controller: _passwordController),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            child: Text('Sign In as Guest',
                              style: GoogleFonts.lato(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 14, fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),

                            ),
                            onPressed: () async {
                              PageNavigator.changePage(context, const HomeScreen());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                /*
                ############################
                #=-=-= Sign In Button =-=-=#
                ############################
                */

                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      child: ElevatedButton(
                        style: Theme.of(context).elevatedButtonTheme.style,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text('Sign In',
                                style: GoogleFonts.lato(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 20, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        onPressed: () async {
                          print(buttonClickable);
                          if (buttonClickable) {
                            if (Form.of(context).validate()) {
                              String username = _usernameController.text.trim();
                              String password = _passwordController.text.trim();

                              var response = await authorizeUser(
                                  username, password);
                              if (response[0] == 'Failed to Authorize User') {
                                if (!context.mounted) return;
                                showDialog(context: context,
                                    builder: (
                                        context) => const TeachAssistErrorAlert());
                              } else if (response[0] == 'Invalid Login') {
                                if (!context.mounted) return;
                                if (buttonClickable) {
                                  buttonClickable = false;
                                  showDialog(context: context, builder: (context) => const InvalidLoginAlert(), barrierDismissible: false);
                                }
                              } else {
                                // print('Valid Login');
                                sharedPrefs.username = username;
                                sharedPrefs.password = password;

                                await TeachAssistModel().init();
                                if (!context.mounted) return;
                                Navigator.pushNamed(context, '/homeScreen');
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

/*
######################
#=-=-= Username =-=-=#
######################
*/
class UsernameField extends StatefulWidget {
  final TextEditingController controller;

  const UsernameField({
    required this.controller,
    super.key,
  });

  @override
  State<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends State<UsernameField> {
  Color _colorText = Colors.grey;

  @override
  Widget build(BuildContext context) {
    const defaultColor = Colors.grey;
    final focusColor = Theme.of(context).colorScheme.secondary;

    return Focus(
      onFocusChange: (hasFocus) {
      setState(() => _colorText = hasFocus ? focusColor : defaultColor);
      },
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person, color: _colorText),
          labelText: "Student Number",
          labelStyle: TextStyle(color: _colorText),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _colorText)
          ),
        ),
        validator: (PassCurrentValue) {
          var passNonNullValue=PassCurrentValue??"";
          if(passNonNullValue.isEmpty){
            return ("Please Enter Your Student Number");
          }
          return null;
        },
      ),
    );
  }
}


/*
######################
#=-=-= Password =-=-=#
######################
*/
class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({
    required this.controller,
    super.key,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  Color _colorText = Colors.grey;

  @override
  Widget build(BuildContext context) {
    const defaultColor = Colors.grey;
    final focusColor = Theme.of(context).colorScheme.secondary;

    return Focus(
      onFocusChange: (hasFocus) {
      setState(() => _colorText = hasFocus ? focusColor : defaultColor);
      },
      child: TextFormField(
        controller: widget.controller,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: _colorText),
          labelText: "Password",
          labelStyle: TextStyle(color: _colorText),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _colorText)
          ),
        ),
        validator: (PassCurrentValue){
          var passNonNullValue=PassCurrentValue??"";
          if (passNonNullValue.isEmpty){
            return ("Please Enter Your Password");
          }
          return null;
        },
      ),
    );
  }
}

class InvalidLoginAlert extends StatelessWidget {
  const InvalidLoginAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('INVALID LOGIN'),
      content: const Text('Incorrect username and/or password. Please try again.'),
      actions: [
        TextButton(
          child: Text('RETRY',
            style: GoogleFonts.lato(
            fontSize: 16, fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.secondary)
          ),
          onPressed: () {
            buttonClickable = true;
            Navigator.pop(context);
          }
        )
      ],
    );
  }
}

class TeachAssistErrorAlert extends StatelessWidget {
  const TeachAssistErrorAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ERROR'),
      content: const Text('Trouble accessing TeachAssist. Please try again later.'),
      actions: [
        TextButton(
          child: Text('RETRY',
            style: GoogleFonts.lato(
            fontSize: 16, fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.secondary)
          ),
          onPressed: () => Navigator.pop(context),)
      ],
    );
  }
}