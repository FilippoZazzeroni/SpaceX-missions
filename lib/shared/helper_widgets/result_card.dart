import 'package:flutter/material.dart';
import 'package:spacex_missions/models/mission.dart';
import 'package:spacex_missions/shared/custom_shadow.dart';
import 'package:spacex_missions/shared/custom_text_style.dart';

/// Widget used to display data from the api
class ResultCard extends StatelessWidget {
  final Mission mission;

  const ResultCard({required this.mission});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15.0, 0, 15.0, 10.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [CustomShadow.card]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mission.missionName,
            style: CustomTextStyles.title,
          ),
          if (mission.details != null)
            Text(mission.details!, style: CustomTextStyles.body)
        ],
      ),
    );
  }
}
