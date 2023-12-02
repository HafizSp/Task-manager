import 'package:task_manager/ui/widgets/task_item_card.dart';

class Urls {
  static const String _baseUrl = "https://task.teamrabbil.com/api/v1";
  static const String registration = "$_baseUrl/registration";
  static const String login = "$_baseUrl/login";
  static const String createTask = "$_baseUrl/createTask";

  static String getNewTasks =
      "$_baseUrl/listTaskByStatus/${TaskStatus.New.name}";

  static String getProgressTasks =
      "$_baseUrl/listTaskByStatus/${TaskStatus.Progress.name}";

  static String getCompletedTask =
      "$_baseUrl/listTaskByStatus/${TaskStatus.Completed.name}";

  static String getCancelledTask =
      "$_baseUrl/listTaskByStatus/${TaskStatus.Cancelled.name}";

  static const String getTaskStatusCount = "$_baseUrl/taskStatusCount";

  static String updateTaskStatus(String taskId, String status) =>
      "$_baseUrl/updateTaskStatus/$taskId/$status";
}
