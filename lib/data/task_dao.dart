import 'package:alura_flutter_curso_1/components/tasks.dart';
import 'package:alura_flutter_curso_1/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  static const String tableSql = 'CREATE TABLE $_tablename('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT)';

  static const String _tablename = 'taskTable';
  static const String _difficulty = 'difficulty';
  static const String _image = 'image';
  static const String _name = 'name';

  save(Tasks tarefa) async {
    final Database database = await getDatabase();
    var itemmExists = await find(tarefa.nome);
    if (itemmExists.isEmpty) {
      return await database.insert(_tablename, toMap(tarefa));
    } else {
      return await database.update(_tablename, toMap(tarefa),
          where: '$_name = ?', whereArgs: [tarefa.nome]);
    }
  }

  Future<List<Tasks>> findAll() async {
    print('Acessando o findAll:  ');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(_tablename);
    print('Procurando dados');
    return toList(result);
  }

  List<Tasks> toList(List<Map<String, dynamic>> listaDeTarefas) {
    print('Converting to list:  ');
    final List<Tasks> tarefas = [];
    for (Map<String, dynamic> linha in listaDeTarefas) {
      final Tasks tarefa =
          Tasks(linha[_name], linha[_image], linha[_difficulty]);
      tarefas.add(tarefa);
    }
    return tarefas;
  }

  Map<String, dynamic> toMap(Tasks tarefa) {
    final Map<String, dynamic> mapaDeTarefas = Map();
    mapaDeTarefas[_name] = tarefa.nome;
    mapaDeTarefas[_difficulty] = tarefa.dificuldade;
    mapaDeTarefas[_image] = tarefa.foto;

    return mapaDeTarefas;
  }

  Future<List<Tasks>> find(String nomeDaTarefa) async {
    print('Acessando o find:  ');
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database
        .query(_tablename, where: '$_name = ?', whereArgs: [nomeDaTarefa]);
    return toList(result);
  }

  delete(String nomeDaTarefa) async {
    final Database database = await getDatabase();
    return database
        .delete(_tablename, where: '$_name = ?', whereArgs: [nomeDaTarefa]);
  }
}
