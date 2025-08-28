// domain/customer.dart
class Customer {
  final String id;
  final String name;
  final String address;
  final String phone;

  Customer({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
  });
}

// domain/customer_repository.dart
abstract class CustomerRepository {
  Future<void> saveCustomer(Customer customer);
  Future<List<Customer>> getAllCustomers();
}
