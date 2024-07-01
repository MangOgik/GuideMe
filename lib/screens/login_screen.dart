import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/cubit/location/location_cubit.dart';
import 'package:guideme/cubit/user/user_cubit.dart';
import 'package:guideme/screens/input_url_screen.dart';
import 'package:guideme/services/data_services.dart';
import 'package:guideme/utils/constants.dart';
import 'package:ionicons/ionicons.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isCustomer = true;
  bool isRememberMe = false;
  bool isSignupScreen = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  //Register Customer
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  //Register Tour Guide
  final TextEditingController _priceRateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  static final List<String> _items = [
    "EN",
    "CN",
    "ES",
    "FR",
  ];

  final _itemsList =
      _items.map((item) => MultiSelectItem<String>(item, item)).toList();

  List<dynamic> _selectedItems = [];
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    context.read<LocationCubit>().fetchLocations();
  }

  void loginSuccess(Map<String, dynamic> user) {
    if (mounted) {
      if (user.containsKey('customer_id')) {
        Navigator.pushReplacementNamed(context, '/guideme-screen');
        BlocProvider.of<UserCubit>(context).fetchCustomer(user);
      } else if (user.containsKey('tourguide_id')) {
        Navigator.pushReplacementNamed(context, '/guidemealt-screen');
        BlocProvider.of<UserCubit>(context).fetchTourGuide(user);
      }
    }
  }

  void registerSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Registration success!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  isSignupScreen = false;
                });
                _loginEmailController.text = _emailController.text;
                _emailController.clear();
                _usernameController.clear();
                _passwordController.clear();
                _phoneNumberController.clear();
                _addressController.clear();
                _priceRateController.clear();
                _descriptionController.clear();
                _selectedLocation = null;
                Navigator.pop(context);
                // Additional action on success if needed (e.g., navigate to another screen)
              },
            ),
          ],
        );
      },
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      debugPrint("Logging in..");
      final loginResult = await DataService.loginFirebase(
          _loginEmailController.text, _passwordController.text);
      if (loginResult != null) {
        loginSuccess(loginResult);
      } else {
        showErrorDialog('Login failed, try again!');
      }
    }
  }

  void _registerCustomer() async {
    if (_formKey.currentState!.validate()) {
      debugPrint("Register Customer..");
      final registerResult = await DataService.registerCustomer(
        customerEmail: _emailController.text,
        customerUsername: _usernameController.text,
        password: _passwordController.text,
        phoneNumber: _phoneNumberController.text,
        address: _addressController.text,
      );
      if (registerResult) {
        registerSuccess();
      } else {
        showErrorDialog('Register failed. try again!');
      }
    }
  }

  void _registerTourGuide() async {
    if (_formKey.currentState!.validate()) {
      debugPrint("Register tourguide..");
      final registerResult = await DataService.registerTourGuide(
        tourguideEmail: _emailController.text,
        tourguideUsername: _usernameController.text,
        password: _passwordController.text,
        priceRate: _priceRateController.text,
        desc: _descriptionController.text,
        language: _selectedItems,
        locationName: _selectedLocation ?? '',
      );
      if (registerResult) {
        registerSuccess();
      } else {
        showErrorDialog('Register failed. try again!');
      }
    }
  }

  void showErrorDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Error',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void inputUrl() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Silakan masukkan URL untuk konfigurasi ke aplikasi dengan baik.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _urlController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a URL";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Enter URL",
                              prefixIcon: const Icon(Icons.network_check_sharp),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                String url = _urlController.text;
                                debugPrint("URL: $url");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Text(
                              "Submit",
                              style: GoogleFonts.poppins(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InputUrlScreen(),
            ),
          );
        },
        label: Text(
          'Set URL',
          style: GoogleFonts.poppins(),
        ),
        icon: const Icon(Icons.signal_wifi_4_bar_outlined),
        backgroundColor: Colors.blue[100],
      ),
      backgroundColor: Palette.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: SizedBox(
              height: 390,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeInOut,
                child: Container(
                  padding:
                      EdgeInsets.only(top: isSignupScreen ? 50 : 80, left: 20),
                  color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      RichText(
                        text: TextSpan(
                            text: isSignupScreen ? "Welcome to " : "Welcome ",
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                text: isSignupScreen ? "GuideMe," : "Back,",
                                style: GoogleFonts.poppins(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            ]),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        isSignupScreen
                            ? "Signup to Continue"
                            : "Signin to Continue",
                        style: GoogleFonts.poppins(
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            top: isSignupScreen ? 150 : 180,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOut,
              height: isSignupScreen
                  ? isCustomer
                      ? 500
                      : 600
                  : 280,
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = false;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: !isSignupScreen
                                          ? Palette.activeColor
                                          : Palette.textColor1),
                                ),
                                if (!isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.blue,
                                  )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "SIGNUP",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isSignupScreen
                                          ? Palette.activeColor
                                          : Palette.textColor1),
                                ),
                                if (isSignupScreen)
                                  Container(
                                    margin: const EdgeInsets.only(top: 3),
                                    height: 2,
                                    width: 55,
                                    color: Colors.blue,
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                      if (isSignupScreen) buildRegisterSection(),
                      if (!isSignupScreen) buildLoginSection()
                    ],
                  ),
                ),
              ),
            ),
          ),
          buildBottomHalfContainer(),
        ],
      ),
    );
  }

  Container buildLoginSection() {
    return Container(
      // color: Colors.red,
      height: 160,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildTextField(Icons.mail_outline, "test@gmail.com", false, true,
              _loginEmailController),
          buildTextField(Ionicons.lock_closed_outline, "**********", true,
              false, _passwordController),
        ],
      ),
    );
  }

  List<Widget> buildCustomerFields() {
    return [
      buildTextField(
          Ionicons.mail_outline, "Email", false, true, _emailController),
      buildTextField(
          Ionicons.lock_closed, "Password", true, false, _passwordController),
      buildTextField(
          Icons.person, "Username", false, false, _usernameController,
          maxLength: 15),
      buildTextField(Ionicons.call_outline, "Phone Number", false, false,
          _phoneNumberController),
      buildTextField(
          Ionicons.home_outline, "Address", false, false, _addressController),
    ];
  }

  List<Widget> buildTourGuideFields() {
    return [
      buildTextField(Ionicons.mail_outline, "Tour Guide Email", false, true,
          _emailController),
      buildTextField(
          Ionicons.lock_closed, "Password", true, false, _passwordController),
      buildTextField(
          Icons.person, "Username", false, false, _usernameController,
          maxLength: 15),
      buildTextField(
          Icons.attach_money, "Price Rate", false, false, _priceRateController),
      buildTextField(Ionicons.create_outline, "Short Description", false, false,
          _descriptionController),
      const SizedBox(
        height: 5,
      ),
      BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          final List<String> locationList;
          if (state.locationList != null && state.locationList!.isNotEmpty) {
            locationList =
                state.locationList!.map((e) => e.locationName).toList();
          } else {
            locationList = [];
          }
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                  borderSide: const BorderSide(color: Palette.textColor1)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            style: GoogleFonts.poppins(color: Colors.black),
            hint: const Text("Select Location"),
            value: _selectedLocation,
            items: locationList.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedLocation = newValue;
              });
            },
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Palette.iconColor,
            ),
          );
        },
      ),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Select Languages : ',
              style: GoogleFonts.poppins(),
            ),
          ],
        ),
      ),
      MultiSelectChipField(
        selectedChipColor: Colors.blue.shade200,
        chipShape: RoundedRectangleBorder(
          side: const BorderSide(color: Palette.textColor1),
          borderRadius: BorderRadius.circular(15),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        title: const Text(
          'Select Languages',
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
        ),
        chipWidth: 35,
        headerColor: Colors.blue.shade300,
        showHeader: false,
        initialValue: const [],
        items: _itemsList,
        onTap: (value) {
          setState(() {
            _selectedItems = value;
          });
          debugPrint('$_selectedItems');
        },
      ),
    ];
  }

  Container buildRegisterSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          ...isCustomer ? buildCustomerFields() : buildTourGuideFields(),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCustomer = true;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isCustomer
                                ? Palette.textColor2
                                : Colors.transparent,
                            border: Border.all(
                                width: 1,
                                color: isCustomer
                                    ? Colors.transparent
                                    : Palette.textColor1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          Icons.person,
                          color: isCustomer ? Colors.white : Palette.iconColor,
                        ),
                      ),
                      Text(
                        "Customer",
                        style: GoogleFonts.poppins(color: Palette.textColor1),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCustomer = false;
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isCustomer
                                ? Colors.transparent
                                : Palette.textColor2,
                            border: Border.all(
                                width: 1,
                                color: isCustomer
                                    ? Palette.textColor1
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          Icons.person_2_outlined,
                          color: isCustomer ? Palette.iconColor : Colors.white,
                        ),
                      ),
                      Text(
                        "Tour Guide",
                        style: GoogleFonts.poppins(color: Palette.textColor1),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            margin: const EdgeInsets.only(top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                text: "By pressing 'Submit' you agree to our ",
                style: TextStyle(color: Palette.textColor2),
                children: [
                  TextSpan(
                    //recognizer: ,
                    text: "term & conditions.",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  TextButton buildTextButton(
    IconData icon,
    String title,
    Color backgroundColor,
  ) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(width: 1, color: Colors.grey),
          minimumSize: const Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      top: isSignupScreen
          ? isCustomer
              ? 665
              : 765
          : 475,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
            height: 90,
            width: 90,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blueGrey[200] ?? Colors.orange,
                    Colors.lightBlue[400] ?? Colors.red
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1))
                  ]),
              child: ElevatedButton(
                onPressed: () {
                  if (isSignupScreen) {
                    isCustomer ? _registerCustomer() : _registerTourGuide();
                  } else {
                    _login();
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(right: 0),
                    backgroundColor: Colors.transparent),
                child: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }

    final emailPattern = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");

    if (!emailPattern.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail, TextEditingController? controller,
      {int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field cannot be empty';
          } else if (isEmail &&
              !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$")
                  .hasMatch(value)) {
            return 'Please enter a valid email address';
          }
          return null;
        },
        controller: controller,
        obscureText: isPassword,
        maxLength: maxLength,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          counterText: '',
          prefixIcon: Icon(
            icon,
            color: Palette.iconColor,
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Palette.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: const EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14, color: Palette.textColor1),
        ),
      ),
    );
  }
}
