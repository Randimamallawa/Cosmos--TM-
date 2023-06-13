import 'dart:io';

import 'package:cosmos_client/Constants.dart';
import 'package:cosmos_client/Orgnization/Screens/Your_Org.dart';
import 'package:cosmos_client/Orgnization/Models/orgModels.dart';
import 'package:cosmos_client/Orgnization/Services/api_services.dart';
import 'package:cosmos_client/Orgnization/Widgets/Const_Texts.dart';
import 'package:cosmos_client/Orgnization/Widgets/Profile_Pic.dart';
import 'package:flutter/material.dart';

class OrgForm extends StatefulWidget {
  const OrgForm({Key? key}) : super(key: key);

  @override
  State<OrgForm> createState() => _OrgFormState();
}

class _OrgFormState extends State<OrgForm> {
  final formKeyorg = GlobalKey<FormState>();
  ApiService apiService = ApiService();
  TextEditingController cardControllername = TextEditingController();
  TextEditingController cardControllerDes = TextEditingController();
  late String profilePic;

  void submitForm() async {
    if (formKeyorg.currentState!.validate()) {
      formKeyorg.currentState!.save();

      // Call the API to create the organization
      try {
        await apiService.createOrganization(
          name: cardControllername.text,
          pic: profilePic, // Provide the appropriate value for pic
          description: cardControllerDes.text,
        );

        cardsx.add(
          OrganizationModel(
            cardID: uuid.v1(),
            cardName: cardControllername.text,
            description: cardControllerDes.text,
            profilePic: profilePic,
            members: [],
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateCards()),
        );

        cardControllername.clear();
        cardControllerDes.clear();
        _resetProfilePicture();
      } catch (e) {
        // Handle the API call exception
        print('Exception occurred: $e');
      }
    }
  }

  void _resetProfilePicture() {
    setState(() {
      profilePic = '';
    });
  }

  //Org Name
  Widget buildOrgNameField() {
    return TextFormField(
      controller: cardControllername,
      maxLength: 20,

      decoration: const InputDecoration(
        labelText: 'Enter Organization Name *',
        prefixIcon: Icon(Icons.people, color: Colors.white60),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.white),
        ),
        labelStyle: TextStyle(color: Colors.white60),
      ),
      // Validations
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your organization name';
        }
        if (value.length < 2) {
          return 'Name must be at least 2 characters long';
        }
        if (value.length > 20) {
          return 'Name must be less than 20 characters long';
        }
        return null;
      },
    );
  }

  //org description
  Widget buildDescriptionField() {
    return TextFormField(
      controller: cardControllerDes,
      maxLength: 1000,
      maxLines: 5,
      decoration: const InputDecoration(
        labelText: 'Description*',
        prefixIcon: Icon(Icons.description, color: Colors.white60),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: Colors.white),
        ),
        labelStyle: TextStyle(color: Colors.white60),
      ),

      // Validations
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a description';
        }
        if (value.length < 2) {
          return 'Description must be at least 2 characters long';
        }
        if (value.length > 1000) {
          return 'Description must be less than 1000 characters long';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create New Organization',
            style: kAppBarTitle,
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Container(
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: formKeyorg,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ProfilePictureWidget(
                            onImageSelected: (String? imagePath) {
                              setState(() {
                                profilePic = imagePath ?? '';
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 60),
                        Text('Organization Name',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1.3,
                              wordSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(2, 2),
                                  blurRadius: 2,
                                ),
                              ],
                            )),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: buildOrgNameField(),
                        ),
                        const SizedBox(height: 20),
                        Text('Organization Discription',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 1.3,
                              wordSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(2, 2),
                                  blurRadius: 2,
                                ),
                              ],
                            )),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: buildDescriptionField(),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20.0)),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            minimumSize: const Size(255.0, 50.0),
                            shadowColor: Colors.black,
                            alignment: Alignment.center,
                            elevation: 10,
                          ),
                          onPressed: submitForm,
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 17,
                              letterSpacing: 1.3,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
