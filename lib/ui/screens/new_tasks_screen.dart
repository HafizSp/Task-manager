import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_count_summary_list_model.dart';
import 'package:task_manager/data/models/task_list_model.dart';
import 'package:task_manager/data/network/network_caller.dart';
import 'package:task_manager/data/network/network_response.dart';
import 'package:task_manager/ui/widgets/summary_card.dart';

import '../../data/models/task_count.dart';
import '../../data/utility/urls.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/task_item_card.dart';
import 'add_new_task_screen.dart';

class NewTasksScreen extends StatefulWidget {
  const NewTasksScreen({super.key});

  @override
  State<NewTasksScreen> createState() => _NewTasksScreenState();
}

class _NewTasksScreenState extends State<NewTasksScreen> {
  bool getNewTaskInProgress = false;
  bool getTaskCountSummaryInProgress = false;

  TaskListModel taskListModel = TaskListModel();
  TaskCountSummaryListModel taskCountSummaryListModel =
      TaskCountSummaryListModel();

  Future<void> getNewTaskList() async {
    getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getNewTasks);

    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }

    getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getTaskCountSummary() async {
    getTaskCountSummaryInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.getTaskStatusCount);

    if (response.isSuccess) {
      taskCountSummaryListModel =
          TaskCountSummaryListModel.fromJson(response.jsonResponse);
    }
    getTaskCountSummaryInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getTaskCountSummary();
    getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummary(),
            Visibility(
              visible: getTaskCountSummaryInProgress == false &&
                  (taskCountSummaryListModel.taskCountList?.isNotEmpty ??
                      false),
              replacement: const LinearProgressIndicator(),
              child: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    TaskCount taskCount =
                        taskCountSummaryListModel.taskCountList![index];
                    return FittedBox(
                      child: SummaryCard(
                        count: taskCount.sum.toString(),
                        title: taskCount.sId ?? '',
                      ),
                    );
                  },
                  itemCount:
                      taskCountSummaryListModel.taskCountList?.length ?? 0,
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: getNewTaskInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: getNewTaskList,
                  child: ListView.builder(
                    itemBuilder: (context, index) => TaskItemCard(
                      task: taskListModel.taskList![index],
                      onChangeStatus: () {
                        getNewTaskList();
                        getTaskCountSummary();
                      },
                      countSummaryProgress: (countProgress) {
                        getTaskCountSummaryInProgress = countProgress;
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      showProgress: (inProgress) {
                        getNewTaskInProgress = inProgress;
                        if (mounted) {
                          setState(() {});
                        }
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );
        },
      ),
    );
  }
}
