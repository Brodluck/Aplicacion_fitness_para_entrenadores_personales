import 'package:flutter/material.dart';

class TrainerDashboardTab extends StatelessWidget {
  const TrainerDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trainer Dashboard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          _buildOverviewSection(),
          const SizedBox(height: 20),
          _buildClientManagementSection(context),
          const SizedBox(height: 20),
          _buildActivityFeedSection(),
          const SizedBox(height: 20),
          _buildPerformanceMetricsSection(),
          const SizedBox(height: 20),
          _buildQuickActionsSection(context),
        ],
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildOverviewItem('Clients', '25'),
            _buildOverviewItem('Exercises', '50'),
            _buildOverviewItem('Diets', '10'),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(String title, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(title),
      ],
    );
  }

  Widget _buildClientManagementSection(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.people),
        title: const Text('Manage Clients'),
        subtitle: const Text('View and manage your clients'),
        onTap: () {
        
        },
      ),
    );
  }

  Widget _buildActivityFeedSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildActivityItem('John Doe completed 3 exercises'),
            _buildActivityItem('Jane Smith logged a new diet plan'),
            _buildActivityItem('Mike Johnson updated his weight'),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity) {
    return ListTile(
      leading: const Icon(Icons.check_circle, color: Colors.green),
      title: Text(activity),
    );
  }

  Widget _buildPerformanceMetricsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildPerformanceChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: const Center(child: Text('Performance Chart Placeholder')),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildQuickActionButton(
          context,
          icon: Icons.person_add,
          label: 'Add Client',
          onPressed: () {
            // Navigate to add client page
          },
        ),
        _buildQuickActionButton(
          context,
          icon: Icons.fitness_center,
          label: 'Add Exercise',
          onPressed: () {
            // Navigate to add exercise page
          },
        ),
        _buildQuickActionButton(
          context,
          icon: Icons.restaurant,
          label: 'Assign Diet',
          onPressed: () {
            // Navigate to assign diet page
          },
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          heroTag: label,
          child: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
