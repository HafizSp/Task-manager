import 'package:flutter/material.dart';

import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';

class InProgressTasksScreen extends StatefulWidget {
  const InProgressTasksScreen({super.key});

  @override
  State<InProgressTasksScreen> createState() => _InProgressTasksScreenState();
}

class _InProgressTasksScreenState extends State<InProgressTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => const TaskItemCard(),
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
