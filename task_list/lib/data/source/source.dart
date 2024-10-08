abstract class Datasource<T> {
  Future<List<T>> getAll({String searchKeyWord});
  Future<T> findById(dynamic id);
  Future<void> deleteAll();
  Future<void> delete(T data);
  Future<void> deleteById(dynamic id);
  Future<T>createOrUpdate(T data);
}
