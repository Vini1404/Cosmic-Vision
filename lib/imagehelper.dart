// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ImageHelper {
  void downloadMedia(BuildContext context, dynamic media) async {
    final storageDir = await getApplicationDocumentsDirectory();
    final cosmicVisionDir = Directory('${storageDir.path}/media');
    final dirExists = await cosmicVisionDir.exists();
    if (!dirExists) {
      cosmicVisionDir.create();
    }

    String fileName = '';

    if (media is String) {
      final response = await http.get(Uri.parse(media));
      final mediaBytes = response.bodyBytes;
      fileName = 'imagem-do-dia.jpg';
      final filePath = '${cosmicVisionDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(mediaBytes);
      await ImageGallerySaver.saveFile(filePath, name: 'Imagem do Dia');
    } else if (media is Map<String, dynamic>) {
      final videoUrl = media['url'];
      final yt = YoutubeExplode();
      final video = await yt.videos.get(videoUrl);
      final manifest =
          await yt.videos.streamsClient.getManifest(video.id.value);
      final streamInfo = manifest.muxed.withHighestBitrate();

      final filePath = '${cosmicVisionDir.path}/${video.id.value}.mp4';
      final file = File(filePath);
      final response = await http.get(Uri.parse(streamInfo.url.toString()));
      await file.writeAsBytes(response.bodyBytes);

      yt.close();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vídeo salvo em $filePath'),
        ),
      );
      return;
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
