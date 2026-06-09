// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssessmentModelImpl _$$AssessmentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AssessmentModelImpl(
      vehicleType: json['vehicleType'] as String,
      fuelType: json['fuelType'] as String,
      weeklyDistance: (json['weeklyDistance'] as num).toDouble(),
      publicTransportUsage: (json['publicTransportUsage'] as num).toDouble(),
      flightsPerYear: (json['flightsPerYear'] as num).toInt(),
      monthlyElectricity: (json['monthlyElectricity'] as num).toDouble(),
      acUsage: (json['acUsage'] as num).toDouble(),
      renewableEnergyUsage: (json['renewableEnergyUsage'] as num).toDouble(),
      dietType: json['dietType'] as String,
      shoppingFrequency: json['shoppingFrequency'] as String,
      electronicsPurchase: json['electronicsPurchase'] as String,
      recyclingHabits: json['recyclingHabits'] as String,
      plasticConsumption: json['plasticConsumption'] as String,
      composting: json['composting'] as bool,
    );

Map<String, dynamic> _$$AssessmentModelImplToJson(
        _$AssessmentModelImpl instance) =>
    <String, dynamic>{
      'vehicleType': instance.vehicleType,
      'fuelType': instance.fuelType,
      'weeklyDistance': instance.weeklyDistance,
      'publicTransportUsage': instance.publicTransportUsage,
      'flightsPerYear': instance.flightsPerYear,
      'monthlyElectricity': instance.monthlyElectricity,
      'acUsage': instance.acUsage,
      'renewableEnergyUsage': instance.renewableEnergyUsage,
      'dietType': instance.dietType,
      'shoppingFrequency': instance.shoppingFrequency,
      'electronicsPurchase': instance.electronicsPurchase,
      'recyclingHabits': instance.recyclingHabits,
      'plasticConsumption': instance.plasticConsumption,
      'composting': instance.composting,
    };
