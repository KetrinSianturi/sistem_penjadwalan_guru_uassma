import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/jadwal_bloc.dart';
import '../bloc/jadwal_event.dart';
import '../bloc/jadwal_state.dart';
import '../models/jadwal_model.dart';

class PostIndexPage extends StatefulWidget {
  const PostIndexPage({super.key});

  @override
  State<PostIndexPage> createState() => _PostIndexPageState();
}

class _PostIndexPageState extends State<PostIndexPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<JadwalBloc>().add(LoadJadwalEvent());
  }

  void _onSearch(String keyword) {
    context.read<JadwalBloc>().add(SearchJadwalEvent(keyword));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text('Jadwal Mengajar Guru SMA'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Cari nama guru',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.deepPurple.shade200),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<JadwalBloc, JadwalState>(
              builder: (context, state) {
                if (state is JadwalLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is JadwalLoaded) {
                  final jadwalList = state.jadwal;
                  if (jadwalList.isEmpty) {
                    return const Center(child: Text('Data jadwal kosong.'));
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columnSpacing: 20,
                          headingRowColor: MaterialStateProperty.all(Colors.deepPurple.shade100),
                          border: TableBorder.all(color: Colors.deepPurple.shade200),
                          columns: const [
                            DataColumn(label: Text('Nama Guru', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('NIP', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Mapel', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Hari', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Jam', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Kelas', style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text('Aksi', style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: List.generate(jadwalList.length, (index) {
                            final jadwal = jadwalList[index];
                            return DataRow(cells: [
                              DataCell(Text(jadwal.namaGuru)),
                              DataCell(Text(jadwal.nip)),
                              DataCell(Text(jadwal.mataPelajaran)),
                              DataCell(Text(jadwal.hari)),
                              DataCell(Text(jadwal.jam)),
                              DataCell(Text(jadwal.kelas)),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.deepPurple),
                                    tooltip: 'Edit',
                                    onPressed: () => _showForm(context, jadwal: jadwal, index: index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    tooltip: 'Hapus',
                                    onPressed: () {
                                      context.read<JadwalBloc>().add(DeleteJadwalEvent(index));
                                    },
                                  ),
                                ],
                              )),
                            ]);
                          }),
                        ),
                      ),
                    ),
                  );
                } else if (state is JadwalError) {
                  return Center(child: Text('Error: ${state.message}'));
                } else {
                  return const Center(child: Text('Memuat data...'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add),
        label: const Text("Tambah Jadwal"),
        onPressed: () => _showForm(context),
      ),
    );
  }

  void _showForm(BuildContext context, {JadwalModel? jadwal, int? index}) {
    final namaController = TextEditingController(text: jadwal?.namaGuru ?? '');
    final nipController = TextEditingController(text: jadwal?.nip ?? '');
    final mapelController = TextEditingController(text: jadwal?.mataPelajaran ?? '');
    final hariController = TextEditingController(text: jadwal?.hari ?? '');
    final jamController = TextEditingController(text: jadwal?.jam ?? '');
    final kelasController = TextEditingController(text: jadwal?.kelas ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(jadwal == null ? 'Tambah Jadwal' : 'Edit Jadwal'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(namaController, 'Nama Guru'),
              _buildTextField(nipController, 'NIP'),
              _buildTextField(mapelController, 'Mata Pelajaran'),
              _buildTextField(hariController, 'Hari'),
              _buildTextField(jamController, 'Jam'),
              _buildTextField(kelasController, 'Kelas'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
            child: Text(jadwal == null ? 'Tambah' : 'Simpan'),
            onPressed: () {
              final newJadwal = JadwalModel(
                namaGuru: namaController.text,
                nip: nipController.text,
                mataPelajaran: mapelController.text,
                hari: hariController.text,
                jam: jamController.text,
                kelas: kelasController.text,
              );

              if (jadwal == null) {
                context.read<JadwalBloc>().add(AddJadwalEvent(newJadwal));
              } else {
                context.read<JadwalBloc>().add(UpdateJadwalEvent(index!, newJadwal));
              }

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.deepPurple.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
