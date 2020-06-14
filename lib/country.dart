import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Currency {
  final String code;
  final String name;
  final String symbol;

  Currency({this.code, this.name, this.symbol});

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'],
      name: json['name'],
      symbol: json['symbol'],
    );
  }
}

class Country {
  final String name;
  final String flag;
  final String alpha2Code;
  final List<dynamic> currencies;

  Country({this.name, this.flag, this.alpha2Code, this.currencies});

  factory Country.fromJson(Map<String, dynamic> json) {
    print(json['currencies']);
    List<dynamic> cur;
    if (json['currencies'] != null){
      cur = json['currencies'].map((currency) => new Currency.fromJson(currency)).toList();
    }
    return Country(
      name: json['name'],
      flag: json['flag'],
      alpha2Code: json['alpha2Code'],
      currencies: cur,
    );
  }
}

class CountriesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Country>>(
      future: _fetchCountries(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Country> data = snapshot.data;
          return _countriesListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Country>> _fetchCountries() async {

    final countriesListAPIUrl = 'https://restcountries.eu/rest/v2/all';
    final response = await http.get(countriesListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((country) => new Country.fromJson(country)).toList();
    } else {
      throw Exception('Failed to load countries from API');
    }
  }

  ListView _countriesListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].name, data[index].alpha2Code, data[index].flag, data[index].currencies);
        });
  }

  ListTile _tile(String title, String subtitle, String flag, List currencies) => ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text("CUR => " + currencies.map((e) => (e.name != null ? e.name : '') + (e.symbol != null ? "(" + e.symbol + ")" : '')).join(', ')),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.network(flag),
        ),
        trailing: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Text(currencies.first.symbol != null ? currencies.first.symbol : '', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[900]),),
        ),
      );
}