import 'package:flutter/material.dart';
import 'package:flutter_deprem/models/deprem.dart';

class DepremDetailPage extends StatelessWidget {
  final Deprem deprem;
  const DepremDetailPage({Key? key, required this.deprem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Text(deprem.baslik)),
    );
  }
}
