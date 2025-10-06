import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_theme.dart';
import '../../../domain/entities/service_category.dart';
import '../../../domain/entities/project.dart';
import '../../bloc/projects/projects_bloc.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_overlay.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  ServiceCategory? _selectedCategory;
  ProjectPriority _selectedPriority = ProjectPriority.medium;
  DateTime? _preferredDate;
  TimeOfDay? _preferredTime;
  List<String> _selectedImages = [];

  final List<ServiceCategory> _categories = [
    ServiceCategory(
      id: '1',
      name: 'تنظيف المنزل',
      description: 'خدمات تنظيف شاملة للمنزل',
      icon: 'cleaning',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ServiceCategory(
      id: '2',
      name: 'صيانة كهربائية',
      description: 'إصلاح وصيانة الأجهزة الكهربائية',
      icon: 'electrical',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ServiceCategory(
      id: '3',
      name: 'سباكة',
      description: 'إصلاح وصيانة السباكة',
      icon: 'plumbing',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ServiceCategory(
      id: '4',
      name: 'نجارة',
      description: 'أعمال النجارة والأثاث',
      icon: 'carpentry',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ServiceCategory(
      id: '5',
      name: 'دهان',
      description: 'دهان الجدران والأسقف',
      icon: 'painting',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    ServiceCategory(
      id: '6',
      name: 'تكييف',
      description: 'صيانة وتركيب أجهزة التكييف',
      icon: 'ac',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleCreateProject() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى اختيار فئة الخدمة'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      final project = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        categoryId: _selectedCategory!.id,
        clientId: 'current_user_id', // Should come from auth state
        budget: double.tryParse(_budgetController.text) ?? 0,
        location: _locationController.text.trim(),
        priority: _selectedPriority,
        status: ProjectStatus.pending,
        preferredDate: _preferredDate,
        preferredTime: _preferredTime?.format(context),
        images: _selectedImages,
        notes: _notesController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      context.read<ProjectsBloc>().add(ProjectCreateRequested(project: project));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectsBloc, ProjectsState>(
      listener: (context, state) {
        if (state is ProjectCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إنشاء المشروع بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is ProjectsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is ProjectsLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('إنشاء مشروع جديد'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      _buildHeader(),
                      
                      const SizedBox(height: 24),
                      
                      // Basic Information
                      _buildBasicInformation(),
                      
                      const SizedBox(height: 24),
                      
                      // Category Selection
                      _buildCategorySelection(),
                      
                      const SizedBox(height: 24),
                      
                      // Budget and Priority
                      _buildBudgetAndPriority(),
                      
                      const SizedBox(height: 24),
                      
                      // Schedule
                      _buildSchedule(),
                      
                      const SizedBox(height: 24),
                      
                      // Location
                      _buildLocation(),
                      
                      const SizedBox(height: 24),
                      
                      // Images
                      _buildImages(),
                      
                      const SizedBox(height: 24),
                      
                      // Additional Notes
                      _buildAdditionalNotes(),
                      
                      const SizedBox(height: 32),
                      
                      // Create Button
                      CustomButton(
                        text: 'إنشاء المشروع',
                        onPressed: _handleCreateProject,
                        icon: Icons.add_circle_outline,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.add_task,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 12),
          const Text(
            'أنشئ مشروعك الجديد',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'املأ التفاصيل أدناه وسنجد لك أفضل مقدمي الخدمات',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المعلومات الأساسية',
          style: AppTheme.headingMedium,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _titleController,
          label: 'عنوان المشروع',
          hint: 'مثال: تنظيف شقة 3 غرف',
          prefixIcon: Icons.title,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'يرجى إدخال عنوان المشروع';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _descriptionController,
          label: 'وصف المشروع',
          hint: 'اشرح تفاصيل العمل المطلوب...',
          prefixIcon: Icons.description,
          maxLines: 4,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'يرجى إدخال وصف المشروع';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'فئة الخدمة',
          style: AppTheme.headingMedium,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = _selectedCategory?.id == category.id;
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getCategoryIcon(category.icon),
                      size: 32,
                      color: isSelected ? Colors.white : AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: isSelected ? Colors.white : AppTheme.textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBudgetAndPriority() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الميزانية والأولوية',
          style: AppTheme.headingMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _budgetController,
                label: 'الميزانية المتوقعة',
                hint: '0',
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'يرجى إدخال الميزانية';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'يرجى إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الأولوية',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<ProjectPriority>(
                    value: _selectedPriority,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    items: ProjectPriority.values.map((priority) {
                      return DropdownMenuItem(
                        value: priority,
                        child: Text(_getPriorityText(priority)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الجدولة المفضلة',
          style: AppTheme.headingMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _preferredDate = date;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'التاريخ المفضل',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.secondaryTextColor,
                              ),
                            ),
                            Text(
                              _preferredDate != null
                                  ? '${_preferredDate!.day}/${_preferredDate!.month}/${_preferredDate!.year}'
                                  : 'اختر التاريخ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      _preferredTime = time;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.borderColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الوقت المفضل',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.secondaryTextColor,
                              ),
                            ),
                            Text(
                              _preferredTime != null
                                  ? _preferredTime!.format(context)
                                  : 'اختر الوقت',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الموقع',
          style: AppTheme.headingMedium,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _locationController,
          label: 'عنوان المشروع',
          hint: 'مثال: الرياض، حي النرجس، شارع الملك فهد',
          prefixIcon: Icons.location_on,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'يرجى إدخال عنوان المشروع';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الصور (اختياري)',
          style: AppTheme.headingMedium,
        ),
        const SizedBox(height: 16),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () {
              // Handle image selection
              _selectImages();
            },
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 48,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'اضغط لإضافة صور',
                    style: TextStyle(
                      color: AppTheme.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            'تم اختيار ${_selectedImages.length} صورة',
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAdditionalNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ملاحظات إضافية',
          style: AppTheme.headingMedium,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _notesController,
          label: 'ملاحظات',
          hint: 'أي تفاصيل إضافية أو متطلبات خاصة...',
          prefixIcon: Icons.note,
          maxLines: 3,
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'cleaning':
        return Icons.cleaning_services;
      case 'electrical':
        return Icons.electrical_services;
      case 'plumbing':
        return Icons.plumbing;
      case 'carpentry':
        return Icons.carpenter;
      case 'painting':
        return Icons.format_paint;
      case 'ac':
        return Icons.ac_unit;
      default:
        return Icons.home_repair_service;
    }
  }

  String _getPriorityText(ProjectPriority priority) {
    switch (priority) {
      case ProjectPriority.low:
        return 'منخفضة';
      case ProjectPriority.medium:
        return 'متوسطة';
      case ProjectPriority.high:
        return 'عالية';
      case ProjectPriority.urgent:
        return 'عاجلة';
    }
  }

  void _selectImages() {
    // Mock image selection
    setState(() {
      _selectedImages = ['image1.jpg', 'image2.jpg'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم اختيار الصور (محاكاة)'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
