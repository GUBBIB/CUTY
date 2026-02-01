import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewProvider = StateProvider<String>((ref) => 'dashboard'); // 'dashboard' or 'job'
