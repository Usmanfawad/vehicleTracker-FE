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
    String imageUrl =
        'https://firebasestorage.googleapis.com/v0/b/the-chat-app-363a8.appspot.com/o/download.jpg?alt=media&token=422dbc5e-4481-428c-aac1-df0284343241';

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
                              imageUrl: imageUrl,
                              busData: _apiData,
                              isIdle: busData.isIdle,
                              isIdle2: busData.isIdle2,
                              noOfBus: busData.noOfBus,
                              stationNames: busData.stationNames,
                            );
                          },
                        ),
                        // child: Stack(
                        //   children: [
                        //     const Positioned(
                        //       left: 32,
                        //       top: 40,
                        //       child: SizedBox(
                        //         height: 450,
                        //         width: 5,
                        //         child: ColoredBox(
                        //             color: const Color.fromARGB(255, 163, 186, 198)),
                        //       ),
                        //     ),

                        //   ],
                        // ),
                      ),
              ]))
            ],
          ),
        ));
  }
}
