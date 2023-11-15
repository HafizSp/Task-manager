import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/edit_profile_screen.dart';

class ProfileSummary extends StatelessWidget {
  const ProfileSummary({
    super.key,
    this.enableOnTap = true,
  });

  final bool enableOnTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (enableOnTap) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditProfileScreen(),
            ),
          );
        }
      },
      tileColor: Colors.green,
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: const Text(
        "Hafizur Rahman",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      subtitle: const Text(
        "rahman@gmail.com",
        style: TextStyle(color: Colors.white),
      ),
      trailing: enableOnTap
          ? const Icon(
              Icons.arrow_right_alt_rounded,
              color: Colors.white,
            )
          : null,
    );
  }
}
