abstract class PagingData<T> {
  int getDataTotalCount();

  List<T>? getDataSource();
}

enum LoadStatus { refresh, loadMore, reload }
