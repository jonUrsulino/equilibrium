
import 'package:equilibrium/data/data_source/local/shirt_data_source.dart';
import 'package:equilibrium/domain/model/shirt.dart';
import 'package:equilibrium/domain/repository/shirt_repository.dart';

class ShirtRepositoryImpl implements ShirtRepository {
  ShirtRepositoryImpl(this._dataSource);

  final ShirtDataSource _dataSource;

  List<Shirt> usedShirts = List.empty(growable: true);

  @override
  List<Shirt> getAvailableShirts() {
    return _dataSource.getShirts();
  }

  @override
  void markShirtUsed(Shirt shirt) {
    usedShirts.add(shirt);
  }

  @override
  void resetAvailable() {
    print("resetAvailable antes: ${usedShirts.length}");
    usedShirts.clear();
    usedShirts = List.empty(growable: true);
    print("resetAvailable depois: ${usedShirts.length}");
  }

  @override
  Shirt getNextShirt() {
    final List<Shirt> shirts = getAvailableShirts();
    print("usedShirts ${usedShirts.length}");

    shirts.removeWhere((element) => usedShirts.contains(element));

    Shirt? shirt = shirts.firstOrNull;
    if (shirt != null) {
      markShirtUsed(shirt);
    }
    print("Shirt $shirt");

    return shirt ?? Shirt.undefined();
  }
}