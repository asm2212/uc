import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io';

import 'package:category_widget/category.dart';

/// The REST API retrieves unit conversions for [Categories] that change.
///
/// For example, the currency exchange rate, stock prices, the height of the
/// tides change often.
/// We have set up an API that retrieves a list of currencies and their current
/// exchange rate (mock data).
///   GET /currency: get a list of currencies
///   GET /currency/convert: get conversion from one currency amount to another
class Api {

  final String _baseUrl = 'flutter.udacity.com';
  final HttpClient _httpClient = HttpClient();

  /// Gets all the units and conversion rates for a given category.
  ///
  /// The `category` parameter is the name of the [Category] from which to
  /// retrieve units. We pass this into the query parameter in the API call.
  ///
  /// Returns a list. Returns null on error.
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

  /// Given two units, converts from one to another.
  ///
  /// Returns a double, which is the converted amount. Returns null on error.

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
