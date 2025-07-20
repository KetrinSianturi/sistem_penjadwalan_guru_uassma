import 'package:flutter_bloc/flutter_bloc.dart';
import 'jadwal_event.dart';
import 'jadwal_state.dart';
import '../models/jadwal_model.dart';

class JadwalBloc extends Bloc<JadwalEvent, JadwalState> {
  final List<JadwalModel> _jadwalList = [];

  JadwalBloc() : super(JadwalInitial()) {
    on<LoadJadwalEvent>((event, emit) {
      emit(JadwalLoading());
      emit(JadwalLoaded(List.from(_jadwalList)));
    });

    on<AddJadwalEvent>((event, emit) {
      _jadwalList.add(event.jadwal);
      emit(JadwalLoaded(List.from(_jadwalList)));
    });

    on<UpdateJadwalEvent>((event, emit) {
      if (event.index >= 0 && event.index < _jadwalList.length) {
        _jadwalList[event.index] = event.jadwal;
        emit(JadwalLoaded(List.from(_jadwalList)));
      }
    });

    on<DeleteJadwalEvent>((event, emit) {
      if (event.index >= 0 && event.index < _jadwalList.length) {
        _jadwalList.removeAt(event.index);
        emit(JadwalLoaded(List.from(_jadwalList)));
      }
    });

    on<SearchJadwalEvent>((event, emit) {
      final filtered = _jadwalList.where((jadwal) =>
      jadwal.namaGuru.toLowerCase().contains(event.keyword.toLowerCase()) ||
          jadwal.mataPelajaran.toLowerCase().contains(event.keyword.toLowerCase())
      ).toList();
      emit(JadwalLoaded(filtered));
    });
  }
}
