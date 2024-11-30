
import 'package:equilibrium/domain/model/shirt.dart';

abstract class ShirtRepository {

  List<Shirt> getAvailableShirts();
  void markShirtUsed(Shirt shirt);
  void resetAvailable();

  Shirt getNextShirt();

}