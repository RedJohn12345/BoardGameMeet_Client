import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class CityWidget extends StatefulWidget {


  final TextEditingController controller;
  bool withHelper = false;
  String city;
  CityWidget({
    Key? key,
    required this.controller, this.withHelper = false, required this.city}): super(key: key);

  @override
  _CityWidgetState createState() {
    return _CityWidgetState();
  }


}

class _CityWidgetState extends State<CityWidget> {

  bool cityIsFind = true;
  bool widgetSelect = false;
  @override
  void initState() {
    widget.controller.text = widget.city;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) widgetSelect = true;
          if (!hasFocus) {
            _onCityChanged(widget.controller.text);
            widgetSelect = false;
          }
        },
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            labelText: widget.withHelper ? "Город*" : "Город",
            fillColor:  Color(0xff171717),
            filled: true,
            labelStyle: TextStyle(color: Colors.white60),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            )
          ),
          keyboardType: TextInputType.name,
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if((value?.isEmpty ?? true) || widgetSelect) {
              return 'Please enter a city';
            } else if (!cityIsFind) {
              return 'City is not found';
            }
            return null;
          },
        ),
      ),
    ],
  );

  Future _onCityChanged(city) async {
    print('Suggest query: $city');
    if (city.isEmpty) {
        return;
    } else {
      final resultWithSession = YandexSearch.searchByText(searchText: city, geometry: Geometry.fromBoundingBox(BoundingBox(
          northEast: Point(latitude: 71.155753, longitude: -177.650671),
          southWest: Point(latitude: 44.063222,  longitude: 180.940636)
      ),), searchOptions: SearchOptions());

      return await _addResult(await resultWithSession.result, city);

    }

  }

  _addResult(SearchSessionResult result, String city) async {
      bool find = false;
      result.items!.asMap().forEach((i, item) {
        if (item.toponymMetadata != null && item.toponymMetadata!.address.addressComponents[SearchComponentKind.locality] != null) {
          if (!find) {
            find = true;
            widget.controller.text =
            item.toponymMetadata!.address.addressComponents[SearchComponentKind
                .locality]!;
          } else {
            return;
          }
        }
      });

      setState(() {
        cityIsFind = find;
      });

  }

}


