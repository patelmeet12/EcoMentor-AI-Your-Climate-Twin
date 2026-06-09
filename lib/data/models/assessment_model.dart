import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/assessment.dart';

part 'assessment_model.freezed.dart';
part 'assessment_model.g.dart';

@freezed
class AssessmentModel with _$AssessmentModel {
  const factory AssessmentModel({
    required String vehicleType,
    required String fuelType,
    required double weeklyDistance,
    required double publicTransportUsage,
    required int flightsPerYear,
    required double monthlyElectricity,
    required double acUsage,
    required double renewableEnergyUsage,
    required String dietType,
    required String shoppingFrequency,
    required String electronicsPurchase,
    required String recyclingHabits,
    required String plasticConsumption,
    required bool composting,
  }) = _AssessmentModel;

  factory AssessmentModel.fromJson(Map<String, dynamic> json) =>
      _$AssessmentModelFromJson(json);

  factory AssessmentModel.fromEntity(Assessment entity) => AssessmentModel(
        vehicleType: entity.vehicleType,
        fuelType: entity.fuelType,
        weeklyDistance: entity.weeklyDistance,
        publicTransportUsage: entity.publicTransportUsage,
        flightsPerYear: entity.flightsPerYear,
        monthlyElectricity: entity.monthlyElectricity,
        acUsage: entity.acUsage,
        renewableEnergyUsage: entity.renewableEnergyUsage,
        dietType: entity.dietType,
        shoppingFrequency: entity.shoppingFrequency,
        electronicsPurchase: entity.electronicsPurchase,
        recyclingHabits: entity.recyclingHabits,
        plasticConsumption: entity.plasticConsumption,
        composting: entity.composting,
      );
}

extension AssessmentModelX on AssessmentModel {
  Assessment toEntity() => Assessment(
        vehicleType: vehicleType,
        fuelType: fuelType,
        weeklyDistance: weeklyDistance,
        publicTransportUsage: publicTransportUsage,
        flightsPerYear: flightsPerYear,
        monthlyElectricity: monthlyElectricity,
        acUsage: acUsage,
        renewableEnergyUsage: renewableEnergyUsage,
        dietType: dietType,
        shoppingFrequency: shoppingFrequency,
        electronicsPurchase: electronicsPurchase,
        recyclingHabits: recyclingHabits,
        plasticConsumption: plasticConsumption,
        composting: composting,
      );
}
