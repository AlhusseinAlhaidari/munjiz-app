import 'package:equatable/equatable.dart';

enum ProjectStatus {
  draft,
  published,
  inProgress,
  completed,
  cancelled,
  disputed
}

enum ProjectPriority { low, medium, high, urgent }

enum ProjectType { oneTime, recurring, ongoing }

class Project extends Equatable {
  final String id;
  final String title;
  final String description;
  final String clientId;
  final String categoryId;
  final ProjectStatus status;
  final ProjectPriority priority;
  final ProjectType type;
  final double budget;
  final String currency;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final List<String> attachments;
  final ProjectLocation? location;
  final List<ProjectTask> tasks;
  final List<ProjectBid> bids;
  final List<String> assignedProviders;
  final ProjectPayment? payment;
  final List<ProjectMilestone> milestones;
  final Map<String, dynamic> metadata;

  factory Project.fromApiJson(Map<String, dynamic> json) {
    return Project(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      clientId: json["clientId"],
      categoryId: json["categoryId"],
      status: ProjectStatus.values.firstWhere((e) => e.toString() == 'ProjectStatus.' + json["status"]),
      priority: ProjectPriority.values.firstWhere((e) => e.toString() == 'ProjectPriority.' + json["priority"]),
      type: ProjectType.values.firstWhere((e) => e.toString() == 'ProjectType.' + json["type"]),
      budget: (json["budget"] as num).toDouble(),
      currency: json["currency"] ?? 'SAR',
      startDate: json["startDate"] != null ? DateTime.parse(json["startDate"]) : null,
      endDate: json["endDate"] != null ? DateTime.parse(json["endDate"]) : null,
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      tags: List<String>.from(json["tags"] ?? []),
      attachments: List<String>.from(json["attachments"] ?? []),
      location: json["location"] != null ? ProjectLocation.fromApiJson(json["location"]) : null,
      tasks: (json["tasks"] as List<dynamic>?)?.map((e) => ProjectTask.fromApiJson(e)).toList() ?? [],
      bids: (json["bids"] as List<dynamic>?)?.map((e) => ProjectBid.fromApiJson(e)).toList() ?? [],
      assignedProviders: List<String>.from(json["assignedProviders"] ?? []),
      payment: json["payment"] != null ? ProjectPayment.fromApiJson(json["payment"]) : null,
      milestones: (json["milestones"] as List<dynamic>?)?.map((e) => ProjectMilestone.fromApiJson(e)).toList() ?? [],
      metadata: Map<String, dynamic>.from(json["metadata"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "clientId": clientId,
      "categoryId": categoryId,
      "status": status.toString().split('.').last,
      "priority": priority.toString().split('.').last,
      "type": type.toString().split('.').last,
      "budget": budget,
      "currency": currency,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "tags": tags,
      "attachments": attachments,
      "location": location?.toJson(),
      "tasks": tasks.map((e) => e.toJson()).toList(),
      "bids": bids.map((e) => e.toJson()).toList(),
      "assignedProviders": assignedProviders,
      "payment": payment?.toJson(),
      "milestones": milestones.map((e) => e.toJson()).toList(),
      "metadata": metadata,
    };
  }

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.clientId,
    required this.categoryId,
    required this.status,
    required this.priority,
    required this.type,
    required this.budget,
    this.currency = 'SAR',
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
    this.attachments = const [],
    this.location,
    this.tasks = const [],
    this.bids = const [],
    this.assignedProviders = const [],
    this.payment,
    this.milestones = const [],
    this.metadata = const {},
  });

  bool get isActive => status == ProjectStatus.inProgress;
  bool get isCompleted => status == ProjectStatus.completed;
  bool get canBid => status == ProjectStatus.published;
  bool get hasLocation => location != null;
  
  double get completionPercentage {
    if (tasks.isEmpty) return 0.0;
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    return (completedTasks / tasks.length) * 100;
  }

  Project copyWith({
    String? id,
    String? title,
    String? description,
    String? clientId,
    String? categoryId,
    ProjectStatus? status,
    ProjectPriority? priority,
    ProjectType? type,
    double? budget,
    String? currency,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    List<String>? attachments,
    ProjectLocation? location,
    List<ProjectTask>? tasks,
    List<ProjectBid>? bids,
    List<String>? assignedProviders,
    ProjectPayment? payment,
    List<ProjectMilestone>? milestones,
    Map<String, dynamic>? metadata,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      clientId: clientId ?? this.clientId,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      type: type ?? this.type,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      attachments: attachments ?? this.attachments,
      location: location ?? this.location,
      tasks: tasks ?? this.tasks,
      bids: bids ?? this.bids,
      assignedProviders: assignedProviders ?? this.assignedProviders,
      payment: payment ?? this.payment,
      milestones: milestones ?? this.milestones,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        clientId,
        categoryId,
        status,
        priority,
        type,
        budget,
        currency,
        startDate,
        endDate,
        createdAt,
        updatedAt,
        tags,
        attachments,
        location,
        tasks,
        bids,
        assignedProviders,
        payment,
        milestones,
        metadata,
      ];
}

class ProjectLocation extends Equatable {
  final String address;
  final double latitude;
  final double longitude;
  final String city;
  final String country;
  final String? postalCode;
  final bool isRemote;

