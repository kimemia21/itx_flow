import 'package:flutter/material.dart';

class Regulators extends StatefulWidget {
  const Regulators({super.key});

  @override
  State<Regulators> createState() => _RegulatorsState();
}

class _RegulatorsState extends State<Regulators> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(centerTitle: true,
    title: Text("Commodity Regulator"),
    ),
    body: SingleChildScrollView(child: Column(children: [],),),
    );
  }
}
