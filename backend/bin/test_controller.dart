import 'package:backend/backend.dart';

@ControllerInfo()
class MathController extends BackendController {
  @Get(path: '/:first/:second')
  int add(BackendRequest request) {
    return request.get<int>(ParamsType.params, 'first')! +
        request.get<int>(ParamsType.params, 'second')!;
  }

  @Get(path: '/test')
  Map test(BackendRequest request) {
    Map<String, int> map = Map();
    for (int i = 0; i < 100; i++) {
      map[i.toString()] = i;
    }
    return map;
  }
}
