import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

import 'package:category_widget/category.dart';


class Api {

  final String _baseUrl = 'flutter.udacity.com';
  final HttpClient _httpClient = HttpClient();

 
  Future<List> getUnits(String category) async {
    try {
      final uri = Uri.https(_baseUrl, '/$category');

      final jsonResponse = await _getJson(uri);

      if (jsonResponse == null || jsonResponse['units'] == null) {
        print('Error retrieving units.');
        return null;
      }

      return jsonResponse['units'];
    } on Exception catch (e) {
        print('$e');
        return null;
    }
  }


  Future<double> convert(String category, String amount, String fromUnit, String toUnit) async {
    try{
      final uri = Uri.https(_baseUrl, '/$category/convert', {
        'amount': amount, 'from': fromUnit, 'to': toUnit
      });

      final jsonResponse = await _getJson(uri);

      if (jsonResponse == null || jsonResponse['status'] == null) {
        print('Error retrieving conversion.');
        return null;

      } else if (jsonResponse['status'] == 'error') {
        print(jsonResponse['message']);
        return null;
      }

      return jsonResponse['conversion'].toDouble();
    } on Exception catch (e) {
        print('$e');
        return null;
    }
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try{
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();

      if(httpResponse.statusCode != HttpStatus.ok){
        return null;
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } on Exception catch(e) {
      print('$e');
      return null;
    }
  }

}
