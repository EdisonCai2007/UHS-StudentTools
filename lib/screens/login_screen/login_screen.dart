import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
#########################
#=-=-= LoginScreen =-=-=#
#########################
*/
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      extendBody: true,
      body: SingleChildScrollView(
        child: Column(
          children: [

            /*
            ####################
            #=-=-= Header =-=-=#
            ####################
            */
            SizedBox (
              height: 450,
              child: Padding(
                padding: const EdgeInsets.only(top: 90, left: 60, right: 60, bottom: 30),
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
            const SizedBox (
              height: 350,
              child: Form(
                child: Padding(
                  padding: EdgeInsets.all(50),
                  child: Column(
                    children: [
                      // Gapps Username
                      UsernameField(),

                      // Gapps Password
                      PasswordField(),
                    ],
                  ),
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
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text('Sign In',
                      style: GoogleFonts.lato(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 20, fontWeight: FontWeight.w600)),
                  ),
                  onPressed: (){

                  },
                ),
              ),
            ),
          ],
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
  const UsernameField({
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
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person, color: _colorText),
          labelText: "Student Number",
          labelStyle: TextStyle(color: _colorText),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: _colorText)
          ),
        ),
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
  const PasswordField({
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
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock, color: _colorText),
          labelText: "Password",
          labelStyle: TextStyle(color: _colorText),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _colorText)
          ),
        ),
      ),
    );
  }
}