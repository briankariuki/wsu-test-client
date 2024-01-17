// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserPage _$UserPageFromJson(Map<String, dynamic> json) => UserPage()
  ..docs = (json['docs'] as List<dynamic>)
      .map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList()
  ..totalDocs = json['totalDocs'] as int
  ..limit = json['limit'] as int
  ..hasPrevPage = json['hasPrevPage'] as bool
  ..hasNextPage = json['hasNextPage'] as bool
  ..page = json['page'] as int?
  ..totalPages = json['totalPages'] as int?
  ..offset = json['offset'] as int?
  ..prevPage = json['prevPage'] as int?
  ..nextPage = json['nextPage'] as int?
  ..pagingCounter = json['pagingCounter'] as int?
  ..users = (json['users'] as List<dynamic>?)
      ?.map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$UserPageToJson(UserPage instance) => <String, dynamic>{
      'docs': instance.docs,
      'totalDocs': instance.totalDocs,
      'limit': instance.limit,
      'hasPrevPage': instance.hasPrevPage,
      'hasNextPage': instance.hasNextPage,
      'page': instance.page,
      'totalPages': instance.totalPages,
      'offset': instance.offset,
      'prevPage': instance.prevPage,
      'nextPage': instance.nextPage,
      'pagingCounter': instance.pagingCounter,
      'users': instance.users,
    };
