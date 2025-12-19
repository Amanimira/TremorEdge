import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tremor_ring_app/models/emergency_contact.dart';
import 'package:tremor_ring_app/utils/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  
  // Form Controllers
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _contactNameController;
  late TextEditingController _contactPhoneController;
  
  // User Data
  String? _selectedGender;
  double _tremorSensitivity = 5.0;
  List<Map<String, String>> _emergencyContacts = [];
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _contactNameController = TextEditingController();
    _contactPhoneController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _contactNameController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  /// الانتقال إلى الصفحة التالية
  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  /// العودة إلى الصفحة السابقة
  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// حفظ بيانات المستخدم وإنهاء الإعداد الأولي
  Future<void> _completeOnboarding() async {
    try {
      final prefs = Hive.box('app_preferences');
      
      // حفظ بيانات المستخدم
      await prefs.put('user_name', _nameController.text);
      await prefs.put('user_age', int.parse(_ageController.text));
      await prefs.put('user_gender', _selectedGender ?? 'other');
      await prefs.put('tremor_sensitivity', _tremorSensitivity);
      
      // حفظ جهات الاتصال الطارئة
      final contactsBox = Hive.box<EmergencyContact>('emergency_contacts');
      for (var contact in _emergencyContacts) {
        final emergencyContact = EmergencyContact(
          name: contact['name'] ?? '',
          phone: contact['phone'] ?? '',
          isPrimary: _emergencyContacts.indexOf(contact) == 0, relation: '',
        );
        await contactsBox.add(emergencyContact);
      }
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: ${e.toString()}')),
      );
    }
  }

  /// إضافة جهة اتصال طارئة
  void _addEmergencyContact() {
    if (_contactNameController.text.isEmpty || _contactPhoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
      return;
    }

    setState(() {
      _emergencyContacts.add({
        'name': _contactNameController.text,
        'phone': _contactPhoneController.text,
      });
      _contactNameController.clear();
      _contactPhoneController.clear();
    });
  }

  /// حذف جهة اتصال طارئة
  void _removeEmergencyContact(int index) {
    setState(() {
      _emergencyContacts.removeAt(index);
    });
  }

  /// الصفحة 1: شاشة الترحيب
  Widget _buildWelcomePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          
          // الأيقونة
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite,
              size: 60,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 40),

          // العنوان
          Text(
            'أهلاً بك في Tremor Guard',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // الوصف
          Text(
            'تطبيق ذكي لمراقبة رعشة الرجفان في مرضى الشلل الرعاش',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 60),

          // المزايا
          _buildFeatureItem(
            icon: Icons.watch,
            title: 'مراقبة مستمرة',
            description: 'راقب رعشتك على مدار اليوم',
          ),
          const SizedBox(height: 20),
          _buildFeatureItem(
            icon: Icons.notifications_active,
            title: 'تنبيهات فورية',
            description: 'احصل على تنبيهات فوراً عند اكتشاف تفاقم',
          ),
          const SizedBox(height: 20),
          _buildFeatureItem(
            icon: Icons.people,
            title: 'جهات اتصال طارئة',
            description: 'أبلغ أحبائك تلقائياً في الحالات الطارئة',
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  /// بناء عنصر المزايا
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// الصفحة 2: بيانات المستخدم
  Widget _buildUserInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          // العنوان
          Text(
            'معلوماتك الشخصية',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'ساعدنا على فهم وضعك الصحي بشكل أفضل',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 40),

          // حقل الاسم
          Text('الاسم', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'أدخل اسمك الكامل',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // حقل العمر
          Text('العمر', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'أدخل عمرك',
              prefixIcon: const Icon(Icons.cake),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // حقل الجنس
          Text('الجنس', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: _selectedGender,
              hint: const Text('اختر جنسك'),
              isExpanded: true,
              underline: const SizedBox(),
              items: ['ذكر', 'أنثى', 'آخر'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(value),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() => _selectedGender = value);
              },
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  /// الصفحة 3: جهات الاتصال الطارئة
  Widget _buildEmergencyContactsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          Text(
            'جهات الاتصال الطارئة',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'أضف أشخاصاً لإبلاغهم في حالة الطوارئ (حتى 3)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 32),

          // حقول الإدخال
          TextField(
            controller: _contactNameController,
            decoration: InputDecoration(
              labelText: 'اسم المتصل',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: _contactPhoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'رقم الهاتف',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // زر الإضافة
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _emergencyContacts.length < 3 ? _addEmergencyContact : null,
              icon: const Icon(Icons.add),
              label: const Text('إضافة جهة اتصال'),
            ),
          ),

          const SizedBox(height: 32),

          // قائمة جهات الاتصال
          if (_emergencyContacts.isEmpty)
            Center(
              child: Text(
                'لم تُضف أي جهات اتصال بعد',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _emergencyContacts.length,
              itemBuilder: (context, index) {
                final contact = _emergencyContacts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact['name'] ?? '',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                contact['phone'] ?? '',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeEmergencyContact(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  /// الصفحة 4: معايرة حساسية الرعشة
  Widget _buildTremorSensitivityPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          Text(
            'معايرة حساسية الكشف',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'اضبط حساسية كشف الرعشة حسب احتياجاتك',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 60),

          // عرض القيمة الحالية
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'الحساسية الحالية',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _tremorSensitivity.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 60),

          // مؤشر الحساسية
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('منخفضة', style: Theme.of(context).textTheme.bodySmall),
                    Text('عالية', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Slider(
                value: _tremorSensitivity,
                min: 1,
                max: 10,
                divisions: 9,
                label: _tremorSensitivity.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() => _tremorSensitivity = value);
                },
              ),
            ],
          ),

          const SizedBox(height: 40),

          // الوصف
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ملاحظات:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• حساسية منخفضة = تنبيهات أقل (رعشات شديدة فقط)\n• حساسية عالية = تنبيهات أكثر (رعشات خفيفة وشديدة)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  /// الصفحة 5: توصيل الحلقة الذكية
  Widget _buildRingConnectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          Text(
            'توصيل الحلقة الذكية',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'ربط الحلقة الذكية عبر البلوتوث',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 60),

          // رسم توضيحي
          Center(
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bluetooth,
                size: 80,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 60),

          // خطوات الاتصال
          _buildConnectionStep(
            number: 1,
            title: 'تشغيل وضع البلوتوث',
            description: 'تأكد من تشغيل البلوتوث على الهاتف والحلقة',
          ),
          const SizedBox(height: 20),
          _buildConnectionStep(
            number: 2,
            title: 'البحث عن الأجهزة',
            description: 'ستظهر "TremorRing" في قائمة الأجهزة المتاحة',
          ),
          const SizedBox(height: 20),
          _buildConnectionStep(
            number: 3,
            title: 'تأكيد الاتصال',
            description: 'انقر على الحلقة لإكمال الربط',
          ),

          const SizedBox(height: 60),

          // ملاحظة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'يمكنك ربط الحلقة لاحقاً من إعدادات التطبيق',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.amber[900],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  /// بناء خطوة الاتصال
  Widget _buildConnectionStep({
    required int number,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // صفحات الإعداد الأولي
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            children: [
              _buildWelcomePage(),
              _buildUserInfoPage(),
              _buildEmergencyContactsPage(),
              _buildTremorSensitivityPage(),
              _buildRingConnectionPage(),
            ],
          ),

          // مؤشرات الصفحات والأزرار
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              child: Column(
                children: [
                  // مؤشرات الصفحات
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == _currentPage
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // الأزرار
                  Row(
                    children: [
                      // زر السابق
                      if (_currentPage > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousPage,
                            child: const Text('السابق'),
                          ),
                        ),
                      if (_currentPage > 0) const SizedBox(width: 12),

                      // زر التالي / إنهاء
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          child: Text(
                            _currentPage == 4 ? 'إنهاء' : 'التالي',
                          ),
                        ),
                      ),
                    ],
                  ),

                  // رقم الصفحة الحالية
                  const SizedBox(height: 12),
                  Text(
                    'الخطوة ${_currentPage + 1} من 5',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
