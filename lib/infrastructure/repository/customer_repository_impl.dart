// infrastructure/repository/customer_repository_impl.dart
import 'package:sqflite/sqflite.dart';
import '../../domain/customer.dart';
import '../../domain/customer_repository.dart';
import '../database/app_database.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  @override
  Future<void> saveCustomer(Customer customer) async {
    final db = await AppDatabase.instance();
    await db.insert('customers', {
      'id': customer.id,
      'name': customer.name,
      'address': customer.address,
      'phone': customer.phone,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<Customer>> getAllCustomers() async {
    final db = await AppDatabase.instance();
    final maps = await db.query('customers');
    return maps
        .map(
          (row) => Customer(
            id: row['id'] as String,
            name: row['name'] as String,
            address: row['address'] as String,
            phone: row['phone'] as String,
          ),
        )
        .toList();
  }
}
