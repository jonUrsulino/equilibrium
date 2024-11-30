
import 'package:equilibrium/domain/model/shirt.dart';

abstract class ShirtDataSource {
  List<Shirt> getShirts();
}