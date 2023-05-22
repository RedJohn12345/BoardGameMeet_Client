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

  @override
  void initState() {
    widget.controller.text = widget.city;
    super.initState();
  }

  List<String> _suggestions = [];

  @override
  Widget build(BuildContext context) => Column(
    children: [
      TextFormField(
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
          if(value!.isEmpty) {
            return 'Please enter a city';
          } else if(!_suggestions.contains(value)) {
            return 'Please select a city from the suggestions';
          }
          return null;
        },
        onChanged: _onCityChanged,
      ),
      ListView.builder(
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_suggestions[index]),
            onTap: () {
              widget.controller.text = _suggestions[index];
              _suggestions = [];
            },
          );
        },
      )
    ],
  );

  Future<void> _onCityChanged(String city) async {
    print('Suggest query: $city');
    if (city.isEmpty) {
      setState(() {
        _suggestions = [];
      });
    } else {
      final resultWithSession = YandexSuggest.getSuggestions(
          text: city,
          boundingBox: BoundingBox(
              northEast: Point(latitude: 71.155753, longitude: -177.650671),
              southWest: Point(latitude: 44.063222,  longitude: 19.940636)
          ),
          suggestOptions: SuggestOptions(suggestType: SuggestType.geo)
      );

      await _addResult(await resultWithSession.result, Geometry.fromBoundingBox(BoundingBox(
          northEast: Point(latitude: 71.155753, longitude: -177.650671),
          southWest: Point(latitude: 44.063222,  longitude: 19.940636)
      ),));

    }


  }

  _addResult(SuggestSessionResult result, Geometry geometry) async {
    var locations = [];
    result.items!.asMap().forEach((i, item) {
      locations.add(item.searchText);
    });
    var cities = Set<String>();
    locations.asMap().forEach((key, value) async { 
      SearchResultWithSession resultWithSession = YandexSearch.searchByText(searchText: value, geometry: geometry, searchOptions: SearchOptions());
      SearchSessionResult result = await resultWithSession.result;
      if (cities.length < 7) {
        cities.add(result.items!.first.toponymMetadata!.address
            .addressComponents[SearchComponentKind.locality]!);
      }
    });
    
    setState(() {
      _suggestions = cities.toList();
    });
    


  }
}


