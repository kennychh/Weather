import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Model/ForecastModel.dart';
import 'Model/WeatherModel.dart';
import 'package:weather/Model/Model.dart';
import 'package:http/http.dart' as http;

Future<WeatherModel> getWeather(String lat, String lng) async {
  final response = await http.get(
      'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&appid=9f91436f32b5c48101062ca635294353&units=metric');
  if (response.statusCode == 200) {
    var result = json.decode(response.body);
    var model = WeatherModel.fromJson(result);
    return model;
  } else
    throw Exception('Failed to load Weather information');
}

Future<ForecastModel> getForecast(String lat, String lng) async {
  final response = await http.get(
      'http://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lng&appid=9f91436f32b5c48101062ca635294353&units=metric');
  if (response.statusCode == 200) {
    var result = json.decode(response.body);
    var model = ForecastModel.fromJson(result);
    return model;
  } else
    throw Exception('Failed to load Weather information');
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        fontFamily: 'Product Sans',
        accentColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyHomeState();
}

class MyHomeState extends State<MyHomePage> {
  Color darkPrimaryColor = Color(0xff232130);
  Color darkAccentColor = Color(0xff4d4a62);
  Color accentColor = Color(0xff5d4ead);
  int _currentIndex = 0;
  Color dayIconColor = Color(0xff464073);
  Color nightIconColor = Colors.deepPurple[50];
  int pageIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(),
        bottomNavigationBar: Builder(
          builder: (context) => BottomNavigationBar(
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
              if (index == 0) {
                Scaffold.of(context).openDrawer();
              }
            },
            items: [
              BottomNavigationBarItem(
                  title:
                      Text('', style: TextStyle(fontWeight: FontWeight.w600)),
                  icon: Image.asset(
                    'assets/weather_icons/menu.png',
                    scale: 4.2,
                    color: Color(0xff4c33d6),
                  )),
              BottomNavigationBarItem(
                  title:
                      Text('', style: TextStyle(fontWeight: FontWeight.w600)),
                  icon: Image.asset('assets/weather_icons/plus.png',
                      scale: 4.2, color: Color(0xff4c33d6))),
              BottomNavigationBarItem(
                  title:
                      Text('', style: TextStyle(fontWeight: FontWeight.w600)),
                  icon: Image.asset(
                    'assets/weather_icons/search.png',
                    scale: 4.2,
                    color: Color(0xff4c33d6),
                  )),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Scaffold(
                backgroundColor: Colors.transparent,
                body: PageView(
                  pageSnapping: true,
                  physics: NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (index) {
                    pageChanged(index);
                  },
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          color: Color(0xffdfe6ff),
                        ),
                        Align(
                          alignment: Alignment(1, -0.64),
                          child: Image.asset('assets/images/vectorwoman.png',
                              scale: 3.5),
                        ),
                        CustomScrollView(
                          slivers: <Widget>[
                            SliverAppBar(
                              brightness: Brightness.light,
                              floating: false,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              expandedHeight: 300.0,
                              flexibleSpace: FlexibleSpaceBar(
                                background: Stack(
                                  children: <Widget>[
                                    Container(
                                      child: FutureBuilder<WeatherModel>(
                                        future:
                                            getWeather('43.7001', '-79.4163'),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            WeatherModel model = snapshot.data;
                                            var now = new DateTime.now();
                                            var fm =
                                                DateFormat.yMMMMEEEEd('en_US');
                                            var fm_hour = new DateFormat.Hm();
                                            return Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 50,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(-1, -1.0),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 25,
                                                    ),
                                                    child: Text('${model.name}',
                                                        style: TextStyle(
                                                            fontSize: 25.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Color(
                                                                0xff4c33d6)),
                                                        textAlign:
                                                            TextAlign.left),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(-1, -1.0),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 25,
                                                    ),
                                                    child: Text(
                                                        '${fm.format(now)}',
                                                        style: TextStyle(
                                                            fontSize: 13.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: accentColor),
                                                        textAlign:
                                                            TextAlign.left),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40,
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(-1, -1.0),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 25,
                                                    ),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            weatherIcon(
                                                                '${model.weather[0].icon}',
                                                                accentColor),
                                                            Text(' '),
                                                            Text(
                                                              '${model.weather[0].description}',
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color:
                                                                    accentColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(-1, -1.0),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 25,
                                                    ),
                                                    child: Text(
                                                      '${model.main.temp.round()}°',
                                                      style: TextStyle(
                                                          fontSize: 70.0,
                                                          color: Color(
                                                              0xff4c33d6)),
                                                    ),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment(-1, -1.0),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      left: 25,
                                                    ),
                                                    child: Text(
                                                      'Feels like ${model.main.feels_like.round()}°',
                                                      style: TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: accentColor),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          } else if (snapshot.hasError)
                                            return Text('${snapshot.error}',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.blue));
                                          return CircularProgressIndicator();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          topRight: Radius.circular(50)),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 30,
                                      ),
                                      FutureBuilder(
                                          future:
                                              getWeather('43.7001', '-79.4163'),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              WeatherModel model =
                                                  snapshot.data;
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 70,
                                                        height: 70,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Image.asset(
                                                                'assets/weather_icons/wind.png',
                                                                scale: 5,
                                                                color: Colors
                                                                    .green[700])
                                                          ],
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                20.0),
                                                          ),
                                                          color:
                                                              Colors.green[50],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        '${model.wind.speed} km/h',
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors
                                                                .green[700],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 70,
                                                        height: 70,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Image.asset(
                                                                'assets/weather_icons/droplet.png',
                                                                scale: 5,
                                                                color: Colors
                                                                        .blueAccent[
                                                                    700])
                                                          ],
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                20.0),
                                                          ),
                                                          color:
                                                              Colors.blue[50],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        '${model.main.humidity}%',
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors
                                                                    .blueAccent[
                                                                700],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 70,
                                                        height: 70,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Image.asset(
                                                                'assets/weather_icons/cloud.png',
                                                                scale: 5,
                                                                color: Colors
                                                                        .pinkAccent[
                                                                    700])
                                                          ],
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                20.0),
                                                          ),
                                                          color:
                                                              Colors.pink[50],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        '${model.clouds.all}%',
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors
                                                                    .pinkAccent[
                                                                700],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              );
                                            } else if (snapshot.hasError)
                                              return Text('${snapshot.error}',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.blue));
                                            return CircularProgressIndicator();
                                          }),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment(-1, 0),
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 25,
                                              ),
                                              child: Text(
                                                'Today',
                                                style: TextStyle(
                                                    color: Color(0xff464073),
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Align(
                                              alignment: Alignment(1, 0),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: 25,
                                                ),
                                                child: FlatButton(
                                                  onPressed: () =>
                                                      pageController
                                                          .animateToPage(
                                                    1,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    curve: Curves.ease,
                                                  ),
                                                  child: SizedBox(
                                                    width: 100,
                                                    height: 45,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Image.asset(
                                                          'assets/icons/left.png',
                                                          scale: 5.5,
                                                          color:
                                                              Color(0xff5615ed),
                                                        ),
                                                        Text(
                                                          'Next 5 Days  ',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff5615ed)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  disabledColor:
                                                      Color(0xffe0e0ff),
                                                  color: Color(0xffefedfc),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      FutureBuilder<ForecastModel>(
                                        future:
                                            getForecast('43.7001', '-79.4163'),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var fm_hour = new DateFormat.Hm();
                                            var fmDay = new DateFormat.MMMd();
                                            ForecastModel model = snapshot.data;
                                            return Container(
                                              height: 125,
                                              child: ListView.separated(
                                                padding: EdgeInsets.only(
                                                    left: 25, right: 25),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: 5,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Align(
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Column(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Text(
                                                              '${fm_hour.format(DateTime.fromMillisecondsSinceEpoch(model.list[index].dt * 1000))}',
                                                              style: TextStyle(
                                                                  color:
                                                                      accentColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            weatherIcon(
                                                                '${model.list[index].weather[0].icon}',
                                                                accentColor),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              '${model.list[index].main.temp.round()}°',
                                                              style: TextStyle(
                                                                  color:
                                                                      accentColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        width: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          color: Colors
                                                              .deepPurple[50],
                                                        )),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return VerticalDivider(
                                                    color: Colors.white,
                                                    width: 18,
                                                  );
                                                },
                                              ),
                                            );
                                          } else if (snapshot.hasError)
                                            return Text('${snapshot.error}',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.blue));
                                          return CircularProgressIndicator();
                                        },
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment(-1, 0),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: 25,
                                          ),
                                          child: Text(
                                            'Sun',
                                            style: TextStyle(
                                                color: Color(0xff464073),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      FutureBuilder(
                                          //sunrise sunset
                                          future:
                                              getWeather('43.7001', '-79.4163'),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var fm_hour = new DateFormat.Hm();
                                              WeatherModel model =
                                                  snapshot.data;
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 150,
                                                        height: 70,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Image.asset(
                                                                'assets/weather_icons/sunrise.png',
                                                                scale: 5,
                                                                color: Colors
                                                                        .deepOrange[
                                                                    900])
                                                          ],
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                20.0),
                                                          ),
                                                          color:
                                                              Color(0xffffe1d1),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        '${fm_hour.format(DateTime.fromMillisecondsSinceEpoch(model.sys.sunrise * 1000))}',
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors
                                                                    .deepOrange[
                                                                900],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: <Widget>[
                                                      Container(
                                                        width: 150,
                                                        height: 70,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Image.asset(
                                                                'assets/weather_icons/sunset.png',
                                                                scale: 5,
                                                                color: Color(
                                                                    0xff6a0d83))
                                                          ],
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                20.0),
                                                          ),
                                                          color:
                                                              Color(0xffffdbe1),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(
                                                        '${fm_hour.format(DateTime.fromMillisecondsSinceEpoch(model.sys.sunset * 1000))}',
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Color(
                                                                0xff6a0d83),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              );
                                            } else if (snapshot.hasError)
                                              return Text('${snapshot.error}',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.blue));
                                            return CircularProgressIndicator();
                                          }),
                                      SizedBox(
                                        height: 500,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    WillPopScope(
                      onWillPop: () => Future.sync(onWillPop),
                      child: Scaffold(
                        backgroundColor: Color(0xffebebff),
                        body: Container(
                          child: Column(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    height: 280,
                                    width: MediaQuery.of(context).size.width,
                                    child: Align(
                                      child: FutureBuilder<ForecastModel>(
                                        future:
                                            getForecast('43.7001', '-79.4163'),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            var fm_hour = new DateFormat.Hm();
                                            var fmDay = new DateFormat.MMMd();
                                            ForecastModel model = snapshot.data;
                                            return Container(
                                              color: Colors.transparent,
                                              width: 340,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              'Tomorrow',
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color(
                                                                      0xff3a2bab)),
                                                            ),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            weatherIcon(
                                                                '${model.list[12].weather[0].icon}',
                                                                Color(
                                                                    0xff2f1fab))
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            '${minMax(model.list, 8)[0]}°   ',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff2f1fab),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 25),
                                                          ),
                                                          Text(
                                                            '${minMax(model.list, 8)[1]}°',
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff7e7fbf),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 25),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 60,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          width: 180,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text('Wind',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff2f1fab),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              15)),
                                                                  Text(
                                                                      '${model.list[12].wind.speed.round()} km/h',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff7e7fbf),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              15))
                                                                ],
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      'Humidity',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff2f1fab),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              15)),
                                                                  Text(
                                                                      '${model.list[12].main.humidity}%',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff7e7fbf),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              15))
                                                                ],
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 25,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          width: 180,
                                                          child: Column(
                                                            children: <Widget>[
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      'Cloudiness',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff2f1fab),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              15)),
                                                                  Text(
                                                                      '${model.list[12].wind.speed.round()}%',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff7e7fbf),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              15))
                                                                ],
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                      'Pressure',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff2f1fab),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              15)),
                                                                  Text(
                                                                      '${model.list[12].main.pressure.round()} hPa',
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff7e7fbf),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontSize:
                                                                              15))
                                                                ],
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else if (snapshot.hasError)
                                            return Text('${snapshot.error}',
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.blue));
                                          return CircularProgressIndicator();
                                        },
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xffebebff),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(50),
                                              topLeft: Radius.circular(50),
                                            ))),
                                    Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 20,
                                        ),
                                        FutureBuilder<ForecastModel>(
                                          future: getForecast(
                                              '43.7001', '-79.4163'),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var fm_hour = new DateFormat.Hm();
                                              var fmDay = new DateFormat.MMMd();
                                              ForecastModel model =
                                                  snapshot.data;
                                              return ListView.separated(
                                                shrinkWrap: true,
                                                itemCount: 5,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                      width: 320,
                                                      height: 65,
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: <Widget>[
                                                              weatherIcon(
                                                                  '${model.list[12].weather[0].icon}',
                                                                  Color(
                                                                      0xff2f1fab)),
                                                              Text(
                                                                '${minMax(model.list, 8 * index)[0]}°   ',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff2f1fab),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              Text(
                                                                '${minMax(model.list, 8 * index)[1]}°',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff7e7fbf),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        20),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20)),
                                                        color:
                                                            Colors.transparent,
                                                      ));
                                                },
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Divider(
                                                    color: Colors.white,
                                                  );
                                                },
                                              );
                                            } else if (snapshot.hasError)
                                              return Text('${snapshot.error}',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.blue));
                                            return CircularProgressIndicator();
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ));
  }

  bool onWillPop() {
    pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    return false;
  }

  void pageChanged(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  Image weatherIcon(String weatherId, Color colorChoice) {
    Image image = Image.asset(
      'assets/icons/sun.png',
      scale: 15,
      color: colorChoice,
    );
    if (weatherId == '01d') {
      image = Image.asset(
        'assets/icons/sun.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '02d') {
      image = Image.asset(
        'assets/icons/cloudy.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '03d') {
      image = Image.asset(
        'assets/icons/cloudy.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '04d') {
      image = Image.asset(
        'assets/icons/cloudy.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '09d') {
      image = Image.asset(
        'assets/icons/rain.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '10d') {
      image = Image.asset(
        'assets/icons/rain.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '11d') {
      image = Image.asset(
        'assets/icons/lightning.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '13d') {
      image = Image.asset(
        'assets/icons/snow.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '50d') {
      image = Image.asset(
        'assets/icons/mist.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '01n') {
      image = Image.asset(
        'assets/icons/moon.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '02n') {
      image = Image.asset(
        'assets/icons/cloudy.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '03n') {
      image = Image.asset(
        'assets/icons/cloudy.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '04n') {
      image = Image.asset(
        'assets/icons/cloudy.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '09n') {
      image = Image.asset(
        'assets/icons/rain.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '10n') {
      image = Image.asset(
        'assets/icons/rain.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '11n') {
      image = Image.asset(
        'assets/icons/lightning.png',
        scale: 15,
        color: colorChoice,
      );
    } else if (weatherId == '13n') {
      image = Image.asset(
        'assets/icons/snow.png',
        scale: 15,
        color: colorChoice,
      );
    } else {
      image = Image.asset(
        'assets/icons/mist.png',
        scale: 15,
        color: colorChoice,
      );
    }
    return image;
  }

  List<int> minMax(List<ForecastList> list, int startingIndex) {
    int max = list[startingIndex].main.temp.round();
    int min = 5000;
    for (int i = 1 + startingIndex; i < 8 + startingIndex; i++) {
      if (max < list[i].main.temp.round()) {
        max = list[i].main.temp.round();
      } else if (min > list[i].main.temp.round()) {
        min = list[i].main.temp.round();
      }
    }
    return [max, min];
  }
}

class CustomElevation extends StatelessWidget {
  final Widget child;

  CustomElevation({@required this.child}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.deepPurple[500].withOpacity(0),
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: this.child,
    );
  }
}
