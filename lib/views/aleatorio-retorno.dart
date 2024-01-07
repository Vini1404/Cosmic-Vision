// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DetalhesImagem extends StatefulWidget {
  final Map<String, dynamic> imageInfo;

  const DetalhesImagem({Key? key, required this.imageInfo}) : super(key: key);

  @override
  State<DetalhesImagem> createState() => _DetalhesImagemState();
}

class _DetalhesImagemState extends State<DetalhesImagem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.imageInfo['title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(widget.imageInfo['hdurl']),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.imageInfo['explanation'],
                style: const TextStyle(fontSize: 16),
              ),
            ),
            // Outras informações que você desejar exibir
          ],
        ),
      ),
    );
  }
}