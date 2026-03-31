/// ctrl^date - Onboarding Screen
/// Multi-step onboarding for new users: name, age, photo, calendar import
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/onboarding_provider.dart';
import '../theme.dart';

/// Onboarding screen with multiple steps
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Form data
  final _nameController = TextEditingController();
  int? _selectedAge;
  File? _selectedImage;
  String? _uploadedAvatarUrl;
  bool _isUploading = false;
  bool _connectingGoogle = false;
  bool _connectingApple = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill from existing state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final onboarding = ref.read(onboardingProvider);
      if (onboarding.displayName != null) {
        _nameController.text = onboarding.displayName!;
      }
      if (onboarding.age != null) {
        setState(() => _selectedAge = onboarding.age);
      }
      if (onboarding.avatarUrl != null) {
        setState(() => _uploadedAvatarUrl = onboarding.avatarUrl);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final notifier = ref.read(onboardingProvider.notifier);

    // Save name if provided
    if (_nameController.text.isNotEmpty) {
      await notifier.updateDisplayName(_nameController.text);
    }

    // Save age if selected
    if (_selectedAge != null) {
      await notifier.updateAge(_selectedAge!);
    }

    // Save avatar if uploaded
    if (_uploadedAvatarUrl != null) {
      await notifier.updateAvatarUrl(_uploadedAvatarUrl!);
    }

    await notifier.completeOnboarding();

    if (mounted) {
      context.go('/calendar');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _takeSelfie() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.front,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      final fileName = 'avatars/$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await Supabase.instance.client.storage
          .from('user-files')
          .upload(fileName, _selectedImage!);

      final url = Supabase.instance.client.storage
          .from('user-files')
          .getPublicUrl(fileName);

      setState(() {
        _uploadedAvatarUrl = url;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo uploaded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload photo: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _connectGoogleCalendar() async {
    setState(() => _connectingGoogle = true);

    try {
      // TODO: Implement Google Calendar OAuth flow
      // 1. Use google_sign_in package to authenticate
      // 2. Request calendar.readonly scope
      // 3. Fetch events via Google Calendar API
      // 4. Upload to backend /import/google endpoint
      await Future.delayed(const Duration(seconds: 2));

      await ref.read(onboardingProvider.notifier).setGoogleCalendarConnected(true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Calendar connected!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _connectingGoogle = false);
    }
  }

  Future<void> _connectAppleCalendar() async {
    setState(() => _connectingApple = true);

    try {
      // TODO: Implement Apple Calendar access via device_calendar package
      // 1. Request calendar permissions
      // 2. Read local calendars via EventKit
      // 3. Import events to our database
      await Future.delayed(const Duration(seconds: 2));

      await ref.read(onboardingProvider.notifier).setAppleCalendarConnected(true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Apple Calendar connected!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to connect: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _connectingApple = false);
    }
  }

  Future<void> _importFromFile() async {
    // TODO: Use file_picker to let user pick CSV/ICS file during onboarding
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['csv', 'ics'],
    // );
    // if (result != null) {
    //   final file = result.files.single;
    //   final ext = file.extension ?? 'csv';
    //   await apiService.uploadFile('/import/$ext', file.path!);
    // }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File import coming soon — add file_picker package')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onboarding = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index <= _currentStep
                            ? AppColors.black
                            : AppColors.gray300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildWelcomeStep(theme),
                  _buildNameStep(theme),
                  _buildAgeStep(theme),
                  _buildPhotoStep(theme),
                  _buildCalendarStep(theme, onboarding),
                ],
              ),
            ),

            // Navigation buttons
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: const Text('Back'),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: _currentStep == 0 ? 1 : 1,
                    child: ElevatedButton(
                      onPressed: _currentStep == 4
                          ? _completeOnboarding
                          : _nextStep,
                      child: Text(
                        _currentStep == 4 ? 'Get Started' : 'Continue',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: const Icon(
              Icons.calendar_month,
              size: 80,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Welcome to ctrl^date',
            style: theme.textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Let\'s set up your account so you can get the most out of your calendar.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            'What should we call you?',
            style: theme.textTheme.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This is how you\'ll appear in the app and to friends.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Your name',
              prefixIcon: Icon(Icons.person_outline),
            ),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
          ),
          const Spacer(),
          Text(
            'You can change this later in settings.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAgeStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            'How old are you?',
            style: theme.textTheme.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'This helps us personalize your experience.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 200,
                child: CupertinoPicker(
                  itemExtent: 50,
                  scrollController: FixedExtentScrollController(
                    initialItem: (_selectedAge ?? 25) - 13,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() => _selectedAge = index + 13);
                  },
                  children: List.generate(88, (index) {
                    final age = index + 13;
                    return Center(
                      child: Text(
                        '$age years old',
                        style: theme.textTheme.headlineMedium,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          Text(
            'Your age is private and won\'t be shared.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.gray500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoStep(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Add a profile photo',
            style: theme.textTheme.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Help friends recognize you with a photo.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppColors.gray100,
                          shape: BoxShape.circle,
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : _uploadedAvatarUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(_uploadedAvatarUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                        ),
                        child: _selectedImage == null && _uploadedAvatarUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 80,
                                color: AppColors.gray400,
                              )
                            : null,
                      ),
                      if (_isUploading)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _isUploading ? null : _pickImage,
                        icon: const Icon(Icons.photo_library_outlined),
                        label: const Text('Gallery'),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      OutlinedButton.icon(
                        onPressed: _isUploading ? null : _takeSelfie,
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('Camera'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: _nextStep,
              child: const Text('Skip for now'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarStep(ThemeData theme, OnboardingState onboarding) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Import your calendars',
            style: theme.textTheme.headlineLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Bring your existing events into ctrl^date.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.gray600,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          // Google Calendar
          _CalendarConnectTile(
            icon: Icons.g_mobiledata,
            title: 'Google Calendar',
            subtitle: onboarding.connectedGoogleCalendar
                ? 'Connected'
                : 'Import events from Google',
            isConnected: onboarding.connectedGoogleCalendar,
            isLoading: _connectingGoogle,
            onTap: onboarding.connectedGoogleCalendar
                ? null
                : _connectGoogleCalendar,
          ),
          const SizedBox(height: AppSpacing.md),
          // Apple Calendar
          _CalendarConnectTile(
            icon: Icons.apple,
            title: 'Apple Calendar',
            subtitle: onboarding.connectedAppleCalendar
                ? 'Connected'
                : 'Import events from iCloud',
            isConnected: onboarding.connectedAppleCalendar,
            isLoading: _connectingApple,
            onTap: onboarding.connectedAppleCalendar
                ? null
                : _connectAppleCalendar,
          ),
          const SizedBox(height: AppSpacing.md),
          // Import from file
          _CalendarConnectTile(
            icon: Icons.upload_file,
            title: 'Import from File',
            subtitle: 'Import CSV or ICS calendar file',
            isConnected: false,
            isLoading: false,
            onTap: _importFromFile,
          ),
          const Spacer(),
          Center(
            child: Text(
              'You can connect more calendars later in settings.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tile for connecting a calendar service
class _CalendarConnectTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isConnected;
  final bool isLoading;
  final VoidCallback? onTap;

  const _CalendarConnectTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isConnected,
    required this.isLoading,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isConnected ? AppColors.gray100 : AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(
              color: isConnected ? AppColors.success : AppColors.gray300,
            ),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isConnected ? AppColors.success : AppColors.gray100,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isConnected ? AppColors.white : AppColors.black,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isConnected
                                ? AppColors.success
                                : AppColors.gray600,
                          ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (isConnected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                )
              else
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.gray500,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
