import 'package:flutter/material.dart';
import 'models/user_model.dart';
import 'services/user_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD REST API',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: const Color(0xFFEAF5FF),
        useMaterial3: true,
      ),
      home: const UserPage(),
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final UserService service = UserService();
  late Future<List<UserModel>> futureUsers;

  final Color biru = const Color(0xFF64B5F6);

  @override
  void initState() {
    super.initState();
    futureUsers = service.getUsers();
  }

  void muatUlang() {
    setState(() {
      futureUsers = service.getUsers();
    });
  }

  void pesan(String teks, {bool berhasil = true}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(teks),
          backgroundColor: berhasil ? Colors.green : Colors.red,
        ),
      );
  }

  Future<void> bukaForm({UserModel? user}) async {
    final formKey = GlobalKey<FormState>();
    final namaDepan = TextEditingController(
      text: user?.first_name ?? '',
    );
    final namaBelakang = TextEditingController(
      text: user?.last_name ?? '',
    );
    final email = TextEditingController(
      text: user?.email ?? '',
    );

    final hasil = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(user == null ? 'Tambah Pengguna' : 'Edit Pengguna'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: namaDepan,
                  decoration: const InputDecoration(
                    labelText: 'Nama Depan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Nama depan wajib diisi'
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: namaBelakang,
                  decoration: const InputDecoration(
                    labelText: 'Nama Belakang',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Nama belakang wajib diisi'
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Masukkan email yang valid';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              Navigator.pop(dialogContext, true);
            },
            child: Text(user == null ? 'Simpan' : 'Perbarui'),
          ),
        ],
      ),
    );

    if (hasil == true && mounted) {
      try {
        if (user == null) {
          await service.createUser(
            firstName: namaDepan.text.trim(),
            lastName: namaBelakang.text.trim(),
            email: email.text.trim(),
          );
          pesan('Pengguna berhasil ditambahkan!');
        } else {
          await service.updateUser(
          id: user.id,
          firstName: namaDepan.text.trim(),
          lastName: namaBelakang.text.trim(),
          email: email.text.trim(),
        );
        pesan('Pengguna berhasil diperbarui!');
        }

        muatUlang();
      } catch (e) {
        pesan('Gagal menyimpan data: $e', berhasil: false);
      }
    }

    namaDepan.dispose();
    namaBelakang.dispose();
    email.dispose();
  }

  Future<void> hapusUser(UserModel user) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Pengguna'),
        content: Text(
          'Apakah kamu yakin ingin menghapus '
          '${user.first_name} ${user.last_name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (konfirmasi != true || !mounted) return;

    try {
      await service.deleteUser(user.id);
      pesan('Pengguna berhasil dihapus!');
      muatUlang();
    } catch (e) {
      pesan('Gagal menghapus data: $e', berhasil: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Pengguna',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: biru,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: muatUlang,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: FutureBuilder<List<UserModel>>(
            future: futureUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Memuat data pengguna...'),
                    ],
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Gagal mengambil data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: muatUlang,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final users = snapshot.data ?? [];

              if (users.isEmpty) {
                return const Center(
                  child: Text('Belum ada data pengguna.'),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CRUD REST API',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Kelola data pengguna menggunakan ReqRes API.',
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Icon(
                                Icons.people,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text('Total data: ${users.length}'),
                              const Spacer(),
                              FilledButton.icon(
                                onPressed: () => bukaForm(),
                                icon: const Icon(Icons.add),
                                label: const Text('Tambah'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...users.map(
                    (user) => Card(
                      color: Colors.white,
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFFD6EBFF),
                              backgroundImage:
                                  user.avatar.isNotEmpty
                                      ? NetworkImage(user.avatar)
                                      : null,
                              child: user.avatar.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.first_name} ${user.last_name}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    'ID: ${user.id}',
                                    style: const TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  bukaForm(user: user);
                                } else if (value == 'delete') {
                                  hapusUser(user);
                                }
                              },
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.blue),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Hapus'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bukaForm(),
        backgroundColor: biru,
        foregroundColor: Colors.white,
        tooltip: 'Tambah pengguna',
        child: const Icon(Icons.add),
      ),
    );
  }
}