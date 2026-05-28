import 'package:shared_preferences/shared_preferences.dart';
import 'package:resume_builder/core/constants/storage_keys.dart';

import 'favorite_templates_store.dart';

class FavoriteTemplatesStoreImpl implements IFavoriteTemplatesStore {
  @override
  Future<Set<String>> loadFavoriteTemplateIds() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(StorageKeys.favoriteTemplateIds) ??
        const <String>[];
    return values
        .map((value) => value.trim())
        .where((v) => v.isNotEmpty)
        .toSet();
  }

  @override
  Future<void> saveFavoriteTemplateIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    final normalized = ids.toList()..sort();
    await prefs.setStringList(StorageKeys.favoriteTemplateIds, normalized);
  }
}
