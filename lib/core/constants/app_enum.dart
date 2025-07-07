enum MenuType {
  finance('Finance'),
  sales('Sales');

  final String key;

  static MenuType? fromKey(String key) {
    return MenuType.values.where((element) => element.key == key).firstOrNull;
  }

  const MenuType(this.key);
}

enum SubMenuType {
  bankType('Bank Payment'),
  salesQuotation('Sales Quotation');

  final String key;
  static SubMenuType? fromKey(String key) {
    return SubMenuType.values
        .where((element) => element.key == key)
        .firstOrNull;
  }

  const SubMenuType(this.key);
}
