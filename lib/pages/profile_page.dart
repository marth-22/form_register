
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const navy = Color(0xFF071A35);
  static const blue = Color(0xFF102D52);
  static const lightBlue = Color(0xFF2876A8);
  static const cyan = Color(0xFF8BDCF5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FA),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  _profilePhoto(),
                  const SizedBox(height: 18),
                  const Text(
                    'Fauziyah Martha Aula',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 7),
                  _badge(),
                  const SizedBox(height: 25),
                  _contactCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // HEADER
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 55, 24, 30),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF071A35),
            Color(0xFF102D52),
            Color(0xFF174A78),
            Color(0xFF2876A8),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -35,
            child: Icon(
              Icons.blur_on,
              size: 150,
              color: Colors.white.withOpacity(0.09),
            ),
          ),
          Positioned(
            right: 35,
            top: 15,
            child: Icon(
              Icons.auto_awesome,
              size: 32,
              color: cyan.withOpacity(0.7),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MY ACCOUNT',
                style: TextStyle(
                  color: cyan,
                  fontSize: 12,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Profil Saya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Informasi dan identitas pemilik akun',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // FOTO PROFIL
  Widget _profilePhoto() {
    return AvatarGlow(
      glowColor: lightBlue,
      duration: const Duration(milliseconds: 2000),
      repeat: true,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [cyan, blue, lightBlue],
          ),
        ),
        child: const CircleAvatar(
          radius: 65,
          backgroundColor: blue,
          child: Icon(
            Icons.person,
            size: 75,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // LABEL PROFIL
  Widget _badge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2FC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Aplikasi Daftar Kontak',
        style: TextStyle(
          fontSize: 13,
          color: blue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // KARTU INFORMASI
  Widget _contactCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDAE6F2)),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.contact_mail, color: lightBlue, size: 22),
              SizedBox(width: 10),
              Text(
                'Informasi Kontak',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _contactInfo(Icons.code, 'Github', 'marth-22'),
          const SizedBox(height: 16),
          _contactInfo(
            Icons.email_outlined,
            'Email',
            'fauziyahmartha@gmail.com',
          ),
          const SizedBox(height: 16),
          _contactInfo(
            Icons.phone_outlined,
            'Telepon',
            '081234567890',
          ),
        ],
      ),
    );
  }

  // ITEM INFORMASI KONTAK
  static Widget _contactInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 33,
          child: Icon(
            Icons.circle,
            size: 0,
          ),
        ),
        Icon(icon, color: lightBlue, size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: blue,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF526477),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}