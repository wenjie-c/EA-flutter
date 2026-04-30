import 'dart:typed_data';

import 'package:ea_seminario_flutter/models/task.dart';
import 'package:ea_seminario_flutter/providers/auth_provider.dart';
import 'package:ea_seminario_flutter/screens/task_detail_screen.dart';
import 'package:ea_seminario_flutter/services/SharedPreferences.dart';
import 'package:ea_seminario_flutter/services/tareaService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> todo = [];
  List<Task> inProgress = [];
  List<Task> done = [];

  void doApicall() async {
    TareaService tservice = TareaService();
    SharedPreferences pref = SharedPreferences();
    String? id = pref.read('id');
    if (id != null) {
      var res = await tservice.readTaskByUsuario(id);
      setState(() {
        for (Task tarea in res) {
          switch (tarea.status) {
            case 'To do':
              todo.add(tarea);
              break;
            case 'In Progress':
              inProgress.add(tarea);
              break;
            /*
              case 'Done':
              break;
              */
            default:
              done.add(tarea);
          }
        }
      });
    }
  }

  @override
  initState() {
    doApicall();
    super.initState(); // evita que explote

    print("State initiated");
    // TareaService tservice = TareaService();
    // SharedPreferences pref = SharedPreferences();
    // String id = pref.read('id')!;

    // tservice
    //     .readTaskByUsuario(id)
    //     .then(
    //       (value) => setState(() {
    //         buffer = value;
    //       }),
    //     );
  }

  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ToDoColumn(tareas: todo),
          InProgressColumn(tareas: inProgress),
          DoneColumn(tareas: done),
        ],
      ),
      padding: EdgeInsets.all(8),
    );
  }
}

class ToDoColumn extends StatelessWidget {
  final List<Task> tareas;
  const ToDoColumn({Key? key, required this.tareas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Text('To do', style: TextStyle(fontSize: 26)),
            for (var tarea in tareas) TareaIndividual(tarea: tarea),
          ],
        ),
        color: Color(0xffEAAE98),
      ),
    );
  }
}

class InProgressColumn extends StatelessWidget {
  final List<Task> tareas;
  const InProgressColumn({Key? key, required this.tareas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Text('In Progress', style: TextStyle(fontSize: 26)),
            for (var tarea in tareas) TareaIndividual(tarea: tarea),
          ],
        ),
        color: Color(0xffF7F3CB),
      ),
    );
  }
}

class DoneColumn extends StatelessWidget {
  final List<Task> tareas;
  const DoneColumn({Key? key, required this.tareas}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Text('Done', style: TextStyle(fontSize: 26)),
            for (var tarea in tareas) TareaIndividual(tarea: tarea),
          ],
        ),
        color: Color(0xffCDEBCC),
      ),
    );
  }
}

class TareaIndividual extends StatelessWidget {
  final Task tarea;
  const TareaIndividual({Key? key, required this.tarea}) : super(key: key);
  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(task: tarea),
          ),
        );
      },
      leading: const Icon(Icons.task_alt),
      title: Text(
        tarea.titulo,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'Inicio: ${_formatDate(tarea.fechaInicio)}\nFin: ${_formatDate(tarea.fechaFin)}',
      ),
      isThreeLine: true,
    );
  }
}
