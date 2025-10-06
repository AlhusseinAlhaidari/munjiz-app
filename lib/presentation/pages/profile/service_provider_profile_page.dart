import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_theme.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/service_category.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_overlay.dart';

class ServiceProviderProfilePage extends StatefulWidget {
  const ServiceProviderProfilePage({super.key});

  @override
  State<ServiceProviderProfilePage> createState() => _ServiceProviderProfilePageState();
}

class _ServiceProviderProfilePageState extends State<ServiceProviderProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for profile editing
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController();
  final _locationController = TextEditingController();
  final _hourlyRateController = TextEditingController();

  bool _isEditing = false;
  List<String> _selectedServices = [];
  List<String> _portfolioImages = [];
  
  // Mock data for services
  final List<ServiceCategory> _availableServices = [
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
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    _locationController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Mock user data loading
    _firstNameController.text = 'أحمد';
    _lastNameController.text = 'محمد';
    _phoneController.text = '+966501234567';
    _bioController.text = 'مقدم خدمات محترف مع خبرة 5 سنوات في مجال التنظيف والصيانة المنزلية';
    _experienceController.text = '5';
    _locationController.text = 'الرياض، المملكة العربية السعودية';
    _hourlyRateController.text = '50';
    _selectedServices = ['1', '2']; // تنظيف وكهرباء
    _portfolioImages = ['portfolio1.jpg', 'portfolio2.jpg', 'portfolio3.jpg'];
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save profile logic here
      setState(() {
        _isEditing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ الملف الشخصي بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is AuthLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('الملف الشخصي'),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: _toggleEdit,
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                ),
                if (_isEditing)
                  IconButton(
                    onPressed: _saveProfile,
                    icon: const Icon(Icons.save),
                  ),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.secondaryTextColor,
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(text: 'المعلومات'),
                  Tab(text: 'الخدمات'),
                  Tab(text: 'معرض الأعمال'),
                  Tab(text: 'التقييمات'),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(),
                _buildServicesTab(),
                _buildPortfolioTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            _buildProfilePicture(),
            
            const SizedBox(height: 24),
            
            // Basic Information
            _buildBasicInformation(),
            
            const SizedBox(height: 24),
            
            // Professional Information
            _buildProfessionalInformation(),
            
            const SizedBox(height: 24),
            
            // Contact Information
            _buildContactInformation(),
            
            if (_isEditing) ...[
              const SizedBox(height: 32),
              CustomButton(
                text: 'حفظ التغييرات',
                onPressed: _saveProfile,
                icon: Icons.save,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: Icon(
            Icons.person,
            size: 60,
            color: AppTheme.primaryColor,
          ),
        ),
        if (_isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  // Handle image selection
                  _selectProfileImage();
                },
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
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
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _firstNameController,
                label: 'الاسم الأول',
                enabled: _isEditing,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'يرجى إدخال الاسم الأول';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _lastNameController,
                label: 'الاسم الأخير',
                enabled: _isEditing,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'يرجى إدخال الاسم الأخير';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _bioController,
          label: 'نبذة عني',
          maxLines: 3,
          enabled: _isEditing,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'يرجى إدخال نبذة عنك';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildProfessionalInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المعلومات المهنية',
          style: AppTheme.headingMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _experienceController,
                label: 'سنوات الخبرة',
                keyboardType: TextInputType.number,
                enabled: _isEditing,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'يرجى إدخال سنوات الخبرة';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                controller: _hourlyRateController,
                label: 'السعر بالساعة (ريال)',
                keyboardType: TextInputType.number,
                enabled: _isEditing,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'يرجى إدخال السعر';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _locationController,
          label: 'المنطقة',
          enabled: _isEditing,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'يرجى إدخال المنطقة';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContactInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معلومات التواصل',
          style: AppTheme.headingMedium,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _phoneController,
          label: 'رقم الهاتف',
          keyboardType: TextInputType.phone,
          enabled: _isEditing,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'يرجى إدخال رقم الهاتف';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildServicesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الخدمات المقدمة',
                style: AppTheme.headingMedium,
              ),
              if (_isEditing)
                TextButton(
                  onPressed: _showServiceSelectionDialog,
                  child: const Text('تعديل الخدمات'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedServices.isEmpty)
            const Center(
              child: Text(
                'لم يتم اختيار أي خدمات بعد',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              itemCount: _selectedServices.length,
              itemBuilder: (context, index) {
                final serviceId = _selectedServices[index];
                final service = _availableServices.firstWhere(
                  (s) => s.id == serviceId,
                );
                return _buildServiceCard(service);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(ServiceCategory service) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor),
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
            _getServiceIcon(service.icon),
            size: 32,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            service.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'معرض الأعمال',
                style: AppTheme.headingMedium,
              ),
              if (_isEditing)
                TextButton(
                  onPressed: _addPortfolioImage,
                  child: const Text('إضافة صورة'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_portfolioImages.isEmpty)
            const Center(
              child: Text(
                'لا توجد صور في معرض الأعمال',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: _portfolioImages.length,
              itemBuilder: (context, index) {
                return _buildPortfolioImageCard(_portfolioImages[index], index);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPortfolioImageCard(String imagePath, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.image,
              size: 48,
              color: AppTheme.primaryColor,
            ),
          ),
          if (_isEditing)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _portfolioImages.removeAt(index);
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Summary
          _buildRatingSummary(),
          
          const SizedBox(height: 24),
          
          // Reviews List
          Text(
            'التقييمات والمراجعات',
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3, // Mock reviews
            itemBuilder: (context, index) {
              return _buildReviewCard(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                '4.8',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < 4 ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(height: 4),
              const Text(
                '24 تقييم',
                style: TextStyle(
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              children: [
                _buildRatingBar('5 نجوم', 18, 24),
                _buildRatingBar('4 نجوم', 4, 24),
                _buildRatingBar('3 نجوم', 2, 24),
                _buildRatingBar('2 نجوم', 0, 24),
                _buildRatingBar('1 نجمة', 0, 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, int count, int total) {
    double percentage = count / total;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(int index) {
    final reviews = [
      {
        'name': 'سارة أحمد',
        'rating': 5,
        'date': '2024-01-15',
        'comment': 'خدمة ممتازة وسريعة. أنصح بالتعامل معه.',
      },
      {
        'name': 'محمد علي',
        'rating': 4,
        'date': '2024-01-10',
        'comment': 'عمل جيد ولكن تأخر قليلاً عن الموعد المحدد.',
      },
      {
        'name': 'فاطمة خالد',
        'rating': 5,
        'date': '2024-01-05',
        'comment': 'محترف جداً ونتيجة العمل فاقت التوقعات.',
      },
    ];

    final review = reviews[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < (review['rating'] as int)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          review['date'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'] as String,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String iconName) {
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

  void _selectProfileImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم اختيار صورة الملف الشخصي (محاكاة)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showServiceSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر الخدمات'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _availableServices.length,
            itemBuilder: (context, index) {
              final service = _availableServices[index];
              final isSelected = _selectedServices.contains(service.id);
              
              return CheckboxListTile(
                title: Text(service.name),
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    if (value ?? false) {
                      _selectedServices.add(service.id);
                    } else {
                      _selectedServices.remove(service.id);
                    }
                  });
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _addPortfolioImage() {
    setState(() {
      _portfolioImages.add('new_portfolio_${_portfolioImages.length + 1}.jpg');
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إضافة صورة جديدة (محاكاة)'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
