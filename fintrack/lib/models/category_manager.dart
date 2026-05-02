class CategoryManager {
  static final List<String> categories = [
    'Alimentação',
    'Transporte',
    'Lazer',
    'Contas',
    'Compras',
    'Saúde',
  ];

  static bool addCategory(String category) {
    final trimmed = category.trim();
    if (trimmed.isNotEmpty && !categories.map((e) => e.toLowerCase()).contains(trimmed.toLowerCase())) {
      categories.add(trimmed);
      return true;
    }
    return false;
  }
}
