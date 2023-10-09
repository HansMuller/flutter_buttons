import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shipment_calendar/model/model.dart';

import '../service/service.dart';

final stepDataProvider = FutureProvider<List<StepperData>>((ref) async {
  final stepDataService = ref.read(stepDataServiceProvider); // Get the StepDataService instance
  final jsonString = await stepDataService.loadStepDataJson(); // Call the method on the instance
  final jsonData = json.decode(jsonString);
  return List<StepperData>.from(jsonData);
});

final asyncValueProvider = Provider<AsyncValue<List<StepperData>>>(
      (ref) => ref.watch(stepDataProvider),
);


