import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapShowScreen extends StatefulWidget {
  late int color;

  MapShowScreen({super.key, required this.color});

  @override
  _MapShowScreenState createState() => _MapShowScreenState(color: color);
}

class _MapShowScreenState extends State<MapShowScreen> {

  @override
  void initState() {
    super.initState();
    AppMetrica.reportEvent('Map screen');
  }

  late int color;
  _MapShowScreenState({required this.color});

  final List<MapObject> mapObjects = [];
  final MapObjectId mapObjectId = MapObjectId('normal_icon_placemark');
  late YandexMapController controller;
  final box = const BoundingBox(northEast: Point(latitude: 71.155753, longitude: -177.650671),
  southWest: Point(latitude: 44.063222,  longitude: 180.940636));
  Point geo = Point(latitude: 55.7522200, longitude: 37.6155600);
  String address = "";
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
    final list = (ModalRoute.of(context)?.settings.arguments) as List;
    geo = list[0] as Point;
    address = list[1] as String;

    return Scaffold(
        appBar: AppBar(
          title:
          Text("Карта", style: TextStyle(fontSize: 24),),
          centerTitle: true,
          backgroundColor: Color(color),
        ),
        backgroundColor: Color(0xff292929),
      body: Stack(
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
            },
          ),
          Positioned(
            top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(16),
                child: TextFormField(controller: TextEditingController(text: address),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      fillColor:  Color(0xff171717),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                ),
              )
          ),
        ],
      )
    );
  }


}