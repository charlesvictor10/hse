import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:poc_free/home.dart';

// ignore: constant_identifier_names
const SERVER_IP = 'http://127.0.0.1:8000';
//const SERVER_IP = 'http://192.168.1.14:8000';
//const SERVER_IP = 'http://10.0.2.2:8000';
const storage = FlutterSecureStorage();

class CollectePage extends StatefulWidget {
  const CollectePage({Key? key}) : super(key: key);

  @override
  State<CollectePage> createState() => _CollecteState();
}

class _CollecteState extends State<CollectePage> {
  _logout() async {
    var accessToken = await storage.read(key: "jwt");
    var token = jsonDecode(accessToken.toString()) as Map<String, dynamic>;
    var value = ('${token['access_token']}');

    await http.post(Uri.parse('$SERVER_IP/api/v1/logout'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $value"});
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
                "Nouvelle collecte",
                style: TextStyle(
                    fontFamily: 'Rubik Regular',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 249, 250, 252),
                    fontSize: 22),
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 204, 0, 10),
            leading: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
        body: collecteForm());
  }

  collecteForm() {
    List<String> items = ["1", "2", "3", "4", "5"];

    final _formKey = GlobalKey<FormState>();

    final nbHeureDep1Controller = TextEditingController();
    final nbHeureDep2Controller = TextEditingController();
    final nbHeureDep3Controller = TextEditingController();
    final nbIncidentDysfController = TextEditingController();
    final severiteIncidentDysfController = TextEditingController();
    final nbDommageEquipementController = TextEditingController();
    final severiteDommageEquipementController = TextEditingController();
    final nbDommageVehiculeController = TextEditingController();
    final severiteDommageVehiculeController = TextEditingController();
    final commentaireIncidentsController = TextEditingController();
    final nbAmController = TextEditingController();
    final severiteAmController = TextEditingController();
    final nbBaController = TextEditingController();
    final severiteBaController = TextEditingController();
    final nbCtmController = TextEditingController();
    final severiteCtmController = TextEditingController();
    final nbCpsController = TextEditingController();
    final severiteCpsController = TextEditingController();
    final commentaireAccidentsController = TextEditingController();
    final nbFormationController = TextEditingController();
    final nbHeureFormationController = TextEditingController();
    final nbParticipantsController = TextEditingController();
    final nbInspectionsController = TextEditingController();
    final nbVisitesController = TextEditingController();

    Future<Object> _sendData(
        String nb_heure_dep_1,
        String nb_heure_dep_2,
        String nb_heure_dep_3,
        String nb_incident_dysf,
        String severite_incident_dysf,
        String nb_dommage_equipement,
        String severite_dommage_equipement,
        String nb_dommage_vehicule,
        String severite_dommage_vehicule,
        String commentaire_incidents,
        String nb_am,
        String severite_am,
        String nb_ba,
        String severite_ba,
        String nb_ctm,
        String severite_ctm,
        String nb_cps,
        String severite_cps,
        String commentaire_accidents,
        String nb_formation,
        String nb_heure_formation,
        String nb_participants,
        String nb_inspections,
        String nb_visites) async {
      var accessToken = await storage.read(key: "jwt");
      var token = jsonDecode(accessToken.toString()) as Map<String, dynamic>;
      var value = ('${token['access_token']}');

      var body = {
        'nb_heure_dep_1': nb_heure_dep_1,
        'nb_heure_dep_2': nb_heure_dep_2,
        'nb_heure_dep_3': nb_heure_dep_3,
        'nb_incident_dysf': nb_incident_dysf,
        'severite_incident_dysf': severite_incident_dysf,
        'nb_dommage_equipement': nb_dommage_equipement,
        'severite_dommage_equipement': severite_dommage_equipement,
        'nb_dommage_vehicule': nb_dommage_vehicule,
        'severite_dommage_vehicule': severite_dommage_vehicule,
        'commentaire_incidents': commentaire_incidents,
        'nb_am': nb_am,
        'severite_am': severite_am,
        'nb_ba': nb_ba,
        'severite_ba': severite_ba,
        'nb_ctm': nb_ctm,
        'severite_ctm': severite_ctm,
        'nb_cps': nb_cps,
        'severite_cps': severite_cps,
        'commentaire_accidents': commentaire_accidents,
        'nb_formation': nb_formation,
        'nb_heure_formation': nb_heure_formation,
        'nb_participants': nb_participants,
        'nb_inspections': nb_inspections,
        'nb_visites': nb_visites
      };

      var response = await http.post(Uri.parse('$SERVER_IP/api/v1/collect'),
          headers: {
            'content-type': 'application/json',
            HttpHeaders.authorizationHeader: "Bearer $value"
          },
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        return response.body;
      }
      return {};
    }

    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Card(
            color: const Color.fromARGB(255, 204, 0, 10),
            child: ExpansionTile(
              title: const Text(
                "Indicateur Hygiène, Sécurité, Environnement",
                style: TextStyle(
                    fontFamily: 'Rubik Regular',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 249, 250, 252),
                    fontSize: 22),
              ),
              iconColor: Colors.white,
              children: [
                Container(
                    color: const Color.fromARGB(255, 249, 250, 252),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Text(
                          "Nombre d’heures travaillées par chaque département",
                          style: TextStyle(
                              fontFamily: 'Rubik Regular',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Installations et maintenance des reseaux ",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                                textAlign: TextAlign.center),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText:
                                                "Nombre d'heures travaillées"),
                                        controller: nbHeureDep1Controller,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'heures travaillées sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Déploiement de la fibre optique",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                                textAlign: TextAlign.center),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText:
                                                "Nombre d'heures travaillées"),
                                        controller: nbHeureDep2Controller,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'heures travaillées sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Conception des lignes de transmission sur poteux",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                                textAlign: TextAlign.center),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText:
                                                "Nombre d'heures travaillées"),
                                        controller: nbHeureDep3Controller,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'heures travaillées sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Nombre d’incidents enregistrables avec leur degré de sévérité",
                          style: TextStyle(
                              fontFamily: 'Rubik Regular',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Disfonctionnement équipement",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText: "Nombre d'incidents"),
                                        controller: nbIncidentDysfController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'incidents sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: ListTile(
                                    subtitle: TextField(
                              controller: severiteIncidentDysfController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 204, 0, 10))),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10)),
                                labelText: "Sévérité",
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    severiteIncidentDysfController.text = value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return items.map<PopupMenuItem<String>>(
                                        (String value) {
                                      return PopupMenuItem(
                                          value: value, child: Text(value));
                                    }).toList();
                                  },
                                ),
                              ),
                            ))),
                          ],
                        ),
                        const Text("dommage équipement",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText: "Nombre d'incidents"),
                                        controller:
                                            nbDommageEquipementController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'incidents sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: ListTile(
                                    subtitle: TextField(
                              controller: severiteDommageEquipementController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 204, 0, 10))),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10)),
                                labelText: "Sévérité",
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    severiteDommageEquipementController.text =
                                        value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return items.map<PopupMenuItem<String>>(
                                        (String value) {
                                      return PopupMenuItem(
                                          value: value, child: Text(value));
                                    }).toList();
                                  },
                                ),
                              ),
                            ))),
                          ],
                        ),
                        const Text("Dommage véhicule",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText: "Nombre d'incidents"),
                                        controller: nbDommageVehiculeController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'incidents sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: ListTile(
                                    subtitle: TextField(
                              controller: severiteDommageVehiculeController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 204, 0, 10))),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10)),
                                labelText: "Sévérité",
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    severiteDommageVehiculeController.text =
                                        value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return items.map<PopupMenuItem<String>>(
                                        (String value) {
                                      return PopupMenuItem(
                                          value: value, child: Text(value));
                                    }).toList();
                                  },
                                ),
                              ),
                            ))),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Commentaire",
                          style: TextStyle(
                              fontFamily: 'Rubik Regular',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        maxLines: 3,
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText:
                                                "Commencez à saisir votre commentaire..."),
                                        controller:
                                            commentaireIncidentsController))),
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
          Card(
            color: const Color.fromARGB(255, 204, 0, 10),
            child: ExpansionTile(
              title: const Text(
                "Indicateur de performance",
                style: TextStyle(
                    fontFamily: 'Rubik Regular',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 249, 250, 252),
                    fontSize: 22),
              ),
              iconColor: Colors.white,
              children: [
                Container(
                    color: const Color.fromARGB(255, 249, 250, 252),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Text(
                          "Nombre d’accidents avec leur degré de sévérité",
                          style: TextStyle(
                              fontFamily: 'Rubik Regular',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Accident mortel (AM)",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText: "Nombre d'accidents"),
                                        controller: nbAmController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'accidents sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: ListTile(
                                    subtitle: TextField(
                              controller: severiteAmController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 204, 0, 10))),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10)),
                                labelText: "Sévérité",
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    severiteAmController.text = value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return items.map<PopupMenuItem<String>>(
                                        (String value) {
                                      return PopupMenuItem(
                                          value: value, child: Text(value));
                                    }).toList();
                                  },
                                ),
                              ),
                            ))),
                          ],
                        ),
                        const Text("Blessure avec arrêt (BA)",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText: "Nombre d'accidents"),
                                        controller: nbBaController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'accidents sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: ListTile(
                                    subtitle: TextField(
                              controller: severiteBaController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 204, 0, 10))),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10)),
                                labelText: "Sévérité",
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    severiteBaController.text = value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return items.map<PopupMenuItem<String>>(
                                        (String value) {
                                      return PopupMenuItem(
                                          value: value, child: Text(value));
                                    }).toList();
                                  },
                                ),
                              ),
                            ))),
                          ],
                        ),
                        const Text("Cas de traitement médical (CTM)",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText: "Nombre d'accidents"),
                                        controller: nbCtmController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'accidents sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: ListTile(
                                    subtitle: TextField(
                              controller: severiteCtmController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 204, 0, 10))),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10)),
                                labelText: "Sévérité",
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    severiteCtmController.text = value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return items.map<PopupMenuItem<String>>(
                                        (String value) {
                                      return PopupMenuItem(
                                          value: value, child: Text(value));
                                    }).toList();
                                  },
                                ),
                              ),
                            ))),
                          ],
                        ),
                        const Text("Cas de premier soin (CPS)",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText: "Nombre d'accidents"),
                                        controller: nbCpsController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'accidents sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                child: ListTile(
                                    subtitle: TextField(
                              controller: severiteCpsController,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                border: const OutlineInputBorder(),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 204, 0, 10))),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                floatingLabelStyle: const TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10)),
                                labelText: "Sévérité",
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onSelected: (String value) {
                                    severiteCpsController.text = value;
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return items.map<PopupMenuItem<String>>(
                                        (String value) {
                                      return PopupMenuItem(
                                          value: value, child: Text(value));
                                    }).toList();
                                  },
                                ),
                              ),
                            ))),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Commentaire",
                          style: TextStyle(
                              fontFamily: 'Rubik Regular',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        maxLines: 3,
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText:
                                                "Commencez à saisir votre commentaire..."),
                                        controller:
                                            commentaireAccidentsController))),
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
          Card(
            color: const Color.fromARGB(255, 204, 0, 10),
            child: ExpansionTile(
              title: const Text(
                "Indicateur Proactif",
                style: TextStyle(
                    fontFamily: 'Rubik Regular',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 249, 250, 252),
                    fontSize: 22),
              ),
              iconColor: Colors.white,
              children: [
                Container(
                    color: const Color.fromARGB(255, 249, 250, 252),
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Text("Nombre de formation interne et externe",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText:
                                                "Nombre de formation interne et externe"),
                                        controller: nbFormationController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre de formation interne et externe sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Nombre d’heures de formation",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText:
                                                "Nombre d'heures de formation"),
                                        controller: nbHeureFormationController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'heures de formation sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Nombre de participants",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText:
                                                "Nombre de participants"),
                                        controller: nbParticipantsController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre de participants sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Nombre d’inspections",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText: "Nombre d'inspections"),
                                        controller: nbInspectionsController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre d'inspections sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Nombre de visite management",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16)),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                                    subtitle: TextFormField(
                                        decoration: const InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black)),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 204, 0, 10))),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            floatingLabelStyle: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 204, 0, 10)),
                                            labelText:
                                                "Nombre de visite de management"),
                                        controller: nbVisitesController,
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Veuillez saisir le nombre de visite de management sinon mettre 0.";
                                          }
                                          return null;
                                        }))),
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
          const SizedBox(
            height: 300,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var nb_heure_dep_1 = nbHeureDep1Controller.text.trim();
                  var nb_heure_dep_2 = nbHeureDep2Controller.text.trim();
                  var nb_heure_dep_3 = nbHeureDep3Controller.text.trim();
                  var nb_incident_dysf = nbIncidentDysfController.text.trim();
                  var severite_incident_dysf =
                      severiteIncidentDysfController.text.trim();
                  var nb_dommage_equipement =
                      nbDommageEquipementController.text.trim();
                  var severite_dommage_equipement =
                      severiteDommageEquipementController.text.trim();
                  var nb_dommage_vehicule =
                      nbDommageVehiculeController.text.trim();
                  var severite_dommage_vehicule =
                      severiteDommageVehiculeController.text.trim();
                  var commentaire_incidents =
                      commentaireIncidentsController.text.trim();
                  var nb_am = nbAmController.text.trim();
                  var severite_am = severiteAmController.text.trim();
                  var nb_ba = nbBaController.text.trim();
                  var severite_ba = severiteBaController.text.trim();
                  var nb_ctm = nbCtmController.text.trim();
                  var severite_ctm = severiteCtmController.text.trim();
                  var nb_cps = nbCpsController.text.trim();
                  var severite_cps = severiteCpsController.text.trim();
                  var commentaire_accidents =
                      commentaireAccidentsController.text.trim();
                  var nb_formation = nbFormationController.text.trim();
                  var nb_heure_formation =
                      nbHeureFormationController.text.trim();
                  var nb_participants = nbParticipantsController.text.trim();
                  var nb_inspections = nbInspectionsController.text.trim();
                  var nb_visites = nbVisitesController.text.trim();

                  await _sendData(
                      nb_heure_dep_1,
                      nb_heure_dep_2,
                      nb_heure_dep_3,
                      nb_incident_dysf,
                      severite_incident_dysf,
                      nb_dommage_equipement,
                      severite_dommage_equipement,
                      nb_dommage_vehicule,
                      severite_dommage_vehicule,
                      commentaire_incidents,
                      nb_am,
                      severite_am,
                      nb_ba,
                      severite_ba,
                      nb_ctm,
                      severite_ctm,
                      nb_cps,
                      severite_cps,
                      commentaire_accidents,
                      nb_formation,
                      nb_heure_formation,
                      nb_participants,
                      nb_inspections,
                      nb_visites);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => const Menu()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: const Color.fromARGB(255, 204, 0, 10)),
              child: const Text('Enregistrer',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Rubik Regular',
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    )));
  }
}
