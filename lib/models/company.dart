import 'package:flutter/material.dart';

class Company {
  String? id;
  String? name;
  Icon icon = const Icon(Icons.apartment);


  Company({this.id, this.name});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
      };
}
