import 'package:equatable/equatable.dart';
import '../models/jadwal_model.dart';

abstract class JadwalState extends Equatable {
  const JadwalState();

  @override
  List<Object> get props => [];
}

class JadwalInitial extends JadwalState {}

class JadwalLoading extends JadwalState {}

class JadwalLoaded extends JadwalState {
  final List<JadwalModel> jadwal;

  const JadwalLoaded(this.jadwal);

  @override
  List<Object> get props => [jadwal];
}

class JadwalError extends JadwalState {
  final String message;

  const JadwalError(this.message);

  @override
  List<Object> get props => [message];
}
