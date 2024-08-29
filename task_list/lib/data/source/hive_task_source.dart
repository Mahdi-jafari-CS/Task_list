import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data/data.dart';
import 'package:task_list/data/source/source.dart';

class HiveTaskDataSource implements Datasource<TaskEntity> {
  final Box<TaskEntity> box;
  HiveTaskDataSource(this.box);

  @override
  Future<TaskEntity> createOrUpdate(TaskEntity data) async {
    if (data.isInBox) {
      //update
      data.save();
    } else {
      //save
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(TaskEntity data) {
    return data.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) async {
    box.delete(id);
  }

  @override
  Future<TaskEntity> findById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<TaskEntity>> getAll({String searchKeyWord = ''}) async {
    if (searchKeyWord.isNotEmpty) {
      return box.values
          .where((element) => element.name.contains(searchKeyWord)).toList();
    }else
    return box.values.toList();
  }
}
