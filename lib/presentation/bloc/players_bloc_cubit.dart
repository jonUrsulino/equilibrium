import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'players_bloc_state.dart';

class PlayersBlocCubit extends Cubit<PlayersBlocState> {
  PlayersBlocCubit() : super(PlayersBlocInitial());
}
