enum MenuType {
  dashboard('Dashboard'),
  finance('Finance'),
  production('Production'),
  purchase('Purchase'),
  sales('Sales');

  final String key;

  static MenuType? fromKey(String? key) {
    return MenuType.values.where((element) => element.key == key).firstOrNull;
  }

  const MenuType(this.key);
}

enum SubMenuType {
  // Finance
  bankPayment('Bank Payment'),
  bankReceipt('Bank Receipt'),
  cashPayment('Cash Payment'),
  cashReceipt('Cash Receipt'),

  // Sales
  salesQuotation('Sales Quotation'),
  salesOrder('Sales Order'),
  salesDebitNote('Sales Debit Note'),
  salesCreditNote('Sales Credit Note'),

  // Purchase
  purchaseIndent('Purchase Indent'),
  purchaseOrder('Purchase Order'),
  gateInward('Gate Inward'),
  goodsReceiptNote('Goods Receipts Note'),
  purchaseBill('Purchase Bill'),
  purchaseCreditNote('Purchase Credit Note'),
  purchaseDebitNote('Purchase Debit Note'),

  // Production
  yieldSheet('Yield Sheet');

  final String key;

  const SubMenuType(this.key);

  static SubMenuType? fromKey(String? key) {
    return SubMenuType.values
        .where((element) => element.key == key)
        .firstOrNull;
  }
}
