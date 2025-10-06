import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/themes/app_theme.dart';
import '../../../domain/entities/user.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_overlay.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  UserType _selectedUserType = UserType.client;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى الموافقة على الشروط والأحكام'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneController.text.trim().isNotEmpty 
              ? _phoneController.text.trim() 
              : null,
          userType: _selectedUserType,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthEmailVerificationPending) {
          Navigator.of(context).pushReplacementNamed('/email-verification');
        } else if (state is AuthError) {
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
          isLoading: state is AuthLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('إنشاء حساب جديد'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      _buildHeader(),
                      
                      const SizedBox(height: 32),
                      
                      // User Type Selection
                      _buildUserTypeSelection(),
                      
                      const SizedBox(height: 24),
                      
                      // Personal Information
                      _buildPersonalInformation(),
                      
                      const SizedBox(height: 24),
                      
                      // Account Information
                      _buildAccountInformation(),
                      
                      const SizedBox(height: 24),
                      
                      // Terms and Conditions
                      _buildTermsCheckbox(),
                      
                      const SizedBox(height: 32),
                      
                      // Register Button
                      CustomButton(
                        text: 'إنشاء الحساب',
                        onPressed: _handleRegister,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Login Link
                      _buildLoginLink(),
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
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.person_add,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'انضم إلى منجز',
          style: AppTheme.headingLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'أنشئ حسابك واستمتع بخدماتنا',
          style: AppTheme.bodyLarge.copyWith(
            color: AppTheme.secondaryTextColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUserTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الحساب',
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              RadioListTile<UserType>(
                title: const Text('عميل'),
                subtitle: const Text('أبحث عن خدمات منزلية'),
                value: UserType.client,
                groupValue: _selectedUserType,
                onChanged: (value) {
                  setState(() {
                    _selectedUserType = value!;
                  });
                },
              ),
              const Divider(height: 1),
              RadioListTile<UserType>(
                title: const Text('مقدم خدمة'),
                subtitle: const Text('أقدم خدمات منزلية'),
                value: UserType.serviceProvider,
                groupValue: _selectedUserType,
                onChanged: (value) {
                  setState(() {
                    _selectedUserType = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المعلومات الشخصية',
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _firstNameController,
                label: 'الاسم الأول',
                prefixIcon: Icons.person_outlined,
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
                prefixIcon: Icons.person_outlined,
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
          controller: _phoneController,
          label: 'رقم الهاتف (اختياري)',
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone_outlined,
          validator: (value) {
            if (value?.isNotEmpty ?? false) {
              if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value!)) {
                return 'يرجى إدخال رقم هاتف صحيح';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAccountInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معلومات الحساب',
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          label: 'البريد الإلكتروني',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'يرجى إدخال البريد الإلكتروني';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'يرجى إدخال بريد إلكتروني صحيح';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          label: 'كلمة المرور',
          obscureText: !_isPasswordVisible,
          prefixIcon: Icons.lock_outlined,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'يرجى إدخال كلمة المرور';
            }
            if (value!.length < 8) {
              return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _confirmPasswordController,
          label: 'تأكيد كلمة المرور',
          obscureText: !_isConfirmPasswordVisible,
          prefixIcon: Icons.lock_outlined,
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
            },
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'يرجى تأكيد كلمة المرور';
            }
            if (value != _passwordController.text) {
              return 'كلمة المرور غير متطابقة';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'أوافق على ',
              style: AppTheme.bodyMedium,
              children: [
                TextSpan(
                  text: 'الشروط والأحكام',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' و '),
                TextSpan(
                  text: 'سياسة الخصوصية',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لديك حساب بالفعل؟ ',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.secondaryTextColor,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'تسجيل الدخول',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
