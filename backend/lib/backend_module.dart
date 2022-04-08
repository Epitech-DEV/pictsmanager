import 'package:meta/meta.dart';
import 'package:backend/backend.dart';

abstract class BackendModule {
  @protected
  final Backend backend;
  BackendModule(this.backend);

  void init();
}
