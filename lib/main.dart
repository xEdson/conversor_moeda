import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "http://api.hgbrasil.com/finance?format=jason&key=4b9f231e";

void main() async {
  print(await getData());

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realContoller = TextEditingController();
  final dolarContoller = TextEditingController();
  final euroContoller = TextEditingController();


  double dolar;
  double euro;

  void _realChanged(String text){

    double real = double.parse(text);
    dolarContoller.text=(real/dolar).toStringAsFixed(2);
    euroContoller.text = (real/euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text){
    double dolar = double.parse(text);
    realContoller.text = (dolar*this.dolar).toStringAsFixed(2);
    euroContoller.text =(dolar*this.dolar/ euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    double euro = double.parse(text);
    realContoller.text = (euro*this.euro).toStringAsFixed(2);
    dolarContoller.text = (euro*this.euro/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            // ignore: missing_return
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Carregando Dados...",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "ERRO ao Carregando Dados...=(",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0,
                      ),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dolar =
                        snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    print(dolar);
                    print(euro);

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.amber),
                          buildTextField("Reais", "R\$ ", realContoller, _realChanged),
                          Divider(),
                          buildTextField("Dolares", "US\$ ", dolarContoller, _dollarChanged),
                          Divider(),
                          buildTextField("Euros", "€ ", euroContoller, _euroChanged)
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget buildTextField(String label, String prefix, TextEditingController controller, Function function) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: function,
    keyboardType: TextInputType.number,
  );
}
