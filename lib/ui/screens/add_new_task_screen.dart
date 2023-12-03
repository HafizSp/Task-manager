import 'package:flutter/material.dart';
import 'package:task_manager/data/network/network_caller.dart';
import 'package:task_manager/data/network/network_response.dart';
import 'package:task_manager/ui/widgets/body_background.dart';
import 'package:task_manager/ui/widgets/profile_summary_card.dart';
import 'package:task_manager/ui/widgets/snack_message.dart';

import '../../data/utility/urls.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key, required this.onAddTask});

  final VoidCallback onAddTask;

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool createTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(),
            Expanded(
              child: BodyBackground(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),
                          Text(
                            "Add New Task",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextFormField(
                            controller: _titleTEController,
                            decoration:
                                const InputDecoration(hintText: "Title"),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return "Enter valid title";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _descriptionTEController,
                            maxLines: 4,
                            decoration:
                                const InputDecoration(hintText: "Description"),
                            validator: (String? value) {
                              if (value?.trim().isEmpty ?? true) {
                                return "Enter valid description";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: Visibility(
                              visible: createTaskInProgress == false,
                              replacement: const Center(
                                child: CircularProgressIndicator(),
                              ),
                              child: ElevatedButton(
                                onPressed: createTask,
                                child: const Text("Add"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    createTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response = await NetworkCaller().postRequest(
      Urls.createTask,
      body: {
        "title": _titleTEController.text.trim(),
        "description": _descriptionTEController.text.trim(),
        "status": "New"
      },
    );
    createTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      widget.onAddTask();
      _titleTEController.clear();
      _descriptionTEController.clear();
      if (mounted) {
        showSnackMessage(context, 'Successfully new task created!');
      }
    } else {
      if (mounted) {
        showSnackMessage(context, 'Create new task failed!', true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleTEController.dispose();
    _descriptionTEController.dispose();
  }
}
