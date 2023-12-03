import 'package:flutter/material.dart';

import '../../data/models/task_list_model.dart';
import '../../data/network/network_caller.dart';
import '../../data/network/network_response.dart';
import '../../data/utility/urls.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';

class CancelledTasksScreen extends StatefulWidget {
  const CancelledTasksScreen({super.key});

  @override
  State<CancelledTasksScreen> createState() => _CancelledTasksScreenState();
}

class _CancelledTasksScreenState extends State<CancelledTasksScreen> {
  bool getCancelledTaskInProgress = false;
  TaskListModel taskListModel = TaskListModel();

  Future<void> getCancelledTaskList() async {
    getCancelledTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getCancelledTask);

    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }

    getCancelledTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getCancelledTaskList();
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
                visible: getCancelledTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: getCancelledTaskList,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return TaskItemCard(
                        task: taskListModel.taskList![index],
                        onChangeStatus: () {
                          getCancelledTaskList();
                        },
                        showProgress: (inProgress) {
                          getCancelledTaskInProgress = inProgress;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        countSummaryProgress: (countProgress) {},
                        onDelete: () {
                          getCancelledTaskList();
                        },
                      );
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
