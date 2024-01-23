// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BuddyModel {
  String name;
  String number;
  BuddyModel({
    required this.name,
    required this.number,
  });

  BuddyModel copyWith({
    String? name,
    String? number,
  }) {
    return BuddyModel(
      name: name ?? this.name,
      number: number ?? this.number,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'number': number,
    };
  }

  factory BuddyModel.fromMap(Map<String, dynamic> map) {
    return BuddyModel(
      name: map['name'] as String,
      number: map['number'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BuddyModel.fromJson(String source) =>
      BuddyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BuddyModel(name: $name, number: $number)';

  @override
  bool operator ==(covariant BuddyModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.number == number;
  }

  @override
  int get hashCode => name.hashCode ^ number.hashCode;
}
