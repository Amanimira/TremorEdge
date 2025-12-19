import 'package:flutter/material.dart';
import 'package:tremor_ring_app/utils/colors.dart';


/// Splash Screen - شاشة البداية
/// تظهر عند فتح التطبيق مع animation جميلة
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    // تهيئة Animation Controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Scale Animation - تكبير النص
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Fade Animation - تلاشي النص
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Slide Animation - انزلاق الـ Subtitle
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // بدء الـ Animation
    _animationController.forward();

    // الانتقال للشاشة الرئيسية بعد 3 ثوان
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var SvgPicture;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.primary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogoSection(),
  
                // الشعار أو الأيقونة
                _buildLogoSection(),
                    const SizedBox(height: 40),
                SvgPicture.asset('assets/images/app_icon.svg', // مسار الملف
               height: 100, // الطول (اختياري)
               width: 100,  ),

                // العنوان الرئيسي
                _buildMainTitle(),
                const SizedBox(height: 16),

                // الـ Subtitle
                _buildSubtitle(),
                const SizedBox(height: 60),

                // شريط التحميل
                _buildLoadingBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ==================== Logo Section ====================
  Widget _buildLogoSection() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: 0.1),
          border: Border.all(
            color: AppColors.primary,
            width: 3,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.favorite,
            size: 60,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  /// ==================== Main Title ====================
  Widget _buildMainTitle() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          children: [
            Text(
              'Tremor Guard',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
              ),
              textAlign: TextAlign.center,
              semanticsLabel: 'Tremor Guard التطبيق',
            ),
            const SizedBox(height: 8),
            Text(
              'TremorEdge',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ==================== Subtitle ====================
  Widget _buildSubtitle() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Semantics(
          label: 'وصف التطبيق',
          child: Text(
            'مراقبة صحتك بأمان',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
              ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  /// ==================== Loading Bar ====================
  Widget _buildLoadingBar() {
    return Column(
      children: [
        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            minHeight: 8,
            backgroundColor: AppColors.textSecondary.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(height: 20),

        // Loading Text
        FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'جاري التحميل...',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
              ),
          ),
        ),
      ],
    );
  }
}

/// ==================== Onboarding Screen ====================
/// شاشة التعريف بالتطبيق
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'مراقبة مستمرة',
      description: 'راقب صحتك بشكل مستمر على مدار اليوم',
      icon: Icons.favorite,
      color: Colors.red,
    ),
    OnboardingPage(
      title: 'كشف ذكي',
      description: 'تقنيات متقدمة لكشف الحالات الطارئة',
      icon: Icons.smart_toy,
      color: Colors.blue,
    ),
    OnboardingPage(
      title: 'طوارئ آمنة',
      description: 'تنبيهات فورية لجهات الطوارئ المدرجة',
      icon: Icons.phone_in_talk,
      color: Colors.green,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildOnboardingPage(_pages[index]);
            },
          ),

          // Indicators
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: _buildIndicators(),
          ),

          // Buttons
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: _buildButtons(),
          ),
        ],
      ),
    );
  }

  /// ==================== Onboarding Page ====================
  Widget _buildOnboardingPage(OnboardingPage page) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: page.color.withValues(alpha: 0.1),
              ),
              child: Icon(
                page.icon,
                size: 60,
                color: page.color,
              ),
            ),
            const SizedBox(height: 40),

            // Title
            Text(
              page.title,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              page.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// ==================== Indicators ====================
  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => Semantics(
          label: 'الصفحة ${index + 1}',
          child: GestureDetector(
            onTap: () => _pageController.jumpToPage(index),
            child: Container(
              width: _currentPage == index ? 32 : 12,
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: _currentPage == index
                    ? AppColors.primary
                    : AppColors.textSecondary.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ==================== Buttons ====================
  Widget _buildButtons() {
    return Row(
      children: [
        // Skip Button
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
            child: const Text('تخطي'),
          ),
        ),
        const SizedBox(width: 16),

        // Next/Done Button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_currentPage == _pages.length - 1) {
                Navigator.of(context).pushReplacementNamed('/home');
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(
              _currentPage == _pages.length - 1 ? 'ابدأ' : 'التالي',
            ),
          ),
        ),
      ],
    );
  }
}

/// ==================== Data Model ====================
class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
