import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/network/network_caller.dart';
import 'package:task_manager/data/network/network_response.dart';
import 'package:task_manager/ui/widgets/task_item_card.dart';

import '../../data/utility/urls.dart';
import '../widgets/profile_summary_card.dart';

class CompletedTasksScreen extends StatefulWidget {
  const CompletedTasksScreen({super.key});

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  bool getCompletedTaskInProgress = false;
  TaskListModel taskListModel = TaskListModel();

  Future<void> getCompletedTaskList() async {
    getCompletedTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getCompletedTask);

    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }

    getCompletedTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(),
            Expanded(
              child: Visibility(
                visible: getCompletedTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: getCompletedTaskList,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                          task: taskListModel.taskList![index],
                          onChangeStatus: () {
                            getCompletedTaskList();
                          },
                          showProgress: (inProgress) {
                            getCompletedTaskInProgress = inProgress;
                            if (mounted) {
                              setState(() {});
                            }
                          },
                          countSummaryProgress: (countProgress) {});
                    },
                    itemCount: taskListModel.taskList?.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
