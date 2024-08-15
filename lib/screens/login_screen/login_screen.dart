import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wolfpackapp/models_services/teachassist_model.dart';

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

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      extendBody: true,
      body: SingleChildScrollView(
        child: Form(
          child: Builder(
            builder: (context) {
              return Column(
                children: [

                  /*
                ####################
                #=-=-= Header =-=-=#
                ####################
                */
                  SizedBox(
                    height: 450,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 90, left: 60, right: 60, bottom: 30),
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

                  /*
                ##################
                #=-=-= Form =-=-=#
                ##################
                */

                  SizedBox(
                    height: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: Column(
                        children: [
                          // Username
                          UsernameField(controller: _usernameController),

                          // Password
                          PasswordField(controller: _passwordController),
                        ],
                      ),
                    ),
                  ),

                  /*
                ####################
                #=-=-= Button =-=-=#
                ####################
                */
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: Theme
                            .of(context)
                            .elevatedButtonTheme
                            .style,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text('Sign In',
                              style: GoogleFonts.lato(
                                  color: Theme
                                      .of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontSize: 20, fontWeight: FontWeight.w600)),
                        ),
                        onPressed: () async {
                          if (Form.of(context).validate()) {
                            String username = _usernameController.text.trim();
                            String password = _passwordController.text.trim();
                            var response = await authorizeUser(username, password);
                            print(response);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
        ),
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
        validator: (PassCurrentValue){
          RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{8,}$');
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
          RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&*~]).{8,}$');
          var passNonNullValue=PassCurrentValue??"";
          if(passNonNullValue.isEmpty){
            return ("Please Enter Your Password");
          }
          return null;
        },
      ),
    );
  }
}