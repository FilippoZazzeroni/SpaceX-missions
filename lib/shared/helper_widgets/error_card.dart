import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spacex_missions/models/error_card_data.dart';
import 'package:spacex_missions/shared/custom_shadow.dart';
import 'package:spacex_missions/shared/custom_text_style.dart';

/// Widget used to display errors coming from the api
class ErrorCard extends StatelessWidget {
  final ErrorCardData data;

  final VoidCallback? onRefreshButtonPressed;

  ErrorCard({required this.data, this.onRefreshButtonPressed}) {
    if (data.hasRefreshButton) assert(onRefreshButtonPressed != null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(15.0, 0, 15.0, 10.0),
      padding: EdgeInsets.all(15.0),
      height: 300,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          boxShadow: [CustomShadow.card]),
      child: Column(
        children: [
          Expanded(child: SvgPicture.asset(data.imgPath)),
          Text(
            data.title,
            style: CustomTextStyles.body,
          ),
          if (data.hasRefreshButton)
            ElevatedButton.icon(
                onPressed: onRefreshButtonPressed,
                icon: Icon(Icons.refresh),
                label: Text(
                  "Refresh",
                  style: CustomTextStyles.body,
                ))
        ],
      ),
    );
  }
}
