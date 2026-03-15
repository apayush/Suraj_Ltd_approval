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
  journalVoucher('Journal Voucher'),

  // Purchase
  purchaseInvoice('Purchase Invoice'),
  purchaseOrder('Purchase Order'),
  purchaseIndent('Purchase Indent'),
  goodsReceiptNote('Goods Receipt Note'),
  purchaseDebitNote('Debit Note Purchase'),
  purchaseQuotation('Purchase Comparision'),
  // gateInward('Gate Inward'),
  // purchaseCreditNote('Purchase Credit Note'),

  // Sales
  salesOrder('Sales Order'),
  salesQuotation('Sales Quotation'),
  salesEnquiry('Sales Enquiry'),
  salesCreditNote('Credit Note Sales'),
  // salesDebitNote('Sales Debit Note'),

  // Production
  // yieldSheet('Yield Sheet'),
  hourlyProductionEntry('Hourly Production Entry');

  final String key;

  const SubMenuType(this.key);

  static SubMenuType? fromKey(String? key) {
    return SubMenuType.values
        .where((element) => element.key == key)
        .firstOrNull;
  }
}
