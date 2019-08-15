import 'package:like_this/gson/home_title_avatar_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "HomeTitleAvatarEntity") {
      return HomeTitleAvatarEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}