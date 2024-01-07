import 'package:flutter/material.dart';

class DetalhesImagem extends StatefulWidget {
  final Map<String, dynamic> imageInfo;

  const DetalhesImagem({super.key, required this.imageInfo});
  @override
  State<DetalhesImagem> createState() => _DetalhesImagemState();
}

class _DetalhesImagemState extends State<DetalhesImagem> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> imageInfo =
        widget.imageInfo; // Adicione esta linha
    return Scaffold(
      appBar: AppBar(
        title: Text(imageInfo['title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(imageInfo['hdurl']),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                imageInfo['explanation'],
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