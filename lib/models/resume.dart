import 'package:uuid/uuid.dart';

class Resume {
  final String id;
  final String title;
  final PersonalInfo personalInfo;
  final List<Experience> experience;
  final List<Education> education;
  final List<Skill> skills;
  final List<Language> languages;
  final String? summary;

  Resume({
    String? id,
    required this.title,
    required this.personalInfo,
    this.experience = const [],
    this.education = const [],
    this.skills = const [],
    this.languages = const [],
    this.summary,
  }) : id = id ?? const Uuid().v4();

  Resume copyWith({
    String? title,
    PersonalInfo? personalInfo,
    List<Experience>? experience,
    List<Education>? education,
    List<Skill>? skills,
    List<Language>? languages,
    String? summary,
  }) {
    return Resume(
      id: id,
      title: title ?? this.title,
      personalInfo: personalInfo ?? this.personalInfo,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      summary: summary ?? this.summary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'personalInfo': personalInfo.toMap(),
      'experience': experience.map((e) => e.toMap()).toList(),
      'education': education.map((e) => e.toMap()).toList(),
      'skills': skills.map((e) => e.toMap()).toList(),
      'languages': languages.map((e) => e.toMap()).toList(),
      'summary': summary,
    };
  }

  factory Resume.fromMap(Map<String, dynamic> map) {
    return Resume(
      id: map['id'],
      title: map['title'],
      personalInfo: PersonalInfo.fromMap(map['personalInfo']),
      experience: (map['experience'] as List).map((e) => Experience.fromMap(e)).toList(),
      education: (map['education'] as List).map((e) => Education.fromMap(e)).toList(),
      skills: (map['skills'] as List).map((e) => Skill.fromMap(e)).toList(),
      languages: (map['languages'] as List).map((e) => Language.fromMap(e)).toList(),
      summary: map['summary'],
    );
  }
}

class PersonalInfo {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? address;
  final String? website;
  final String? photoPath;

  PersonalInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.address,
    this.website,
    this.photoPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'website': website,
      'photoPath': photoPath,
    };
  }

  factory PersonalInfo.fromMap(Map<String, dynamic> map) {
    return PersonalInfo(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      website: map['website'],
      photoPath: map['photoPath'],
    );
  }
}

class Experience {
  final String company;
  final String position;
  final String startDate;
  final String? endDate;
  final bool isCurrent;
  final String? description;

  Experience({
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'company': company,
      'position': position,
      'startDate': startDate,
      'endDate': endDate,
      'isCurrent': isCurrent,
      'description': description,
    };
  }

  factory Experience.fromMap(Map<String, dynamic> map) {
    return Experience(
      company: map['company'],
      position: map['position'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      isCurrent: map['isCurrent'] ?? false,
      description: map['description'],
    );
  }
}

class Education {
  final String institution;
  final String degree;
  final String startDate;
  final String? endDate;
  final String? description;

  Education({
    required this.institution,
    required this.degree,
    required this.startDate,
    this.endDate,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'institution': institution,
      'degree': degree,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
    };
  }

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      institution: map['institution'],
      degree: map['degree'],
      startDate: map['startDate'],
      endDate: map['endDate'],
      description: map['description'],
    );
  }
}

class Skill {
  final String name;
  final double level; // 0.0 to 1.0

  Skill({required this.name, this.level = 0.5});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'level': level,
    };
  }

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      name: map['name'],
      level: map['level'],
    );
  }
}

class Language {
  final String name;
  final String level; // e.g., Native, B2, Fluent

  Language({required this.name, required this.level});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'level': level,
    };
  }

  factory Language.fromMap(Map<String, dynamic> map) {
    return Language(
      name: map['name'],
      level: map['level'],
    );
  }
}
