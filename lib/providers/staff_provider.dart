import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/staff.dart';
import '../repositories/staff_repository.dart';

final staffRepositoryProvider = Provider((ref) => StaffRepository());

final staffStreamProvider = StreamProvider<List<Staff>>((ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return repository.getStaff();
}); 