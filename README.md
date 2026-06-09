# EcoMentor AI – Your Climate Twin 🌍

A production-ready, highly interactive sustainability assistant built for the **PromptWars Hackathon**. EcoMentor AI helps users understand, track, and optimize their carbon footprint through a digital, living "Climate Twin."

---

## 🏆 Chosen Vertical
**Carbon Footprint Awareness Platform**

---

## ⚠️ Problem Statement
Conventional carbon calculators are often dry, numbers-heavy questionnaires that offer little behavioral insight. They lack personalization and fail to show users *how* changes in daily habits directly lower emissions. This creates a disconnect: users complete an assessment but walk away without actionable, practical, or gamified incentives to progress.

---

## ✨ Solution Overview
**EcoMentor AI** bridges this gap by introducing a digital **Climate Twin**—a living avatar that mirrors the user's environmental behaviors. 
* Rather than simple static math, it runs a reactive, local **Recommendation Engine** that computes realistic cash savings (in ₹) and CO₂ offsets for customized goals.
* An interactive **Future Impact Simulator** lets users toggle potential habit updates and instantly see before/after comparisons of their twin's mood, grade, and wallet projections.
* A conversational **Sustainability Coach** answers carbon-related questions and sets weekly goals with zero external API calls.
* **Gamification** features XP, streaks, and unlockable achievement badges to build emotional ownership.

---

## 🧬 Climate Twin Concept
The Climate Twin is a custom-painted digital representation of the user's environmental DNA. It continuously evaluates habits across 5 key sectors:
1. **Transportation**: Car types, distances, train/bus hours, and flights.
2. **Home Energy**: Electricity consumption, AC hours, and clean solar offsets.
3. **Food**: Diet classifications from Vegan to High Meat.
4. **Shopping**: Consumption frequency and electronics buying habits.
5. **Waste**: Segregation habits, composting, and plastic packaging.

### Dynamic Moods & Gradients:
* **Score 85–100 (Grade A/A+)**: Vibrant Emerald theme, smiling twin, clean sky, floating leaves.
* **Score 70–84 (Grade B)**: Teal theme, happy/neutral smile, clean environment, floating bubbles.
* **Score 55–69 (Grade C)**: Amber theme, neutral facial expression, normal surroundings.
* **Score 40–54 (Grade D)**: Orange theme, concerned face, overcast background.
* **Score 0–39 (Grade F)**: Slate Slate theme, sad face, smoggy surroundings, gray particles.

---

## ⚙️ Recommendation Engine Logic
The engine runs locally to process the user's assessment vectors, determining candidate actions based on high-impact areas:

```
                  +--------------------------------+
                  |  Lifestyle Assessment Answers  |
                  +---------------+----------------+
                                  |
                                  v
                  +---------------+----------------+
                  |  Calculate Annual Emissions   |
                  +---------------+----------------+
                                  |
                                  v
                  +---------------+----------------+
                  | Compare Categories Pct Metrics |
                  +---------------+----------------+
                                  |
                                  v
                  +---------------+----------------+
                  |   Trigger Matching Rules:      |
                  |   - Weekly distance > 80km     |
                  |   - AC usage > 3 hrs/day       |
                  |   - High-meat diet             |
                  |   - No composting/recycling    |
                  +---------------+----------------+
                                  |
                                  v
                  +---------------+----------------+
                  | Generate Checklist Actions:    |
                  | - CO2 Reduction (kg/year)      |
                  | - Financial Savings (INR/year) |
                  | - Priority & Difficulty tag    |
                  | - Contextual reasoning string  |
                  +--------------------------------+
```

---

## 🏗️ Architecture
The project strictly implements **Clean Architecture** combined with **Riverpod** for robust state management:

```
lib/
├── core/
│   ├── theme/           # Light/Dark Material 3 colors, glassmorphic styling
│   └── utils/           # Emission formulas & recommendation engine rules
├── data/
│   ├── datasources/     # SharedPreferences JSON persistence layer
│   ├── models/          # Freezed assessment and progress data models
│   └── repositories/    # UserRepository implementation mapping data/domain
├── domain/
│   ├── entities/        # Pure Dart entities (Assessment, Twin, UserProgress, Recommendation)
│   ├── usecases/        # Pure business logic Use Cases (CalculateCarbonUseCase, CalculateScoreUseCase, GetRecommendationsUseCase, SimulateCarbonUseCase)
│   └── repositories/    # Repository interfaces
├── presentation/
│   ├── pages/
│   │   ├── onboarding/  # Questionnaire wizard pages
│   │   ├── dashboard/   # Stories, interactive charts, and checklists
│   │   ├── simulator/   # Side-by-side toggles simulation board
│   │   ├── coach/       # Sustainability chat screen
│   │   ├── profile/     # Badge collections and level statistics
│   │   └── shell/       # Sidebar layout with accessibility buttons
│   ├── widgets/         # GlassCard, ScoreGauge, TwinAvatar
│   └── providers/       # Riverpod state managers (Twin, Simulation, Coach, Theme)
├── routes/              # GoRouter configurations and redirects
└── main.dart            # SharedPreferences initialization and app startup
```

---

## 💡 Assumptions
* **Grid Emission Factor**: Electricity calculations assume a carbon intensity of `0.85 kg CO₂/kWh` (typical of fossil-fuel-reliant grids like India).
* **Fuel Consumption Costs**: Estimated running cost savings are computed assuming gasoline price averages `₹100/liter` and standard internal combustion vehicle mileage is `15 km/liter`.
* **EV Savings**: Assumes EV operation yields a running cost saving of roughly `₹3.5/km` compared to gasoline equivalents.

---

## 🚀 Setup Instructions

### Prerequisites
* Flutter SDK (Channel Stable `3.38.5` or higher)
* Dart SDK `3.0.0` or higher
* Google Chrome (for Web deployment)

### Steps
1. **Clone the repository**:
   ```bash
   git clone <repository_url>
   cd EcoMentor-AI-Your-Climate-Twin
   ```

2. **Download Packages**:
   ```bash
   flutter pub get
   ```

3. **Compile Generated Files**:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Launch Application Locally**:
   ```bash
   flutter run -d chrome
   ```

---

## 🧪 Testing Instructions

Run the automated test suite testing carbon math, priority conditions, cache writing, and layout pumps:

### Running Tests:
```bash
flutter test
```

### Coverage Details:
* `test/unit/carbon_calculations_test.dart`: Validates transportation, home cooling, food diets, and waste emission constants.
* `test/unit/recommendation_engine_test.dart`: Confirms recommendation suggestions respond accurately to high footprint triggers.
* `test/repository/user_repository_test.dart`: Validates SharedPreferences cache serializations and reset commands.
* `test/widget_test.dart`: Verifies onboarding flows and text visibility.

---

## 🌐 Deployment Instructions
To build the optimized production assets for web servers:
```bash
flutter build web --release
```
The compiled files will compile to the `build/web` directory, ready to be served via host environments like Vercel, Firebase Hosting, Netlify, or GitHub Pages.
