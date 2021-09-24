import 'package:widget_lections/data_provider.dart';

onlyLike(String id, bool isLiked, int likeCount) {
  {
    DataProvider.likePhoto(id);
      isLiked ? likeCount-- : likeCount++;
      isLiked = !isLiked;
  }
}