import 'dart:convert';

class AllCharactersModel {
  final Info? info;
  final List<Result>? results;

  AllCharactersModel({this.info, this.results});

  factory AllCharactersModel.fromRawJson(String str) =>
      AllCharactersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllCharactersModel.fromJson(Map<String, dynamic> json) =>
      AllCharactersModel(
        info: json["info"] == null ? null : Info.fromJson(json["info"]),
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "info": info?.toJson(),
    "results": results == null
        ? []
        : List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Info {
  final int? count;
  final int? pages;
  final String? next;
  final String? prev;

  Info({this.count, this.pages, this.next, this.prev});

  factory Info.fromRawJson(String str) => Info.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    count: json["count"],
    pages: json["pages"],
    next: json["next"],
    prev: json["prev"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "pages": pages,
    "next": next,
    "prev": prev,
  };
}

class Result {
  final int? id;
  final String? name;
  final Status? status;
  final String? species;
  final String? type;
  final Gender? gender;
  final Location? origin;
  final Location? location;
  final String? image;
  final List<String>? episode;
  final String? url;
  final DateTime? created;

  Result({
    this.id,
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.origin,
    this.location,
    this.image,
    this.episode,
    this.url,
    this.created,
  });

  factory Result.fromRawJson(String str) => Result.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    status: statusValues.map[json["status"]]!,
    species: json["species"],
    type: json["type"],
    gender: genderValues.map[json["gender"]]!,
    origin: json["origin"] == null ? null : Location.fromJson(json["origin"]),
    location: json["location"] == null
        ? null
        : Location.fromJson(json["location"]),
    image: json["image"],
    episode: json["episode"] == null
        ? []
        : List<String>.from(json["episode"]!.map((x) => x)),
    url: json["url"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": statusValues.reverse[status],
    "species": species,
    "type": type,
    "gender": genderValues.reverse[gender],
    "origin": origin?.toJson(),
    "location": location?.toJson(),
    "image": image,
    "episode": episode == null
        ? []
        : List<dynamic>.from(episode!.map((x) => x)),
    "url": url,
    "created": created?.toIso8601String(),
  };
}

enum Gender { female, male, genderless, unknown }

final genderValues = EnumValues({
  "Female": Gender.female,
  "Male": Gender.male,
  "Genderless": Gender.genderless,
  "unknown": Gender.unknown,
});

class Location {
  final String? name;
  final String? url;

  Location({this.name, this.url});

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(name: json["name"], url: json["url"]);

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}

enum Status { alive, dead, unknown }

final statusValues = EnumValues({
  "Alive": Status.alive,
  "Dead": Status.dead,
  "unknown": Status.unknown,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
