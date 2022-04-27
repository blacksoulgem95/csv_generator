import 'dart:developer';

import 'package:csv_generator/generator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CSV Generator',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home:
          const LoaderOverlay(child: MyHomePage(title: 'CSV Generator for QA')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int rows = 0;
  String mobileCol = "mobile";
  final TextEditingController _controller = TextEditingController();

  void _updateRowCount(value) {
    setState(() {
      if (value.length == 0) {
        log("saving value 0");
        rows = 0;
      } else {
        log("saving value " + value);
        rows = int.parse(value);
      }
    });
  }

  void _updateMobileCol(value) {
    setState(() {
      if (value.length == 0) {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  content: Text("The mobile column cannot be empty"),
                ));

        mobileCol = "mobile";
        _controller.value = _controller.value.copyWith(
          text: mobileCol,
          selection: TextSelection.collapsed(offset: mobileCol.length),
        );

        return;
      } else {
        log("saving value " + value);
        mobileCol = value;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _controller.value = _controller.value.copyWith(
      text: mobileCol,
      selection: TextSelection.collapsed(offset: mobileCol.length),
    );
  }

  void _saveFile() async {
    if (rows < 1) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text("You need at least 1 contact"),
              ));
      return;
    }

    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'CSV_Contacts_$rows.csv',
    );

    if (outputFile == null) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text("Action cancelled"),
              ));
      return;
    }
    context.loaderOverlay.show();

    try {
      await Generator.generate(rows, mobileCol, outputFile);

      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text("File saved"),
              ));
    } on Exception catch (error) {
      log('error on saving file: $error');

      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                content: Text("An error occurred"),
              ));
    } finally {
      context.loaderOverlay.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'How many rows you need?',
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Column(children: [
                  Row(
                    children: [
                      TextField(
                        decoration:
                            const InputDecoration(labelText: "Row count"),
                        keyboardType: TextInputType.number,
                        onChanged: _updateRowCount,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                      ),
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                            labelText: "Mobile Column Name"),
                        keyboardType: TextInputType.name,
                        onChanged: _updateMobileCol,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ], // Single line text
                      ),
                    ],
                  ),
                  Row(
                    children: [

                    ],
                  )
                ]))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveFile,
        tooltip: 'Generate',
        child: const Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
