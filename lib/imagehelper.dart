// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImageHelper {
  void downloadMedia(BuildContext context, dynamic media, String date) async {
    final storageDir = await getApplicationDocumentsDirectory();
    final cosmicVisionDir = Directory('${storageDir.path}/media');
    final dirExists = await cosmicVisionDir.exists();
    if (!dirExists) {
      cosmicVisionDir.create();
    }
    final formatter = DateFormat('dd-MM-yyyy');
    final formattedDate = formatter.format(DateTime.parse(date));
    String fileName = '';

    if (media is String) {
      final response = await http.get(Uri.parse(media));
      final mediaBytes = response.bodyBytes;
      fileName = 'imagem-do-dia-$formattedDate.jpg';
      final filePath = '${cosmicVisionDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(mediaBytes);
      await ImageGallerySaver.saveFile(filePath,
          name: 'Imagem do Dia $formattedDate');
    } else if (media is Map<String, dynamic>) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vídeo não pode ser baixado'),
        ),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mídia salva em ${cosmicVisionDir.path}/$fileName'),
      ),
    );
  }

  void shareImage(BuildContext context, String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/image.png').create();
    await file.writeAsBytes(bytes);

    final xFile = XFile(file.path);
    await Share.shareXFiles([xFile], text: 'Confira a imagem do dia da NASA!');
  }
}
