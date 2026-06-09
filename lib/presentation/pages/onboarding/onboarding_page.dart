import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/twin_provider.dart';
import '../../../domain/entities/assessment.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isCalculating = false;

  // Temp form fields
  String _vehicleType = 'None';
  double _weeklyDistance = 50.0;
  double _publicTransport = 2.0;
  int _flightsPerYear = 1;

  double _monthlyElectricity = 150.0;
  double _acUsage = 2.0;
  double _renewablePct = 0.0;

  String _dietType = 'Mixed';

  String _shoppingFrequency = 'Medium';
  String _electronicsPurchase = 'Occasionally';

  String _recyclingHabits = 'Occasionally';
  String _plasticConsumption = 'Medium';
  bool _composting = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 5) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _calculateAndSaveTwin();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _calculateAndSaveTwin() async {
    setState(() {
      _isCalculating = true;
    });

    // Simulate calculation loader
    await Future.delayed(const Duration(seconds: 2));

    final assessment = Assessment(
      vehicleType: _vehicleType,
      fuelType: _vehicleType == 'None' ? 'None' : 'Gasoline', // simplified mapping
      weeklyDistance: _weeklyDistance,
      publicTransportUsage: _publicTransport,
      flightsPerYear: _flightsPerYear,
      monthlyElectricity: _monthlyElectricity,
      acUsage: _acUsage,
      renewableEnergyUsage: _renewablePct,
      dietType: _dietType,
      shoppingFrequency: _shoppingFrequency,
      electronicsPurchase: _electronicsPurchase,
      recyclingHabits: _recyclingHabits,
      plasticConsumption: _plasticConsumption,
      composting: _composting,
    );

    await ref.read(twinProvider.notifier).saveAssessment(assessment);

    if (mounted) {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isCalculating) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark ? [AppColors.darkBg, const Color(0xFF0F172A)] : [AppColors.lightBg, const Color(0xFFEFF6FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Analyzing Carbon DNA...',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Formulating your unique digital Climate Twin',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark ? [AppColors.darkBg, const Color(0xFF0F172A)] : [AppColors.lightBg, const Color(0xFFEFF6FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress Header
              _buildProgressHeader(isDark),

              // Form step cards
              Expanded(
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 680),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Card(
                      elevation: isDark ? 0 : 4,
                      color: isDark ? AppColors.darkCard : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildWelcomeStep(isDark),
                            _buildTransportationStep(isDark),
                            _buildEnergyStep(isDark),
                            _buildFoodStep(isDark),
                            _buildShoppingStep(isDark),
                            _buildWasteStep(isDark),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom control buttons
              _buildControlRow(isDark),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader(bool isDark) {
    if (_currentStep == 0) return const SizedBox(height: 32);

    final double progress = _currentStep / 5.0;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step $_currentStep of 5',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
                ),
                Text(
                  '${(progress * 100).toInt()}% Complete',
                  style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: isDark ? AppColors.darkCardBorder : Colors.grey.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeStep(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withOpacity(0.12),
          ),
          child: const Icon(Icons.eco, size: 64, color: AppColors.primary),
        ),
        const SizedBox(height: 24),
        Text(
          'EcoMentor AI',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          'YOUR CLIMATE TWIN',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 2.5,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Welcome to EcoMentor. Complete this lifestyle assessment to build your Climate Twin—a digital representation of your carbon footprint. Receive intelligent recommendations to track and optimize your habits!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTransportationStep(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('Transportation habits', 'How do you commute and travel throughout the year?'),
          const SizedBox(height: 16),

          // Vehicle dropdown
          const Text('Primary Commute Vehicle', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _vehicleType,
            dropdownColor: isDark ? AppColors.darkCard : Colors.white,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            items: ['None', 'Gasoline Car', 'Diesel Car', 'Hybrid Car', 'Electric Car', 'Motorcycle']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _vehicleType = val);
            },
          ),
          const SizedBox(height: 16),

          if (_vehicleType != 'None') ...[
            Text('Weekly Commute Distance: ${_weeklyDistance.round()} km', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Slider(
              min: 0,
              max: 600,
              divisions: 60,
              value: _weeklyDistance,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _weeklyDistance = val),
            ),
            const SizedBox(height: 12),
          ],

          Text('Weekly Public Transit usage: ${_publicTransport.round()} hours', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Slider(
            min: 0,
            max: 40,
            divisions: 40,
            value: _publicTransport,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _publicTransport = val),
          ),
          const SizedBox(height: 12),

          Text('Flights per year: $_flightsPerYear flights', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Slider(
            min: 0,
            max: 20,
            divisions: 20,
            value: _flightsPerYear.toDouble(),
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _flightsPerYear = val.toInt()),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyStep(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('Home Energy details', 'Help us evaluate your home electricity usage and cooling devices.'),
          const SizedBox(height: 16),

          Text('Monthly Electricity Usage: ${_monthlyElectricity.round()} kWh', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Slider(
            min: 0,
            max: 800,
            divisions: 80,
            value: _monthlyElectricity,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _monthlyElectricity = val),
          ),
          const SizedBox(height: 16),

          Text('AC usage per day: ${_acUsage.round()} hours', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          Slider(
            min: 0,
            max: 24,
            divisions: 24,
            value: _acUsage,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _acUsage = val),
          ),
          const SizedBox(height: 16),

          const Text('Renewable Energy Sourcing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<double>(
            value: _renewablePct,
            dropdownColor: isDark ? AppColors.darkCard : Colors.white,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            items: const [
              DropdownMenuItem(value: 0.0, child: Text('No Solar / Standard Grid (0%)')),
              DropdownMenuItem(value: 0.25, child: Text('Quarterly Solar offset (25%)')),
              DropdownMenuItem(value: 0.50, child: Text('Partial clean energy (50%)')),
              DropdownMenuItem(value: 0.75, child: Text('Strong Solar sourcing (75%)')),
              DropdownMenuItem(value: 1.0, child: Text('Full Net-Zero Clean Sourcing (100%)')),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _renewablePct = val);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFoodStep(bool isDark) {
    final dietOptions = [
      {'title': 'Vegan', 'desc': '100% plant-based diet. Excludes dairy, meat, and eggs.', 'icon': Icons.nature_people},
      {'title': 'Vegetarian', 'desc': 'Excludes meat/poultry, but consumes dairy and eggs.', 'icon': Icons.grass},
      {'title': 'Mixed Diet', 'desc': 'Standard meals. Consumes meat, dairy, and vegetables.', 'icon': Icons.restaurant_menu},
      {'title': 'High Meat Consumption', 'desc': 'Meat forms the main source of most daily meals.', 'icon': Icons.kebab_dining},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Diet choices', 'Select the option that best reflects your regular diet.'),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: dietOptions.length,
            itemBuilder: (context, index) {
              final opt = dietOptions[index];
              final title = opt['title'] as String;
              final isSelected = _dietType == title || (_dietType == 'Mixed' && title == 'Mixed Diet') || (_dietType == 'High Meat' && title == 'High Meat Consumption');

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Semantics(
                  button: true,
                  selected: isSelected,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (title == 'Mixed Diet') {
                          _dietType = 'Mixed';
                        } else if (title == 'High Meat Consumption') {
                          _dietType = 'High Meat';
                        } else {
                          _dietType = title;
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : (isDark ? AppColors.darkCardBorder : AppColors.lightCardBorder),
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected ? AppColors.primary.withOpacity(0.08) : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Icon(opt['icon'] as IconData, color: isSelected ? AppColors.primary : Colors.grey, size: 24),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isSelected ? AppColors.primary : null),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  opt['desc'] as String,
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShoppingStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepTitle('Consumer behavior', 'Tell us about your shopping frequencies and electronics hardware purchases.'),
        const SizedBox(height: 24),

        const Text('General Shopping Frequency (Clothes, goods, etc.)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _shoppingFrequency,
          dropdownColor: isDark ? AppColors.darkCard : Colors.white,
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
          items: ['Low', 'Medium', 'High']
              .map((freq) => DropdownMenuItem(value: freq, child: Text('$freq Frequency')))
              .toList(),
          onChanged: (val) {
            if (val != null) setState(() => _shoppingFrequency = val);
          },
        ),
        const SizedBox(height: 24),

        const Text('Electronics Hardware Purchases', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: _electronicsPurchase,
          dropdownColor: isDark ? AppColors.darkCard : Colors.white,
          decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
          items: ['Rarely', 'Occasionally', 'Frequently']
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: (val) {
            if (val != null) setState(() => _electronicsPurchase = val);
          },
        ),
      ],
    );
  }

  Widget _buildWasteStep(bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepTitle('Waste & Circularity', 'Detail your household recycling, plastic consumption, and organic waste habits.'),
          const SizedBox(height: 16),

          const Text('Recycling habits', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _recyclingHabits,
            dropdownColor: isDark ? AppColors.darkCard : Colors.white,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            items: ['Regularly', 'Occasionally', 'Never']
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _recyclingHabits = val);
            },
          ),
          const SizedBox(height: 16),

          const Text('Plastic Packaging Usage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _plasticConsumption,
            dropdownColor: isDark ? AppColors.darkCard : Colors.white,
            decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 16)),
            items: ['Low', 'Medium', 'High']
                .map((item) => DropdownMenuItem(value: item, child: Text('$item Consumption')))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _plasticConsumption = val);
            },
          ),
          const SizedBox(height: 24),

          // Composting switch
          CheckboxListTile(
            value: _composting,
            activeColor: AppColors.primary,
            title: const Text('Organic Composting at Home', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: const Text('We compost vegetable peels, waste food, and coffee grounds at home.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            onChanged: (val) {
              if (val != null) setState(() => _composting = val);
            },
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildStepTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }

  Widget _buildControlRow(bool isDark) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 680),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentStep > 0)
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _prevStep,
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            )
          else
            const SizedBox.shrink(),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            onPressed: _nextStep,
            icon: Icon(_currentStep == 5 ? Icons.check : Icons.arrow_forward),
            label: Text(_currentStep == 0
                ? 'Get Started'
                : _currentStep == 5
                    ? 'Generate Twin'
                    : 'Next'),
          ),
        ],
      ),
    );
  }
}
