import 'package:get/get.dart';

class VoucherModel {
  final String? mainType;
  final String? subType;
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
  final RxBool? isPdfLoading;
  final bool? isHold;

  VoucherModel({
    this.mainType,
    this.linkField,
    this.subType,
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
    this.mBranch,
    this.isPdfLoading,
    this.isHold,
  });

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      mainType: json['MainType'] as String?,
      linkField: json['LinkField'] as String?,
      type: json['Type'] as String?,
      srl: json['Srl'] as String?,
      docDate: json['DocDate'] as String?,
      sno:
          json['Sno'] == '' || json['Sno'] == null
              ? 0
              : int.tryParse(json['Sno'].toString()) ?? 0,
      party: json['Party'] as String?,
      debit: (json['Debit'] as num?)?.toDouble(),
      credit: (json['Credit'] as num?)?.toDouble(),
      cheque: json['Cheque'] as String?,
      narr: json['Narr'] as String?,
      authIds: json['AuthIds'] as String?,
      fcmid: json['fcmid'] as String?,
      mBranch: json['mBranch'] as String?,
      subType: json['SubType'] as String?,
      isHold: json['isHold'] as bool?,
      isPdfLoading: false.obs,
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
      'SubType': subType,
      'isHold': isHold,
    };
  }

  static List<VoucherModel> fromDecodedJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => VoucherModel.fromJson(item)).toList();
  }
}
