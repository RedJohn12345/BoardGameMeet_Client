import 'package:boardgm/apiclient/persons_api_client.dart';
import 'package:boardgm/model/Location.dart';
import 'package:boardgm/utils/preference.dart';
import 'package:boardgm/model/member.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapKitUtil {
  static Future<String?> getCity() async {
    LocationPermission status = await Geolocator.requestPermission();
    return await getLocation(status);
  }

  static Future<String?> getCityByAddress(String address) async {
    return await searchCityByAddress(address);
  }

  static Future<String?> searchCityByAddress(address) async {

    final resultWithSession = YandexSearch.searchByText(searchText: address, geometry: Geometry.fromBoundingBox(BoundingBox(
        northEast: Point(latitude: 71.155753, longitude: -177.650671),
        southWest: Point(latitude: 44.063222,  longitude: 180.940636)
    ),), searchOptions: SearchOptions());

    return await findCity(resultWithSession);

  }

  static Future<String?> findCity(SearchResultWithSession resultWithSession) async {
    var result = await resultWithSession.result;

    return result.items!.first.toponymMetadata!.address.addressComponents[SearchComponentKind.locality]!;
  }


  static Future<String?> getLocation(status) async {
    bool isMoscow = !(status == LocationPermission.always || status == LocationPermission.whileInUse);
    AppLatLong? pos = isMoscow ? MoscowLocation() : null;
    if (!isMoscow) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      pos = AppLatLong(lat: position.latitude, long: position.longitude);
    }
    return await searchCity(pos);

  }

  static Future<String?> searchCity(pos) async {
    SearchResultWithSession resultWithSession = YandexSearch.searchByPoint(point: Point(latitude: pos!.lat, longitude: pos.long), searchOptions: SearchOptions());
    var result = await resultWithSession.result;

    var res = [];
    result.items!.asMap().forEach((i, item) {
      var city = item.toponymMetadata!.address.addressComponents[SearchComponentKind.locality];
      res.add(city ?? "Москва");
    });
    return res[0];

  }

  static Future<String> getCityToSearch() async {
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


  static Future<Point> getGeo() async {
    print("getGeo");
    LocationPermission status = await Geolocator.requestPermission();
    return await getGeolocation(status);
  }

  static Future getGeolocation(status) async {
    bool isMoscow = !(status == LocationPermission.always || status == LocationPermission.whileInUse);
    AppLatLong? pos = isMoscow ? MoscowLocation() : null;
    if (!isMoscow) {
      var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      pos = AppLatLong(lat: position.latitude, long: position.longitude);
    }
    return Point(latitude: pos!.lat, longitude: pos.long);
  }

  static Future<Point?> getPointByText(String text) async {
    final resultWithSession = YandexSearch.searchByText(searchText: text, geometry: Geometry.fromBoundingBox(BoundingBox(
        northEast: Point(latitude: 71.155753, longitude: -177.650671),
        southWest: Point(latitude: 44.063222,  longitude: 180.940636)
    ),), searchOptions: SearchOptions());
    var result = await resultWithSession.result;
    if (result.items == null || result.items!.first.toponymMetadata == null) {
      return null;
    } else {
      return result.items!.first.toponymMetadata!.balloonPoint;

    }
  }

  static bool isCityOfFederalSignificance(String text) {
    return text == "Москва" || text == "Севастополь" || text == "Санкт-Петербург";
  }
}