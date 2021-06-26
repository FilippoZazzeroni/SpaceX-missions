import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:spacex_missions/models/api/api_expections.dart';
import 'package:spacex_missions/models/api/mission.dart';

// test GET request: https://api.spacex.land/graphql/launches?query={launches(find: {mission_name:"Thai"}){mission_name,details}}

class Api {
  final _baseUrl = "https://api.spacex.land/graphql/launches";

  /// [mission] is the string used to get filtered data by 'mission_name' from spaceX api
  Future<List<Mission>> fetchData(String mission) async {
    final query = """
      {
          launches(find: {
            mission_name: "$mission"
          }) {
            mission_name,
            details
        }
      }
    """;

    print(query);

    final url = Uri.parse("$_baseUrl?query=$query");

    try {
      final response = await http.get(url);
      final rawData = _handleResponse(response);
      final missions = <Mission>[];

      (rawData["launches"] as List).forEach((value) => missions.add(Mission(
          missionName: value["mission_name"]!, details: value["details"])));

      return missions;
    } on SocketException {
      throw FetchDataException();
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

    switch (response.statusCode) {
      case 200:
        return decodedResponse["data"];
      //TODO inserire decodedResponse["error"]
      case 400:
        //TODO Syntax error use invalidInputExceptions
        //TODO da testare
        throw BadRequestException(message: response.body);
      default:
        //TODO da capire possibili errori
        throw FetchDataException(
            message:
                "Error getting data from server. response: ${response.statusCode}");
    }
  }
}

// //find: {
//             mission_name: $mission
//           }
