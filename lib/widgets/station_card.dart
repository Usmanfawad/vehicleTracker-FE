import 'package:bus_tracker/services/bus_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StationCard extends StatefulWidget {
  const StationCard({
    super.key,
    required this.index,
    required this.imageUrl,
    required this.busData,
    required this.isIdle,
    required this.isIdle2,
    required this.noOfBus,
    required this.stationNames,
  });
  //you can change the images through the imageUrl parameter in the constructor of the widget
  final int index;
  final String imageUrl;
  final Map<String, dynamic> busData;
  final Map<String, dynamic> stationNames;
  final bool isIdle;
  final bool isIdle2;
  final int noOfBus;

  @override
  State<StationCard> createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  bool atSameStation = false;
  @override
  Widget build(BuildContext context) {
    final String stationName =
        widget.stationNames['data']['locationStops'][widget.index].keys.first;
    return Stack(children: [
      Positioned(
        left: 32,
        top: widget.index == 0 ? 50 : 0,
        bottom:
            widget.busData['data'][0]['distances'].length == widget.index + 1
                ? 50
                : 0,
        child: const SizedBox(
          height: 120,
          width: 5,
          child: ColoredBox(
            color: const Color.fromARGB(255, 163, 186, 198),
          ),
        ),
      ),
      Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          //color indicator
          SizedBox(
            child: Container(
              decoration: BoxDecoration(
                  color: getIndicatorColor(),
                  gradient: atSameStation
                      ? const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 248, 229, 143),
                            Color.fromARGB(255, 9, 49, 82),
                          ],
                          end: Alignment.bottomCenter,
                          begin: Alignment.topCenter,
                          stops: [50, 100],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(25)),
              child: SizedBox(
                height: 30,
                width: 30,
                child: Center(
                  child: Text(
                    (widget.index + 1).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              elevation: 4,
              shadowColor: Colors.black87,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: MediaQuery.sizeOf(context).width - 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            widget.imageUrl,
                            fit: BoxFit.fill,
                            width: 70,
                            height: 70,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stationName.length > 20
                                  ? stationName.replaceRange(
                                      20, stationName.length, " ")
                                  : stationName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: widget.isIdle
                                            ? Colors.grey.shade200
                                            : const Color.fromARGB(
                                                255, 248, 229, 143),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                      color: widget.isIdle
                                          ? Colors.grey.shade600
                                          : Colors.yellow[100]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    //first bus time
                                    child: Text(
                                      formatTime(0),
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: widget.isIdle
                                            ? Colors.white
                                            : Color.fromARGB(255, 4, 38, 88),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                //validation for no of busses
                                widget.noOfBus == 2
                                    ? Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: widget.isIdle2
                                                ? Colors.grey.shade200
                                                : Color.fromARGB(
                                                    255, 131, 175, 191),
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: widget.isIdle2
                                              ? Colors.grey.shade600
                                              : Color.fromARGB(
                                                  255, 188, 213, 220),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          //second bus time
                                          child: Text(
                                            formatTime(1),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: widget.isIdle2
                                                  ? Colors.white
                                                  : Color.fromARGB(
                                                      255, 4, 38, 88),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  Color getIndicatorColor() {
    if (widget.noOfBus == 2) {
      if (widget.busData['data'][0]['distances'][widget.index]['in_m'] <= 200 &&
          widget.busData['data'][1]['distances'][widget.index]['in_m'] <= 200) {
        //HAndle both busses;
        setState(() {
          atSameStation = true;
        });
        return Colors.transparent;
      } else if (widget.busData['data'][1]['distances'][widget.index]['in_m'] <=
          200) {
        setState(() {
          atSameStation = false;
        });
        return Color.fromARGB(255, 9, 49, 82);
      } else if (widget.busData['data'][0]['distances'][widget.index]['in_m'] <=
          200) {
        setState(() {
          atSameStation = false;
        });
        return Color.fromARGB(255, 248, 229, 143);
      }
    } else {
      if (widget.busData['data'][0]['distances'][widget.index]['in_m'] <= 200) {
        return Color.fromARGB(255, 248, 229, 143);
      }
    }

    return Colors.blueGrey.shade400;
  }

  String formatTime(int busIndex) {
    DateTime now = DateTime.now();
    int totalSeconds = 0;
    for (int i = 0; i <= widget.index; i++) {
      totalSeconds +=
          widget.busData['data'][busIndex]['distances'][i]['in_s'] as int;
    }
    DateTime newTime = now.add(Duration(seconds: totalSeconds));
    String formattedTime =
        '${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}';

    return formattedTime;
  }
}
