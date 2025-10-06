import 'dart:math';
import '../../domain/entities/project.dart';
import '../../domain/entities/user.dart';

class AIMatchingService {
  static final AIMatchingService _instance = AIMatchingService._internal();
  factory AIMatchingService() => _instance;
  AIMatchingService._internal();

  /// Calculate matching score between a project and a service provider
  double calculateMatchingScore(Project project, User serviceProvider) {
    double totalScore = 0.0;
    int factors = 0;

    // 1. Service Category Match (40% weight)
    double categoryScore = _calculateCategoryScore(project, serviceProvider);
    totalScore += categoryScore * 0.4;
    factors++;

    // 2. Location Proximity (25% weight)
    double locationScore = _calculateLocationScore(project, serviceProvider);
    totalScore += locationScore * 0.25;
    factors++;

    // 3. Budget Compatibility (20% weight)
    double budgetScore = _calculateBudgetScore(project, serviceProvider);
    totalScore += budgetScore * 0.2;
    factors++;

    // 4. Provider Rating (10% weight)
    double ratingScore = _calculateRatingScore(serviceProvider);
    totalScore += ratingScore * 0.1;
    factors++;

    // 5. Availability Score (5% weight)
    double availabilityScore = _calculateAvailabilityScore(project, serviceProvider);
    totalScore += availabilityScore * 0.05;
    factors++;

    return totalScore;
  }

  /// Find best matching service providers for a project
  List<MatchResult> findBestMatches(Project project, List<User> serviceProviders) {
    List<MatchResult> matches = [];

    for (User provider in serviceProviders) {
      if (provider.userType != UserType.serviceProvider) continue;

      double score = calculateMatchingScore(project, provider);
      
      if (score >= 0.3) { // Minimum threshold
        matches.add(MatchResult(
          provider: provider,
          score: score,
          reasons: _generateMatchReasons(project, provider, score),
        ));
      }
    }

    // Sort by score (highest first)
    matches.sort((a, b) => b.score.compareTo(a.score));

    // Return top 10 matches
    return matches.take(10).toList();
  }

  /// Calculate category matching score
  double _calculateCategoryScore(Project project, User serviceProvider) {
    final serviceProfile = serviceProvider.profile?.serviceProviderProfile;
    if (serviceProfile?.categories == null || serviceProfile!.categories.isEmpty) {
      return 0.0;
    }

    // Check if provider offers the required service category
    bool hasMatchingCategory = serviceProfile.categories.any(
      (service) => service.toLowerCase().contains(project.categoryId.toLowerCase()) ||
                   project.categoryId.toLowerCase().contains(service.toLowerCase())
    );

    if (hasMatchingCategory) {
      return 1.0;
    }

    // Check for related services using keyword matching
    double partialMatch = _calculateServiceSimilarity(project.categoryId, serviceProfile.categories);
    return partialMatch;
  }

  /// Calculate location proximity score
  double _calculateLocationScore(Project project, User serviceProvider) {
    final userProfile = serviceProvider.profile;
    if (userProfile?.address == null) return 0.5;

    String projectLocation = project.location?.address ?? project.location?.city ?? '';
    String providerLocation = userProfile!.address!.toLowerCase();
    projectLocation = projectLocation.toLowerCase();

    // Exact city match
    if (projectLocation.contains(providerLocation) || 
        providerLocation.contains(projectLocation)) {
      return 1.0;
    }

    // Check for same region/area keywords
    List<String> projectKeywords = projectLocation.split(' ');
    List<String> providerKeywords = providerLocation.split(' ');

    int matchingKeywords = 0;
    for (String keyword in projectKeywords) {
      if (providerKeywords.any((pk) => pk.contains(keyword) || keyword.contains(pk))) {
        matchingKeywords++;
      }
    }

    double similarity = matchingKeywords / max(projectKeywords.length, providerKeywords.length);
    return similarity;
  }

  /// Calculate budget compatibility score
  double _calculateBudgetScore(Project project, User serviceProvider) {
    final serviceProfile = serviceProvider.profile?.serviceProviderProfile;
    if (serviceProfile?.hourlyRate == null) return 0.7; // Neutral score if no rate specified

    double providerRate = serviceProfile!.hourlyRate;
    double projectBudget = project.budget;

    // Estimate project hours (simple heuristic)
    double estimatedHours = _estimateProjectHours(project);
    double estimatedCost = providerRate * estimatedHours;

    if (estimatedCost <= projectBudget) {
      // Provider is within budget
      double efficiency = projectBudget / estimatedCost;
      return min(1.0, efficiency / 2); // Cap at 1.0, reward efficiency
    } else {
      // Provider is over budget
      double overBudgetRatio = estimatedCost / projectBudget;
      if (overBudgetRatio <= 1.2) {
        return 0.8; // Slightly over budget is still acceptable
      } else if (overBudgetRatio <= 1.5) {
        return 0.5; // Moderately over budget
      } else {
        return 0.1; // Significantly over budget
      }
    }
  }

