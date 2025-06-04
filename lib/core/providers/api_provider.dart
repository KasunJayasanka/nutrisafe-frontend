import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../services/api_service.dart';

final apiProvider = Provider<ApiService>((ref) => ApiService());
