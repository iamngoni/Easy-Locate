import 'package:easy_locate/api/apiCalls.dart';
import 'package:easy_locate/statics/static.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapView extends StatefulWidget {
  final String storeId;
  final String productId;
  MapView(this.storeId, this.productId);
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Future<dynamic> _place;
  var _api = new ApiCalls();
  var _response;
  LatLng _center;
  GoogleMapController _mapController;
  var _data;
  final Set<Marker> _markers = {};
  var _stores;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    _place = _api.getActualLocation();
    _response = _api.getMapData(this.widget.productId, this.widget.storeId);
    _data = _api.getCoords();
    _stores = _api.getRelatedStores(this.widget.productId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Statics _statics = new Statics(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(
                              Icons.arrow_back,
                              size: 30,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Map View",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on,
                          size: 27,
                          color: Colors.grey,
                        ),
                        FutureBuilder(
                          future: _place,
                          // ignore: missing_return
                          builder: (context, snapshot) {
                            while (!snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    backgroundColor: _statics.purplish,
                                  ),
                                ),
                              );
                            }
                            var place = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("${place.name}"),
                                Text("${place.country}"),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: _statics.height * 0.9,
                width: _statics.width,
                color: _statics.purplish,
                child: Column(
                  children: [
                    Container(
                      height: _statics.height * 0.4,
                      width: _statics.width,
                      child: FutureBuilder(
                        future: _data,
                        builder: (context, snapshot) {
                          while (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          _center = LatLng(
                              snapshot.data.latitude, snapshot.data.longitude);
                          Marker startMarker = Marker(
                            markerId: MarkerId('MyLocation'),
                            position: _center,
                            infoWindow: InfoWindow(
                              title: 'My Location',
                              snippet: 'My current location',
                            ),
                            icon: BitmapDescriptor.defaultMarker,
                          );
                          _markers.add(startMarker);
                          return GoogleMap(
                            onMapCreated: (GoogleMapController controller) {
                              _mapController = controller;
                            },
                            initialCameraPosition: CameraPosition(
                              target: _center,
                              zoom: 15.0,
                            ),
                            myLocationButtonEnabled: true,
                            mapType: MapType.normal,
                            zoomGesturesEnabled: true,
                            zoomControlsEnabled: false,
                            markers: _markers,
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: _response,
                        // ignore: missing_return
                        builder: (context, snapshot) {
                          while (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          var data = snapshot.data;
                          return ListView(
                            scrollDirection: Axis.vertical,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Product Details",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "${data["product"]["name"]} ${data["product"]["model"]}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Price",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "\$${data["product"]["price"]}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Store Details",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Name",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "${data["store"]["name"]}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Address",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "${data["store"]["address"]}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Contact",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () => _makePhoneCall(
                                          "tel:${data["store"]["phone"]}"),
                                      child: Text(
                                        "${data["store"]["phone"]}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Statistics",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Divider(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
