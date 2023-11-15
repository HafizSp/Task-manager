import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/cancelled_tasks_screen.dart';
import 'package:task_manager/ui/screens/completed_tasks_screen.dart';
import 'package:task_manager/ui/screens/in_progress_tasks_screen.dart';
import 'package:task_manager/ui/screens/new_tasks_screen.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const InProgressTasksScreen(),
    const CompletedTasksScreen(),
    const CancelledTasksScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          _selectedIndex = index;
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: "New",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.incomplete_circle_outlined),
            label: "In progress",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_all_outlined),
            label: "Completed",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: "Cancelled",
          ),
        ],
      ),
    );
  }
}
