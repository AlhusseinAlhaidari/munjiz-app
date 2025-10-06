import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_theme.dart';
import '../../../core/services/ai_matching_service.dart';
import '../../../domain/entities/project.dart';
import '../../../domain/entities/user.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../widgets/loading_overlay.dart';

class SuggestedProvidersPage extends StatefulWidget {
  final Project project;
  
  const SuggestedProvidersPage({
    super.key,
    required this.project,
  });

  @override
  State<SuggestedProvidersPage> createState() => _SuggestedProvidersPageState();
}

class _SuggestedProvidersPageState extends State<SuggestedProvidersPage> {
  final AIMatchingService _aiService = AIMatchingService();
  List<MatchResult> _suggestedProviders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSuggestedProviders();
  }

  void _loadSuggestedProviders() {
    setState(() {
      _isLoading = true;
    });

    // Mock service providers data with proper User model structure
    List<User> mockProviders = [
      User(
        id: 'provider_1',
        firstName: 'أحمد',
        lastName: 'محمد',
        email: 'ahmed@example.com',
        userType: UserType.serviceProvider,
        status: UserStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
        phoneNumber: '+966501234567',
        profile: UserProfile(
          address: 'الرياض، حي النرجس',
          city: 'الرياض',
          country: 'السعودية',
          serviceProviderProfile: ServiceProviderProfile(
            averageRating: 4.8,
            yearsOfExperience: 5,
            hourlyRate: 45.0,
            categories: ['تنظيف المنزل', 'تنظيف السجاد', 'تنظيف النوافذ'],
            isAvailable: true,
          ),
        ),
      ),
      User(
        id: 'provider_2',
        firstName: 'سارة',
        lastName: 'أحمد',
        email: 'sara@example.com',
        userType: UserType.serviceProvider,
        status: UserStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now(),
        phoneNumber: '+966502345678',
        profile: UserProfile(
          address: 'الرياض، حي العليا',
          city: 'الرياض',
          country: 'السعودية',
          serviceProviderProfile: ServiceProviderProfile(
            averageRating: 4.6,
            yearsOfExperience: 3,
            hourlyRate: 40.0,
            categories: ['تنظيف المنزل', 'تنظيف المكاتب'],
            isAvailable: true,
          ),
        ),
      ),
      User(
        id: 'provider_3',
        firstName: 'محمد',
        lastName: 'علي',
        email: 'mohammed@example.com',
        userType: UserType.serviceProvider,
        status: UserStatus.active,
        createdAt: DateTime.now().subtract(const Duration(days: 500)),
        updatedAt: DateTime.now(),
        phoneNumber: '+966503456789',
        profile: UserProfile(
          address: 'الرياض، حي الملز',
          city: 'الرياض',
          country: 'السعودية',
          serviceProviderProfile: ServiceProviderProfile(
            averageRating: 4.9,
            yearsOfExperience: 7,
            hourlyRate: 55.0,
            categories: ['تنظيف المنزل', 'تنظيف شامل', 'تنظيف بعد الدهان'],
            isAvailable: true,
          ),
        ),
      ),
    ];

    // Use AI service to find best matches
    _suggestedProviders = _aiService.findBestMatches(widget.project, mockProviders);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: _isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('مقدمو الخدمات المقترحون'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Column(
              children: [
                // Project Info Header
                _buildProjectHeader(),
                
                // AI Matching Info
                _buildAIMatchingInfo(),
                
                // Suggested Providers List
                Expanded(
                  child: _suggestedProviders.isEmpty
                      ? _buildEmptyState()
                      : _buildProvidersList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProjectHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.project.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.category,
                size: 16,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                widget.project.categoryId, // Using categoryId instead of category
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.attach_money,
                size: 16,
                color: Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.project.budget.toStringAsFixed(0)} ريال',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIMatchingInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.psychology,
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'تم اختيار هؤلاء المقدمين باستخدام الذكاء الاصطناعي بناءً على مطابقة الخدمات والموقع والميزانية والتقييمات',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لم يتم العثور على مقدمي خدمات مناسبين',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'جرب تعديل معايير المشروع أو انتظر مقدمي خدمات جدد',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadSuggestedProviders,
            child: const Text('إعادة البحث'),
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _suggestedProviders.length,
      itemBuilder: (context, index) {
        final matchResult = _suggestedProviders[index];
        return _buildProviderCard(matchResult, index + 1);
      },
    );
  }

  Widget _buildProviderCard(MatchResult matchResult, int rank) {
    final provider = matchResult.provider;
    final score = matchResult.score;
    final reasons = matchResult.reasons;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        border: rank <= 3 ? Border.all(
          color: _getRankColor(rank),
          width: 2,
        ) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with rank and match score
            Row(
              children: [
                _buildRankBadge(rank),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${provider.firstName} ${provider.lastName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildMatchScore(score),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Provider details
            _buildProviderDetails(provider),
            
            const SizedBox(height: 12),
            
            // Match reasons
            _buildMatchReasons(reasons),
            
            const SizedBox(height: 16),
            
            // Action buttons
            _buildActionButtons(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color color = _getRankColor(rank);
    IconData icon;
    
    switch (rank) {
      case 1:
        icon = Icons.emoji_events;
        break;
      case 2:
        icon = Icons.military_tech;
        break;
      case 3:
        icon = Icons.workspace_premium;
        break;
      default:
        icon = Icons.star;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[600]!;
      case 3:
        return Colors.orange[800]!;
      default:
        return AppTheme.primaryColor;
    }
  }

  Widget _buildMatchScore(double score) {
    String scoreText;
    Color scoreColor;
    
    if (score >= 0.8) {
      scoreText = 'مطابقة ممتازة';
      scoreColor = Colors.green;
    } else if (score >= 0.6) {
      scoreText = 'مطابقة جيدة';
      scoreColor = Colors.blue;
    } else if (score >= 0.4) {
      scoreText = 'مطابقة متوسطة';
      scoreColor = Colors.orange;
    } else {
      scoreText = 'مطابقة ضعيفة';
      scoreColor = Colors.red;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: scoreColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            scoreText,
            style: TextStyle(
              fontSize: 12,
              color: scoreColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(score * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 12,
            color: scoreColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProviderDetails(User provider) {
    final serviceProfile = provider.profile?.serviceProviderProfile;
    
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.star,
              size: 16,
              color: Colors.amber,
            ),
            const SizedBox(width: 4),
            Text(
              serviceProfile?.averageRating?.toStringAsFixed(1) ?? 'جديد',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.work,
              size: 16,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(width: 4),
            Text(
              '${serviceProfile?.yearsOfExperience ?? 0} سنوات خبرة',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                provider.profile?.address ?? 'غير محدد',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            if (serviceProfile?.hourlyRate != null) ...[
              Icon(
                Icons.attach_money,
                size: 16,
                color: Colors.green,
              ),
              const SizedBox(width: 4),
              Text(
                '${serviceProfile!.hourlyRate.toStringAsFixed(0)} ريال/ساعة',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildMatchReasons(List<String> reasons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أسباب الاقتراح:',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: reasons.map((reason) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              reason,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.primaryColor,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(User provider) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              _viewProviderProfile(provider);
            },
            icon: const Icon(Icons.person, size: 16),
            label: const Text('عرض الملف'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _contactProvider(provider);
            },
            icon: const Icon(Icons.chat, size: 16),
            label: const Text('تواصل'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              _sendProjectOffer(provider);
            },
            icon: const Icon(Icons.send, size: 16),
            label: const Text('إرسال عرض'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _viewProviderProfile(User provider) {
    Navigator.of(context).pushNamed(
      '/service-provider-profile',
      arguments: provider,
    );
  }

  void _contactProvider(User provider) {
    Navigator.of(context).pushNamed(
      '/chat-detail',
      arguments: {
        'providerId': provider.id,
        'providerName': '${provider.firstName} ${provider.lastName}',
        'projectId': widget.project.id,
        'projectTitle': widget.project.title,
      },
    );
  }

  void _sendProjectOffer(User provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إرسال عرض إلى ${provider.firstName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('هل تريد إرسال عرض المشروع التالي:'),
            const SizedBox(height: 8),
            Text(
              widget.project.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'الميزانية: ${widget.project.budget.toStringAsFixed(0)} ريال',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إرسال العرض إلى ${provider.firstName}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }
}
