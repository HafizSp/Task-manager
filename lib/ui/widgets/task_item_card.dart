import 'package:flutter/material.dart';
import 'package:task_manager/data/network/network_caller.dart';

import '../../data/models/task.dart';
import '../../data/utility/urls.dart';

enum TaskStatus { New, Progress, Completed, Cancelled }

class TaskItemCard extends StatefulWidget {
  const TaskItemCard({
    super.key,
    required this.task,
    required this.onChangeStatus,
    required this.showProgress,
    required this.countSummaryProgress,
    required this.onDelete,
    required this.clipColor,
  });

  final Task task;
  final VoidCallback onChangeStatus;
  final VoidCallback onDelete;
  final MaterialColor clipColor;

  final Function(bool) showProgress;
  final Function(bool) countSummaryProgress;

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {
  Future<void> deleteTask() async {
    widget.showProgress(true);
    widget.countSummaryProgress(true);
    setState(() {});
    final response = await NetworkCaller()
        .getRequest(Urls.deleteTask(widget.task.sId ?? ''));
    if (response.isSuccess) {
      widget.onDelete();
    }
    widget.showProgress(false);
    widget.countSummaryProgress(false);
    setState(() {});
  }

  Future<void> updateTaskStatus(String status) async {
    widget.showProgress(true);
    widget.countSummaryProgress(true);
    final response = await NetworkCaller()
        .getRequest(Urls.updateTaskStatus(widget.task.sId ?? '', status));
    if (response.isSuccess) {
      widget.onChangeStatus();
    }
    widget.showProgress(false);
    widget.countSummaryProgress(false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.title ?? '',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
            Text(
              widget.task.description ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Text(
              "Data: ${widget.task.createdDate}",
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    widget.task.status ?? 'New',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: widget.clipColor,
                ),
                Wrap(
                  children: [
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  "Do you really want to delete the task?",
                                  style: TextStyle(fontSize: 18),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: deleteTask,
                                      child: const Text("Yes")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("No"))
                                ],
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                    ),
                    IconButton(
                      onPressed: showUpdateStatusModal,
                      icon: const Icon(
                        Icons.edit_note_outlined,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showUpdateStatusModal() {
    List<ListTile> item = TaskStatus.values
        .map((e) => ListTile(
              title: Text(e.name),
              onTap: () {
                updateTaskStatus(e.name);
                Navigator.pop(context);
              },
            ))
        .toList();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Status"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: item,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            ],
          );
        });
  }
}
