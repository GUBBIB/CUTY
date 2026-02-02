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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      school: json['school'] != null
          ? School.fromJson(json['school'])
          : School.empty(),
      college: json['college'] != null
          ? College.fromJson(json['college'])
          : College.empty(),
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : Department.empty(),
      country: json['country'] != null
          ? Country.fromJson(json['country'])
          : Country.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'school': school.toJson(),
      'college': college.toJson(),
      'department': department.toJson(),
      'country': country.toJson(),
    };
  }

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
    );
  }

  // Getters to match old UserModel fields
  String get university => school.name;
  String get major => department.name; // Added compatibility
  String get visaType => '비자 정보 없음'; // Placeholder: API doesn't provide this yet
  int get points => 0; // Placeholder: Points might come from separate API
  String get visaExpiry => '-';
  String get workPermitDate => '- ~ -';
  bool get isWorkPermitApproved => false;
}

class School {
  final int id;
  final String name;

  School({required this.id, required this.name});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  factory School.empty() {
    return School(id: 0, name: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class College {
  final int id;
  final String name;

  College({required this.id, required this.name});

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  factory College.empty() {
    return College(id: 0, name: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Department {
  final int id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  factory Department.empty() {
    return Department(id: 0, name: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  factory Country.empty() {
    return Country(id: 0, name: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
