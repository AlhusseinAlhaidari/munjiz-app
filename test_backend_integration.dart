#!/usr/bin/env dart
// Test script for Backend integration

import 'dart:convert';
import 'dart:io';

void main() async {
  print('🧪 بدء اختبار تكامل Backend مع Flutter...\n');

  final client = HttpClient();
  const baseUrl = 'http://localhost:5000/api';

  try {
    // Test 1: Health Check
    print('1️⃣ اختبار Health Check...');
    final healthRequest = await client.getUrl(Uri.parse('$baseUrl/health'));
    final healthResponse = await healthRequest.close();
    final healthBody = await healthResponse.transform(utf8.decoder).join();
    
    if (healthResponse.statusCode == 200) {
      final healthData = json.decode(healthBody);
      print('✅ Health Check نجح: ${healthData['status']}');
    } else {
      print('❌ Health Check فشل: ${healthResponse.statusCode}');
      return;
    }

    // Test 2: Register User
    print('\n2️⃣ اختبار تسجيل مستخدم جديد...');
    final registerRequest = await client.postUrl(Uri.parse('$baseUrl/auth/register'));
    registerRequest.headers.set('Content-Type', 'application/json');
    
    final registerData = {
      'firstName': 'محمد',
      'lastName': 'أحمد',
      'email': 'test_flutter@example.com',
      'password': 'password123',
      'userType': 'client',
      'phoneNumber': '+966501234567'
    };
    
    registerRequest.add(utf8.encode(json.encode(registerData)));
    final registerResponse = await registerRequest.close();
    final registerBody = await registerResponse.transform(utf8.decoder).join();
    
    String? accessToken;
    if (registerResponse.statusCode == 201) {
      final registerResult = json.decode(registerBody);
      accessToken = registerResult['accessToken'];
      print('✅ تسجيل المستخدم نجح: ${registerResult['user']['firstName']}');
      print('🔑 Token: ${accessToken?.substring(0, 20)}...');
    } else if (registerResponse.statusCode == 409) {
      print('⚠️ المستخدم موجود مسبقاً، سنحاول تسجيل الدخول...');
      
      // Try login instead
      final loginRequest = await client.postUrl(Uri.parse('$baseUrl/auth/login'));
      loginRequest.headers.set('Content-Type', 'application/json');
      
      final loginData = {
        'email': 'test_flutter@example.com',
        'password': 'password123'
      };
      
      loginRequest.add(utf8.encode(json.encode(loginData)));
      final loginResponse = await loginRequest.close();
      final loginBody = await loginResponse.transform(utf8.decoder).join();
      
      if (loginResponse.statusCode == 200) {
        final loginResult = json.decode(loginBody);
        accessToken = loginResult['accessToken'];
        print('✅ تسجيل الدخول نجح: ${loginResult['user']['firstName']}');
        print('🔑 Token: ${accessToken?.substring(0, 20)}...');
      } else {
        print('❌ تسجيل الدخول فشل: ${loginResponse.statusCode}');
        print('Response: $loginBody');
        return;
      }
    } else {
      print('❌ تسجيل المستخدم فشل: ${registerResponse.statusCode}');
      print('Response: $registerBody');
      return;
    }

    if (accessToken == null) {
      print('❌ لم يتم الحصول على Token');
      return;
    }

    // Test 3: Get Current User
    print('\n3️⃣ اختبار الحصول على معلومات المستخدم الحالي...');
    final userRequest = await client.getUrl(Uri.parse('$baseUrl/auth/me'));
    userRequest.headers.set('Authorization', 'Bearer $accessToken');
    final userResponse = await userRequest.close();
    final userBody = await userResponse.transform(utf8.decoder).join();
    
    if (userResponse.statusCode == 200) {
      final userData = json.decode(userBody);
      print('✅ الحصول على معلومات المستخدم نجح: ${userData['user']['firstName']} ${userData['user']['lastName']}');
    } else {
      print('❌ الحصول على معلومات المستخدم فشل: ${userResponse.statusCode}');
      print('Response: $userBody');
    }

    // Test 4: Create Project
    print('\n4️⃣ اختبار إنشاء مشروع جديد...');
    final projectRequest = await client.postUrl(Uri.parse('$baseUrl/projects'));
    projectRequest.headers.set('Content-Type', 'application/json');
    projectRequest.headers.set('Authorization', 'Bearer $accessToken');
    
    final projectData = {
      'title': 'تنظيف المنزل - اختبار Flutter',
      'description': 'مشروع اختبار من تطبيق Flutter',
      'categoryId': 'cleaning',
      'budget': 300.0,
      'priority': 'medium'
    };
    
    projectRequest.add(utf8.encode(json.encode(projectData)));
    final projectResponse = await projectRequest.close();
    final projectBody = await projectResponse.transform(utf8.decoder).join();
    
    String? projectId;
    if (projectResponse.statusCode == 201) {
      final projectResult = json.decode(projectBody);
      projectId = projectResult['projectId'];
      print('✅ إنشاء المشروع نجح: $projectId');
    } else {
      print('❌ إنشاء المشروع فشل: ${projectResponse.statusCode}');
      print('Response: $projectBody');
    }

    // Test 5: Get Projects
    print('\n5️⃣ اختبار الحصول على قائمة المشاريع...');
    final projectsRequest = await client.getUrl(Uri.parse('$baseUrl/projects'));
    projectsRequest.headers.set('Authorization', 'Bearer $accessToken');
    final projectsResponse = await projectsRequest.close();
    final projectsBody = await projectsResponse.transform(utf8.decoder).join();
    
    if (projectsResponse.statusCode == 200) {
      final projectsData = json.decode(projectsBody);
      final projects = projectsData['projects'] as List;
      print('✅ الحصول على المشاريع نجح: ${projects.length} مشروع');
      
      if (projects.isNotEmpty) {
        final firstProject = projects.first;
        print('   📋 أول مشروع: ${firstProject['title']}');
        print('   💰 الميزانية: ${firstProject['budget']} ريال');
        print('   📊 الحالة: ${firstProject['status']}');
      }
    } else {
      print('❌ الحصول على المشاريع فشل: ${projectsResponse.statusCode}');
      print('Response: $projectsBody');
    }

    // Test 6: Get Categories
    print('\n6️⃣ اختبار الحصول على فئات الخدمات...');
    final categoriesRequest = await client.getUrl(Uri.parse('$baseUrl/categories'));
    final categoriesResponse = await categoriesRequest.close();
    final categoriesBody = await categoriesResponse.transform(utf8.decoder).join();
    
    if (categoriesResponse.statusCode == 200) {
      final categoriesData = json.decode(categoriesBody);
      final categories = categoriesData['categories'] as List;
      print('✅ الحصول على الفئات نجح: ${categories.length} فئة');
      
      for (final category in categories) {
        print('   🏷️ ${category['name']} (${category['id']})');
      }
    } else {
      print('❌ الحصول على الفئات فشل: ${categoriesResponse.statusCode}');
      print('Response: $categoriesBody');
    }

    // Test 7: Publish Project (if we have a project)
    if (projectId != null) {
      print('\n7️⃣ اختبار نشر المشروع...');
      final publishRequest = await client.postUrl(Uri.parse('$baseUrl/projects/$projectId/publish'));
      publishRequest.headers.set('Authorization', 'Bearer $accessToken');
      final publishResponse = await publishRequest.close();
      final publishBody = await publishResponse.transform(utf8.decoder).join();
      
      if (publishResponse.statusCode == 200) {
        print('✅ نشر المشروع نجح');
      } else {
        print('❌ نشر المشروع فشل: ${publishResponse.statusCode}');
        print('Response: $publishBody');
      }
    }

    print('\n🎉 انتهى اختبار التكامل بنجاح!');
    print('📱 يمكن الآن ربط تطبيق Flutter مع Backend');

  } catch (e) {
    print('❌ خطأ في الاختبار: $e');
  } finally {
    client.close();
  }
}
