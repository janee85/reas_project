
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'report_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF176B87),
        foregroundColor: Colors.white,
        title: const Text('Purchase Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'Customer Purchase Record System Dashboard',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // CREATE REPORT BUTTON
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ReportFormScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Create Purchase Report'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF176B87),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            LayoutBuilder(
              builder: (context, constraints) {
                final columns =
                    constraints.maxWidth >= 600 ? 3 : 1;

                return GridView.count(
                  crossAxisCount: columns,
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio:
                      columns == 1 ? 3 : 1.2,
                  children: const [
                    SummaryCard(
                      title: 'Total Customers',
                      value: '25',
                      icon: Icons.people_outline,
                      color: Colors.blue,
                    ),
                    SummaryCard(
                      title: 'Purchase Records',
                      value: '48',
                      icon: Icons.receipt_long_outlined,
                      color: Colors.orange,
                    ),
                    SummaryCard(
                      title: 'Total Sales',
                      value: '₱12,500',
                      icon: Icons.payments_outlined,
                      color: Colors.green,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 28),

            const Text(
              'Recent Purchases',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            const Card(
              color: Colors.white,
              child: Column(
                children: [
                  PurchaseTile(
                    name: 'Juan Dela Cruz',
                    item: 'Rice and Cooking Oil',
                    amount: '₱850.00',
                    date: 'Oct 10, 2026',
                  ),
                  Divider(height: 1),
                  PurchaseTile(
                    name: 'Maria Santos',
                    item: 'Canned Goods',
                    amount: '₱450.00',
                    date: 'Oct 11, 2026',
                  ),
                  Divider(height: 1),
                  PurchaseTile(
                    name: 'Pedro Reyes',
                    item: 'Grocery Items',
                    amount: '₱1,200.00',
                    date: 'Oct 12, 2026',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SUMMARY CARD
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// PURCHASE TILE
class PurchaseTile extends StatelessWidget {
  final String name;
  final String item;
  final String amount;
  final String date;

  const PurchaseTile({
    super.key,
    required this.name,
    required this.item,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(Icons.shopping_cart_outlined),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text('$item\n$date'),
      isThreeLine: true,
      trailing: Text(
        amount,
        style: const TextStyle(
          color: Color(0xFF176B87),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}