import 'package:equatable/equatable.dart';

class ServiceCategory extends Equatable {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String iconUrl;
  final String? parentId;
  final List<ServiceCategory> subcategories;
  final bool isActive;
  final int order;
  final Map<String, dynamic> metadata;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.iconUrl,
    this.parentId,
    this.subcategories = const [],
    this.isActive = true,
    this.order = 0,
    this.metadata = const {},
  });

  bool get hasSubcategories => subcategories.isNotEmpty;
  bool get isRootCategory => parentId == null;

  ServiceCategory copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    String? iconUrl,
    String? parentId,
    List<ServiceCategory>? subcategories,
    bool? isActive,
    int? order,
    Map<String, dynamic>? metadata,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      iconUrl: iconUrl ?? this.iconUrl,
      parentId: parentId ?? this.parentId,
      subcategories: subcategories ?? this.subcategories,
      isActive: isActive ?? this.isActive,
      order: order ?? this.order,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nameAr,
        description,
        descriptionAr,
        iconUrl,
        parentId,
        subcategories,
        isActive,
        order,
        metadata,
      ];
}

class Service extends Equatable {
  final String id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final String categoryId;
  final double basePrice;
  final String currency;
  final String unit; // per hour, per project, etc.
  final List<String> tags;
  final bool isActive;
  final Map<String, dynamic> metadata;

  const Service({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.categoryId,
    required this.basePrice,
    this.currency = 'SAR',
    required this.unit,
    this.tags = const [],
    this.isActive = true,
    this.metadata = const {},
  });

  Service copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    String? categoryId,
    double? basePrice,
    String? currency,
    String? unit,
    List<String>? tags,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      categoryId: categoryId ?? this.categoryId,
      basePrice: basePrice ?? this.basePrice,
      currency: currency ?? this.currency,
      unit: unit ?? this.unit,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        nameAr,
        description,
        descriptionAr,
        categoryId,
        basePrice,
        currency,
        unit,
        tags,
        isActive,
        metadata,
      ];
}
