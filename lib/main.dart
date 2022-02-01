import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarmy',
      theme: ThemeData(backgroundColor: Colors.grey[800]),
      home: const MyHomePage(title: 'Alarmy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final AudioCache _audioCache;

  late Timer setTimer;
  int clockDown = 0;
  late String frequencySelected;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  TextEditingController setNumber = TextEditingController();
  TextEditingController taskName = TextEditingController();
  TextEditingController taskNotes = TextEditingController();

  //Format Duration
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  //Timer Function
  void startTimer() {
    var oneSec = const Duration(seconds: 1);
    setTimer = Timer.periodic(oneSec, (timer) {
      if (clockDown == 0) {
        setState(() {
          _audioCache.play('alarmSound.mp3');
          // timer.cancel();
        });
      } else {
        setState(() {
          clockDown--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache(
      prefix: 'lib/src/',
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
    );
  }

  @override
  void dispose() {
    setTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.grey[800],
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.grey[850],
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      formatDuration(Duration(seconds: clockDown)),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 60.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 20.0),
                    child: TextField(
                      controller: setNumber,
                      decoration: InputDecoration(
                        filled: true,
                        isDense: true,
                        hintText: 'Enter Seconds',
                        fillColor: Colors.grey[800],
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                      ),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18.0),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              if (setNumber != '') {
                                clockDown = int.parse(setNumber.text);
                                startTimer();
                              } else {
                                print('Oops Please Enter Number');
                              }
                            },
                            child: Container(
                                height: 60.0,
                                margin: const EdgeInsets.only(
                                    top: 20.0, left: 10.0),
                                decoration: BoxDecoration(
                                    color: Colors.green[800],
                                    border: Border.all(
                                        color: Colors.green, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const <Widget>[
                                    Text(
                                      'Start Timer',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ))),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              _audioCache.fixedPlayer!.stop();
                              FocusScope.of(context).unfocus();
                              setState(() {
                                clockDown = 0;
                                setTimer.cancel();
                                setNumber.clear();
                              });
                            },
                            child: Container(
                                height: 60.0,
                                margin: const EdgeInsets.only(
                                    top: 20.0, right: 10.0),
                                decoration: BoxDecoration(
                                    color: Colors.red[800],
                                    border: Border.all(
                                        color: Colors.red, width: 1.0),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const <Widget>[
                                    Text(
                                      'Stop',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ))),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0))),
                          backgroundColor: Colors.grey[850],
                          builder: (BuildContext context) {
                            return GestureDetector(
                                onTap: () {
                                  print('test');
                                  FocusScope.of(context).unfocus();
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    const Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.0, top: 20.0),
                                      child: Text(
                                        'Create Task',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, right: 20.0, top: 15.0),
                                      // padding: const EdgeInsets.only(left: 10.0),
                                      child: TextField(
                                        controller: taskName,
                                        decoration: InputDecoration(
                                          hintText: "Task Name",
                                          filled: true,
                                          isDense: true,
                                          fillColor: Colors.grey[800],
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),

                                          border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.all(Radius
                                                          .circular(10.0))),
                                          // focusedBorder: OutlineInputBorder(
                                          //     borderSide: BorderSide(
                                          //         color: Colors.grey, width: 1.0),
                                          //     borderRadius: BorderRadius.all(
                                          //         Radius.circular(10.0))),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          left: 20.0, right: 20.0, top: 15.0),
                                      // padding: const EdgeInsets.only(left: 10.0),
                                      child: TextField(
                                        controller: taskNotes,
                                        maxLines: 6,
                                        decoration: InputDecoration(
                                          hintText: "Notes",
                                          filled: true,
                                          isDense: true,
                                          fillColor: Colors.grey[800],
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),

                                          border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.all(Radius
                                                          .circular(10.0))),
                                          // focusedBorder: OutlineInputBorder(
                                          //     borderSide: BorderSide(
                                          //         color: Colors.grey, width: 1.0),
                                          //     borderRadius: BorderRadius.all(
                                          //         Radius.circular(10.0))),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                    const SizedBox(height: 15.0),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () async {
                                            final selectedTime =
                                                await showTimePicker(
                                                    context: context,
                                                    helpText:
                                                        'Enter Start Time',
                                                    initialTime: startTime,
                                                    initialEntryMode:
                                                        TimePickerEntryMode
                                                            .input);

                                            if (selectedTime != null) {
                                              setState(() {
                                                startTime = selectedTime;

                                                print(
                                                    startTime.format(context));
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: 40.0,
                                            margin: const EdgeInsets.only(
                                                left: 20.0),
                                            decoration: BoxDecoration(
                                                color: Colors.blue[300],
                                                border: Border.all(
                                                    color: Colors.blue,
                                                    width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15.0))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const <Widget>[
                                                Text('Start Time',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold))
                                              ],
                                            ),
                                          ),
                                        )),
                                        const SizedBox(width: 10.0),
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () async {
                                            final selectedTime =
                                                await showTimePicker(
                                                    context: context,
                                                    helpText: 'Enter End Time',
                                                    initialTime: endTime,
                                                    initialEntryMode:
                                                        TimePickerEntryMode
                                                            .input);

                                            if (selectedTime != null) {
                                              setState(() {
                                                endTime = selectedTime;

                                                print(endTime.format(context));
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: 40.0,
                                            margin: const EdgeInsets.only(
                                                right: 20.0),
                                            decoration: BoxDecoration(
                                                color: Colors.blue[300],
                                                border: Border.all(
                                                    color: Colors.blue,
                                                    width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(15.0))),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const <Widget>[
                                                Icon(
                                                  Icons.not_interested_rounded,
                                                  color: Colors.white,
                                                  size: 16.0,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0),
                                                  child: Text('End Time',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {},
                                            child: Container(
                                              height: 55,
                                              margin: const EdgeInsets.only(
                                                  top: 15.0, left: 20.0),
                                              decoration: BoxDecoration(
                                                color: Colors.blueGrey[800],
                                                border: Border.all(
                                                    color: Colors.blueGrey,
                                                    width: 1.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: const <Widget>[
                                                  Icon(
                                                    Icons
                                                        .calendar_today_rounded,
                                                    color: Colors.white,
                                                    size: 18.0,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.0),
                                                    child: Text(
                                                      'Select Date',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(
                                            child: GestureDetector(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Container(
                                                          height: 150.0,
                                                          // decoration: ShapeDecoration(
                                                          //     shape: const RoundedRectangleBorder(
                                                          //         borderRadius: BorderRadius.only(
                                                          //             topLeft: Radius.circular(20.0),
                                                          //             topRight: Radius.circular(20.0)))),
                                                          child:
                                                              CupertinoPicker(
                                                            backgroundColor:
                                                                Colors
                                                                    .grey[800],
                                                            itemExtent: 60.0,
                                                            scrollController:
                                                                FixedExtentScrollController(
                                                                    initialItem:
                                                                        0),
                                                            children: <Widget>[
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: const <
                                                                    Widget>[
                                                                  Text(
                                                                    'Weekly',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: const <
                                                                    Widget>[
                                                                  Text(
                                                                    'Bi-Weekly',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: const <
                                                                    Widget>[
                                                                  Text(
                                                                    'Monthly',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: const <
                                                                    Widget>[
                                                                  Text(
                                                                    'Yearly',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                            onSelectedItemChanged:
                                                                (value) {
                                                              setState(() {
                                                                switch (value) {
                                                                  case 0:
                                                                    setState(
                                                                        () {
                                                                      frequencySelected =
                                                                          'Weekly';
                                                                    });
                                                                    break;
                                                                  case 1:
                                                                    setState(
                                                                        () {
                                                                      frequencySelected =
                                                                          'Bi-Weekly';
                                                                    });
                                                                    break;
                                                                  case 2:
                                                                    setState(
                                                                        () {
                                                                      frequencySelected =
                                                                          'Monthly';
                                                                    });
                                                                    break;
                                                                  case 3:
                                                                    setState(
                                                                        () {
                                                                      frequencySelected =
                                                                          'Yearly';
                                                                    });
                                                                    break;
                                                                  default:
                                                                    break;
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        );
                                                      }).whenComplete(() => {
                                                        print(
                                                            frequencySelected),
                                                        // setState(() {
                                                        //   frequencySelected = '';
                                                        // })
                                                      });
                                                },
                                                child: Container(
                                                  height: 55,
                                                  margin: const EdgeInsets.only(
                                                      top: 15.0, right: 20.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blueGrey[800],
                                                    border: Border.all(
                                                        color: Colors.blueGrey,
                                                        width: 1.0),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20.0),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: const <Widget>[
                                                      Icon(
                                                          Icons
                                                              .access_alarm_rounded,
                                                          color: Colors.white),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0),
                                                        child: Text(
                                                          'Frequency',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )))
                                      ],
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Container(
                                        width: 200.0,
                                        height: 40.0,
                                        margin:
                                            const EdgeInsets.only(bottom: 30.0),
                                        decoration: BoxDecoration(
                                            color: Colors.deepPurple[300],
                                            border: Border.all(
                                                color: Colors.deepPurple,
                                                width: 1.0),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10.0))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: const <Widget>[
                                            Icon(
                                              Icons.create,
                                              color: Colors.white,
                                              size: 18.0,
                                            ),
                                            SizedBox(width: 5.0),
                                            Text(
                                              'Create Task',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ))
                                  ],
                                ));
                          });
                    },
                    child: Container(
                        margin: const EdgeInsets.all(10.0),
                        height: 60.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.blue[800],
                            border: Border.all(color: Colors.blue, width: 1.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            Text(
                              'Create Task',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                  ),
                  Row(
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 20.0),
                        child: Text(
                          'Tasks',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(),
                      )
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 3,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0))),
                                  backgroundColor: Colors.grey[850],
                                  builder: (BuildContext context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(top: 20.0),
                                          child: Text(
                                            'Take Puppies For a Walk',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10.0,
                                              left: 20.0,
                                              right: 20.0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 150.0,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[800],
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const <Widget>[
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10.0, top: 10.0),
                                                child: Text(
                                                  'Notes',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10.0, top: 10.0),
                                                child: Text(
                                                  '- Dont Forget to Clean their butts after',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16.0),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                height: 40.0,
                                                margin: const EdgeInsets.only(
                                                    left: 20.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.blueGrey[800],
                                                    border: Border.all(
                                                        color: Colors.blueGrey,
                                                        width: 1.0),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: const <Widget>[
                                                    Text(
                                                      '8:00AM - 10:00AM',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.0),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Expanded(
                                              child: Container(
                                                height: 40.0,
                                                margin: const EdgeInsets.only(
                                                    right: 20.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.blueGrey[800],
                                                    border: Border.all(
                                                        color: Colors.blueGrey,
                                                        width: 1.0),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10.0))),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: const <Widget>[
                                                    Text(
                                                      'Weekly',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.0),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                height: 50.0,
                                                width: 200.0,
                                                margin: const EdgeInsets.only(
                                                    right: 10.0),
                                                decoration: BoxDecoration(
                                                    color: Colors.blue[300],
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                30.0))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: const <Widget>[
                                                    Icon(Icons.play_arrow,
                                                        color: Colors.white),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5.0),
                                                      child: Text(
                                                        'Start Task',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20.0),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              height: 50.0,
                                              width: 50.0,
                                              decoration: BoxDecoration(
                                                color: Colors.green[300],
                                                shape: BoxShape.circle,
                                                // border: Border.all(
                                                //     color: Colors.blueGrey,
                                                //     width: 1.0),
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 30.0,
                                              ),
                                            ),
                                            const SizedBox(width: 10.0),
                                            Container(
                                                height: 50.0,
                                                width: 50.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.red[300],
                                                  shape: BoxShape.circle,
                                                  // border: Border.all(
                                                  //     color: Colors.blueGrey,
                                                  //     width: 1.0),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: const <Widget>[
                                                    Text(
                                                      'X',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30.0,
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, bottom: 10.0),
                              padding: const EdgeInsets.only(left: 15.0),
                              width: MediaQuery.of(context).size.width,
                              height: 90.0,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey[800],
                                  border: Border.all(
                                      color: Colors.blueGrey, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: const <Widget>[
                                          Icon(Icons.checklist_rounded,
                                              color: Colors.white),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              'Walk The Puppies',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.access_time,
                                              color: Colors.grey,
                                              size: 14.0,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                '8:00AM - 10:00AM',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Row(
                                          children: const <Widget>[
                                            Icon(
                                              Icons.calendar_today_rounded,
                                              color: Colors.grey,
                                              size: 14.0,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                'January 28th, 2022',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          print('Clear');
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.0, right: 10.0),
                                          child: Text(
                                            'Clear',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: SizedBox(),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            )));
  }
}
