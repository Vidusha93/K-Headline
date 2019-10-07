import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:news_app/api_key.dart';
import 'package:news_app/web_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final String url = 'https://newsapi.org/v2/top-headlines?country=kr&apiKey=' + api;
  List data;
  bool isSwitched = false;

  Future<String> getData() async {
    var res = await http.get(Uri.encodeFull(url), headers: {"Accept" : "application/json"});
    setState(() {
      var resbody = json.decode(res.body);
      data = resbody["articles"];
    });
    return 'Success!';
  }

  @override
  void initState(){
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isSwitched ? Colors.black : Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: Text('News App', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        backgroundColor: isSwitched ? Colors.black87 : Colors.blueAccent,
        elevation: 8.0,
        actions: <Widget>[
          Switch(
            value: isSwitched,
            onChanged: (value){
              setState(() {
                isSwitched = value;
              });
            },
            activeColor: Colors.black87,
            activeTrackColor: Colors.white70,
          )
        ],
      ),
      body: data == null ? Container(child: Center(child: SpinKitRing(color: Colors.blueAccent),),) : ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            color: isSwitched ? Colors.black87 : Colors.white,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Card(
                    color: isSwitched ? Colors.black87 : Colors.white,
                    elevation: 5.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            data[index]["title"], 
                            style: TextStyle(
                              fontSize: 18.0, 
                              fontWeight: FontWeight.bold, 
                              color: isSwitched ? Colors.white : Colors.black87 
                            )
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            data[index]["description"] == null ? " " : data[index]["description"], 
                            style: TextStyle(
                              fontSize: 12.0, 
                              fontWeight: FontWeight.bold, 
                              color: isSwitched ? Colors.white70 : Colors.black38
                            )
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                data[index]["publishedAt"] == null ? " " : data[index]["publishedAt"],
                                style: TextStyle(
                                  fontSize: 12.0, 
                                  fontWeight: FontWeight.bold, 
                                  color: isSwitched ? Colors.white54 : Colors.black38
                                )
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 16.0),
                              child: Text(
                                data[index]["author"] == null ? "미지의" : data[index]["author"],
                                style: TextStyle(
                                  fontSize: 12.0, 
                                  fontWeight: FontWeight.bold, 
                                  color: isSwitched ? Colors.white54 : Colors.black38
                                )
                              ),
                            )
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            child: Text('Read More', style: TextStyle(color: isSwitched ? Colors.white54 : Colors.black38),),
                            elevation: 0,
                            highlightElevation: 0,
                            highlightColor: Colors.black12,
                            splashColor: Colors.transparent,
                            color: Colors.transparent,
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebView(gotUrl: data[index]["url"], isSwitched: isSwitched,)
                                )
                              );
                              print('Pressed');
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      )
    );
  }
}
