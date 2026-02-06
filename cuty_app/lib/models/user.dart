import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true)
class User {
  final int id;
  final String name;
  final String email;
  final School school;
  final College college;
  final Department department;
  final Country country;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.school,
    required this.college,
    required this.department,
    required this.country,
    this.isNationalityHidden = false,
    this.isGenderHidden = false,
    this.isSchoolHidden = false,
    this.isNicknameHidden = false,
  });

  final bool isNationalityHidden;
  final bool isGenderHidden;
  final bool isSchoolHidden;
  final bool isNicknameHidden;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  // --- Compatibility Layer for Legacy UI (MyPageScreen) ---
  factory User.dummy() {
    return User(
      id: 0,
      name: 'User Name',
      email: 'test@university.ac.kr',
      school: School(id: 0, name: 'University Name'),
      college: College.empty(),
      department: Department.empty(),
      country: Country.empty(),
      isNationalityHidden: false,
      isGenderHidden: false,
      isSchoolHidden: false,
      isNicknameHidden: false,
    );
  }

  User copyWith({
    bool? isNationalityHidden,
    bool? isGenderHidden,
    bool? isSchoolHidden,
    bool? isNicknameHidden,
  }) {
    return User(
      id: id,
      name: name,
      email: email,
      school: school,
      college: college,
      department: department,
      country: country,
      isNationalityHidden: isNationalityHidden ?? this.isNationalityHidden,
      isGenderHidden: isGenderHidden ?? this.isGenderHidden,
      isSchoolHidden: isSchoolHidden ?? this.isSchoolHidden,
      isNicknameHidden: isNicknameHidden ?? this.isNicknameHidden,
    );
  }

  // Getters to match old UserModel fields
  String get university => school.name;
  String get major => department.name; // Added compatibility
  String get visaType => '비자 정보 없음'; // Placeholder: API doesn't provide this yet
  int get points => 0;
  String get visaExpiry => '-';
  String get workPermitDate => '- ~ -';
  bool get isWorkPermitApproved => false;
}

@JsonSerializable()
class School {
  final int id;
  final String name;

  School({required this.id, required this.name});

  factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);
  Map<String, dynamic> toJson() => _$SchoolToJson(this);

  factory School.empty() {
    return School(id: 0, name: '');
  }
}

@JsonSerializable()
class College {
  final int id;
  final String name;

  College({required this.id, required this.name});

  factory College.fromJson(Map<String, dynamic> json) => _$CollegeFromJson(json);
  Map<String, dynamic> toJson() => _$CollegeToJson(this);

  factory College.empty() {
    return College(id: 0, name: '');
  }
}

@JsonSerializable()
class Department {
  final int id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) => _$DepartmentFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentToJson(this);

  factory Department.empty() {
    return Department(id: 0, name: '');
  }
}

@JsonSerializable()
class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);
  Map<String, dynamic> toJson() => _$CountryToJson(this);

  factory Country.empty() {
    return Country(id: 0, name: '');
  }
}
