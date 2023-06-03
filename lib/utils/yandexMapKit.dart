import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/model/Location.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:boardgm/model/member.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapKitUtil {
  static Future<String> getCity() async {
    LocationPermission status = await Geolocator.requestPermission();
    //LocationPermission status = await Geolocator.checkPermission();
    return await getLocation(status);
  }

  static Future<String> getCityByAddress(String address) async {
    return await searchCityByAddress(address);
  }

  static Future<String> searchCityByAddress(address) async {

    final resultWithSession = YandexSearch.searchByText(searchText: address, geometry: Geometry.fromBoundingBox(BoundingBox(
        northEast: Point(latitude: 71.155753, longitude: -177.650671),
        southWest: Point(latitude: 44.063222,  longitude: 180.940636)
    ),), searchOptions: SearchOptions());

    return await findCity(resultWithSession);

  }

  static Future<String> findCity(SearchResultWithSession resultWithSession) async {
    var result = await resultWithSession.result;

    return result.items!.first.toponymMetadata!.address.addressComponents[SearchComponentKind.locality]!;
  }


  static Future getLocation(status) async {
    bool isMoscow = !(status == LocationPermission.always || status == LocationPermission.whileInUse);
    AppLatLong? pos = isMoscow ? MoscowLocation() : null;
    if (!isMoscow) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      pos = AppLatLong(lat: position.latitude, long: position.longitude);
    }
    return await searchCity(pos);

  }

  static Future searchCity(pos) async {
    SearchResultWithSession resultWithSession = YandexSearch.searchByPoint(point: Point(latitude: pos!.lat, longitude: pos.long), searchOptions: SearchOptions());
    var result = await resultWithSession.result;

    var res = [];
    result.items!.asMap().forEach((i, item) {
      res.add(item.toponymMetadata!.address.addressComponents[SearchComponentKind.locality]);
    });

    return res[0];

  }

  static Future getCityToSearch() async {
    var city;
    if (await Preference.checkToken()) {
      PersonsApiClient apiClient = PersonsApiClient();
      Member member = await apiClient.fetchGetOwnProfile();
      city = member.city;
    } else {
      city = await getCity();
    }

    return city;
  }
}