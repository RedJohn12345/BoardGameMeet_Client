import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:boardgm/utils/yandexMapKit.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapScreen extends StatefulWidget {
  late int color;

  MapScreen({super.key, required this.color});

  @override
  _MapScreenState createState() => _MapScreenState(color: color);
}

class _MapScreenState extends State<MapScreen> {

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('Map screen');
  }

  late int color;
  _MapScreenState({required this.color});

  final List<MapObject> mapObjects = [];
  List<String> suggests = [];
  bool cityOnly = false;
  final formKey = GlobalKey<FormState>();
  bool addressFind = false;
  final MapObjectId mapObjectId = MapObjectId('normal_icon_placemark');
  late YandexMapController controller;
  final textFieldController = TextEditingController();
  final box = const BoundingBox(northEast: Point(latitude: 71.155753, longitude: -177.650671),
  southWest: Point(latitude: 44.063222,  longitude: 180.940636));
  Point geo = Point(latitude: 55.7522200, longitude: 37.6155600);

  //final MapObjectId targetMapObjectId = MapObjectId('target_placemark');
  //static final Point _point = Point(latitude: 59., longitude: 30.320045);
  final animation = MapAnimation(type: MapAnimationType.smooth, duration: 2.0);

  bool tiltGesturesEnabled = true;
  bool zoomGesturesEnabled = true;
  bool rotateGesturesEnabled = true;
  bool scrollGesturesEnabled = true;
  bool modelsEnabled = true;
  bool nightModeEnabled = false;
  bool fastTapEnabled = false;
  bool mode2DEnabled = false;
  ScreenRect? focusRect;
  MapType mapType = MapType.vector;
  int? poiLimit;


  @override
  Widget build(BuildContext context) {
    cityOnly = (ModalRoute.of(context)?.settings.arguments) as bool;

    return Scaffold(
        appBar: AppBar(
          title:
          Text("Карта", style: TextStyle(fontSize: 24),),
          centerTitle: true,
          backgroundColor: Color(color),
        ),
        backgroundColor: Color(0xff292929),
      body: Form(
        key: formKey,
        child: Stack(
          alignment: Alignment.center,
          children: [
            YandexMap(
              mapType: mapType,
              poiLimit: poiLimit,
              tiltGesturesEnabled: tiltGesturesEnabled,
              zoomGesturesEnabled: zoomGesturesEnabled,
              rotateGesturesEnabled: rotateGesturesEnabled,
              scrollGesturesEnabled: scrollGesturesEnabled,
              modelsEnabled: modelsEnabled,
              nightModeEnabled: nightModeEnabled,
              fastTapEnabled: fastTapEnabled,
              mode2DEnabled: mode2DEnabled,
              logoAlignment: MapAlignment(horizontal: HorizontalAlignment.left, vertical: VerticalAlignment.bottom),
              focusRect: focusRect,
              mapObjects: mapObjects,
              onMapCreated: (YandexMapController yandexMapController) async {
                controller = yandexMapController;
                geo = await YandexMapKitUtil.getGeo();
                controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target:
                geo, zoom: 18),));
                setState(() {
                  mapObjects.add(
                      PlacemarkMapObject(mapId: mapObjectId,
                          point: geo,
                          opacity: 0.7,
                          icon: PlacemarkIcon.single(PlacemarkIconStyle(
                            image: BitmapDescriptor.fromAssetImage("assets/images/place.png"),
                            rotationType: RotationType.rotate,
                          )))
                  );
                });
                _searchAddress(geo);
              },
              onMapTap: (Point point) async {
                setState(() {
                  mapObjects.clear();
                  mapObjects.add(
                      PlacemarkMapObject(mapId: mapObjectId,
                          point: point,
                          opacity: 0.7,
                          icon: PlacemarkIcon.single(PlacemarkIconStyle(
                            image: BitmapDescriptor.fromAssetImage("assets/images/place.png"),
                            rotationType: RotationType.rotate,
                          )))
                  );
                });
                _searchAddress(point);
                await controller.deselectGeoObject();
              },
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                  children: [
                    TextFormField(controller: textFieldController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: "Поиск",
                          fillColor:  Color(0xff171717),
                          filled: true,
                          labelStyle: TextStyle(color: Colors.white60),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                      ),
                      onChanged: _onChanged,
                      validator: (text) {
                        if (!addressFind) {
                          return "Выберите адрес на карте или из списка подсказок";
                        } else {
                          return null;
                        }
                      },),
                    SizedBox(height: suggests.length > 3 ? 200 : suggests.length * 60,
                        child:
                        ListView.builder(
                          itemCount: suggests.length,
                          itemBuilder: (_, index) =>
                              Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    onTap: ()  async {
                                      setState(() {
                                        textFieldController.text = suggests[index];
                                        addressFind = true;
                                        suggests = [];
                                      });
                                      _searchGeo(textFieldController.text);
                                    },
                                    title: Text(suggests[index]),
                                  )
                              ),
                        )
                    ),
              ],
              ),
            ),
            Positioned(
              bottom: 16,
              child: ElevatedButton( onPressed: () {
                final form = formKey.currentState!;
                if (form.validate()) {
                  Navigator.pop(context, textFieldController.text);
                }
              },
                child: Text("Сохранить"),
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.green)),
              ),
            ),
          ],
        ),
      )
    );
  }


  _createSuggests(SuggestSessionResult result) {
    if (result.items == null) {
      return;
    }
    List<String> newSuggests = [];
    for (SuggestItem item in result.items!) {
      if (newSuggests.length < 10) {
          newSuggests.add(item.searchText);
      }
    }

    setState(() {
      suggests = newSuggests;
    });
  }

  Future<void> _onChanged(String value) async {
    setState(() {
      addressFind = false;
    });
    if (value.isEmpty) {
      setState(() {
        suggests = [];
      });
      return;
    }

    var resultWithSessions =  YandexSuggest.getSuggestions(text: value, boundingBox: box, suggestOptions: SuggestOptions(suggestType: SuggestType.geo));

    var result = await resultWithSessions.result;
    _createSuggests(result);
  }

  Future<void> _searchGeo(searchText) async {
    var resultWithSessions = YandexSearch.searchByText(searchText: searchText, geometry: Geometry.fromBoundingBox(box), searchOptions: SearchOptions());

    var result = await resultWithSessions.result;
    _searchPoint(result, searchText);
  }

  _searchPoint(SearchSessionResult result, String search) {
    if (result.items == null) {
      return;
    }

    var geo = result.items!.first;
    if (cityOnly && !YandexMapKitUtil.isCityOfFederalSignificance(search)) {
      setState(() {
        if (geo.toponymMetadata!.address.addressComponents[SearchComponentKind
            .locality] == null) {
          addressFind = false;
          textFieldController.clear();
        } else {
        textFieldController.text =
        geo.toponymMetadata!.address.addressComponents[SearchComponentKind
            .locality]!;
        addressFind = true;
      }
      });
    }
    Point point = geo.toponymMetadata!.balloonPoint;

    _moveCamera(point);
  }

  Future<void> _searchAddress(Point point) async {
    var resultWithSessions = YandexSearch.searchByPoint(point: point, searchOptions: SearchOptions());

    var result = await resultWithSessions.result;
    _searchText(result);
  }

  _searchText(SearchSessionResult result) {
    if (result.items == null) {
      return;
    }

    var geo = result.items!.first;
    setState(() {
      suggests = [];
      if (cityOnly) {
        var city = geo.toponymMetadata!.address.addressComponents[SearchComponentKind.locality];
        textFieldController.text = city ?? "Москва";
      } else {
        textFieldController.text =
            geo.toponymMetadata!.address.formattedAddress;
      }
      addressFind = true;
    });
  }

  _moveCamera(Point point) async {
    setState(() {
      mapObjects.removeAt(0);
      mapObjects.add(
          PlacemarkMapObject(mapId: mapObjectId,
              point: point,
              opacity: 0.7,
              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                image: BitmapDescriptor.fromAssetImage("assets/images/place.png"),
                rotationType: RotationType.rotate,
              )))
      );

      controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target:
      point)));
    });
    await controller.deselectGeoObject();
  }


}