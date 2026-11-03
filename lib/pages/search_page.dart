
import 'package:flutter/material.dart';
import '../data/contact_data.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  dynamic selectedContact;
  final Color navy = const Color(0xFF071A35);
  final Color blue = const Color(0xFF102D52);
  final Color cyan = const Color(0xFF8BDCF5);

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
                colors: [
                  Color(0xFF071A35),
                  Color(0xFF102D52),
                  Color(0xFF174A78),
                  Color(0xFF2876A8),
                ],
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'FIND YOUR CONTACT',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 12,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Cari Kontak',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Temukan kontak berdasarkan nama',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // PENCARIAN DAN DETAIL
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cari Nama Kontak',
                    style: TextStyle(
                      color: Color(0xFF071A35),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masukkan nama kontak yang ingin dicari',
                    style: TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dropdown
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
                    child: Autocomplete<String>(
                      optionsBuilder: (value) {
                        if (value.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }

                        return contacts
                            .map((contact) => contact.name)
                            .where(
                              (name) => name.toLowerCase().startsWith(
                                    value.text.toLowerCase(),
                                  ),
                            );
                      },
                      onSelected: (name) {
                        setState(() {
                          selectedContact = contacts.firstWhere(
                            (contact) => contact.name == name,
                          );
                        });
                      },
                      fieldViewBuilder: (
                        context,
                        controller,
                        focusNode,
                        onSubmitted,
                      ) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          onChanged: (_) {
                            setState(() => selectedContact = null);
                          },
                          decoration: InputDecoration(
                            hintText: 'Ketik disini...',
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFF2876A8),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                controller.clear();
                                setState(() => selectedContact = null);
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        );
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 40,
                              constraints: const BoxConstraints(maxHeight: 250),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                children: options.map((name) {
                                  return ListTile(
                                    leading: const Icon(
                                      Icons.person,
                                      color: Color(0xFF2876A8),
                                    ),
                                    title: Text(name),
                                    onTap: () => onSelected(name),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 25),

                  if (selectedContact != null) ...[
                    const Text(
                      'Detail Kontak',
                      style: TextStyle(
                        color: Color(0xFF071A35),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 13),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: const Color(0xFFDAE6F2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: navy.withOpacity(0.07),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: blue,
                            child: Text(
                              selectedContact.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            selectedContact.name,
                            style: const TextStyle(
                              color: Color(0xFF071A35),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _info(Icons.phone, 'Telepon', selectedContact.phone),
                          const SizedBox(height: 14),
                          _info(Icons.email, 'Email', selectedContact.email),
                          const SizedBox(height: 14),
                          _info(
                            Icons.category,
                            'Kategori',
                            selectedContact.category,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF2876A8), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF102D52),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
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