  /// Calculate provider rating score
  double _calculateRatingScore(User serviceProvider) {
    final serviceProfile = serviceProvider.profile?.serviceProviderProfile;
    if (serviceProfile?.averageRating == null) return 0.5; // Neutral for new providers

    double rating = serviceProfile!.averageRating;
    return rating / 5.0; // Normalize to 0-1 scale
  }

  /// Calculate availability score
  double _calculateAvailabilityScore(Project project, User serviceProvider) {
    final serviceProfile = serviceProvider.profile?.serviceProviderProfile;
    
    // Simple availability check based on provider's active status
    if (!serviceProvider.isActive) return 0.0;
    if (serviceProfile?.isAvailable == false) return 0.0;

    // Check if provider has preferred date availability
    if (project.startDate != null) {
      DateTime now = DateTime.now();
      DateTime preferredDate = project.startDate!;
      
      // If preferred date is in the future, assume provider is available
      if (preferredDate.isAfter(now)) {
        return 1.0;
      }
    }

    return 0.8; // Default good availability score
  }

  /// Estimate project duration in hours
  double _estimateProjectHours(Project project) {
    // Simple heuristic based on project category and description
    String category = project.categoryId.toLowerCase();
    String description = project.description.toLowerCase();

    double baseHours = 4.0; // Default 4 hours

    // Category-based estimation
    if (category.contains('تنظيف')) {
      baseHours = 6.0;
    } else if (category.contains('كهرباء')) {
      baseHours = 3.0;
    } else if (category.contains('سباكة')) {
      baseHours = 4.0;
    } else if (category.contains('نجارة')) {
      baseHours = 8.0;
    } else if (category.contains('دهان')) {
      baseHours = 12.0;
    } else if (category.contains('تكييف')) {
      baseHours = 5.0;
    }

    // Adjust based on description keywords
    if (description.contains('كبير') || description.contains('شامل')) {
      baseHours *= 1.5;
    } else if (description.contains('صغير') || description.contains('بسيط')) {
      baseHours *= 0.7;
    }

    // Adjust based on priority
    switch (project.priority) {
      case ProjectPriority.urgent:
        baseHours *= 0.8; // Urgent projects might be simpler
        break;
      case ProjectPriority.high:
        baseHours *= 1.0;
        break;
      case ProjectPriority.medium:
        baseHours *= 1.1;
        break;
      case ProjectPriority.low:
        baseHours *= 1.2;
        break;
    }

    return baseHours;
  }

  /// Calculate service similarity using keyword matching
  double _calculateServiceSimilarity(String projectCategory, List<String> providerServices) {
    String category = projectCategory.toLowerCase();
    double maxSimilarity = 0.0;

    for (String service in providerServices) {
      String serviceText = service.toLowerCase();
      double similarity = _calculateTextSimilarity(category, serviceText);
      maxSimilarity = max(maxSimilarity, similarity);
    }

    return maxSimilarity;
  }

  /// Calculate text similarity using simple keyword matching
  double _calculateTextSimilarity(String text1, String text2) {
    List<String> words1 = text1.split(' ');
    List<String> words2 = text2.split(' ');

    int matchingWords = 0;
    for (String word1 in words1) {
      for (String word2 in words2) {
        if (word1.contains(word2) || word2.contains(word1)) {
          matchingWords++;
          break;
        }
      }
    }

    int totalWords = max(words1.length, words2.length);
    return totalWords > 0 ? matchingWords / totalWords : 0.0;
  }

