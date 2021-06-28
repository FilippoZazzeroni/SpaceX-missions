import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_missions/shared/custom_shadow.dart';
import 'package:spacex_missions/shared/custom_text_style.dart';
import 'package:spacex_missions/view_models/missions_view_model.dart';
import 'package:spacex_missions/view_models/search_bar_view_model.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  final _node = FocusNode();

  late MissionsViewModel _missionsViewModel;

  @override
  void initState() {
    _missionsViewModel = context.read<MissionsViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      padding: EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          boxShadow: [CustomShadow.card]),
      child: Consumer<SearchBarViewModel>(builder: (context, model, _) {
        if (model.isSearchBarHidden)
          return Row(
            children: [
              Expanded(
                child: Text(
                  "SpaceX Missions",
                  style: CustomTextStyles.title,
                ),
              ),
              GestureDetector(
                onTap: () {
                  model.isSearchBarHidden = false;
                  _node.requestFocus();
                },
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 15)
            ],
          );

        return TextField(
          controller: _controller,
          focusNode: _node,
          onChanged: (value) => _missionsViewModel.fetchMissions(value),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Try Thaicom",
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: GestureDetector(
                  onTap: () {
                    model.isSearchBarHidden = true;
                    _node.unfocus();
                    _missionsViewModel.clearMissions();
                  },
                  child: Icon(
                    Icons.clear,
                    color: Colors.black,
                  ),
                ),
              )),
        );
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
