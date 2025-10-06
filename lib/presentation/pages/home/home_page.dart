import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_theme.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/service_category.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../widgets/custom_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  int _selectedIndex = 0;

  // Mock data for services
  final List<ServiceCategory> _serviceCategories = [
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _selectedIndex == 0 
            ? _buildHomeContent()
            : _buildOtherPages(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info and notifications
          _buildHeader(),
          
          // Search bar
          _buildSearchBar(),
          
          // Quick actions
          _buildQuickActions(),
          
          // Service categories
          _buildServiceCategories(),
          
          // Featured services
          _buildFeaturedServices(),
          
          // Recent projects
          _buildRecentProjects(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = 'مستخدم';
        if (state is AuthAuthenticated) {
          userName = '${state.user.firstName} ${state.user.lastName}';
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً، $userName',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'ما الخدمة التي تحتاجها اليوم؟',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      // Navigate to notifications
                    },
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'ابحث عن الخدمة التي تحتاجها...',
            prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
            suffixIcon: IconButton(
              onPressed: () {
                // Apply filters
                _showFiltersBottomSheet();
              },
              icon: const Icon(Icons.tune, color: AppTheme.primaryColor),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onSubmitted: (value) {
            // Perform search
            _performSearch(value);
          },
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إجراءات سريعة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.add_circle_outline,
                  title: 'مشروع جديد',
                  subtitle: 'أنشئ مشروعاً جديداً',
                  onTap: () {
                    Navigator.of(context).pushNamed('/create-project');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.history,
                  title: 'مشاريعي',
                  subtitle: 'عرض المشاريع السابقة',
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.chat_outlined,
                  title: 'المحادثات',
                  subtitle: 'تواصل مع مقدمي الخدمة',
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          children: [
            Icon(
              icon,
              size: 32,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCategories() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'فئات الخدمات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all categories
                },
                child: const Text('عرض الكل'),
              ),
            ],
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
            itemCount: _serviceCategories.length,
            itemBuilder: (context, index) {
              final category = _serviceCategories[index];
              return _buildServiceCategoryCard(category);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCategoryCard(ServiceCategory category) {
    IconData categoryIcon;
    switch (category.icon) {
      case 'cleaning':
        categoryIcon = Icons.cleaning_services;
        break;
      case 'electrical':
        categoryIcon = Icons.electrical_services;
        break;
      case 'plumbing':
        categoryIcon = Icons.plumbing;
        break;
      case 'carpentry':
        categoryIcon = Icons.carpenter;
        break;
      case 'painting':
        categoryIcon = Icons.format_paint;
        break;
      case 'ac':
        categoryIcon = Icons.ac_unit;
        break;
      default:
        categoryIcon = Icons.home_repair_service;
    }

    return GestureDetector(
      onTap: () {
        // Navigate to category services
        _navigateToCategory(category);
      },
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              categoryIcon,
              size: 32,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedServices() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'خدمات مميزة',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return _buildFeaturedServiceCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedServiceCard(int index) {
    final services = [
      {
        'title': 'تنظيف شامل للمنزل',
        'provider': 'شركة النظافة المثالية',
        'rating': 4.8,
        'price': '150 ريال',
        'image': 'cleaning',
      },
      {
        'title': 'صيانة كهربائية طارئة',
        'provider': 'فريق الكهرباء المحترف',
        'rating': 4.9,
        'price': '200 ريال',
        'image': 'electrical',
      },
      {
        'title': 'إصلاح السباكة',
        'provider': 'خبراء السباكة',
        'rating': 4.7,
        'price': '120 ريال',
        'image': 'plumbing',
      },
    ];

    final service = services[index];

    return Container(
      width: 280,
      margin: const EdgeInsets.only(left: 16),
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
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Center(
              child: Icon(
                _getServiceIcon(service['image'] as String),
                size: 48,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  service['provider'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          service['rating'].toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      service['price'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentProjects() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مشاريع حديثة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildRecentProjectCard(index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentProjectCard(int index) {
    final projects = [
      {
        'title': 'تنظيف شقة 3 غرف',
        'status': 'مكتمل',
        'date': '2024-01-15',
        'provider': 'شركة النظافة المثالية',
      },
      {
        'title': 'إصلاح مكيف الهواء',
        'status': 'قيد التنفيذ',
        'date': '2024-01-20',
        'provider': 'فريق التكييف المحترف',
      },
      {
        'title': 'دهان غرفة المعيشة',
        'status': 'في الانتظار',
        'date': '2024-01-25',
        'provider': 'مجموعة الدهان الحديث',
      },
    ];

    final project = projects[index];
    Color statusColor;
    switch (project['status']) {
      case 'مكتمل':
        statusColor = Colors.green;
        break;
      case 'قيد التنفيذ':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.work_outline,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  project['provider'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  project['date'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              project['status'] as String,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherPages() {
    switch (_selectedIndex) {
      case 1:
        return const Center(
          child: Text(
            'صفحة المشاريع',
            style: TextStyle(fontSize: 24),
          ),
        );
      case 2:
        return const Center(
          child: Text(
            'صفحة المحادثات',
            style: TextStyle(fontSize: 24),
          ),
        );
      case 3:
        return const Center(
          child: Text(
            'صفحة الملف الشخصي',
            style: TextStyle(fontSize: 24),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'الرئيسية',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.work),
          label: 'مشاريعي',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'المحادثات',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'الملف الشخصي',
        ),
      ],
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
      default:
        return Icons.home_repair_service;
    }
  }

  void _performSearch(String query) {
    // Implement search functionality
    print('Searching for: $query');
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'فلاتر البحث',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Add filter options here
            const Text('سيتم إضافة خيارات الفلترة هنا'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('تطبيق الفلاتر'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(ServiceCategory category) {
    // Navigate to category services page
    print('Navigating to category: ${category.name}');
  }
}
