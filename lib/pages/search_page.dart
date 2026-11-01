
import 'package:flutter/material.dart';
import '../data/contact_data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();

  static const navy = Color(0xFF071A35);
  static const blue = Color(0xFF102D52);
  static const cyan = Color(0xFF8BDCF5);
  static const lightBlue = Color(0xFF2876A8);

  List<dynamic> searchResults = [];
  bool hasSearched = false;

  void searchContacts() {
    final keyword = searchController.text.trim().toLowerCase();

    setState(() {
      hasSearched = true;
      searchResults = keyword.isEmpty
          ? []
          : contacts.where((c) =>
              c.name.toLowerCase().contains(keyword) ||
              c.phone.toLowerCase().contains(keyword) ||
              c.email.toLowerCase().contains(keyword)).toList();
    });
  }

  void clearSearch() {
    searchController.clear();
    setState(() {
      searchResults = [];
      hasSearched = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FA),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 55, 24, 30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [navy, blue, Color(0xFF174A78), lightBlue],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: navy.withOpacity(0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -35,
                  child: Icon(Icons.blur_on, size: 150,
                      color: Colors.white.withOpacity(0.09)),
                ),
                Positioned(
                  right: 35,
                  top: 15,
                  child: Icon(Icons.auto_awesome, size: 32,
                      color: cyan.withOpacity(0.7)),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FIND YOUR CONTACT',
                        style: TextStyle(
                          color: cyan, fontSize: 12,
                          letterSpacing: 3, fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 10),
                    Text('Cari Kontak',
                        style: TextStyle(
                          color: Colors.white, fontSize: 27,
                          fontWeight: FontWeight.bold,
                        )),
                    SizedBox(height: 7),
                    Text('Temukan kontak yang kamu cari',
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),

          // PENCARIAN DAN HASIL
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Cari Kontak',
                      style: TextStyle(
                        color: navy, fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 8),
                  const Text(
                    'Masukkan nama, nomor telepon, atau email kontak.',
                    style: TextStyle(color: Color(0xFF718096), fontSize: 13),
                  ),
                  const SizedBox(height: 16),

                  // INPUT PENCARIAN
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: navy.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onSubmitted: (_) => searchContacts(),
                      decoration: InputDecoration(
                        hintText: 'Ketik nama atau nomor kontak...',
                        hintStyle: const TextStyle(fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: lightBlue),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: clearSearch,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 17,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),

                  // TOMBOL CARI
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [navy, lightBlue],
                        ),
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: blue.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: searchContacts,
                        icon: const Icon(Icons.search, color: Colors.white),
                        label: const Text('Cari',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // HASIL PENCARIAN
                  if (hasSearched) ...[
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Hasil Pencarian',
                              style: TextStyle(
                                color: navy, fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Text('${searchResults.length} Kontak',
                            style: const TextStyle(
                              color: lightBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            )),
                      ],
                    ),
                    const SizedBox(height: 13),

                    if (searchController.text.trim().isEmpty)
                      const Center(
                        child: Text(
                          'Masukkan kata kunci pencarian terlebih dahulu.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else if (searchResults.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            children: [
                              Icon(Icons.person_search, size: 65,
                                  color: blue.withOpacity(0.35)),
                              const SizedBox(height: 10),
                              const Text('Kontak Tidak Ditemukan',
                                  style: TextStyle(
                                    color: blue,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(height: 5),
                              const Text('Coba gunakan kata kunci lainnya.',
                                  style: TextStyle(
                                    color: Colors.grey, fontSize: 12,
                                  )),
                            ],
                          ),
                        ),
                      )
                    else
                      ...searchResults.map((c) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFDAE6F2)),
                          boxShadow: [
                            BoxShadow(
                              color: navy.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(13),
                          leading: CircleAvatar(
                            radius: 23,
                            backgroundColor: blue,
                            child: Text(
                              c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(c.name,
                              style: const TextStyle(
                                color: navy,
                                fontWeight: FontWeight.bold,
                              )),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Telepon: ${c.phone}'),
                                Text('Email: ${c.email}'),
                              ],
                            ),
                          ),
                        ),
                      )),
                  ] else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            Icon(Icons.search, size: 75,
                                color: blue.withOpacity(0.3)),
                            const SizedBox(height: 12),
                            const Text('Temukan Kontakmu',
                                style: TextStyle(
                                  color: blue, fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )),
                            const SizedBox(height: 5),
                            const Text(
                              'Ketik kata kunci lalu tekan tombol Cari.',
                              style: TextStyle(
                                color: Color(0xFF718096), fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}