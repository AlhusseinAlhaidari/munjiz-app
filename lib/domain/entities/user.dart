import 'package:equatable/equatable.dart';

enum UserType { client, serviceProvider }

enum UserStatus { active, inactive, suspended, pending }

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final UserType userType;
  final UserStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserProfile? profile;
  final List<String> deviceTokens;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final Map<String, dynamic> preferences;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    required this.userType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.profile,
    this.deviceTokens = const [],
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.preferences = const {},
  });

  String get fullName => '$firstName $lastName';

  bool get isActive => status == UserStatus.active;

  bool get isVerified => isEmailVerified && isPhoneVerified;

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    UserType? userType,
    UserStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserProfile? profile,
    List<String>? deviceTokens,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      userType: userType ?? this.userType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profile: profile ?? this.profile,
      deviceTokens: deviceTokens ?? this.deviceTokens,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        firstName,
        lastName,
        phoneNumber,
        profileImageUrl,
        userType,
        status,
        createdAt,
        updatedAt,
        profile,
        deviceTokens,
        isEmailVerified,
        isPhoneVerified,
        preferences,
      ];
}

class UserProfile extends Equatable {
  final String? bio;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? city;
  final String? country;
  final DateTime? dateOfBirth;
  final String? gender;
  final List<String> languages;
  final Map<String, dynamic> socialLinks;
  final ClientProfile? clientProfile;
  final ServiceProviderProfile? serviceProviderProfile;

  const UserProfile({
    this.bio,
    this.address,
    this.latitude,
    this.longitude,
    this.city,
    this.country,
    this.dateOfBirth,
    this.gender,
    this.languages = const [],
    this.socialLinks = const {},
    this.clientProfile,
    this.serviceProviderProfile,
  });

  UserProfile copyWith({
    String? bio,
    String? address,
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    DateTime? dateOfBirth,
    String? gender,
    List<String>? languages,
    Map<String, dynamic>? socialLinks,
    ClientProfile? clientProfile,
    ServiceProviderProfile? serviceProviderProfile,
  }) {
    return UserProfile(
      bio: bio ?? this.bio,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      languages: languages ?? this.languages,
      socialLinks: socialLinks ?? this.socialLinks,
      clientProfile: clientProfile ?? this.clientProfile,
      serviceProviderProfile: serviceProviderProfile ?? this.serviceProviderProfile,
    );
  }

  @override
  List<Object?> get props => [
        bio,
        address,
        latitude,
        longitude,
        city,
        country,
        dateOfBirth,
        gender,
        languages,
        socialLinks,
        clientProfile,
        serviceProviderProfile,
      ];
}

class ClientProfile extends Equatable {
  final int totalProjects;
  final double totalSpent;
  final double averageRating;
  final int completedProjects;
  final List<String> preferredCategories;
  final Map<String, dynamic> paymentMethods;

  const ClientProfile({
    this.totalProjects = 0,
    this.totalSpent = 0.0,
    this.averageRating = 0.0,
    this.completedProjects = 0,
    this.preferredCategories = const [],
    this.paymentMethods = const {},
  });

  ClientProfile copyWith({
    int? totalProjects,
    double? totalSpent,
    double? averageRating,
    int? completedProjects,
    List<String>? preferredCategories,
    Map<String, dynamic>? paymentMethods,
  }) {
    return ClientProfile(
      totalProjects: totalProjects ?? this.totalProjects,
      totalSpent: totalSpent ?? this.totalSpent,
      averageRating: averageRating ?? this.averageRating,
      completedProjects: completedProjects ?? this.completedProjects,
      preferredCategories: preferredCategories ?? this.preferredCategories,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }

  @override
  List<Object?> get props => [
        totalProjects,
        totalSpent,
        averageRating,
        completedProjects,
        preferredCategories,
        paymentMethods,
      ];
}

class ServiceProviderProfile extends Equatable {
  final List<String> skills;
  final List<String> categories;
  final double hourlyRate;
  final String? portfolio;
  final List<String> certifications;
  final int yearsOfExperience;
  final double averageRating;
  final int totalReviews;
  final int completedJobs;
  final double totalEarnings;
  final bool isAvailable;
  final String? availability;
  final double responseTime; // in hours
  final List<String> workingAreas;

  const ServiceProviderProfile({
    this.skills = const [],
    this.categories = const [],
    this.hourlyRate = 0.0,
    this.portfolio,
    this.certifications = const [],
    this.yearsOfExperience = 0,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.completedJobs = 0,
    this.totalEarnings = 0.0,
    this.isAvailable = true,
    this.availability,
    this.responseTime = 24.0,
    this.workingAreas = const [],
  });

  ServiceProviderProfile copyWith({
    List<String>? skills,
    List<String>? categories,
    double? hourlyRate,
    String? portfolio,
    List<String>? certifications,
    int? yearsOfExperience,
    double? averageRating,
    int? totalReviews,
    int? completedJobs,
    double? totalEarnings,
    bool? isAvailable,
    String? availability,
    double? responseTime,
    List<String>? workingAreas,
  }) {
    return ServiceProviderProfile(
      skills: skills ?? this.skills,
      categories: categories ?? this.categories,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      portfolio: portfolio ?? this.portfolio,
      certifications: certifications ?? this.certifications,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      completedJobs: completedJobs ?? this.completedJobs,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      isAvailable: isAvailable ?? this.isAvailable,
      availability: availability ?? this.availability,
      responseTime: responseTime ?? this.responseTime,
      workingAreas: workingAreas ?? this.workingAreas,
    );
  }

  @override
  List<Object?> get props => [
        skills,
        categories,
        hourlyRate,
        portfolio,
        certifications,
        yearsOfExperience,
        averageRating,
        totalReviews,
        completedJobs,
        totalEarnings,
        isAvailable,
        availability,
        responseTime,
        workingAreas,
      ];
}