  factory ProjectLocation.fromApiJson(Map<String, dynamic> json) {
    return ProjectLocation(
      address: json["address"],
      latitude: (json["latitude"] as num).toDouble(),
      longitude: (json["longitude"] as num).toDouble(),
      city: json["city"],
      country: json["country"],
      postalCode: json["postalCode"],
      isRemote: json["isRemote"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "city": city,
      "country": country,
      "postalCode": postalCode,
      "isRemote": isRemote,
    };
  }

  const ProjectLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    this.postalCode,
    this.isRemote = false,
  });

  ProjectLocation copyWith({
    String? address,
    double? latitude,
    double? longitude,
    String? city,
    String? country,
    String? postalCode,
    bool? isRemote,
  }) {
    return ProjectLocation(
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      isRemote: isRemote ?? this.isRemote,
    );
  }

  @override
  List<Object?> get props => [
        address,
        latitude,
        longitude,
        city,
        country,
        postalCode,
        isRemote,
      ];
}

enum TaskStatus { pending, inProgress, completed, cancelled }

class ProjectTask extends Equatable {
  final String id;
  final String title;
  final String? description;
  final TaskStatus status;
  final DateTime? dueDate;
  final String? assignedTo;
  final int order;
  final List<String> dependencies;
  final Map<String, dynamic> metadata;

  factory ProjectTask.fromApiJson(Map<String, dynamic> json) {
    return ProjectTask(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      status: TaskStatus.values.firstWhere((e) => e.toString() == 'TaskStatus.' + json["status"]),
      dueDate: json["dueDate"] != null ? DateTime.parse(json["dueDate"]) : null,
      assignedTo: json["assignedTo"],
      order: json["order"],
      dependencies: List<String>.from(json["dependencies"] ?? []),
      metadata: Map<String, dynamic>.from(json["metadata"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "status": status.toString().split(".").last,
      "dueDate": dueDate?.toIso8601String(),
      "assignedTo": assignedTo,
      "order": order,
      "dependencies": dependencies,
      "metadata": metadata,
    };
  }

  const ProjectTask({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.dueDate,
    this.assignedTo,
    required this.order,
    this.dependencies = const [],
    this.metadata = const {},
  });

  bool get isCompleted => status == TaskStatus.completed;
  bool get isOverdue => dueDate != null && 
      DateTime.now().isAfter(dueDate!) && 
      !isCompleted;

  ProjectTask copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? dueDate,
    String? assignedTo,
    int? order,
    List<String>? dependencies,
    Map<String, dynamic>? metadata,
  }) {
    return ProjectTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      assignedTo: assignedTo ?? this.assignedTo,
      order: order ?? this.order,
      dependencies: dependencies ?? this.dependencies,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        dueDate,
        assignedTo,
        order,
        dependencies,
        metadata,
      ];
}

enum BidStatus { pending, accepted, rejected, withdrawn }

class ProjectBid extends Equatable {
  final String id;
  final String projectId;
  final String providerId;
  final double amount;
  final String currency;
  final String proposal;
  final int estimatedDays;
  final BidStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  final List<String> attachments;
  final Map<String, dynamic> metadata;

