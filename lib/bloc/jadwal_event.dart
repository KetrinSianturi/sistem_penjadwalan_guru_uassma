import 'package:equatable/equatable.dart';
import '../models/jadwal_model.dart';

abstract class JadwalEvent extends Equatable {
  const JadwalEvent();

  @override
  List<Object> get props => [];
}

class LoadJadwalEvent extends JadwalEvent {}

class AddJadwalEvent extends JadwalEvent {
  final JadwalModel jadwal;

  const AddJadwalEvent(this.jadwal);

  @override
  List<Object> get props => [jadwal];
}

class UpdateJadwalEvent extends JadwalEvent {
  final int index;
  final JadwalModel jadwal;

  const UpdateJadwalEvent(this.index, this.jadwal);

  @override
  List<Object> get props => [index, jadwal];
}

class DeleteJadwalEvent extends JadwalEvent {
  final int index;

  const DeleteJadwalEvent(this.index);

  @override
  List<Object> get props => [index];
}

class SearchJadwalEvent extends JadwalEvent {
  final String keyword;

  const SearchJadwalEvent(this.keyword);

  @override
  List<Object> get props => [keyword];
}
