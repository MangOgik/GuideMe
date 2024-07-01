import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guideme/endpoints/endpoints.dart';
import 'package:guideme/utils/secure_storage_util.dart';

class InputUrlScreen extends StatefulWidget {
  const InputUrlScreen({super.key});

  @override
  State<InputUrlScreen> createState() => _InputUrlScreenState();
}

class _InputUrlScreenState extends State<InputUrlScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  static const _storage = SecureStorageUtil.storage;

  @override
  void dispose() {
    super.dispose();
    _urlController.dispose();
  }

  static Future setBaseURL(String url) async {
    await _storage.write(key: 'url', value: url);
  }

  void setURL() async {
    String newBaseURL = _urlController.text;
    await setBaseURL(newBaseURL);
    Endpoints.setBaseURL(newBaseURL);
    setURLSucess();
  }

  void setURLSucess() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Base URL saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      appBar: AppBar(
        title: Text(
          "Input URL",
          style: GoogleFonts.roboto(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
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
                        "URL Configuration",
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
                                prefixIcon:
                                    const Icon(Icons.network_check_sharp),
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
                                  final url = _urlController.text;
                                  setURL();
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
                                style: GoogleFonts.roboto(
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
      ),
    );
  }
}
