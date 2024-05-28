import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:poc_free/home.dart';

// ignore: constant_identifier_names
const SERVER_IP = 'https://poc-free-backend.azurewebsites.net';
const storage = FlutterSecureStorage();

class DetailPage extends StatelessWidget {
  final Accident id;

  const DetailPage({super.key, required this.id});

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
                "Détail de l'accident",
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
            ),
          ),
        ),
        body: detailAccident(id));
  }

  detailAccident(Accident accident) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 236, 235, 235),
              Color.fromARGB(255, 236, 235, 235)
            ]),
          ),
          child: Column(
            children: <Widget>[
              const Hero(
                tag: 'profil',
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    radius: 72.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/images/profil.png'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  utf8.decode(accident.employee!.codeUnits),
                  style: const TextStyle(fontSize: 28.0, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  accident.date_and_hour_of_accident!.replaceRange(10, 19, ''),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0),
                child: Text(
                  utf8.decode(accident.description_accident!.codeUnits),
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          ),
        ) 
      )
    );
  }
}
