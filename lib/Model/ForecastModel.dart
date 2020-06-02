import 'package:weather/Model/Model.dart';
class Main {
  final double temp;
  final double feels_like;
  final double temp_min;
  final double temp_max;
  final double pressure;
  final int humidity;
  final double grnd_level;
  final double sea_level;

  Main(
      {this.grnd_level,
        this.sea_level,
        this.temp,
        this.feels_like,
        this.temp_min,
        this.temp_max,
        this.pressure,
        this.humidity});

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
        temp: double.parse(json['temp'].toString()),
        temp_min: double.parse(json['temp_min'].toString()),
        temp_max: double.parse(json['temp_max'].toString()),
        sea_level:
        json['sea_level'] == null ? 0.0 : double.parse(json['sea_level'].toString()),
        grnd_level:
        json['grnd_level'] == null ? 0.0 : double.parse(json['grnd_level'].toString()),
        pressure: double.parse(json['pressure'].toString()),
        humidity: json['humidity']);
  }
}

class Weather
{
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({this.id, this.main, this.description, this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        id: json['id'],
        main: json['main'],
        description: json['description'],
        icon: json['icon']);
  }
}

class Clouds
{
  final int all;

  Clouds({this.all});
  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(all: json['all']);
  }
}

class Wind
{
  final double speed;
  final double deg;

  Wind({this.speed, this.deg});
  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
        speed: double.parse(json['speed'].toString()), deg: double.parse(json['deg'].toString()));
  }
}

class Sys
{
  final String pod;

  Sys({this.pod});
  factory Sys.fromJson(Map<String, dynamic> json) {
    return Sys(pod: json['pod']);
  }
}

class Rain
{
  final double threeH;

  Rain({this.threeH});
  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(
        threeH: double.parse(json['3h'].toString())
    );
  }
}

class ForecastList
{
  final int dt;
  final Main main;
  final List<Weather> weather;
  final Clouds clouds;
  final Wind wind;
  final Sys sys;
  final String dt_txt;

  ForecastList({this.dt, this.main, this.weather, this.clouds, this.wind, this.sys, this.dt_txt});

  factory ForecastList.fromJson(Map<String, dynamic> json) {
    return ForecastList(
        weather: (json['weather'] as List)
            .map((item) => Weather.fromJson(item))
            .toList(),
        main: Main.fromJson(json['main']),
        clouds: Clouds.fromJson(json['clouds']),
        wind: Wind.fromJson(json['wind']),
        dt: json['dt'],
        sys: Sys.fromJson(json['sys']),
        dt_txt: json['dt_txt'],
    );
  }
}

class Coord
{
  final double lat;
  final double lon;

  Coord({this.lat, this.lon});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
        lon: json['lon'], lat:json['lat']);
  }
}

class City
{
  final int id;
  final String name;
  final Coord coord;
  final String country;
  final int timezone;
  final int sunrise;
  final int sunset;

  City({this.id, this.name, this.coord, this.country, this.timezone, this.sunrise, this.sunset});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      coord: Coord.fromJson(json['coord']),
      country: json['country'],
      timezone: json['timezone'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}

class ForecastModel
{
  final String cod;
  final int message;
  final int cnt;
  final List<ForecastList> list;
  final City city;

  ForecastModel({this.cod, this.message, this.cnt, this.list, this.city});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      cod: json['cod'],
      message: json['message'],
      cnt: json['cnt'],
      city: City.fromJson(json['city']),
      list: (json['list'] as List)
          .map((item) => ForecastList.fromJson(item))
          .toList(),
    );
  }
}