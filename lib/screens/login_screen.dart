import 'package:chawi_hotel/services/firebase_api.dart';
import 'package:chawi_hotel/utils/constants/responisve.dart';
import 'package:chawi_hotel/widgets/bottomnavbar.dart';
import 'package:chawi_hotel/widgets/notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<bool> _submitForm() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      await FirebaseApi.login(_formKey.currentState?.value['email'],
          _formKey.currentState?.value['password']);
      User? user = await FirebaseApi.getCurrentUser();
      if (mounted && user?.email != null) {
        customSnackbar(context, 'Logged in successfully');
        return true;
      }
    } else {
      print("Validation Failed");
    }
    if (mounted) {
      customSnackbar(context, 'Your email or password is incorrect');
    }

    return false;
  }

  void _signout() async {
    FirebaseApi.signOut();
    User? user = await FirebaseApi.getCurrentUser();
    if (mounted) {
      customSnackbar(
          context, (user?.email == null) ? 'Logged Out successfully' : 'Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: context.height,
            width: double.infinity,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/login.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20.0),
                      child: FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: FormBuilderTextField(
                                name: 'email',
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.email(),
                                ]),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: FormBuilderTextField(
                                name: 'password',
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.password),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                                obscureText: true,
                                validator: FormBuilderValidators.compose([
                                  // FormBuilderValidators.required(),
                                  // FormBuilderValidators.minLength(8),
                                  // FormBuilderValidators.hasUppercaseChars(),
                                  // FormBuilderValidators.hasSpecialChars(),
                                ]),
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {
                                    _signout();
                                  },
                                  child: const Text('Forgot Paswword ?',
                                      style:
                                          TextStyle(color: Colors.lightBlue)),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                await _submitForm()
                                    ? Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Bottomnavscreen()))
                                    : null;
                              },
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10)),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                ),
                                fixedSize: WidgetStateProperty.all(
                                  Size(MediaQuery.of(context).size.width * 0.6,
                                      50),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
