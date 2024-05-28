import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:poc_free/home.dart';

// ignore: constant_identifier_names
const SERVER_IP = 'https://poc-free-backend.azurewebsites.net';
const SERVER_ML_IP = 'https://poc-free-ml.icymoss-01df5cf2.canadacentral.azurecontainerapps.io';
const storage = FlutterSecureStorage();

class DeclarationPage extends StatefulWidget {
  const DeclarationPage({Key? key}) : super(key: key);

  @override
  State<DeclarationPage> createState() => _FlutterStepsState();
}

class _FlutterStepsState extends State<DeclarationPage> {
  _logout() async {
    var accessToken = await storage.read(key: "jwt");
    var token = jsonDecode(accessToken.toString()) as Map<String, dynamic>;
    var value = ('${token['access_token']}');

    await http.post(Uri.parse('$SERVER_IP/api/v1/logout'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $value"});
  }

  int currentStep = 0;
  bool isCompleted = false;

  List<String> items = ["Très Sévère", "Sévère", "Peu Sévère", "Pas Sévère"];

  final _formKey = GlobalKey<FormState>();

  //personnel information
  final prenomController = TextEditingController();
  final nomController = TextEditingController();
  final titreController = TextEditingController();

  //collect information
  final dateController = TextEditingController();
  final heureController = TextEditingController();
  final descriptionController = TextEditingController();
  final causeController = TextEditingController();
  final severiteController = TextEditingController();

  //upload image from gallery or camera
  Uint8List? imageFile;

  Future<String> _generateDescriptionFromML(Uint8List image) async {
    const String endPoint = '$SERVER_ML_IP/hse_image_description';

    var formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(image, filename: ''),
    });

    var dio = Dio();

    dio.post(endPoint, data: formData).then((response) {
      var data = jsonDecode(response.toString()) as Map<String, dynamic>;
      var description = ('${data['description']}');
      descriptionController.text = description;
    // ignore: invalid_return_type_for_catch_error
    }).catchError((error) => ());
    return "";
  }

