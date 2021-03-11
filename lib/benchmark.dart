import 'dart:math';

import 'package:hive_benchmark/runners/hive.dart';
import 'package:hive_benchmark/runners/runner.dart';
import 'package:hive_benchmark/runners/shared_preferences.dart';
import 'package:random_string/random_string.dart' as randStr;

class Result {
  final BenchmarkRunner runner;
  int intTime;
  int stringTime;
  int doubleTime;

  Result(this.runner);
}

final runners = [
  HiveRunner(),
  SharedPreferencesRunner(),
];

List<Result> _createResults() {
  return runners.map((r) => Result(r)).toList();
}

Map<String, int> generateIntEntries(int count) {
  var map = Map<String, int>();
  var random = Random();
  for (var i = 0; i < count; i++) {
    var key = randStr.randomAlphaNumeric(randStr.randomBetween(5, 200));
    var val = random.nextInt(2 ^ 50);
    map[key] = val;
  }
  return map;
}

Map<String, String> generateStringEntries(int count) {
  var map = Map<String, String>();
  for (var i = 0; i < count; i++) {
    var key = randStr.randomAlphaNumeric(randStr.randomBetween(5, 200));
    var val = randStr.randomString(randStr.randomBetween(5, 1000));
    map[key] = val;
  }
  return map;
}

Map<String, double> generateDoubleEntries(int count) {
  var map = Map<String, double>();
  var random = Random();
  for (var i = 0; i < count; i++) {
    var key = randStr.randomAlphaNumeric(randStr.randomBetween(5, 200));
    var val = random.nextInt(2 ^ 50) + 0.3;
    map[key] = val;
  }
  return map;
}

Future<List<Result>> benchmarkRead(int count) async {
  var results = _createResults();

  var intEntries = generateIntEntries(count);
  var intKeys = intEntries.keys.toList()..shuffle();

  for (var result in results) {
    await result.runner.setUp();
    await result.runner.batchWriteInt(intEntries);
    result.intTime = await result.runner.batchReadInt(intKeys);
  }

  var stringEntries = generateStringEntries(count);
  var stringKeys = stringEntries.keys.toList()..shuffle();

  for (var result in results) {
    await result.runner.batchWriteString(stringEntries);
    result.stringTime = await result.runner.batchReadString(stringKeys);
  }

  var doubleEntries = generateDoubleEntries(count);
  var doubleKeys = doubleEntries.keys.toList()..shuffle();

  for (var result in results) {
    await result.runner.batchWriteDouble(doubleEntries);
    result.doubleTime = await result.runner.batchReadDouble(doubleKeys);
  }

  for (var result in results) {
    await result.runner.tearDown();
  }

  return results;
}

Future<List<Result>> benchmarkWrite(int count) async {
  final results = _createResults();
  var intEntries = generateIntEntries(count);
  var stringEntries = generateStringEntries(count);
  var doubleEntries = generateDoubleEntries(count);

  for (var result in results) {
    await result.runner.setUp();
    result.intTime = await result.runner.batchWriteInt(intEntries);
    result.stringTime = await result.runner.batchWriteString(stringEntries);
    result.doubleTime = await result.runner.batchWriteDouble(doubleEntries);

    await result.runner.tearDown();
  }

  return results;
}

Future<List<Result>> benchmarkDelete(int count) async {
  final results = _createResults();

  var intEntries = generateIntEntries(count);
  var intKeys = intEntries.keys.toList()..shuffle();
  for (var result in results) {
    await result.runner.setUp();
    await result.runner.batchWriteInt(intEntries);
    result.intTime = await result.runner.batchDeleteInt(intKeys);
  }

  var stringEntries = generateStringEntries(count);
  var stringKeys = stringEntries.keys.toList()..shuffle();
  for (var result in results) {
    await result.runner.batchWriteString(stringEntries);
    result.stringTime = await result.runner.batchDeleteString(stringKeys);
  }

  var doubleEntries = generateDoubleEntries(count);
  var doubleKeys = doubleEntries.keys.toList()..shuffle();
  for (var result in results) {
    await result.runner.batchWriteDouble(doubleEntries);
    result.doubleTime = await result.runner.batchDeleteDouble(doubleKeys);
  }

  for (var result in results) {
    await result.runner.tearDown();
  }

  return results;
}
