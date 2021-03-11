abstract class BenchmarkRunner {
  String get name;

  Future<void> setUp();
  Future<void> tearDown();

  Future<int> batchReadInt(List<String> keys);
  Future<int> batchReadString(List<String> keys);
  Future<int> batchReadDouble(List<String> keys);
  Future<int> batchWriteInt(Map<String, int> entries);
  Future<int> batchWriteString(Map<String, String> entries);
  Future<int> batchWriteDouble(Map<String, double> entries);
  Future<int> batchDeleteInt(List<String> keys);
  Future<int> batchDeleteString(List<String> keys);
  Future<int> batchDeleteDouble(List<String> keys);
}