  Future<Object> _saveData(
      String prenom,
      String nom,
      String titre,
      String date,
      String heure,
      String cause,
      String severite,
      String description,
      Uint8List image) async {
    var accessToken = await storage.read(key: "jwt");
    var token = jsonDecode(accessToken.toString()) as Map<String, dynamic>;
    var value = ('${token['access_token']}');

    var body = {
      'worker_first_name': prenom,
      'worker_last_name': nom,
      'worker_job_title': titre,
      'date_and_hour_of_accident': '${date}T$heure',
      'causes': cause,
      'degre_severite': severite,
      'description_accident': description
    };

    var response = await http.post(Uri.parse('$SERVER_IP/api/v1/accident'),
        headers: {
          'content-type': 'application/json',
          HttpHeaders.authorizationHeader: "Bearer $value"
        },
        body: jsonEncode(body));

    const String endPoint = '$SERVER_ML_IP/hse_image_description';

    var formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(image, filename: ''),
    });

    var dio = Dio();

    dio
        .post(endPoint, data: formData)
        .then((response) {})
        .catchError((error) => ());

    if (response.statusCode == 200) {
      return response.body;
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
            title: const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                "Ajouter une nouvelle déclaration",
                style: TextStyle(
                    fontFamily: 'Rubik Regular',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 249, 250, 252),
                    fontSize: 18),
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 204, 0, 10),
            leading: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(255, 204, 0, 10))),
        child: Form(
          key: _formKey,
          child: Stepper(
            steps: getSteps(),
            type: StepperType.vertical,
            currentStep: currentStep,
            controlsBuilder: (BuildContext context, ControlsDetails controls) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    if (currentStep == 0)
                      ElevatedButton(
                        onPressed: () async {
                          //var image = File(String.fromCharCodes(imageFile!));
                          if (imageFile!.isNotEmpty) {
                            await _generateDescriptionFromML(imageFile!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Veuillez charger une photo')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 204, 0, 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        child: const Text(
                          'Générer description',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    const Spacer(),
                    if (currentStep == 0)
                      ElevatedButton(
                        onPressed: controls.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 204, 0, 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        child: const Text(
                          'Suivant',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (currentStep != 0)
                      ElevatedButton(
                        onPressed: controls.onStepCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 204, 0, 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        child: const Text(
                          'Précédent',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    const Spacer(),
                    if (currentStep != 0)
                      ElevatedButton(
                        onPressed: controls.onStepContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 204, 0, 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        child: const Text(
                          'Suivant',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    const Spacer(),
                    if (currentStep != 0 && currentStep != 1)
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var prenom = prenomController.text.trim();
                            var nom = nomController.text.trim();
                            var titre = titreController.text.trim();
                            var date = dateController.text.trim();
                            var heure = heureController.text.trim();
                            var cause = causeController.text.trim();
                            var severite = severiteController.text.trim();
                            var description = descriptionController.text.trim();
                            var image = imageFile;
                            await _saveData(prenom, nom, titre, date, heure,
                                cause, severite, description, image!);

                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Menu()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Veuillez remplir le formulaire')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 204, 0, 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                        ),
                        child: const Text(
                          'Enregistrer',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              );
            },
            onStepTapped: (step) {
              _formKey.currentState!.validate();
              setState(() {
                currentStep = step;
              });
            },
            onStepContinue: () {
              final isLastStep = currentStep == getSteps().length - 1;
              _formKey.currentState!.validate();
              bool isDetailValid = isDetailComplete();

              if (isDetailValid) {
                if (isLastStep) {
                  setState(() {
                    isCompleted = true;
                  });
                } else {
                  setState(() {
                    currentStep += 1;
                  });
                }
              }
            },
            onStepCancel: () {
              setState(() {
                if (currentStep > 0) {
                  currentStep -= 1;
                } else {
                  currentStep = 0;
                }
              });
            },
          ),
        ),
      ),
    );
  }

  bool isDetailComplete() {
    if (currentStep == 0) {
      return true;
    } else if (currentStep == 1) {
      //check sender fields
      if (prenomController.text.isEmpty ||
          nomController.text.isEmpty ||
          titreController.text.isEmpty) {
        return false;
      } else {
        return true; //if all fields are not empty
      }
    } else if (currentStep == 2) {
      //check receiver fields
      if (dateController.text.isEmpty ||
          heureController.text.isEmpty ||
          causeController.text.isEmpty ||
          severiteController.text.isEmpty ||
          descriptionController.text.isEmpty) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }

  //This will be your screens
  List<Step> getSteps() => [
        imageFile == null
            ? Step(
                title: const Text('Charger une image ou prendre une photo'),
                state: currentStep > 0 ? StepState.complete : StepState.indexed,
                isActive: currentStep >= 0,
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Image(
                      height: 200,
                      width: 700,
                      image: AssetImage('assets/images/cloud.png'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              imageFromGallery();
                            },
                            child: const Text("GALLERY"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              imageFromCamera();
                            },
                            child: const Text("CAMERA"),
                          ),
                        )
                      ],
                    ),
                  ],
                ))
            : Step(
                title: const Text('Image chargé ou photo prise'),
                state: currentStep > 0 ? StepState.complete : StepState.indexed,
                isActive: currentStep >= 0,
                content: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(""),
                      ),
                      SizedBox(
                        height: 300,
                        width: 700,
                        child: Image.memory(
                          imageFile!,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                )),
        Step(
            title: const Text('Information Personnel'),
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            content: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 204, 0, 10))),
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelStyle:
                          TextStyle(color: Color.fromARGB(255, 204, 0, 10)),
                      labelText: "Prénom"),
                  controller: prenomController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez saisir votre prénom";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 204, 0, 10))),
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelStyle:
                          TextStyle(color: Color.fromARGB(255, 204, 0, 10)),
                      labelText: "Nom"),
                  controller: nomController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez saisir votre nom";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 204, 0, 10))),
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelStyle:
                          TextStyle(color: Color.fromARGB(255, 204, 0, 10)),
                      labelText: "Titre"),
                  controller: titreController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez saisir votre titre";
                    }
                    return null;
                  },
                ),
              ],
            )),
        Step(
            title: const Text('Information de l\'accident'),
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            content: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 204, 0, 10))),
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelStyle:
                          TextStyle(color: Color.fromARGB(255, 204, 0, 10)),
                      labelText: 'Date de l\'accident'),
                  controller: dateController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1960),
                        lastDate: DateTime(5000),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                                colorScheme:
                                    const ColorScheme.highContrastLight(
                                        onPrimary: Colors.black,
                                        onSurface: Colors.black,
                                        primary:
                                            Color.fromARGB(255, 204, 0, 10)),
                                dialogBackgroundColor:
                                    const Color.fromARGB(255, 204, 0, 10),
                                textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            fontFamily: 'Quicksand'),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10),
                                                width: 1,
                                                style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(50))))),
                            child: child!,
                          );
                        });
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dateController.text = formattedDate;
                      });
                    } else {
                      'Veuillez saisir la date de l\'accident';
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir la date de l\'accident';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 204, 0, 10))),
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelStyle:
                          TextStyle(color: Color.fromARGB(255, 204, 0, 10)),
                      labelText: 'Heure de l\'accident'),
                  controller: heureController,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                        builder: (context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.highContrastLight(
                                      onPrimary: Colors.black,
                                      onSurface: Colors.black,
                                      primary: Color.fromARGB(255, 204, 0, 10)),
                                  dialogBackgroundColor:
                                      const Color.fromARGB(255, 204, 0, 10),
                                  textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          textStyle: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12,
                                              fontFamily: 'Quicksand'),
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 204, 0, 10),
                                                  width: 1,
                                                  style: BorderStyle.solid),
                                              borderRadius: BorderRadius.circular(50))))),
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              ));
                        });
                    if (pickedTime != null) {
                      String formattedTime =
                          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                      setState(() {
                        heureController.text = formattedTime;
                      });
                    } else {
                      'Veuillez saisir l\'heure de l\'accident';
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir l\'heure de l\'accident';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 204, 0, 10))),
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelStyle:
                          TextStyle(color: Color.fromARGB(255, 204, 0, 10)),
                      labelText: 'Cause de l\'accident'),
                  controller: causeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir la cause de l\'accident';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownMenu<String>(
                  width: 328.0,
                  controller: severiteController,
                  requestFocusOnTap: true,
                  label: const Text("Sévérité de l'accident"),
                  onSelected: (String? value) {
                    setState(() {
                      severiteController.text = value!;
                    });
                  },
                  dropdownMenuEntries:
                      items.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                      value: value,
                      label: value,
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 204, 0, 10))),
                      labelStyle: TextStyle(color: Colors.black),
                      floatingLabelStyle:
                          TextStyle(color: Color.fromARGB(255, 204, 0, 10)),
                      labelText: 'Description de l\'accident'),
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir la description';
                    }
                    return null;
                  },
                ),
              ],
            )),
      ];

  final _picker = ImagePicker();

  imageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 200,
        maxWidth: 200,
        imageQuality: 90);
    final Uint8List? image = await pickedFile?.readAsBytes();
    setState(() {
      imageFile = image;
    });
  }

  imageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 200,
        maxWidth: 200,
        imageQuality: 90);
    final Uint8List? image = await pickedFile?.readAsBytes();
    setState(() {
      imageFile = image;
    });
  }
}
