import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:async';

class MapCity extends StatefulWidget {
  @override
  State<MapCity> createState() => _MapCityState();
}

class _MapCityState extends State<MapCity> {
  TextEditingController _cityController = TextEditingController();

  List<String> _suggestions = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suggest demo'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              onChanged: _onCityChanged,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () {
                      _cityController.text = _suggestions[index];
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

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
          suggestOptions: SuggestOptions(
              suggestType: SuggestType.geo,
              suggestWords: true,
              userPosition: Point(latitude: 56.0321, longitude: 38)
          )
      );

      await _addResult(await resultWithSession.result);

    }


  }

  _addResult(SuggestSessionResult result) async {

    setState(() {
      _suggestions = [];
        result.items!.asMap().forEach((i, item) {
          _suggestions.add(item.title);
        });
    });

  }
}