  /// Generate human-readable match reasons
  List<String> _generateMatchReasons(Project project, User provider, double score) {
    List<String> reasons = [];
    final serviceProfile = provider.profile?.serviceProviderProfile;

    // Category match
    if (serviceProfile?.categories != null && serviceProfile!.categories.isNotEmpty) {
      bool hasMatchingCategory = serviceProfile.categories.any(
        (service) => service.toLowerCase().contains(project.categoryId.toLowerCase())
      );
      if (hasMatchingCategory) {
        reasons.add('يقدم خدمة ${project.categoryId}');
      }
    }

    // Location
    if (provider.profile?.address != null) {
      String projectLocation = project.location?.address ?? project.location?.city ?? '';
      String providerLocation = provider.profile!.address!.toLowerCase();
      projectLocation = projectLocation.toLowerCase();
      
      if (projectLocation.contains(providerLocation) || 
          providerLocation.contains(projectLocation)) {
        reasons.add('يعمل في نفس المنطقة');
      }
    }

    // Rating
    if (serviceProfile?.averageRating != null && serviceProfile!.averageRating >= 4.0) {
      reasons.add('تقييم عالي (${serviceProfile.averageRating.toStringAsFixed(1)} نجوم)');
    }

    // Experience
    if (serviceProfile?.yearsOfExperience != null && serviceProfile!.yearsOfExperience >= 3) {
      reasons.add('خبرة ${serviceProfile.yearsOfExperience} سنوات');
    }

    // Budget compatibility
    if (serviceProfile?.hourlyRate != null) {
      double estimatedHours = _estimateProjectHours(project);
      double estimatedCost = serviceProfile!.hourlyRate * estimatedHours;
      if (estimatedCost <= project.budget) {
        reasons.add('ضمن الميزانية المحددة');
      }
    }

    // Overall score
    if (score >= 0.8) {
      reasons.add('مطابقة ممتازة');
    } else if (score >= 0.6) {
      reasons.add('مطابقة جيدة');
    }

    return reasons;
  }

  /// Get AI-powered project recommendations for service providers
  List<ProjectRecommendation> getProjectRecommendations(User serviceProvider, List<Project> availableProjects) {
    List<ProjectRecommendation> recommendations = [];

    for (Project project in availableProjects) {
      if (project.status != ProjectStatus.published) continue;

      double score = calculateMatchingScore(project, serviceProvider);
      
      if (score >= 0.4) { // Lower threshold for recommendations
        recommendations.add(ProjectRecommendation(
          project: project,
          score: score,
          reasons: _generateProjectRecommendationReasons(project, serviceProvider, score),
          estimatedEarnings: _calculateEstimatedEarnings(project, serviceProvider),
        ));
      }
    }

    // Sort by score and potential earnings
    recommendations.sort((a, b) {
      double scoreA = a.score * 0.7 + (a.estimatedEarnings / 1000) * 0.3;
      double scoreB = b.score * 0.7 + (b.estimatedEarnings / 1000) * 0.3;
      return scoreB.compareTo(scoreA);
    });

    return recommendations.take(5).toList();
  }

  /// Generate project recommendation reasons
  List<String> _generateProjectRecommendationReasons(Project project, User provider, double score) {
    List<String> reasons = [];
    final serviceProfile = provider.profile?.serviceProviderProfile;

    // Category match
    if (serviceProfile?.categories != null && serviceProfile!.categories.isNotEmpty) {
      bool hasMatchingCategory = serviceProfile.categories.any(
        (service) => project.categoryId.toLowerCase().contains(service.toLowerCase())
      );
      if (hasMatchingCategory) {
        reasons.add('يتطابق مع خدماتك');
      }
    }

    // Budget attractiveness
    double estimatedEarnings = _calculateEstimatedEarnings(project, provider);
    if (estimatedEarnings >= 500) {
      reasons.add('عائد مالي جيد');
    }

    // Priority
    if (project.priority == ProjectPriority.urgent) {
      reasons.add('مشروع عاجل');
    } else if (project.priority == ProjectPriority.high) {
      reasons.add('أولوية عالية');
    }

    // Location convenience
    if (provider.profile?.address != null) {
      String projectLocation = project.location?.address ?? project.location?.city ?? '';
      String providerLocation = provider.profile!.address!.toLowerCase();
      projectLocation = projectLocation.toLowerCase();
      
      if (projectLocation.contains(providerLocation) || 
          providerLocation.contains(projectLocation)) {
        reasons.add('قريب من موقعك');
      }
    }

    return reasons;
  }

  /// Calculate estimated earnings for a project
  double _calculateEstimatedEarnings(Project project, User provider) {
    final serviceProfile = provider.profile?.serviceProviderProfile;
    if (serviceProfile?.hourlyRate == null) return project.budget * 0.8; // Assume 80% of budget

    double estimatedHours = _estimateProjectHours(project);
    double estimatedEarnings = serviceProfile!.hourlyRate * estimatedHours;
    
    // Cap at project budget
    return min(estimatedEarnings, project.budget);
  }
}

/// Result of AI matching between project and service provider
class MatchResult {
  final User provider;
  final double score;
  final List<String> reasons;

  MatchResult({
    required this.provider,
    required this.score,
    required this.reasons,
  });
}

/// AI recommendation for service providers
class ProjectRecommendation {
  final Project project;
  final double score;
  final List<String> reasons;
  final double estimatedEarnings;

  ProjectRecommendation({
    required this.project,
    required this.score,
    required this.reasons,
    required this.estimatedEarnings,
  });
}