  factory ProjectBid.fromApiJson(Map<String, dynamic> json) {
    return ProjectBid(
      id: json["id"],
      projectId: json["projectId"],
      providerId: json["providerId"],
      amount: (json["amount"] as num).toDouble(),
      currency: json["currency"] ?? 'SAR',
      proposal: json["proposal"],
      estimatedDays: json["estimatedDays"],
      status: BidStatus.values.firstWhere((e) => e.toString() == 'BidStatus.' + json["status"]),
      createdAt: DateTime.parse(json["createdAt"]),
      respondedAt: json["respondedAt"] != null ? DateTime.parse(json["respondedAt"]) : null,
      attachments: List<String>.from(json["attachments"] ?? []),
      metadata: Map<String, dynamic>.from(json["metadata"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "projectId": projectId,
      "providerId": providerId,
      "amount": amount,
      "currency": currency,
      "proposal": proposal,
      "estimatedDays": estimatedDays,
      "status": status.toString().split('.').last,
      "createdAt": createdAt.toIso8601String(),
      "respondedAt": respondedAt?.toIso8601String(),
      "attachments": attachments,
      "metadata": metadata,
    };
  }

  const ProjectBid({
    required this.id,
    required this.projectId,
    required this.providerId,
    required this.amount,
    this.currency = 'SAR',
    required this.proposal,
    required this.estimatedDays,
    required this.status,
    required this.createdAt,
    this.respondedAt,
    this.attachments = const [],
    this.metadata = const {},
  });

  bool get isPending => status == BidStatus.pending;
  bool get isAccepted => status == BidStatus.accepted;

  ProjectBid copyWith({
    String? id,
    String? projectId,
    String? providerId,
    double? amount,
    String? currency,
    String? proposal,
    int? estimatedDays,
    BidStatus? status,
    DateTime? createdAt,
    DateTime? respondedAt,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
  }) {
    return ProjectBid(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      providerId: providerId ?? this.providerId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      proposal: proposal ?? this.proposal,
      estimatedDays: estimatedDays ?? this.estimatedDays,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        providerId,
        amount,
        currency,
        proposal,
        estimatedDays,
        status,
        createdAt,
        respondedAt,
        attachments,
        metadata,
      ];
}

enum PaymentStatus { pending, inEscrow, released, refunded, disputed }

class ProjectPayment extends Equatable {
  final String id;
  final String projectId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String? paymentMethodId;
  final String? escrowId;
  final DateTime? paidAt;
  final DateTime? releasedAt;
  final Map<String, dynamic> metadata;

  factory ProjectPayment.fromApiJson(Map<String, dynamic> json) {
    return ProjectPayment(
      id: json["id"],
      projectId: json["projectId"],
      amount: (json["amount"] as num).toDouble(),
      currency: json["currency"] ?? 'SAR',
      status: PaymentStatus.values.firstWhere((e) => e.toString() == 'PaymentStatus.' + json["status"]),
      paymentMethodId: json["paymentMethodId"],
      escrowId: json["escrowId"],
      paidAt: json["paidAt"] != null ? DateTime.parse(json["paidAt"]) : null,
      releasedAt: json["releasedAt"] != null ? DateTime.parse(json["releasedAt"]) : null,
      metadata: Map<String, dynamic>.from(json["metadata"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "projectId": projectId,
      "amount": amount,
      "currency": currency,
      "status": status.toString().split('.').last,
      "paymentMethodId": paymentMethodId,
      "escrowId": escrowId,
      "paidAt": paidAt?.toIso8601String(),
      "releasedAt": releasedAt?.toIso8601String(),
      "metadata": metadata,
    };
  }

  const ProjectPayment({
    required this.id,
    required this.projectId,
    required this.amount,
    this.currency = 'SAR',
    required this.status,
    this.paymentMethodId,
    this.escrowId,
    this.paidAt,
    this.releasedAt,
    this.metadata = const {},
  });

  bool get isInEscrow => status == PaymentStatus.inEscrow;
  bool get isReleased => status == PaymentStatus.released;

  ProjectPayment copyWith({
    String? id,
    String? projectId,
    double? amount,
    String? currency,
    PaymentStatus? status,
    String? paymentMethodId,
    String? escrowId,
    DateTime? paidAt,
    DateTime? releasedAt,
    Map<String, dynamic>? metadata,
  }) {
    return ProjectPayment(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      escrowId: escrowId ?? this.escrowId,
      paidAt: paidAt ?? this.paidAt,
      releasedAt: releasedAt ?? this.releasedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        projectId,
        amount,
        currency,
        status,
        paymentMethodId,
        escrowId,
        paidAt,
        releasedAt,
        metadata,
      ];
}

enum MilestoneStatus { pending, inProgress, completed, approved, rejected }

class ProjectMilestone extends Equatable {
  final String id;
  final String title;
  final String? description;
  final double amount;
  final MilestoneStatus status;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final DateTime? approvedAt;
  final int order;
  final List<String> deliverables;
  final Map<String, dynamic> metadata;

  factory ProjectMilestone.fromApiJson(Map<String, dynamic> json) {
    return ProjectMilestone(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      amount: (json["amount"] as num).toDouble(),
      status: MilestoneStatus.values.firstWhere((e) => e.toString() == 'MilestoneStatus.' + json["status"]),
      dueDate: json["dueDate"] != null ? DateTime.parse(json["dueDate"]) : null,
      completedAt: json["completedAt"] != null ? DateTime.parse(json["completedAt"]) : null,
      approvedAt: json["approvedAt"] != null ? DateTime.parse(json["approvedAt"]) : null,
      order: json["order"],
      deliverables: List<String>.from(json["deliverables"] ?? []),
      metadata: Map<String, dynamic>.from(json["metadata"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "amount": amount,
      "status": status.toString().split('.').last,
      "dueDate": dueDate?.toIso8601String(),
      "completedAt": completedAt?.toIso8601String(),
      "approvedAt": approvedAt?.toIso8601String(),
      "order": order,
      "deliverables": deliverables,
      "metadata": metadata,
    };
  }

  const ProjectMilestone({
    required this.id,
    required this.title,
    this.description,
    required this.amount,
    required this.status,
    this.dueDate,
    this.completedAt,
    this.approvedAt,
    required this.order,
    this.deliverables = const [],
    this.metadata = const {},
  });

  bool get isCompleted => status == MilestoneStatus.completed;
  bool get isApproved => status == MilestoneStatus.approved;

  ProjectMilestone copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    MilestoneStatus? status,
    DateTime? dueDate,
    DateTime? completedAt,
    DateTime? approvedAt,
    int? order,
    List<String>? deliverables,
    Map<String, dynamic>? metadata,
  }) {
    return ProjectMilestone(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      order: order ?? this.order,
      deliverables: deliverables ?? this.deliverables,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        amount,
        status,
        dueDate,
        completedAt,
        approvedAt,
        order,
        deliverables,
        metadata,
      ];
}
