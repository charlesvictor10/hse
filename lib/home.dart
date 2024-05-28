// ignore: file_names
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:poc_free/collecte.dart';
import 'package:poc_free/declaration.dart';
import 'package:poc_free/detail.dart';
import 'package:poc_free/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: constant_identifier_names
const SERVER_IP = 'https://poc-free-backend.azurewebsites.net';
const storage = FlutterSecureStorage();

class HomePage extends StatelessWidget {
  final String jwt;
  final Map<String, dynamic> payload;

  const HomePage(this.jwt, this.payload, {super.key});

  factory HomePage.fromBase64(String jwt) => HomePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  _logout() async {
    var accessToken = await storage.read(key: "jwt");
    var token = jsonDecode(accessToken.toString()) as Map<String, dynamic>;
    var value = ('${token['access_token']}');

    await http.post(Uri.parse('$SERVER_IP/api/v1/logout'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $value"});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: 50,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  height: 45.0,
                ),
              ],
            ),
            actions: [
              InkWell(
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/profil.png',
                      height: 45.0,
                    ),
                  )),
              PopupMenuButton<int>(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(Icons.account_circle),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Profil")
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Déconnexion")
                      ],
                    ),
                  ),
                ],
                offset: const Offset(0, 100),
                color: Colors.white,
                elevation: 2,
                onSelected: (value) async {
                  if (value == 1) {
                  } else if (value == 2) {
                    _logout();
                    storage.delete(key: "jwt");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  }
                },
              ),
            ],
          ),
          body: const Menu(),
        ));
  }
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: AppBar(
                backgroundColor: const Color.fromARGB(255, 204, 0, 10),
                toolbarHeight: 30,
                bottom: const TabBar(
                    dividerColor: Colors.white,
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(
                          icon: Icon(Icons.dashboard,
                              color: Color.fromARGB(255, 249, 250, 252)),
                          child: Text(
                            "Collecte",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 249, 250, 252),
                                fontSize: 18),
                          )),
                      Tab(
                          icon: Icon(Icons.add_moderator,
                              color: Color.fromARGB(255, 249, 250, 252)),
                          child: Text(
                            "Déclaration",
                            style: TextStyle(
                                fontFamily: 'Rubik Regular',
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 249, 250, 252),
                                fontSize: 18),
                          ))
                    ]),
              ),
            ),
            body: const TabBarView(children: [ListKpi(), ListTable()]),
          )),
    );
  }
}

class Accident {
  int? id;
  String? description_accident;
  String? causes;
  String? date_and_hour_of_accident;
  String? degre_severite;
  String? employee;
  String? worker_job_title;

  Accident(
      {this.id,
      this.description_accident,
      this.causes,
      this.date_and_hour_of_accident,
      this.degre_severite,
      this.employee,
      this.worker_job_title});

  Accident.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description_accident = json['description_accident'];
    causes = json['causes'];
    date_and_hour_of_accident = json["date_and_hour_of_accident"];
    degre_severite = json['degre_severite'];
    employee = json['employee'];
    worker_job_title = json['worker_job_title'];
  }
}

class Collect {
  String? accidents;
  String? incidents;
  String? formations;
  String? visite;
  String? inspections;
  String? departement1;
  String? departement2;
  String? departement3;

  Collect(
      {this.accidents,
      this.incidents,
      this.formations,
      this.visite,
      this.inspections,
      this.departement1,
      this.departement2,
      this.departement3});

  Collect.fromJson(Map<String, dynamic> json) {
    accidents = json['accidents'];
    incidents = json['incidents'];
    formations = json['formations'];
    visite = json['visite'];
    inspections = json['inspections'];
    departement1 = json['departement1'];
    departement2 = json['departement2'];
    departement3 = json['departement3'];
  }
}

class ListTable extends StatefulWidget {
  const ListTable({Key? key}) : super(key: key);
  @override
  State<ListTable> createState() => _TableState();
}

class _TableState extends State<ListTable> {
  static Future<List<Accident>> _getData() async {
    var accessToken = await storage.read(key: "jwt");
    var token = jsonDecode(accessToken.toString()) as Map<String, dynamic>;
    var value = ('${token['access_token']}');

    var response = await http.get(
        Uri.parse(
            '$SERVER_IP/api/v1/accident/data_table_feed/?only_completed=false&include_archived=false&only_uncompleted=true'),
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $value"
        });

    var body = jsonDecode(response.body);
    final List list = body["records"];
    return list.map((e) => Accident.fromJson(e)).toList();
  }

  var accidentsFuture = _getData();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: size.height,
          margin: const EdgeInsets.only(top: 20.0),
          child: Center(
              child: FutureBuilder<List<Accident>>(
                  future: accidentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      final accidents = snapshot.data!;
                      return buildAccidents(accidents);
                    } else {
                      return const Center(
                        child: Text(
                          "Aucune données collecté.",
                          style: TextStyle(
                            fontFamily: 'Rubik Regular',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 204, 0, 10),
                            fontSize: 22
                          ),
                          textAlign: TextAlign.center,
                        )
                      );
                    }
                  })),
        ),
      ),
    );
  }

  Widget buildAccidents(List<Accident> accidents) {
    // ListView Builder to show data in a list
    return ListView.builder(
      itemCount: accidents.length,
      itemBuilder: (context, index) {
        final accident = accidents[index];
        return Card(
            color: const Color.fromARGB(255, 236, 235, 235),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      flex: 1,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage('assets/images/profil.png'),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            utf8.decode(accident.employee!.codeUnits),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            utf8.decode(accident.degre_severite!.codeUnits),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(""),
                          Text(
                            accident.date_and_hour_of_accident!
                                .replaceRange(10, 19, ''),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.keyboard_arrow_right),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailPage(id: accident)),
                                );
                              })
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}

