import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poolinspection/src/helpers/connectivity.dart';

class TestWidget extends StatefulWidget {
  @override
  TestWidgetState createState() => new TestWidgetState();
}

class TestWidgetState extends State<TestWidget> {
  StreamSubscription _connectionChangeStream;

  bool isOffline = false;

  @override
  initState() {
    super.initState();

    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }
  @override
  void dispose() {
    super.dispose();
    _connectionChangeStream.cancel();
  }
  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
        body: Center(
            child: (isOffline)
                ? new Text("Not connected")
                : new Text("Connected")));
  }
}
