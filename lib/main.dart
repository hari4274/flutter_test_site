import 'package:fdata_site/country.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'WhatsApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _showMessageInScaffold(String message){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return  DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: false,
          title: Text(widget.title),
          backgroundColor: Colors.green[900],
          bottom: TabBar(
            // indicatorSize: TabBarIndicatorSize.label,
            // labelPadding: Padding(padding: null),
            indicatorColor: Colors.white,
            indicatorWeight: 2.5,
            tabs: [
              Tab(
                icon: Icon(Icons.camera_alt),
              ),
              Tab(
                text: "Chats",
              ),
              Tab(
                text: "Status",
              ),
              Tab(
                text: "Calls",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Icon(Icons.camera_alt)
              ),
            ),
            Container(
              child: CountriesListView()
            ),
            Container(
              child: Image.network('https://restcountries.eu/data/ago.svg'),
            ),
            Container(
              child: Text("Tab2"),
            ),
          ]
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showMessageInScaffold('float pressed'),
          tooltip: 'Increment',
          child: Icon(Icons.chat),
        ),
      ),
    );
  }
}
