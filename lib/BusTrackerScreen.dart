import 'dart:async';
import 'dart:convert';
import 'package:bus_tracker/services/bus_service.dart';
import 'package:bus_tracker/widgets/station_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BusTrackerScreen extends StatefulWidget {
  BusTrackerScreen({super.key});

  @override
  State<BusTrackerScreen> createState() => _BusTrackerScreenState();
}

class _BusTrackerScreenState extends State<BusTrackerScreen> {
  late Map<String, dynamic> _apiData;
  bool _isLoading = true;
  BusData busData = BusData();
  late Map<String, dynamic> stationNames;
  @override
  void initState() {
    super.initState();
    startTimer();
    fetchData();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 15), (Timer t) {
      fetchData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    BusService call = BusService();
    _apiData = await call.fetchDataFromApi();
    stationNames = await call.fetchStationNames();

    setState(() {
      _isLoading = false;
      busData.setData(_apiData, stationNames);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CustomScrollView(
            slivers: <Widget>[
              const SliverAppBar(
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Bus',
                  style: TextStyle(
                      color: Color.fromARGB(255, 4, 38, 88),
                      fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _apiData['data'][0]['distances'].length,
                          itemBuilder: (context, i) {
                            return StationCard(
                              index: i,
                              imageUrl: imageUrl[i],
                              busData: _apiData,
                              isIdle: busData.isIdle,
                              isIdle2: busData.isIdle2,
                              noOfBus: busData.noOfBus,
                              stationNames: busData.stationNames,
                            );
                          },
                        ),
                      ),
              ]))
            ],
          ),
        ));
  }
}

final List<String> imageUrl = [
  'assets/Meeranerplatz.jpeg',
  'assets/Teichstrasse.png',
  'assets/Tumringerstr.png',
  'assets/Bauhaus.jpeg',
  'assets/Beim Haagensteeg.jpg',
  'assets/Schwarzwaldstrasse.jpeg',
  'assets/Am Hebelpark.jpg',
];
