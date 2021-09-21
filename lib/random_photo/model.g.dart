// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RandomPhoto _$RandomPhotoFromJson(Map<String, dynamic> json) {
  // проверка что данный ключ- обязателен
  $checkKeys(json, requiredKeys: const ['alt_description'],);
  return RandomPhoto(
    // преобразование URL в список
    urls: (json['urls'] as List<dynamic>)
        .map((e) => Url.fromJson(e as Map<String, dynamic>))
        .toList(),
  )
    // преобразование типов
    ..id = json['id'] as String
    ..createdAt = DateTime.parse(json['created_at'] as String)
    ..alternativeDescription = json['alt_description'] as String;
}

Map<String, dynamic> _$RandomPhotoToJson(RandomPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt!.toIso8601String(),
      'alt_description': instance.alternativeDescription,
      'urls': instance.urls,
    };

Url _$UrlFromJson(Map<String, dynamic> json) => Url(
      thumb: json['thumb'] as String,
      full: json['full'] as String,
    );

Map<String, dynamic> _$UrlToJson(Url instance) => <String, dynamic>{
      'thumb': instance.thumb,
      'full': instance.full,
    };
