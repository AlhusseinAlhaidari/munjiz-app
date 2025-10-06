# منجز (Munjiz) - سوق خدمات المنزل الذكي

[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)](https://github.com/username/munjiz)
[![Flutter Version](https://img.shields.io/badge/flutter-3.24.5-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 📱 نظرة عامة

**منجز** هو تطبيق متقدم يربط بين العملاء ومقدمي الخدمات المنزلية، مع نظام ذكي لإدارة المشاريع ومطابقة الخدمات باستخدام الذكاء الاصطناعي.

## ✨ الميزات الرئيسية

### 🎯 للعملاء
- **إنشاء مشاريع متقدمة** مع تقسيم المهام والمعالم
- **نظام مطابقة ذكي** يقترح أفضل مقدمي الخدمات
- **إدارة شاملة للمشاريع** مع تتبع التقدم
- **نظام دفع آمن** مع خدمة الضمان (Escrow)
- **تقييمات ومراجعات** شاملة

### 🔧 لمقدمي الخدمات
- **ملف شخصي احترافي** مع معرض الأعمال
- **إدارة العروض والمناقصات** بسهولة
- **تتبع الأرباح والإحصائيات** المفصلة
- **نظام تقييم متقدم** لبناء السمعة
- **أدوات تواصل متطورة** مع العملاء

### 🤖 الذكاء الاصطناعي
- **مطابقة ذكية** بين المشاريع ومقدمي الخدمات
- **تحليل المهارات والخبرات** تلقائياً
- **توقع التكاليف والمدة** بدقة عالية
- **اقتراحات محسنة** لتحسين الأداء

### 💬 التواصل والتعاون
- **محادثات فورية** مع إشعارات ذكية
- **مكالمات فيديو** عالية الجودة
- **مشاركة الملفات** والمستندات
- **تتبع المشاريع** في الوقت الفعلي

## 🏗️ الهندسة المعمارية

يتبع التطبيق مبادئ **Clean Architecture** مع فصل واضح للطبقات:

```
lib/
├── core/                    # الأساسيات المشتركة
│   ├── constants/          # الثوابت والإعدادات
│   ├── errors/             # إدارة الأخطاء
│   ├── network/            # طبقة الشبكة
│   ├── themes/             # التصميم والألوان
│   └── utils/              # الأدوات المساعدة
├── data/                   # طبقة البيانات
│   ├── datasources/        # مصادر البيانات
│   ├── models/             # نماذج البيانات
│   └── repositories/       # تنفيذ المستودعات
├── domain/                 # طبقة المنطق التجاري
│   ├── entities/           # الكيانات الأساسية
│   ├── repositories/       # واجهات المستودعات
│   └── usecases/          # حالات الاستخدام
└── presentation/           # طبقة العرض
    ├── bloc/              # إدارة الحالة
    ├── pages/             # الصفحات
    └── widgets/           # المكونات المخصصة
```

## 🛠️ التقنيات المستخدمة

### Frontend (Flutter)
- **Flutter 3.24.5** - إطار العمل الأساسي
- **Dart 3.5.4** - لغة البرمجة
- **BLoC Pattern** - إدارة الحالة
- **Go Router** - التنقل المتقدم
- **Hive** - قاعدة البيانات المحلية

### Backend Integration
- **Dio** - HTTP Client متقدم
- **Retrofit** - REST API Client
- **Socket.IO** - التواصل الفوري
- **Firebase** - المصادقة والإشعارات

### UI/UX
- **Material Design 3** - نظام التصميم
- **Custom Themes** - تصميم مخصص
- **Lottie Animations** - الرسوم المتحركة
- **Shimmer Effects** - تأثيرات التحميل

### الميزات المتقدمة
- **AI/ML Integration** - TensorFlow Lite
- **Video Calls** - Agora RTC Engine
- **Maps & Location** - Google Maps
- **Payments** - Stripe Integration
- **File Handling** - متعدد الأنواع

## 🚀 البدء السريع

### المتطلبات الأساسية
- Flutter SDK 3.24.5+
- Dart SDK 3.5.4+
- Android Studio / VS Code
- Git

### التثبيت

1. **استنساخ المشروع**
```bash
git clone https://github.com/username/munjiz.git
cd munjiz
```

2. **تثبيت التبعيات**
```bash
flutter pub get
```

3. **إعداد Firebase**
```bash
# إضافة ملفات التكوين
# android/app/google-services.json
# ios/Runner/GoogleService-Info.plist
```

4. **تشغيل التطبيق**
```bash
flutter run
```

### إعداد البيئة

1. **متغيرات البيئة**
```bash
# إنشاء ملف .env
GOOGLE_MAPS_API_KEY=your_api_key
STRIPE_PUBLISHABLE_KEY=your_stripe_key
AGORA_APP_ID=your_agora_id
```

2. **إعداد قاعدة البيانات**
```bash
# تشغيل الخادم المحلي
flutter packages pub run build_runner build
```

## 📊 الاختبارات

### تشغيل الاختبارات
```bash
# اختبارات الوحدة
flutter test

# اختبارات التكامل
flutter test integration_test/

# تحليل الكود
flutter analyze
```

### تغطية الاختبارات
```bash
# إنشاء تقرير التغطية
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 📱 لقطات الشاشة

| الصفحة الرئيسية | المشاريع | المحادثات |
|:---:|:---:|:---:|
| ![Home](screenshots/home.png) | ![Projects](screenshots/projects.png) | ![Chat](screenshots/chat.png) |

## 🔧 التطوير

### إضافة ميزة جديدة
1. إنشاء فرع جديد: `git checkout -b feature/new-feature`
2. تطوير الميزة مع الاختبارات
3. تشغيل الاختبارات: `flutter test`
4. إرسال Pull Request

### معايير الكود
- اتباع [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- استخدام `flutter analyze` للتحقق من الكود
- كتابة اختبارات شاملة للميزات الجديدة
- توثيق الكود باللغة العربية

## 🚀 النشر

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT - راجع ملف [LICENSE](LICENSE) للتفاصيل.

## 🤝 المساهمة

نرحب بالمساهمات! يرجى قراءة [دليل المساهمة](CONTRIBUTING.md) للتفاصيل.

## 📞 التواصل

- **البريد الإلكتروني**: contact@munjiz.com
- **الموقع الإلكتروني**: [www.munjiz.com](https://www.munjiz.com)
- **تويتر**: [@MunjizApp](https://twitter.com/MunjizApp)

## 🙏 شكر وتقدير

- فريق Flutter لإطار العمل الرائع
- مجتمع المطورين العرب للدعم المستمر
- جميع المساهمين في هذا المشروع

---

**منجز** - حيث تلتقي الخدمات بالتميز 🏠✨
