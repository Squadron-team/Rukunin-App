import 'package:flutter/material.dart';
import 'package:rukunin/pages/general/onboarding/pages/welcome_page.dart';
import 'package:rukunin/pages/general/onboarding/pages/ktp_page.dart';
import 'package:rukunin/pages/general/onboarding/pages/kk_page.dart';
import 'package:rukunin/pages/general/onboarding/widgets/progress_indicator.dart';
import 'package:rukunin/pages/general/onboarding/widgets/navigation_buttons.dart';
import 'package:rukunin/pages/general/onboarding/state/onboarding_state.dart';
import 'package:rukunin/pages/general/onboarding/services/onboarding_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _onboardingState = OnboardingState();
  final _onboardingService = OnboardingService();

  int _currentPage = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _onboardingState.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      if (_validateCurrentPage()) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _submitOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateCurrentPage() {
    if (_currentPage == 0) {
      return true;
    } else if (_currentPage == 1) {
      return _onboardingState.validateKTPData(context);
    } else if (_currentPage == 2) {
      return _onboardingState.validateKKData(context);
    }
    return true;
  }

  Future<void> _submitOnboarding() async {
    if (!_validateCurrentPage()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _onboardingService.submitOnboardingData(
        context,
        _onboardingState,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            OnboardingProgressIndicator(currentPage: _currentPage),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  const WelcomePage(),
                  KTPPage(state: _onboardingState),
                  KKPage(state: _onboardingState),
                ],
              ),
            ),
            NavigationButtons(
              currentPage: _currentPage,
              isLoading: _isLoading,
              onNext: _nextPage,
              onPrevious: _previousPage,
            ),
          ],
        ),
      ),
    );
  }
}
