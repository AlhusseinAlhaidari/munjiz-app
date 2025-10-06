import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_theme.dart';
import '../../../domain/entities/project.dart';
import '../../bloc/projects/projects_bloc.dart';
import '../../widgets/loading_overlay.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Load projects when page initializes
    context.read<ProjectsBloc>().add(ProjectsLoadRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is ProjectsLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('مشاريعي'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/create-project');
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.secondaryTextColor,
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(text: 'الكل'),
                  Tab(text: 'في الانتظار'),
                  Tab(text: 'قيد التنفيذ'),
                  Tab(text: 'مكتملة'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildProjectsList(null), // All projects
                _buildProjectsList(ProjectStatus.pending),
                _buildProjectsList(ProjectStatus.inProgress),
                _buildProjectsList(ProjectStatus.completed),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/create-project');
              },
              backgroundColor: AppTheme.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectsList(ProjectStatus? filterStatus) {
    return BlocBuilder<ProjectsBloc, ProjectsState>(
      builder: (context, state) {
        if (state is ProjectsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'حدث خطأ في تحميل المشاريع',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProjectsBloc>().add(ProjectsLoadRequested());
                  },
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is ProjectsLoaded) {
          List<Project> projects = state.projects;
          
          // Filter projects by status if specified
          if (filterStatus != null) {
            projects = projects.where((project) => project.status == filterStatus).toList();
          }

          if (projects.isEmpty) {
            return _buildEmptyState(filterStatus);
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProjectsBloc>().add(ProjectsLoadRequested());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _buildProjectCard(project);
              },
            ),
          );
        }

        // Default loading state or initial state
        return _buildEmptyState(filterStatus);
      },
    );
  }

  Widget _buildEmptyState(ProjectStatus? filterStatus) {
    String message;
    IconData icon;
    
    switch (filterStatus) {
      case ProjectStatus.pending:
        message = 'لا توجد مشاريع في الانتظار';
        icon = Icons.hourglass_empty;
        break;
      case ProjectStatus.inProgress:
        message = 'لا توجد مشاريع قيد التنفيذ';
        icon = Icons.work_outline;
        break;
      case ProjectStatus.completed:
        message = 'لا توجد مشاريع مكتملة';
        icon = Icons.check_circle_outline;
        break;
      default:
        message = 'لا توجد مشاريع حتى الآن';
        icon = Icons.folder_open;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed('/create-project');
            },
            icon: const Icon(Icons.add),
            label: const Text('إنشاء مشروع جديد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (project.status) {
      case ProjectStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.hourglass_empty;
        statusText = 'في الانتظار';
        break;
      case ProjectStatus.inProgress:
        statusColor = Colors.blue;
        statusIcon = Icons.work_outline;
        statusText = 'قيد التنفيذ';
        break;
      case ProjectStatus.completed:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        statusText = 'مكتملة';
        break;
      case ProjectStatus.cancelled:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'ملغي';
        break;
      case ProjectStatus.draft:
        statusColor = Colors.grey;
        statusIcon = Icons.edit_note;
        statusText = 'مسودة';
        break;
      case ProjectStatus.published:
        statusColor = Colors.blueAccent;
        statusIcon = Icons.public;
        statusText = 'منشور';
        break;
      case ProjectStatus.disputed:
        statusColor = Colors.deepOrange;
        statusIcon = Icons.gavel;
        statusText = 'متنازع عليه';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showProjectDetails(project);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          statusIcon,
                          size: 16,
                          color: statusColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                project.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Details row
              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${project.budget.toStringAsFixed(0)} ريال',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      project.location?.address ?? 'غير محدد',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Date and priority
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${project.createdAt.day}/${project.createdAt.month}/${project.createdAt.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  _buildPriorityChip(project.priority),
                ],
              ),
              
              // Action buttons for active projects
              if (project.status == ProjectStatus.pending || 
                  project.status == ProjectStatus.inProgress) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _editProject(project);
                        },
                        child: const Text('تعديل'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _viewOffers(project);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('عرض العروض'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(ProjectPriority priority) {
    Color color;
    String text;
    
    switch (priority) {
      case ProjectPriority.low:
        color = Colors.green;
        text = 'منخفضة';
        break;
      case ProjectPriority.medium:
        color = Colors.orange;
        text = 'متوسطة';
        break;
      case ProjectPriority.high:
        color = Colors.red;
        text = 'عالية';
        break;
      case ProjectPriority.urgent:
        color = Colors.purple;
        text = 'عاجلة';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showProjectDetails(Project project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Title
                  Text(
                    project.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Project details
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("الميزانية", project.budget.toStringAsFixed(0) + " ريال"),
                        _buildDetailRow("الموقع", project.location?.address ?? "غير محدد"),
                        _buildDetailRow("تاريخ الإنشاء", 
                           '${project.createdAt.day}/${project.createdAt.month}/${project.createdAt.year}'),
                        if (project.preferredDate != null)
                          _buildDetailRow("التاريخ المفضل", '${project.preferredDate!.day}/${project.preferredDate!.month}/${project.preferredDate!.year}'),
                      ],
                    ),
                  ),
                ),
                
                // Action buttons
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _editProject(project);
                        },
                        child: const Text('تعديل المشروع'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _viewOffers(project);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('عرض العروض'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _editProject(Project project) {
    // Navigate to edit project page
    // Navigator.of(context).pushNamed('/edit-project', arguments: project);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('وظيفة التعديل غير متوفرة حاليًا.')),
    );
  }

  void _viewOffers(Project project) {
    // Navigate to offers page for this project
    // Navigator.of(context).pushNamed('/project-offers', arguments: project);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('وظيفة عرض العروض غير متوفرة حاليًا.')),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

