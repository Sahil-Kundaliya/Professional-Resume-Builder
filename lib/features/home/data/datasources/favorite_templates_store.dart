abstract class IFavoriteTemplatesStore {
  Future<Set<String>> loadFavoriteTemplateIds();
  Future<void> saveFavoriteTemplateIds(Set<String> ids);
}
