import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_list_model.dart';

import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';

class InProgressTasksScreen extends StatefulWidget {
  const InProgressTasksScreen({super.key});

  @override
  State<InProgressTasksScreen> createState() => _InProgressTasksScreenState();
}

class _InProgressTasksScreenState extends State<InProgressTasksScreen> {
  bool getProgressTaskInProgress = false;
  TaskListModel taskListModel = TaskListModel();

  Future<void> getProgressTaskList() async {
    getProgressTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getProgressTasks);

    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }

    getProgressTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getProgressTaskList();
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
                visible: getProgressTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: getProgressTaskList,
                  child: ListView.builder(
                    itemBuilder: (context, index) => TaskItemCard(
                      task: taskListModel.taskList![index],
                      onChangeStatus: () {
                        getProgressTaskList();
                      },
                      showProgress: (inProgress) {
                        getProgressTaskInProgress = inProgress;
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      countSummaryProgress: (countProgress) {},
                      onDelete: () {
                        getProgressTaskList();
                      },
                    ),
                    itemCount: taskListModel.taskList?.length ?? 0,
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
