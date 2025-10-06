import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/service_category.dart';
import '../../../core/errors/failures.dart';

// Events
abstract class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

class ProjectsLoadRequested extends ProjectsEvent {
  final int page;
  final int limit;
  final String? categoryId;
  final ProjectStatus? status;
  final String? searchQuery;

  const ProjectsLoadRequested({
    this.page = 1,
    this.limit = 20,
    this.categoryId,
    this.status,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [page, limit, categoryId, status, searchQuery];
}

class ProjectCreateRequested extends ProjectsEvent {
  final String title;
  final String description;
  final String categoryId;
  final double budget;
  final ProjectPriority priority;
  final ProjectType type;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> tags;
  final ProjectLocation? location;
  final List<ProjectTask> tasks;

  const ProjectCreateRequested({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.budget,
    required this.priority,
    required this.type,
    this.startDate,
    this.endDate,
    this.tags = const [],
    this.location,
    this.tasks = const [],
  });

  @override
  List<Object?> get props => [
        title,
        description,
        categoryId,
        budget,
        priority,
        type,
        startDate,
        endDate,
        tags,
        location,
        tasks,
      ];
}

class ProjectUpdateRequested extends ProjectsEvent {
  final String projectId;
  final String? title;
  final String? description;
  final String? categoryId;
  final double? budget;
  final ProjectPriority? priority;
  final ProjectType? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? tags;
  final ProjectLocation? location;
  final List<ProjectTask>? tasks;

  const ProjectUpdateRequested({
    required this.projectId,
    this.title,
    this.description,
    this.categoryId,
    this.budget,
    this.priority,
    this.type,
    this.startDate,
    this.endDate,
    this.tags,
    this.location,
    this.tasks,
  });

  @override
  List<Object?> get props => [
        projectId,
        title,
        description,
        categoryId,
        budget,
        priority,
        type,
        startDate,
        endDate,
        tags,
        location,
        tasks,
      ];
}

class ProjectDeleteRequested extends ProjectsEvent {
  final String projectId;

  const ProjectDeleteRequested({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

class ProjectStatusUpdateRequested extends ProjectsEvent {
  final String projectId;
  final ProjectStatus status;

  const ProjectStatusUpdateRequested({
    required this.projectId,
    required this.status,
  });

  @override
  List<Object> get props => [projectId, status];
}

class ProjectBidSubmitted extends ProjectsEvent {
  final String projectId;
  final double amount;
  final String proposal;
  final int estimatedDays;
  final List<String> attachments;

  const ProjectBidSubmitted({
    required this.projectId,
    required this.amount,
    required this.proposal,
    required this.estimatedDays,
    this.attachments = const [],
  });

  @override
  List<Object> get props => [projectId, amount, proposal, estimatedDays, attachments];
}

class ProjectBidAccepted extends ProjectsEvent {
  final String projectId;
  final String bidId;

  const ProjectBidAccepted({
    required this.projectId,
    required this.bidId,
  });

  @override
  List<Object> get props => [projectId, bidId];
}

class ProjectTaskUpdated extends ProjectsEvent {
  final String projectId;
  final ProjectTask task;

  const ProjectTaskUpdated({
    required this.projectId,
    required this.task,
  });

  @override
  List<Object> get props => [projectId, task];
}

class ProjectMilestoneCompleted extends ProjectsEvent {
  final String projectId;
  final String milestoneId;

  const ProjectMilestoneCompleted({
    required this.projectId,
    required this.milestoneId,
  });

  @override
  List<Object> get props => [projectId, milestoneId];
}

class ProjectAIMatchingRequested extends ProjectsEvent {
  final String projectId;

  const ProjectAIMatchingRequested({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

// States
abstract class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object?> get props => [];
}

class ProjectsInitial extends ProjectsState {}

class ProjectsLoading extends ProjectsState {}

class ProjectsLoaded extends ProjectsState {
  final List<Project> projects;
  final bool hasReachedMax;
  final int currentPage;
  final String? searchQuery;
  final String? categoryId;
  final ProjectStatus? status;

  const ProjectsLoaded({
    required this.projects,
    required this.hasReachedMax,
    required this.currentPage,
    this.searchQuery,
    this.categoryId,
    this.status,
  });

  ProjectsLoaded copyWith({
    List<Project>? projects,
    bool? hasReachedMax,
    int? currentPage,
    String? searchQuery,
    String? categoryId,
    ProjectStatus? status,
  }) {
    return ProjectsLoaded(
      projects: projects ?? this.projects,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        projects,
        hasReachedMax,
        currentPage,
        searchQuery,
        categoryId,
        status,
      ];
}

class ProjectCreated extends ProjectsState {
  final Project project;

  const ProjectCreated({required this.project});

  @override
  List<Object> get props => [project];
}

class ProjectUpdated extends ProjectsState {
  final Project project;

  const ProjectUpdated({required this.project});

  @override
  List<Object> get props => [project];
}

class ProjectDeleted extends ProjectsState {
  final String projectId;

  const ProjectDeleted({required this.projectId});

  @override
  List<Object> get props => [projectId];
}

class ProjectBidSubmittedSuccess extends ProjectsState {
  final ProjectBid bid;

  const ProjectBidSubmittedSuccess({required this.bid});

  @override
  List<Object> get props => [bid];
}

class ProjectAIMatchingCompleted extends ProjectsState {
  final String projectId;
  final List<AIProviderMatch> matches;

  const ProjectAIMatchingCompleted({
    required this.projectId,
    required this.matches,
  });

  @override
  List<Object> get props => [projectId, matches];
}

class ProjectsError extends ProjectsState {
  final Failure failure;

  const ProjectsError({required this.failure});

  @override
  List<Object> get props => [failure];
}

// AI Provider Match Model
class AIProviderMatch extends Equatable {
  final String providerId;
  final String providerName;
  final String providerAvatar;
  final double matchScore;
  final List<String> matchingSkills;
  final double averageRating;
  final int completedJobs;
  final double estimatedCost;
  final String reasoning;

  const AIProviderMatch({
    required this.providerId,
    required this.providerName,
    required this.providerAvatar,
    required this.matchScore,
    required this.matchingSkills,
    required this.averageRating,
    required this.completedJobs,
    required this.estimatedCost,
    required this.reasoning,
  });

  @override
  List<Object> get props => [
        providerId,
        providerName,
        providerAvatar,
        matchScore,
        matchingSkills,
        averageRating,
        completedJobs,
        estimatedCost,
        reasoning,
      ];
}

// BLoC
class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  // final ProjectRepository _projectRepository;
  // final AIMatchingService _aiMatchingService;

  ProjectsBloc() : super(ProjectsInitial()) {
    on<ProjectsLoadRequested>(_onProjectsLoadRequested);
    on<ProjectCreateRequested>(_onProjectCreateRequested);
    on<ProjectUpdateRequested>(_onProjectUpdateRequested);
    on<ProjectDeleteRequested>(_onProjectDeleteRequested);
    on<ProjectStatusUpdateRequested>(_onProjectStatusUpdateRequested);
    on<ProjectBidSubmitted>(_onProjectBidSubmitted);
    on<ProjectBidAccepted>(_onProjectBidAccepted);
    on<ProjectTaskUpdated>(_onProjectTaskUpdated);
    on<ProjectMilestoneCompleted>(_onProjectMilestoneCompleted);
    on<ProjectAIMatchingRequested>(_onProjectAIMatchingRequested);
  }

  Future<void> _onProjectsLoadRequested(
    ProjectsLoadRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    if (event.page == 1) {
      emit(ProjectsLoading());
    }

    try {
      // Mock projects data
      await Future.delayed(const Duration(seconds: 1));
      
      final mockProjects = _generateMockProjects(event.page, event.limit);
      
      if (state is ProjectsLoaded && event.page > 1) {
        final currentState = state as ProjectsLoaded;
        final allProjects = [...currentState.projects, ...mockProjects];
        emit(ProjectsLoaded(
          projects: allProjects,
          hasReachedMax: mockProjects.length < event.limit,
          currentPage: event.page,
          searchQuery: event.searchQuery,
          categoryId: event.categoryId,
          status: event.status,
        ));
      } else {
        emit(ProjectsLoaded(
          projects: mockProjects,
          hasReachedMax: mockProjects.length < event.limit,
          currentPage: event.page,
          searchQuery: event.searchQuery,
          categoryId: event.categoryId,
          status: event.status,
        ));
      }
    } catch (e) {
      emit(ProjectsError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onProjectCreateRequested(
    ProjectCreateRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoading());

    try {
      // Validate input
      if (event.title.isEmpty || event.description.isEmpty) {
        emit(const ProjectsError(
          failure: ValidationFailure(
            message: 'يرجى إدخال عنوان ووصف المشروع',
            code: 'MISSING_REQUIRED_FIELDS',
          ),
        ));
        return;
      }

      if (event.budget <= 0) {
        emit(const ProjectsError(
          failure: ValidationFailure(
            message: 'يرجى إدخال ميزانية صحيحة للمشروع',
            code: 'INVALID_BUDGET',
          ),
        ));
        return;
      }

      // Mock project creation
      await Future.delayed(const Duration(seconds: 2));
      
      final project = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: event.title,
        description: event.description,
        clientId: 'current_user_id',
        categoryId: event.categoryId,
        status: ProjectStatus.draft,
        priority: event.priority,
        type: event.type,
        budget: event.budget,
        startDate: event.startDate,
        endDate: event.endDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        tags: event.tags,
        location: event.location,
        tasks: event.tasks,
      );

      emit(ProjectCreated(project: project));
    } catch (e) {
      emit(ProjectsError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onProjectUpdateRequested(
    ProjectUpdateRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoading());

    try {
      // Mock project update
      await Future.delayed(const Duration(seconds: 1));
      
      // Find and update project
      if (state is ProjectsLoaded) {
        final currentState = state as ProjectsLoaded;
        final projectIndex = currentState.projects.indexWhere(
          (p) => p.id == event.projectId,
        );
        
        if (projectIndex != -1) {
          final updatedProject = currentState.projects[projectIndex].copyWith(
            title: event.title,
            description: event.description,
            categoryId: event.categoryId,
            budget: event.budget,
            priority: event.priority,
            type: event.type,
            startDate: event.startDate,
            endDate: event.endDate,
            tags: event.tags,
            location: event.location,
            tasks: event.tasks,
            updatedAt: DateTime.now(),
          );
          
          emit(ProjectUpdated(project: updatedProject));
        }
      }
    } catch (e) {
      emit(ProjectsError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onProjectDeleteRequested(
    ProjectDeleteRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoading());

    try {
      // Mock project deletion
      await Future.delayed(const Duration(seconds: 1));
      emit(ProjectDeleted(projectId: event.projectId));
    } catch (e) {
      emit(ProjectsError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onProjectStatusUpdateRequested(
    ProjectStatusUpdateRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      // Mock status update
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (state is ProjectsLoaded) {
        final currentState = state as ProjectsLoaded;
        final projectIndex = currentState.projects.indexWhere(
          (p) => p.id == event.projectId,
        );
        
        if (projectIndex != -1) {
          final updatedProject = currentState.projects[projectIndex].copyWith(
            status: event.status,
            updatedAt: DateTime.now(),
          );
          
          emit(ProjectUpdated(project: updatedProject));
        }
      }
    } catch (e) {
      emit(ProjectsError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onProjectBidSubmitted(
    ProjectBidSubmitted event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoading());

    try {
      // Validate bid
      if (event.amount <= 0) {
        emit(const ProjectsError(
          failure: ValidationFailure(
            message: 'يرجى إدخال مبلغ صحيح للعرض',
            code: 'INVALID_BID_AMOUNT',
          ),
        ));
        return;
      }

      if (event.proposal.isEmpty) {
        emit(const ProjectsError(
          failure: ValidationFailure(
            message: 'يرجى إدخال اقتراح للمشروع',
            code: 'MISSING_PROPOSAL',
          ),
        ));
        return;
      }

      // Mock bid submission
      await Future.delayed(const Duration(seconds: 1));
      
      final bid = ProjectBid(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        projectId: event.projectId,
        providerId: 'current_provider_id',
        amount: event.amount,
        proposal: event.proposal,
        estimatedDays: event.estimatedDays,
        status: BidStatus.pending,
        createdAt: DateTime.now(),
        attachments: event.attachments,
      );

      emit(ProjectBidSubmittedSuccess(bid: bid));
    } catch (e) {
      emit(ProjectsError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onProjectBidAccepted(
    ProjectBidAccepted event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      // Mock bid acceptance
      await Future.delayed(const Duration(seconds: 1));
      
      // Update project status to in progress
      add(ProjectStatusUpdateRequested(
        projectId: event.projectId,
        status: ProjectStatus.inProgress,
      ));
    } catch (e) {
      emit(ProjectsError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onProjectTaskUpdated(
    ProjectTaskUpdated event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      // Mock task update
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (state is ProjectsLoaded) {
        final currentState = state as ProjectsLoaded;
        final projectIndex = currentState.projects.indexWhere(
          (p) => p.id == event.projectId,
        );
        
        if (projectIndex != -1) {
          final project = currentState.projects[projectIndex];
          final taskIndex = project.tasks.indexWhere(
            (t) => t.id == event.task.id,
          );
          
          if (taskIndex != -1) {
            final updatedTasks = [...project.tasks];
            updatedTasks[taskIndex] = event.task;
            
            final updatedProject = project.copyWith(
              tasks: updatedTasks,
              updatedAt: DateTime.now(),
            );
            
            emit(ProjectUpdated(project: updatedProject));
          }
        }
      }
    } catch (e) {
      emit(ProjectsError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onProjectMilestoneCompleted(
    ProjectMilestoneCompleted event,
    Emitter<ProjectsState> emit,
  ) async {
    try {
      // Mock milestone completion
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (state is ProjectsLoaded) {
        final currentState = state as ProjectsLoaded;
        final projectIndex = currentState.projects.indexWhere(
          (p) => p.id == event.projectId,
        );
        
        if (projectIndex != -1) {
          final project = currentState.projects[projectIndex];
          final milestoneIndex = project.milestones.indexWhere(
            (m) => m.id == event.milestoneId,
          );
          
          if (milestoneIndex != -1) {
            final updatedMilestones = [...project.milestones];
            updatedMilestones[milestoneIndex] = updatedMilestones[milestoneIndex].copyWith(
              status: MilestoneStatus.completed,
              completedAt: DateTime.now(),
            );
            
            final updatedProject = project.copyWith(
              milestones: updatedMilestones,
              updatedAt: DateTime.now(),
            );
            
            emit(ProjectUpdated(project: updatedProject));
          }
        }
      }
    } catch (e) {
      emit(ProjectsError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  Future<void> _onProjectAIMatchingRequested(
    ProjectAIMatchingRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoading());

    try {
      // Mock AI matching
      await Future.delayed(const Duration(seconds: 3));
      
      final matches = _generateMockAIMatches();
      
      emit(ProjectAIMatchingCompleted(
        projectId: event.projectId,
        matches: matches,
      ));
    } catch (e) {
      emit(ProjectsError(failure: FailureFactory.fromException(e as Exception)));
    }
  }

  List<Project> _generateMockProjects(int page, int limit) {
    final projects = <Project>[];
    final startIndex = (page - 1) * limit;
    
    for (int i = startIndex; i < startIndex + limit && i < 50; i++) {
      projects.add(Project(
        id: 'project_$i',
        title: 'مشروع ${i + 1}',
        description: 'وصف تفصيلي للمشروع ${i + 1}',
        clientId: 'client_$i',
        categoryId: 'category_${i % 5}',
        status: ProjectStatus.values[i % ProjectStatus.values.length],
        priority: ProjectPriority.values[i % ProjectPriority.values.length],
        type: ProjectType.values[i % ProjectType.values.length],
        budget: (i + 1) * 1000.0,
        createdAt: DateTime.now().subtract(Duration(days: i)),
        updatedAt: DateTime.now().subtract(Duration(hours: i)),
        tags: ['تطوير', 'تصميم', 'برمجة'],
      ));
    }
    
    return projects;
  }

  List<AIProviderMatch> _generateMockAIMatches() {
    return [
      const AIProviderMatch(
        providerId: 'provider_1',
        providerName: 'أحمد محمد',
        providerAvatar: 'https://example.com/avatar1.jpg',
        matchScore: 0.95,
        matchingSkills: ['Flutter', 'Dart', 'Firebase'],
        averageRating: 4.8,
        completedJobs: 25,
        estimatedCost: 5000.0,
        reasoning: 'خبرة واسعة في تطوير تطبيقات Flutter مع تقييمات ممتازة',
      ),
      const AIProviderMatch(
        providerId: 'provider_2',
        providerName: 'فاطمة علي',
        providerAvatar: 'https://example.com/avatar2.jpg',
        matchScore: 0.87,
        matchingSkills: ['UI/UX', 'Flutter', 'Design'],
        averageRating: 4.6,
        completedJobs: 18,
        estimatedCost: 4500.0,
        reasoning: 'متخصصة في تصميم واجهات المستخدم مع خبرة في Flutter',
      ),
      const AIProviderMatch(
        providerId: 'provider_3',
        providerName: 'محمد سالم',
        providerAvatar: 'https://example.com/avatar3.jpg',
        matchScore: 0.82,
        matchingSkills: ['Backend', 'API', 'Database'],
        averageRating: 4.7,
        completedJobs: 32,
        estimatedCost: 5500.0,
        reasoning: 'خبير في تطوير الخدمات الخلفية وقواعد البيانات',
      ),
    ];
  }
}
