class BankPaymentModel {
  final String? mainType;
  final String? linkField;
  final String? type;
  final String? srl;
  final String? docDate;
  final int? sno;
  final String? party;
  final double? debit;
  final double? credit;
  final String? cheque;
  final String? narr;
  final String? authIds;
  final String? fcmid;
  final String? mBranch;

  BankPaymentModel({
    this.mainType,
    this.linkField,
    this.type,
    this.srl,
    this.docDate,
    this.sno,
    this.party,
    this.debit,
    this.credit,
    this.cheque,
    this.narr,
    this.authIds,
    this.fcmid,
    this.mBranch
  });

  factory BankPaymentModel.fromJson(Map<String, dynamic> json) {
    return BankPaymentModel(
      mainType: json['MainType'] as String?,
      linkField: json['LinkField'] as String?,
      type: json['Type'] as String?,
      srl: json['Srl'] as String?,
      docDate: json['DocDate'] as String?,
      sno: json['Sno'] as int?,
      party: json['Party'] as String?,
      debit: (json['Debit'] as num?)?.toDouble(),
      credit: (json['Credit'] as num?)?.toDouble(),
      cheque: json['Cheque'] as String?,
      narr: json['Narr'] as String?,
      authIds: json['AuthIds'] as String?,
      fcmid: json['fcmid'] as String?,
      mBranch: json['mBranch'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MainType': mainType,
      'LinkField': linkField,
      'Type': type,
      'Srl': srl,
      'DocDate': docDate,
      'Sno': sno,
      'Party': party,
      'Debit': debit,
      'Credit': credit,
      'Cheque': cheque,
      'Narr': narr,
      'AuthIds': authIds,
      'fcmid': fcmid,
      'mBranch': mBranch,
    };
  }
  static List<BankPaymentModel> fromDecodedJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => BankPaymentModel.fromJson(item)).toList();
  }
}
