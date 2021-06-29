import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:spacex_missions/models/api/api_expections.dart';
import 'package:spacex_missions/models/mission.dart';

class Api {
  final _baseUrl = "https://api.spacex.land/graphql/launches";

  /// [search] is the string used to get filtered data by 'mission_name' from spaceX api
  /// [offset] is the index at which the list data fetched from the api are collected. It is used for
  /// pagination
  Future<List<Mission>> fetchData(String search, {int offset = 0}) async {
    final query = """
      query Launch(\$name: String, \$limit: Int, \$offset: Int) {
          launches(find: {mission_name: \$name}, offset: \$offset, limit: \$limit ) {
            mission_name,
            details
          }
        }
    """;

    //lenght of data to fetch
    final limit = 10;

    final url = Uri.parse(_baseUrl);

    try {
      final response = await http.post(url,
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode({
            "query": query,
            "variables": {"name": search, "limit": limit, "offset": offset}
          }));

      final rawData = _handleResponse(response);
      final missions = <Mission>[];

      (rawData["launches"] as List).forEach((value) => missions.add(Mission(
          missionName: value["mission_name"]!, details: value["details"])));

      return missions;
    } on SocketException {
      throw FetchDataException(
          message: "Internet connection absent",
          code: "NO_INTERNET_CONNECTION");
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

    switch (response.statusCode) {
      case 200:
        return decodedResponse["data"];
      case 500:
        throw ServerException(message: "Internal server error");
      default:
        throw FetchDataException(
            message: "Error getting data from server",
            code: "GENERIC_EXCEPTION");
    }
  }
}
