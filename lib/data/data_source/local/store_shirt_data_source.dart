
import 'package:equilibrium/data/data_source/local/shirt_data_source.dart';
import 'package:equilibrium/domain/model/shirt.dart';

class StoreShirtDataSource implements ShirtDataSource {

  final List<Shirt> _availableShirts = [
    Shirt.black(),
    Shirt.orange(),
    Shirt.green(),
    Shirt.white(),
    Shirt.blue(),
  ];

  @override
  List<Shirt> getShirts() {
    return _availableShirts.toList();
  }
}