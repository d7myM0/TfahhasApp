import 'package:flutter/material.dart';

void main() {
  runApp(TfahhasApp());
}

class TfahhasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TFAHHAS App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Check your Link or File",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => LinkCheckPage()));
              },
              child: Text("Check Link"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FileCheckPage()));
              },
              child: Text("Check File"),
            ),
          ],
        ),
      ),
    );
  }
}

class LinkCheckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Check Your Link")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Avoid fake links, let our app scan them for you!"),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Put Your Link",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Check"),
            ),
          ],
        ),
      ),
    );
  }
}

class FileCheckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Check Your File")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Upload your document to check its security."),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Upload Document"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text("Check"),
            ),
          ],
        ),
      ),
    );
  }
}
