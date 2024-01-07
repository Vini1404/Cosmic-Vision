import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class NasaApiClient {
  static const String _baseUrl = 'https://api.nasa.gov';
  final String apiKey;

  NasaApiClient({required this.apiKey});

  Future<Map<String, dynamic>> pegarImagemDoDia() async {
    final hdurl = Uri.parse('$_baseUrl/planetary/apod?api_key=$apiKey');
    final response = await http.get(hdurl);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        ...data,
        'media_type': data['media_type'],
        'video_url': data['media_type'] == 'video' ? data['url'] : null,
      };
    } else {
      return {
        'error': 'Falha ao carregar o conteúdo do dia!',
        'icon': Icons.error,
      };
    }
  }

  Future<Map<String, dynamic>> pegarImagemPorData(String selectedDate) async {
    final url = Uri.parse(
      '$_baseUrl/planetary/apod?api_key=$apiKey&date=$selectedDate',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        ...data,
        'media_type': data['media_type'],
        'video_url': data['media_type'] == 'video' ? data['url'] : null,
      };
    } else {
      return {
        'error': 'Falha ao carregar o conteúdo para a data selecionada!',
        'icon': Icons.error,
      };
    }
  }

  Future<List<Map<String, dynamic>>> pesquisarImagemPorPeriodo(
      DateTime dataInicio, DateTime dataFim) async {
    final formatter = DateFormat('yyyy-MM-dd');
    final startDateString = formatter.format(dataInicio);
    final endDateString = formatter.format(dataFim);
    final url = Uri.parse(
      '$_baseUrl/planetary/apod?api_key=$apiKey&start_date=$startDateString&end_date=$endDateString',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<Map<String, dynamic>> imageData = [];
      for (var item in data) {
        imageData.add({
          'title': item['title'],
          'url': item['url'],
          'date': item['date'],
          'media_type': item['media_type'],
          'video_url': item['media_type'] == 'video' ? item['url'] : null,
        });
      }
      return imageData;
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> buscarImagensAleatorias(
      int quantidade) async {
    List<Map<String, dynamic>> imageData = [];

    for (int i = 0; i < quantidade; i++) {
      final url = Uri.parse('$_baseUrl/planetary/apod?api_key=$apiKey&count=1');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (var item in data) {
          imageData.add({
            'title': item['title'],
            'url': item['url'],
            'date': item['date'],
            'media_type': item['media_type'],
            'video_url': item['media_type'] == 'video' ? item['url'] : null,
          });
        }
      }
    }

    return imageData;
  }
}
