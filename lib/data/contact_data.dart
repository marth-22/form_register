
import 'package:faker/faker.dart';
import '../models/contact.dart';

final faker = Faker();

final List<String> categories = [
  'Keluarga',
  'Teman',
  'Kerja',
];

final List<Contact> contacts = List.generate(15, (index) {
  return Contact(
    name: faker.person.name(),
    phone: faker.phoneNumber.us(),
    email: faker.internet.email(),
    category: faker.randomGenerator.element(categories),
    addedAt: DateTime.now().subtract(
      Duration(days: index * 2),
    ),
  );
});
