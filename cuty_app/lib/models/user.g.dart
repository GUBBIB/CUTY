// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  school: School.fromJson(json['school'] as Map<String, dynamic>),
  college: College.fromJson(json['college'] as Map<String, dynamic>),
  department: Department.fromJson(json['department'] as Map<String, dynamic>),
  country: Country.fromJson(json['country'] as Map<String, dynamic>),
  isNationalityHidden: json['isNationalityHidden'] as bool? ?? false,
  isGenderHidden: json['isGenderHidden'] as bool? ?? false,
  isSchoolHidden: json['isSchoolHidden'] as bool? ?? false,
  isNicknameHidden: json['isNicknameHidden'] as bool? ?? false,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'school': instance.school.toJson(),
  'college': instance.college.toJson(),
  'department': instance.department.toJson(),
  'country': instance.country.toJson(),
  'isNationalityHidden': instance.isNationalityHidden,
  'isGenderHidden': instance.isGenderHidden,
  'isSchoolHidden': instance.isSchoolHidden,
  'isNicknameHidden': instance.isNicknameHidden,
};

School _$SchoolFromJson(Map<String, dynamic> json) =>
    School(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$SchoolToJson(School instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

College _$CollegeFromJson(Map<String, dynamic> json) =>
    College(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$CollegeToJson(College instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

Department _$DepartmentFromJson(Map<String, dynamic> json) =>
    Department(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

Country _$CountryFromJson(Map<String, dynamic> json) =>
    Country(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};
