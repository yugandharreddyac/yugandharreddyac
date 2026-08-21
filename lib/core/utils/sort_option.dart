import '../../data/models/resource_model.dart';

enum SortOption {
  newest,
  oldest,
  alphabetical,
  largest,
  smallest,
  mostDownloaded,
}

extension SortOptionExtension on SortOption {
  String get label {
    switch (this) {
      case SortOption.newest:
        return 'Newest First';
      case SortOption.oldest:
        return 'Oldest First';
      case SortOption.alphabetical:
        return 'Alphabetical (A-Z)';
      case SortOption.largest:
        return 'Largest File';
      case SortOption.smallest:
        return 'Smallest File';
      case SortOption.mostDownloaded:
        return 'Most Downloaded';
    }
  }
}

class ResourceSorter {
  static List<ResourceModel> sort(
      List<ResourceModel> resources, SortOption option) {
    final list = List<ResourceModel>.from(resources);
    switch (option) {
      case SortOption.newest:
        list.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
        break;
      case SortOption.oldest:
        list.sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));
        break;
      case SortOption.alphabetical:
        list.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case SortOption.largest:
        list.sort((a, b) => b.fileSizeBytes.compareTo(a.fileSizeBytes));
        break;
      case SortOption.smallest:
        list.sort((a, b) => a.fileSizeBytes.compareTo(b.fileSizeBytes));
        break;
      case SortOption.mostDownloaded:
        list.sort((a, b) => b.downloadCount.compareTo(a.downloadCount));
        break;
    }
    return list;
  }
}
