
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pendaftaran',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: const Color(0xFFEAF5FF),
        useMaterial3: true,
      ),
      home: const FormPendaftaran(),
    );
  }
}

class FormPendaftaran extends StatefulWidget {
  const FormPendaftaran({super.key});

  @override
  State<FormPendaftaran> createState() => _FormPendaftaranState();
}

class _FormPendaftaranState extends State<FormPendaftaran> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final hpController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final namaFocus = FocusNode();
  final hpFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  String? jenisKelamin;
  String? programStudi;
  bool setuju = false;

  final biru = const Color(0xFF64B5F6);

  @override
  void dispose() {
    namaController.dispose();
    hpController.dispose();
    emailController.dispose();
    passwordController.dispose();

    namaFocus.dispose();
    hpFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();

    super.dispose();
  }

  Widget input({
    required String label,
    required TextEditingController controller,
    required FocusNode focus,
    FocusNode? next,
    bool password = false,
    String? Function(String?)? validator,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focus,
      keyboardType: keyboard,
      obscureText: password,
      textInputAction:
          next == null ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: (_) {
        if (next != null) {
          FocusScope.of(context).requestFocus(next);
        } else {
          FocusScope.of(context).unfocus();
        }
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Masukkan $label',
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  void daftar() {
    if (!_formKey.currentState!.validate()) return;

    if (jenisKelamin == null || programStudi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih jenis kelamin dan program studi!'),
        ),
      );
      return;
    }

    if (!setuju) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan setujui Syarat & Ketentuan!'),
        ),
      );
      return;
    }

    konfirmasiPendaftaran();
  }

  void konfirmasiPendaftaran() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Pendaftaran'),
       content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Apakah data sudah benar?',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Periksa Lagi'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Pendaftaran Berhasil!'),
                    backgroundColor: Colors.green,
                  ),
                );

              _formKey.currentState!.reset();
              namaController.clear();
              hpController.clear();
              emailController.clear();
              passwordController.clear();

              setState(() {
                jenisKelamin = null;
                programStudi = null;
                setuju = false;
              });
            },
            child: const Text('Ya, Daftar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran'),
        centerTitle: true,
        backgroundColor: biru,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 500),
            child: Card(
              color: Colors.white,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Akun Baru',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      input(
                        label: 'Nama Lengkap',
                        controller: namaController,
                        focus: namaFocus,
                        next: hpFocus,
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Nama tidak boleh kosong'
                                : null,
                      ),
                      const SizedBox(height: 15),

                      input(
                        label: 'Nomor HP',
                        controller: hpController,
                        focus: hpFocus,
                        next: emailFocus,
                        keyboard: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor HP tidak boleh kosong';
                          }
                          if (!RegExp(r'^[0-9]{10,15}$')
                              .hasMatch(value)) {
                            return 'Masukkan 10–15 digit angka';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      const Text(
                        'Jenis Kelamin',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      RadioGroup<String>(
                        groupValue: jenisKelamin,
                        onChanged: (value) {
                          setState(() => jenisKelamin = value);
                        },
                        child: const Column(
                          children: [
                            RadioListTile<String>(
                              title: Text('Laki-laki'),
                              value: 'Laki-laki',
                            ),
                            RadioListTile<String>(
                              title: Text('Perempuan'),
                              value: 'Perempuan',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        value: programStudi,
                        decoration: const InputDecoration(
                          labelText: 'Program Studi',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        hint: const Text('Pilih program studi'),
                        items: const [
                          'Sistem Informasi',
                          'Matematika',
                        ].map((item) {
                          return DropdownMenuItem(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => programStudi = value);
                        },
                      ),
                      const SizedBox(height: 15),

                      input(
                        label: 'Email',
                        controller: emailController,
                        focus: emailFocus,
                        next: passwordFocus,
                        keyboard: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!value.contains('@')) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      input(
                        label: 'Password',
                        controller: passwordController,
                        focus: passwordFocus,
                        password: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text(
                          'Saya menyetujui Syarat & Ketentuan',
                        ),
                        value: setuju,
                        onChanged: (value) {
                          setState(() => setuju = value ?? false);
                        },
                      ),
                      const SizedBox(height: 15),

                      GestureDetector(
                        onTap: daftar,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: biru,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Daftar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}