class ListKpi extends StatefulWidget {
  const ListKpi({Key? key}) : super(key: key);
  @override
  State<ListKpi> createState() => _TableKpiState();
}

class _TableKpiState extends State<ListKpi> {
  static Future<Map<String, dynamic>> _getData() async {
    var accessToken = await storage.read(key: "jwt");
    var token = jsonDecode(accessToken.toString()) as Map<String, dynamic>;
    var value = ('${token['access_token']}');

    var response = await http.get(
        Uri.parse(
            '$SERVER_IP/api/v1/collect/metrics?by_user_connected=false&include_archived=false'),
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $value"
        });

    var body = jsonDecode(response.body) as Map<String, dynamic>;

    return body;
  }

  var data = _getData();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            color: const Color.fromARGB(255, 236, 235, 235),
            height: size.height,
            width: double.infinity,
            child: FutureBuilder<Map<String, dynamic>>(
                future: data,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    final metrics = snapshot.data!;
                    return getMetric(metrics);
                  } else {
                    return const Center(
                      child: Text(
                        "Aucune collecte disponible.",
                          style: TextStyle(
                            fontFamily: 'Rubik Regular',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 204, 0, 10),
                            fontSize: 22
                          ),
                          textAlign: TextAlign.center,
                        )
                      );
                  }
                })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Alert(
              context: context,
              desc: "Souhaitez vous faire une déclaration ou une collecte?",
              buttons: [
                DialogButton(
                  color: const Color.fromARGB(255, 204, 0, 10),
                  onPressed: () => {
                    Navigator.of(context, rootNavigator: true).pop(),
                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CollectePage()),
                    )
                  },
                  width: 120,
                  child: const Text(
                    "Collecte",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                DialogButton(
                  color: const Color.fromARGB(255, 204, 0, 10),
                  onPressed: () => {
                    Navigator.of(context, rootNavigator: true).pop(),
                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DeclarationPage()),
                    )
                  },
                  width: 120,
                  child: const Text(
                    "Déclaration",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show()
        },
        tooltip: 'Ajouter une nouvelle déclaration ou collecte',
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 204, 0, 10),
        hoverColor: const Color.fromARGB(255, 204, 0, 10),
        focusColor: const Color.fromARGB(255, 204, 0, 10),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget getMetric(Map<String, dynamic> metrics) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Padding(
            // ignore: prefer_const_constructors
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
            child: GridView.count(
              crossAxisCount: 2,
              children: <Widget>[
                Card(
                  color: Colors.white,
                  // ignore: prefer_const_constructors
                  margin: EdgeInsets.only(
                      left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => {},
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text(
                                    '${metrics["accident"]}',
                                    style: const TextStyle(
                                        fontFamily: 'Rubik Regular',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 204, 0, 10),
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            const Expanded(
                              flex: 5,
                              child: Text(
                                'Accidents',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Card(
                  color: Colors.white,
                  // ignore: prefer_const_constructors
                  margin: EdgeInsets.only(
                      left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => {},
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text(
                                    '${metrics["incident"]}',
                                    style: const TextStyle(
                                        fontFamily: 'Rubik Regular',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 204, 0, 10),
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            const Expanded(
                              flex: 5,
                              child: Text(
                                'Incidents',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Card(
                  color: Colors.white,
                  // ignore: prefer_const_constructors
                  margin: EdgeInsets.only(
                      left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => {},
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text(
                                    '${metrics["formation"]}',
                                    style: const TextStyle(
                                        fontFamily: 'Rubik Regular',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 204, 0, 10),
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            const Expanded(
                              flex: 5,
                              child: Text(
                                'Formations',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Card(
                  color: Colors.white,
                  // ignore: prefer_const_constructors
                  margin: EdgeInsets.only(
                      left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => {},
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text(
                                    '${metrics["inspection"]}',
                                    style: const TextStyle(
                                        fontFamily: 'Rubik Regular',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 204, 0, 10),
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            const Expanded(
                              flex: 5,
                              child: Text(
                                'Inspections',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Card(
                  color: Colors.white,
                  // ignore: prefer_const_constructors
                  margin: EdgeInsets.only(
                      left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => {},
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text(
                                    '${metrics["installations_maintenance_reseaux"]}',
                                    style: const TextStyle(
                                        fontFamily: 'Rubik Regular',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 204, 0, 10),
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            const Expanded(
                              flex: 5,
                              child: Text(
                                'Installations et maintenances',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Card(
                  color: Colors.white,
                  // ignore: prefer_const_constructors
                  margin: EdgeInsets.only(
                      left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => {},
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text(
                                    '${metrics["conception_lignes_transmission"]}',
                                    style: const TextStyle(
                                        fontFamily: 'Rubik Regular',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 204, 0, 10),
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            const Expanded(
                              flex: 5,
                              child: Text(
                                'Conception lignes de transmission',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Card(
                  color: Colors.white,
                  // ignore: prefer_const_constructors
                  margin: EdgeInsets.only(
                      left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => {},
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text(
                                    '${metrics["deploiement_fibre_optique"]}',
                                    style: const TextStyle(
                                        fontFamily: 'Rubik Regular',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 204, 0, 10),
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            const Expanded(
                              flex: 5,
                              child: Text(
                                'Déploiement fibre optique',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                Card(
                  color: Colors.white,
                  // ignore: prefer_const_constructors
                  margin: EdgeInsets.only(
                      left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => {},
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 25.0),
                                  child: Text(
                                    '${metrics["visite"]}',
                                    style: const TextStyle(
                                        fontFamily: 'Rubik Regular',
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 204, 0, 10),
                                        fontSize: 25),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            const Expanded(
                              flex: 5,
                              child: Text(
                                'Visite management',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 204, 0, 10),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
