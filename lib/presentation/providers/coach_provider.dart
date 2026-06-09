import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'twin_provider.dart';

class CoachMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const CoachMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class CoachState {
  final List<CoachMessage> messages;
  final List<String> quickReplies;
  final bool isTyping;

  const CoachState({
    required this.messages,
    required this.quickReplies,
    required this.isTyping,
  });

  CoachState copyWith({
    List<CoachMessage>? messages,
    List<String>? quickReplies,
    bool? isTyping,
  }) {
    return CoachState(
      messages: messages ?? this.messages,
      quickReplies: quickReplies ?? this.quickReplies,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

final coachProvider = StateNotifierProvider<CoachNotifier, CoachState>((ref) {
  final twinState = ref.watch(twinProvider);
  return CoachNotifier(twinState);
});

class CoachNotifier extends StateNotifier<CoachState> {
  final TwinState _twinState;

  CoachNotifier(this._twinState)
      : super(CoachState(
          messages: [
            CoachMessage(
              text: "Hello! I am your Climate Twin Coach. 🌍\n\nI'm here to analyze your sustainability score, answer questions about your footprint, and guide you through customized carbon-reducing goals. How can I assist you today?",
              isUser: false,
              timestamp: DateTime.now(),
            ),
          ],
          quickReplies: [
            "Explain my score",
            "Give me a weekly goal",
            "How do I save money?",
            "Show my achievements",
          ],
          isTyping: false,
        ));

  void sendMessage(String text) async {
    // Add user message
    final userMsg = CoachMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
    );

    // Simulate typing delay for premium UX
    await Future.delayed(const Duration(milliseconds: 600));

    String reply = "";
    final twin = _twinState.twin;
    final progress = _twinState.progress;
    final recs = _twinState.recommendations;

    switch (text) {
      case "Explain my score":
        reply = "Your Sustainability Score is **${twin.score}/100**, earning you a grade of **${twin.grade}**.\n\n"
            "Your annual emissions are **${twin.annualEmissions.toStringAsFixed(0)} kg CO₂** (approx. ${(twin.monthlyEmissions).toStringAsFixed(0)} kg monthly).\n\n"
            "Your biggest carbon driver is **${twin.biggestSource}**:\n"
            "• Transportation: ${twin.transportEmissions.toStringAsFixed(0)} kg CO₂\n"
            "• Home Energy: ${twin.energyEmissions.toStringAsFixed(0)} kg CO₂\n"
            "• Food: ${twin.foodEmissions.toStringAsFixed(0)} kg CO₂\n"
            "• Shopping: ${twin.shoppingEmissions.toStringAsFixed(0)} kg CO₂\n"
            "• Waste: ${twin.wasteEmissions.toStringAsFixed(0)} kg CO₂\n\n"
            "To reach a higher grade, focus on recommendations in your highest emission category!";
        break;

      case "Give me a weekly goal":
        final pending = recs.where((r) => !r.isCompleted).toList();
        if (pending.isEmpty) {
          reply = "Incredible! You have completed all recommended goals. You are a true Climate Hero! Keep maintaining your outstanding green habits.";
        } else {
          // Suggest the highest priority pending action
          pending.sort((a, b) => b.priority == 'High' ? 1 : -1);
          final goal = pending.first;
          reply = "I suggest setting this weekly goal:\n\n"
              "**${goal.title}**\n"
              "• **Description**: ${goal.description}\n"
              "• **Annual Impact**: Save ~${goal.impactKg.toStringAsFixed(0)} kg CO₂\n"
              "• **Annual Savings**: Save ~₹${goal.savingsInr.toStringAsFixed(0)}\n"
              "• **Difficulty**: ${goal.difficulty}\n"
              "• **Why it matters**: ${goal.reasoning}\n\n"
              "Would you like to try completing this action this week? You'll earn +100 XP and boost your Climate Twin!";
        }
        break;

      case "How do I save money?":
        final pending = recs.where((r) => !r.isCompleted).toList();
        if (pending.isEmpty) {
          reply = "You are already fully optimized! If you want to save more, look into expanding home solar or reducing high-emission travel.";
        } else {
          // Sort by highest cash savings
          pending.sort((a, b) => b.savingsInr.compareTo(a.savingsInr));
          final savingAction = pending.first;
          reply = "The recommendation that saves you the most money is:\n\n"
              "**${savingAction.title}**\n"
              "• **Estimated Savings**: **₹${savingAction.savingsInr.toStringAsFixed(0)} per year**\n"
              "• **Carbon Impact**: Reduces ${savingAction.impactKg.toStringAsFixed(0)} kg CO₂/year\n"
              "• **Difficulty**: ${savingAction.difficulty}\n\n"
              "Eco-friendly choices are often great for your wallet too. Try this action to save cash and lower emissions!";
        }
        break;

      case "Show my achievements":
        if (progress.achievements.isEmpty) {
          reply = "You haven't unlocked any achievements yet. Complete your onboarding assessment to earn your first badge: **Green Starter**!";
        } else {
          final badges = progress.achievements.map((b) => "🏆 **$b**").join("\n");
          reply = "Here are your unlocked achievements:\n\n$badges\n\n"
              "• **Current XP**: ${progress.xpPoints} XP\n"
              "• **Active Streak**: ${progress.streakDays} days\n\n"
              "Keep completing goals to unlock the rest of the achievements list!";
        }
        break;

      default:
        // Try to match key terms
        final lower = text.toLowerCase();
        if (lower.contains("transport") || lower.contains("car") || lower.contains("flight")) {
          reply = "For transportation, the best strategy is reducing private fossil-fuel vehicle usage. Try carpooling, switching short trips to cycling, or adopting public transit. That can shave off over 300+ kg CO₂ annually!";
        } else if (lower.contains("energy") || lower.contains("electricity") || lower.contains("solar")) {
          reply = "Home energy emissions are heavily linked to electricity grids. Raising your AC temp to 24°C, shutting off idle devices, and shifting to LED bulbs or solar panels are high-impact ways to cut power bills and grid load.";
        } else if (lower.contains("food") || lower.contains("meat") || lower.contains("diet")) {
          reply = "Food carbon relies heavily on the meat supply chain. Shifting mixed diets toward vegetarian or vegan, or scheduling 'Meatless Mondays' cuts emissions drastically because plant crops use far less water and land than livestock.";
        } else {
          reply = "I understand! Changing daily habits is a step-by-step journey. Focus on completing 1 small goal from your recommendations list on the dashboard, and check in with me whenever you need support.";
        }
    }

    final coachMsg = CoachMessage(
      text: reply,
      isUser: false,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, coachMsg],
      isTyping: false,
    );
  }
}
