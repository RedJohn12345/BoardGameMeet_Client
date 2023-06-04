import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class AddressWidget extends StatefulWidget {

  final TextEditingController controller;
  bool withHelper = false;
  String? city;
  AddressWidget({
    Key? key,
    required this.controller, this.withHelper = false}): super(key: key);

  @override
  _AddressWidgetState createState() {
    return _AddressWidgetState();
  }

}

class _AddressWidgetState extends State<AddressWidget> {
  bool addressIsFind = true;
  bool widgetSelect = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) => Focus(
    onFocusChange: (hasFocus) {
      if (hasFocus) widgetSelect = true;
      if (!hasFocus) {
        _onAddressChanged(widget.controller.text);
        widgetSelect = false;
      }
    },
    child: TextFormField(
      controller: widget.controller,
        maxLength: 100,
      decoration: InputDecoration(
        counterText: "",
        labelText: widget.withHelper ? "Адрес*" : "Адрес",
        fillColor:  Color(0xff171717),
        filled: true,
        labelStyle: TextStyle(color: Colors.white60),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        )
      ),
      keyboardType: TextInputType.name,
      style: TextStyle(color: Colors.white),
        validator: (name) {
          if((name?.isEmpty ?? true) || widgetSelect) {
            return 'Please enter a address';
          } else if (!addressIsFind) {
            return 'Address is not found';
          }
          return null;
        }
    ),
  );

  Future _onAddressChanged(address) async {
    if (address.isEmpty) {
      return;
    } else {
      final resultWithSession = YandexSearch.searchByText(searchText: address, geometry: Geometry.fromBoundingBox(BoundingBox(
          northEast: Point(latitude: 71.155753, longitude: -177.650671),
          southWest: Point(latitude: 44.063222,  longitude: 180.940636)
      ),), searchOptions: SearchOptions());

      return await _addResult(await resultWithSession.result, address);

    }

  }

  _addResult(SearchSessionResult result, String address) async {
    bool find = false;
    result.items!.asMap().forEach((i, item) {
      if (item.toponymMetadata != null && item.toponymMetadata!.address.addressComponents[SearchComponentKind.locality] != null) {
        if (!find) {
          find = true;
          widget.controller.text =
          item.toponymMetadata!.address.formattedAddress;
        } else {
          return;
        }
      }
    });

    setState(() {
      addressIsFind = find;
    });

  }
}
